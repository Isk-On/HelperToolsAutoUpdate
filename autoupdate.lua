local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'


update_state = false
local updating_true = false
local script_vers = 3
local script_vers_text = "v1.0"

local update_url =
'https://raw.githubusercontent.com/Isk-On/TestingAutoUpdate/main/updateIni.ini' 
local update_path = getWorkingDirectory() .. "/updateIni.ini"

local script_url = 'https://raw.githubusercontent.com/Isk-On/TestingAutoUpdate/main/autoupdate.lua'
local script_path = thisScript().path


function main()
    while not isSampAvailable() do wait(0) end

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(
                    "{FFFFFF}Имеется {32CD32}новая {FFFFFF}версия скрипта. Версия: {32CD32}" ..
                    updateIni.info.vers .. ". {FFFFFF}/update что-бы обновить", 0xFF0000)
                update_state = true
            end
            os.remove(update_path)
        end
    end)

    sampRegisterChatCommand("bosit", function(arg)
        sampAddChatMessage("босит " .. arg, -1)
    end)

    sampRegisterChatCommand("update", function()
        updating_true = true
    end)

    while true do
        wait(0)
    end
end

lua_thread.create(function()
    while true do
        wait(0)
        if update_state and updating_true then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{FFFFFF}Скрипт {32CD32}успешно {FFFFFF}обновлён.", 0xFF0000)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end)
