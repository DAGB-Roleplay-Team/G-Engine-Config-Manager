local CURRENT_VERSION = "1.0"
local VERSION_CHECK_URL = "https://raw.githubusercontent.com/YusuDiscord/g-engine-manager/main/version.txt"

local function CheckVersion()
    PerformHttpRequest(VERSION_CHECK_URL, function(statusCode, response, headers)
        if statusCode == 200 and response then
            local latestVersion = response:match("%d+%.%d+")
            if latestVersion and latestVersion ~= CURRENT_VERSION then
                print("\n🔄 Une nouvelle version de G-Engine est disponible : v" .. latestVersion)
                print("👉 Vous utilisez actuellement la version : v" .. CURRENT_VERSION)
                print("📦 Téléchargez la mise à jour ici : https://github.com/YusuDiscord/g-engine-manager\n")
            else
                print("✅ G-Engine est à jour (v" .. CURRENT_VERSION .. ")")
            end
        else
            print("❌ Impossible de vérifier la version de G-Engine (code: " .. tostring(statusCode) .. ")")
        end
    end, "GET", "", {})
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        ConfigManager.LoadConfigs()
        print("✅ Toutes les configs ont été chargées")
        CheckVersion()
    end
end)

function GetConfig(resource)
    return ConfigManager.GetConfig(resource)
end
