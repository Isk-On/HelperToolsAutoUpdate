local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false
local updating_true = false
local script_vers = 6
local script_vers_text = "v1.1"

local update_url =
'https://raw.githubusercontent.com/Isk-On/TestingAutoUpdate/main/updateIni.ini'
local update_path = getWorkingDirectory() .. "/updateIni.ini"

local script_url = 'https://raw.githubusercontent.com/Isk-On/TestingAutoUpdate/main/autoupdate.lua'
local script_path = thisScript().path


function main()
    while not isSampAvailable() do wait(0) end
    sampAddChatMessage("autoUpdate has been {000000}started", -1)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.versInfo.vers) > script_vers then
                update_list = { u8:decode(updateIni.versInfo.whatsNew) }
                sampAddChatMessage(
                    "{FFFFFF}Имеется {32CD32}новая {FFFFFF}версия скрипта. Версия: {32CD32}" ..
                    updateIni.versInfo.vers_text .. ". {FFFFFF}введите /about чтобы увидеть список нововведений",
                    0xFF0000)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    --
    sampRegisterChatCommand("about", function()
        if update_state then
            local updated_list = table.concat(update_list)
            local updated_list_with_linebreak = updated_list:gsub("|", "\n")
            sampShowDialog(8008, "about update", updated_list_with_linebreak,
                "пон", "пох", DIALOG_STYLE_MSGBOX)
        end
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
                end
            end)
            break
        end
    end
end)
