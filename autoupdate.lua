local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'


update_state = false -- Åñëè ïåðåìåííàÿ == true, çíà÷èò íà÷í¸òñÿ îáíîâëåíèå.

local updating_true = false
local script_vers = 2
local script_vers_text =
"v1.0" -- Íàçâàíèå íàøåé âåðñèè. Â áóäóùåì áóäåì å¸ âûâîäèòü ïîëçîâàòåëþ.

local update_url =
'https://raw.githubusercontent.com/Isk-On/TestingAutoUpdate/main/updateIni.ini' -- Ïóòü ê ini ôàéëó. Ïîçæå íàì ïîíàäîáèòüñÿ.
local update_path = getWorkingDirectory() .. "/updateIni.ini"

local script_url = 'https://raw.githubusercontent.com/Isk-On/TestingAutoUpdate/main/autoupdate.lua' -- Ïóòü ñêðèïòó.
local script_path = thisScript().path


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage(
                    "{FFFFFF}Èìååòñÿ {32CD32}íîâàÿ {FFFFFF}âåðñèÿ ñêðèïòà. Âåðñèÿ: {32CD32}" ..
                    updateIni.info.vers .. ". {FFFFFF}/update ÷òî-áû îáíîâèòü", 0xFF0000) -- Ñîîáùàåì î íîâîé âåðñèè.
                update_state = true
            end
            os.remove(update_path)
        end
    end)

    sampRegisterChatCommand("testa", function()
        sampAddChatMessage("dfdf", -1)
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
                    sampAddChatMessage("{FFFFFF}Ñêðèïò {32CD32}óñïåøíî {FFFFFF}îáíîâë¸í.", 0xFF0000)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end)
