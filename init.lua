local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")

function toggleOption(bp, args)
    if #args < 1 then
        micro.InfoBar():Error("Not enough arguments")
        return
    end
    local val = config.GetGlobalOption(args[1])
    if type(val) ~= "boolean" then
        micro.InfoBar():Error("Non-boolean option ", args[1])
        return
    end
    config.SetGlobalOptionNative(args[1], not val)
end

function toggleLocalOption(bp, args)
    if #args < 1 then
        micro.InfoBar():Error("Not enough arguments")
        return
    end
    local val = bp.Buf.Settings[args[1]]
    if type(val) ~= "boolean" then
        micro.InfoBar():Error("Non-boolean option ", args[1])
        return
    end
    bp.Buf:SetOptionNative(args[1], not val)
end

function lockOption(bp, args)
    config.SetGlobalOptionNative("readonly", true)
    micro.InfoBar():Message("File is locked (readonly)")
end

function unlockOption(bp, args)
    config.SetGlobalOptionNative("readonly", false)
    micro.InfoBar():Message("File is unlocked (read/write)")
end

function cursorLineOption(bp, args)
    config.SetGlobalOptionNative("cursorline", false)
end

function transcludeOption(bp, args)
    bp:HandleCommand("textfilter cat " .. args[1])
end

-- function textFilterAliasOption(bp, args)
--    bp:HandleCommand("textfilter " .. table.concat(args, " "))
-- end

function bindingsOption(bp, args)
    bp:HandleCommand("hsplit " .. config.ConfigDir .. "/bindings.json")
end

function settingsOption(bp, args)
    bp:HandleCommand("hsplit " .. config.ConfigDir .. "/settings.json")
end

function initluaOption(bp, args)
    bp:HandleCommand("hsplit " .. config.ConfigDir .. "/init.lua")
end

function microSettingsOption(bp,args)
    bindingsOption(bp, args)
    settingsOption(bp, args)
    initluaOption(bp, args)
end

-- function bindingsOption(bp, args)
--     bp:HandleCommand("vsplit /Users/unforswearing/.config/micro/bindings.json")
-- end


-- automatically update plugins, checking once per day
-- function updatePlugins(bp, args)
--   -- todays date as a two character string prepended with "00"
--   today = tostring(os.date("00%d"))
--
--   -- path to file containing string of last update
--   filepath = config.ConfigDir .. "update_plugins.info"
--
--   -- open a readable version of the file
--   rfile = io.open(filepath, "r+")
--   if not rfile then
--     -- this should actually create the file if it doesn't exist
--     msg = 'no file exists at ' .. filepath
--     -- io.stderr:write(msg)
--     -- messenger:Message(msg)
--     return false
--   end
--
--   lastupdate = assert(rfile:read "*a")
--
--   -- if the file doesn't exist or the last update was before today
--   if not lastupdate or lastupdate ~= today then
--     bp.HandleCommand("plugin update")
--
--     -- open writable file, set updated date string, close file
--     wfile = io.open(filepath, "w+")
--     wfile:write(today)
--     wfile:close()
--
--     -- tell me that plugins were updated
--     micro.InfoBar():Message("Updated Plugins")
--   end
--
--   -- close readable file
--   rfile:close()
--   return true
-- end
--
--
-- function onSetActive(bp)
--  if #bp.Buf.Path ~= 0 then
--    updatePlugins(bp, args)
--  end
-- end

function init()
    config.MakeCommand("toggle", toggleOption, config.OptionComplete)
    config.MakeCommand("togglelocal", toggleLocalOption, config.OptionComplete)
    config.MakeCommand("lock", lockOption, config.OptionComplete)
    config.MakeCommand("unlock", unlockOption, config.OptionComplete)
    config.MakeCommand("cursorline", cursorLineOption, config.OptionComplete)
    -- > transclude file.txt
    config.MakeCommand("transclude", transcludeOption, config.OptionComplete)
    config.MakeCommand("filter", textFilterAliasOption, config.OptionComplete)
    config.MakeCommand("tf", textFilterAliasOption, config.OptionComplete)
    -- edit micro settings files from inside micro
    config.MakeCommand("bindings", bindingsOption, config.OptionComplete)
    config.MakeCommand("settings", settingsOption, config.OptionComplete)
    config.MakeCommand("initlua", initluaOption, config.OptionComplete)
    config.MakeCommand("microsettings", microSettingsOption, config.OptionComplete)
    -- Not working:
    -- config.MakeCommand("bindings", editBindingsOption, config.OptionComplete)
end






















