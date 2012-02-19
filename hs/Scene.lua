----------------------------------------------------------------
-- Sceneはシーングラフを構築するトップレベルコンテナです。
-- Sceneは複数のレイヤーを管理します。
-- このクラスを使用して、画面を構築します。
----------------------------------------------------------------
Scene = Transform()

-- getters
Scene:setPropertyName("layers")
Scene:setPropertyName("topLayer")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Scene:init()
    Scene:super(self)

    -- 初期値
    self.name = ""
    self._layers = {}
    self._opened = false
    self._topLayer = Layer:new()
    self:addLayer(self.topLayer)
    
    self:setSize(Application.stageWidth, Application.stageHeight)

end

---------------------------------------
-- シーンを開きます
-- 引数の設定により、
--
-- @param params effectプロパティを持つテーブル
---------------------------------------
function Scene:openScene(params)
    -- 開いた時の処理
    local event = Event:new(Event.OPEN, self)
    self:onOpen(event)
    self:dispatchEvent(event)

    -- ログ
    Log.debug(self.name .. ":onOpen(event)")

    -- マネージャにスタック
    Application:addScene(self)
    self._opened = true
end

---------------------------------------
-- シーンを閉じます
---------------------------------------
function Scene:closeScene(params)
    -- 閉じた時の処理
    local event = Event:new(Event.CLOSE, self)
    self:onClose(event)
    self:dispatchEvent(event)

    -- ログ
    Log.debug(self.name .. ":onClose(event)")

    -- マネージャから削除
    Application:removeScene(self)
    self._opened = false
end

---------------------------------------
-- シーンを最前面に表示します。
---------------------------------------
function Scene:orderToFront()
    SceneManager:orderToFront(self)
end

---------------------------------------
-- シーンを最背面に表示します。
---------------------------------------
function Scene:orderToBack()
    SceneManager:orderToBack(self)
end

---------------------------------------
-- 描画レイヤーを表示します。
---------------------------------------
function Scene:showRenders()
    for i, layer in ipairs(self.layers) do
        Log.debug("push render!")
        MOAISim.pushRenderPass(layer.renderPass)
    end
end

---------------------------------------
-- カレントシーンかどうか返します。
---------------------------------------
function Scene:isCurrentScene()
    return Application.currentScene == self
end

---------------------------------------
-- 最初に描画するレイヤーを返します。
-- つまり、実際の表示は後ろです。
-- デフォルトで一つだけ追加されているので、
-- 必ず使用できます。
---------------------------------------
function Scene:getTopLayer()
    return self._topLayer
end

---------------------------------------
-- レイヤーを追加します。
---------------------------------------
function Scene:addLayer(layer)
    if table.indexOf(self.layers, layer) > 0 then
        return
    end

    table.insert(self.layers, layer)
    layer.parent = self
    
    if self:isOpened() then
        Application.sceneManager:refreshRenders()
    end
end

---------------------------------------
-- レイヤーを削除します。
---------------------------------------
function Scene:removeLayer(layer)
    if self.topLayer == layer then
        return
    end
    if table.indexOf(self.layers, layer) > 0 then
        return
    end

    table.insert(self.layers, layer)
    layer.parent = self
    
    Application.sceneManager:refreshRenders()
end

---------------------------------------
-- レイヤーリストを返します。
---------------------------------------
function Scene:getLayers()
    return self._layers
end

---------------------------------------
-- 親オブジェクトを設定します。
-- トップレベルコンテナなので、親はありません。
---------------------------------------
function Scene:setParent(parent)
end

---------------------------------------
-- サイズを設定します。
-- デフォルト動作では、deckに対してrectを設定する為、
-- 必要により継承して動作を変更する事を期待します。
---------------------------------------
function Scene:setSize(width, height)
    self._width = width
    self._height = height
    self:centerPivot()
end

---------------------------------------
-- サイズを返します。
---------------------------------------
function Scene:getSize()
    return self._width, self._height
end

---------------------------------------
-- widthを設定します。
---------------------------------------
function Scene:setWidth(width)
    self:setSize(width, self._height)
end

---------------------------------------
-- widthを返します。
---------------------------------------
function Scene:getWidth()
    return self._width
end

---------------------------------------
-- heightを設定します。
---------------------------------------
function Scene:setHeight(height)
    self:setSize(self._width, height)
