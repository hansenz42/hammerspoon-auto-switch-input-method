local function Chinese()
    -- 简体拼音
    hs.keycodes.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
end

local function English()
    -- ABC
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

-- app to expected ime config
-- app和对应的输入法
local app2Ime = {
    {'/Applications/Terminal.app', 'English'},
    {'/Applications/iTerm.app', 'English'},
    {'/Applications/Visual Studio Code.app', 'English'},
    {'/Applications/Xcode.app', 'English'},
    {'/Applications/MacVim.app', 'English'},
    {'/Applications/PyCharm.app', 'English'}
    -- 在这里填写应用路径和对应的输入法
}

function updateFocusAppInputMethod(appObject)
    local ime = 'English'
    local focusAppPath = appObject:path() 
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            ime = expectedIme
            break
        end
    end

    if ime == 'English' then
        English()
    else
        Chinese()
    end
end

-- helper hotkey to figure out the app path and name of current focused window
-- 当选中某窗口按下ctrl+command+.时会显示应用的路径等信息
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."BundleID:    "
    ..hs.window.focusedWindow():application():bundleID()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

-- Handle cursor focus and application's screen manage.
-- 窗口激活时自动切换输入法
function applicationWatcher(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then
        updateFocusAppInputMethod(appObject)
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
