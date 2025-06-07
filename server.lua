local CURRENT_VERSION    = "1.0"
local VERSION_CHECK_URL  = "https://raw.githubusercontent.com/DAGB-Roleplay-Team/G-Engine-Config-Manager/main/version.txt"

local function trim(s)
    return (s or ""):gsub("^%s*(.-)%s*$", "%1")
end

local function CheckVersion()
    PerformHttpRequest(VERSION_CHECK_URL, function(statusCode, response, headers)
        if statusCode == 200 and response then
            local latestVersion = trim(response)
            if latestVersion ~= CURRENT_VERSION then
                -- Prépare les lignes
                local line1 = "🔄 Nouvelle version disponible : v" .. latestVersion
                local line2 = "👉 Version actuelle            : v" .. CURRENT_VERSION
                local line3 = "📦 Télécharger la mise à jour    : https://github.com/DAGB-Roleplay-Team/G-Engine-Config-Manager"
                -- Calcule la largeur max
                local width = math.max(#line1, #line2, #line3) + 2
                -- Affiche la boîte
                print("┌" .. string.rep("─", width) .. "┐")
                print("│ " .. line1 .. string.rep(" ", width - #line1 - 1) .. "")
                print("│ " .. line2 .. string.rep(" ", width - #line2 - 1) .. "")
                print("│ " .. line3 .. string.rep(" ", width - #line3 - 1) .. "")
                print("└" .. string.rep("─", width) .. "┘")
            end
        else
            print("❌ Impossible de vérifier la version de G-Engine Configuration Manager (code: " .. tostring(statusCode) .. ")")
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

function GetConfig(resource)
    return ConfigManager.GetConfig(resource)
end