end

---------------------------------------
-- heightを返します。
---------------------------------------
function Scene:getHeight()
    return self._height
end

---------------------------------------
-- 中心点を中央に設定します。
---------------------------------------
function Scene:centerPivot()
    local w, h = self:getSize()
    local px = w / 2
    local py = h / 2
    self:setPivot(px, py)
end

---------------------------------------
-- SceneにLayerはセットできません。
---------------------------------------
function Scene:setLayer(layer)
end

---------------------------------------
-- 色をアニメーション遷移させます。
---------------------------------------
function Scene:moveColor(red, green, blue, alpha, sec, mode, completeHandler)
    local actionGroup = MOAIAction.new()
    for i, layer in ipairs(self.layers) do
        local action = layer:moveColor(red, green, blue, alpha, sec, mode)
        actionGroup:addChild(action)
    end
    if completeHandler ~= nil then
        actionGroup:setListener(MOAIAction.EVENT_STOP,
            function(prop)
                completeHandler(self)
            end
        )
    end
    actionGroup:start()
    return actionGroup
end

---------------------------------------
-- フェードインします。
---------------------------------------
function Scene:fadeIn(sec, mode, completeHandler)
    local actionGroup = MOAIAction.new()
    for i, layer in ipairs(self.layers) do
        local action = layer:fadeIn(sec, mode)
        actionGroup:addChild(action)
    end
    if completeHandler ~= nil then
        actionGroup:setListener(MOAIAction.EVENT_STOP,
            function(prop)
                completeHandler(self)
            end
        )
    end
    actionGroup:start()
    return actionGroup
end

---------------------------------------
-- フェードアウトします。
---------------------------------------
function Scene:fadeOut(sec, mode, completeHandler)
    local actionGroup = MOAIAction.new()
    for i, layer in ipairs(self.layers) do
        local action = layer:fadeOut(sec, mode)
        actionGroup:addChild(action)
    end
    if completeHandler ~= nil then
        actionGroup:setListener(MOAIAction.EVENT_STOP,
            function(prop)
                completeHandler(self)
            end
        )
    end
    actionGroup:start()
    return actionGroup
end

---------------------------------------
-- 色を設定します。
---------------------------------------
function Scene:setColor(red, green, blue, alpha)
    for i, layer in ipairs(self.layers) do
        layer:setColor(red, green, blue, alpha)
    end
end

---------------------------------------
-- alpha値を設定します。
---------------------------------------
function Scene:setAlpha(alpha)
    self:setColor(self.red, self.green, self.blue, alpha)
end

---------------------------------------
-- alpha値を返します。
---------------------------------------
function Scene:getAlpha()
    return self.topLayer.alpha
end

---------------------------------------
-- red値を設定します。
---------------------------------------
function Scene:setRed(red)
    self:setColor(red, self.green, self.blue, self.alpha)
end

---------------------------------------
-- red値を返します。
---------------------------------------
function Scene:getRed()
    return self.topLayer.red
end

---------------------------------------
-- green値を設定します。
---------------------------------------
function Scene:setGreen(green)
    self:setColor(self.red, green, self.blue, self.alpha)
end

---------------------------------------
-- green値を返します。
---------------------------------------
function Scene:getGreen()
    return self.topLayer.green
end

---------------------------------------
-- blue値を設定します。
---------------------------------------
function Scene:setBlue(blue)
    self:setColor(self.red, self.green, blue, self.alpha)
end

---------------------------------------
-- blue値を返します。
---------------------------------------
function Scene:getBlue()
    return self.topLayer.blue
end

---------------------------------------
-- シーンを開いているか返します。
---------------------------------------
function Scene:isOpened()
    return self._opened
end

---------------------------------------
-- シーンを開いた時のイベントハンドラ関数です
-- 子クラスで継承してください
---------------------------------------
function Scene:onOpen(event)
end

---------------------------------------
-- シーンを閉じた時のイベントハンドラ関数です
-- 子クラスで継承してください
---------------------------------------
function Scene:onClose(event)
end

---------------------------------------
-- 画面をタッチした時のイベント処理です。
-- イベントハンドラ関数です
-- 子クラスで継承してください
---------------------------------------
function Scene:onTouch(event)
end
