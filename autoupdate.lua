local dlstatus = require('moonloader').download_status
local update_state = false -- ���� ���������� == true, ������ ������� ����������.
local update_found = false -- ���� ����� true, ����� �������� ������� /update.

local script_vers = 2.0
local script_vers_text = "v1.0" -- �������� ����� ������. � ������� ����� � �������� �����������.

local update_url = ''           -- ���� � ini �����. ����� ��� ������������.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = '' -- ���� �������.
local script_path = thisScript().path



function check_update() -- ������ ������� ������� ����� ��������� ������� ���������� ��� ������� �������.
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then -- ������� ������ � ������� � � ini ����� �� github
                sampAddChatMessage(
                    "{FFFFFF}������� {32CD32}����� {FFFFFF}������ �������. ������: {32CD32}" ..
                    updateIni.info.vers_text .. ". {FFFFFF}/update ���-�� ��������", 0xFF0000) -- �������� � ����� ������.
                update_found = true -- ���� ���������� �������, ������ ���������� �������� true
            end
            os.remove(update_path)
        end
    end)
end

function main()
    while not isSampAvailable() do wait(100) end

    check_update()

    sampRegisterChatCommand('test', function()
        sampAddChatMessage("� ���� ���������� �������� ������� /test, �������������", -1) 
    end)

    if update_found then                             -- ���� ������� ����������, ������������ ������� /update.
        sampRegisterChatCommand('update', function() 
            update_state = true                      
        end)
    else
        sampAddChatMessage('{FFFFFF}���� ��������� ����������!')
    end

    while true do
        wait(0)

        if update_state then -- ���� ������� ������� /update � ��������� ����, ������� ����������� �������.
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{FFFFFF}������ {32CD32}������� {FFFFFF}�������.", 0xFF0000)
                end
            end)
            break
        end
    end
end
