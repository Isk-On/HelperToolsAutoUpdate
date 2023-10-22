local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'


update_state = false -- Если переменная == true, значит начнётся обновление.

local script_vers = 2
local script_vers_text =
"v1.0" -- Название нашей версии. В будущем будем её выводить ползователю.

local update_url =
'https://raw.githubusercontent.com/Isk-On/TestingAutoUpdate/main/updateIni.ini' -- Путь к ini файлу. Позже нам понадобиться.
local update_path = getWorkingDirectory() .. "/updateIni.ini"

local script_url = 'https://raw.githubusercontent.com/Isk-On/TestingAutoUpdate/main/autoupdate.lua' -- Путь скрипту.
local script_path = thisScript().path


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(
                    "{FFFFFF}Имеется {32CD32}новая {FFFFFF}версия скрипта. Версия: {32CD32}" ..
                    updateIni.info.vers .. ". {FFFFFF}/update что-бы обновить", 0xFF0000) -- Сообщаем о новой версии.
                update_state = true
            end
            os.remove(update_path)
        end
    end)

    sampRegisterChatCommand("bosit", function ()
        sampAddChatMessage("новая весия", -1)
    end)


    while true do
        wait(0)
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{FFFFFF}Скрипт {32CD32}успешно {FFFFFF}обновлён.", 0xFF0000)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end
