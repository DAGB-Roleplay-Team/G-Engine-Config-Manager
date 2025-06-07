local CURRENT_VERSION = "1.1"
local VERSION_URL     = "https://raw.githubusercontent.com/DAGB-Roleplay-Team/G-Engine-Config-Manager/main/version.txt"

local function trim(s)
    return (s or ""):gsub("^%s*(.-)%s*$", "%1")
end

local function printUpdate(latest)
    local l1    = "🔄 Nouvelle version disponible : v" .. latest
    local l2    = "👉 Version actuelle            : v" .. CURRENT_VERSION
    local l3    = "📦 Télécharger la mise à jour   : https://github.com/DAGB-Roleplay-Team/G-Engine-Config-Manager"
    local width = math.max(#l1, #l2, #l3) + 2

    print("┏" .. string.rep("━", width) .. "┓")
    print("┃ " .. l1 .. string.rep(" ", width - #l1 - 1) .. "")
    print("┃ " .. l2 .. string.rep(" ", width - #l2 - 1) .. "")
    print("┃ " .. l3 .. string.rep(" ", width - #l3 - 1) .. "")
    print("┗" .. string.rep("━", width) .. "┛")
end

local function CheckVersion()
    local url = VERSION_URL .. "?t=" .. tostring(os.time())
    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 and response then
            local raw     = trim(response)
            local latest  = raw:match("%d+%.%d+") or raw
            if latest ~= CURRENT_VERSION then
                printUpdate(latest)
            end
        else
            print("❌ Impossible de vérifier la version (HTTP " .. tostring(statusCode) .. ")")
        end
    end, "GET", "", {})
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        ConfigManager.LoadConfigs()
        print("✅ Toutes les configs ont été chargées.")
        CheckVersion()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30 * 1000)
        CheckVersion()
    end
end)

function GetConfig(resource)
    return ConfigManager.GetConfig(resource)
end