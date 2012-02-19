--------------------------------------------------------------------------------
-- 表示オブジェクトを含める事ができるグルーピングクラスです
--
--------------------------------------------------------------------------------

Group = DisplayObject()

-- プロパティ定義
Group:setPropertyName("layout")
Group:setPropertyName("background")
Group:setPropertyName("children")

---------------------------------------
-- コンストラクタです
---------------------------------------
function Group:init(params)
    Group:super(self)
    
    -- オブジェクト定義
    self._children = {}
    self._background = self:newBackground()

    if params then
        table.copy(params, self)
    end
end

---------------------------------------
-- 背景を生成して返します。
---------------------------------------
function Group:newBackground()
    return Graphics:new()
end

---------------------------------------
-- ダミーなので生成しません。
---------------------------------------
function Group:newDeck()
    return nil
end

---------------------------------------
-- ダミーなので生成しません。
---------------------------------------
function Group:newProp(deck)
    return nil
end

---------------------------------------
-- 子オブジェクトを追加します。
---------------------------------------
function Group:addChild(child)
    if child.prop == nil then
        return
    end
    if table.indexOf(self.children, child) > 0 then
        return
    end

    table.insert(self.children, child)
    child.layer = self.layer
    child.parent = self
end

---------------------------------------
-- 子オブジェクトを削除します。
---------------------------------------
function Group:removeChild(child)
    local i = table.indexOf(self.children, child)
    if i > 0 then
        table.remove(self.children, i)
        child.layer = nil
        child.parent = nil
    end
end

---------------------------------------
-- 子オブジェクトリストを返します。
---------------------------------------
function Group:getChildren()
    return self._children
end

---------------------------------------
-- 子オブジェクトを返します。
---------------------------------------
function Group:getChildAt(i)
    return self._children[i]
end

---------------------------------------
-- レイヤーをセットします。
-- 描画オブジェクトをMOAILayerに追加します。
---------------------------------------
function Group:setLayer(layer)
    self._layer = layer
    self.background.layer = layer
    for i, child in ipairs(self.children) do
        child.layer = layer
    end
end

---------------------------------------
-- サイズを設定します。
---------------------------------------
function Group:setSize(width, height)
    DisplayObject.setSize(self, width, height)
    self.background:setSize(width, height)
end

---------------------------------------
-- 表示するか反映します。
---------------------------------------
--[[
function Group:updateVisible()
    DisplayObject.updateVisible(self, visible)
    self.background:updateVisible()
    for i, child in ipairs(self.children) do
        child:updateVisible()
    end
end
--]]
---------------------------------------
-- 表示するか設定します。
---------------------------------------
function Group:setVisible(visible)
    DisplayObject.setVisible(self, visible)
    self.background.visible = visible
    for i, child in ipairs(self.children) do
        child.visible = visible
    end
end

---------------------------------------
-- 背景オブジェクトを設定します。
-- TODO:変更時の子の反映
---------------------------------------
function Group:setBackground(background)
    self._background = background
end

---------------------------------------
-- 背景オブジェクトを返します。
---------------------------------------
function Group:getBackground()
    return self._background
end

---------------------------------------
-- @Deprecated
-- このメソッドは非推奨です。
-- 設定してもbackgroundのdeckが使用されます。
---------------------------------------
function Group:setDeck(deck)
end

---------------------------------------
-- MOAIDeckを返します。
---------------------------------------
function Group:getDeck()
    if self.background then
        return self.background.deck
    else
        return nil
    end
end

---------------------------------------
-- @Deprecated
-- このメソッドは非推奨です。
-- 設定してもbackgroundのpropが使用されます。
---------------------------------------
function Group:setProp(prop)
end

---------------------------------------
-- MOAIPropを返します。
---------------------------------------
function Group:getProp()
    if self.background then
        return self.background.prop
    else
        return nil
    end
end

---------------------------------------
-- グループのレイアウトを設定します。
-- レイアウトクラスを設定すると、子オブジェクトの
-- 座標やサイズを自動的に設定する事が可能になります。
---------------------------------------
function Group:setLayout(layout)
    self._layout = layout
end

---------------------------------------
-- グループのレイアウトを返します。
---------------------------------------
function Group:getLayout()
    return self._layout
end

---------------------------------------
-- 子オブジェクトのレイアウトを更新します。
---------------------------------------
function Group:updateLayout()
    for i, child in ipairs(self.children) do
        if child.updateLayout then
            child:updateLayout()
        end
    end
    if self.layout then
        self.layout:update(self)
    end
end
