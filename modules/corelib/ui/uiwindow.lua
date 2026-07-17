-- @docclass
UIWindow = extends(UIWidget, 'UIWindow')

function UIWindow.create()
    local window = UIWindow.internalCreate()
    window:setTextAlign(AlignTopCenter)
    window:setDraggable(true)
    window:setAutoFocusPolicy(AutoFocusFirst)
    window.hotkeyBlock = false
    return window
end

function UIWindow:onKeyPress(keyCode, keyboardModifiers)
    if keyboardModifiers == KeyboardNoModifier then
        if keyCode == KeyEnter then
            signalcall(self.onEnter, self)
        elseif keyCode == KeyEscape then
            signalcall(self.onEscape, self)
        end
    end
end

function UIWindow:onFocusChange(focused)
    if focused then
        self:raise()
    end
end

function UIWindow:onDragEnter(mousePos)
    self:breakAnchors()
    self.movingReference = {
        x = mousePos.x - self:getX(),
        y = mousePos.y - self:getY()
    }
    return true
end

function UIWindow:onDragLeave(droppedWidget, mousePos)
    -- TODO: auto detect and reconnect anchors
end

function UIWindow:onDragMove(mousePos, mouseMoved)
    local pos = {
        x = mousePos.x - self.movingReference.x,
        y = mousePos.y - self.movingReference.y
    }
    self:setPosition(pos)
    self:bindRectToParent()
end

function UIWindow:onDestroy()
    if self.hotkeyBlock then
        self.hotkeyBlock.release()
        self.hotkeyBlock = false
    end

    if g_game.isOnline() then
        local rootWidget = g_ui.getRootWidget()
        local hasOtherWindow = false
        if rootWidget then
            for _, child in ipairs(rootWidget:getChildren()) do
                if child ~= self and child:isVisible() and child:getClassName() == 'UIWindow' then
                    hasOtherWindow = true
                    break
                end
            end
        end

        if not hasOtherWindow then
            local gameInterface = modules.game_interface
            if gameInterface then
                local gameRootPanel = gameInterface.getRootPanel()
                if gameRootPanel and gameRootPanel:isVisible() then
                    gameRootPanel:focus()
                end
            end
        end
    end
end
