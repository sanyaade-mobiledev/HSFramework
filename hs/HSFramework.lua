
----------------------------------------------------------------
-- モジュール参照
----------------------------------------------------------------
-- 依存関係の順に参照

-- base liblary
require "hs/Class"
require "hs/PropertySupport"
require "hs/Log"
require "hs/Runtime"
require "hs/Globals"
require "hs/UString"

require "hs/ObjectPool"
require "hs/EventPool"

require "hs/Event"
require "hs/EventListener"
require "hs/EventDispatcher"
require "hs/InputManager"

-- display classes
require "hs/Transform"
require "hs/Texture"
require "hs/TextureCache"
require "hs/DisplayObject"
require "hs/Group"
require "hs/Layer"
require "hs/Graphics"
require "hs/Sprite"
require "hs/SpriteSheet"
require "hs/MapSprite"
require "hs/TextLabel"
require "hs/Font"
require "hs/FontCache"
require "hs/Scene"
require "hs/SceneManager"
require "hs/Window"
require "hs/Application"
require "hs/BoxLayout"
require "hs/VBoxLayout"
require "hs/HBoxLayout"
require "hs/EaseType"
require "hs/Animation"

require "hs/TMXMap"
require "hs/TMXMapLoader"
require "hs/TMXLayer"
require "hs/TMXObject"
require "hs/TMXObjectGroup"
require "hs/TMXTileset"

-- util
require "hs/FPSMonitor"

----------------------------------------------------------------
-- HSFramework
----------------------------------------------------------------
HSFramework = {}

HSFramework.VERSION = "0.2"

---------------------------------------
--- フレームワークの初期化処理です
--- この関数は、フレームワークを使用する側で、
--- 必ず一度だけコールしなければなりません。
--- フレームワークの初期化処理を変更する場合、
--- この関数の動作を変更する事で可能です。
---------------------------------------
function HSFramework:initialize()
    Log.info("Hana Saurus Framework loading...", "Version:" .. HSFramework.VERSION)

    InputManager:initialize()
    SceneManager:initialize()
    Application:initialize()
end

HSFramework:initialize()