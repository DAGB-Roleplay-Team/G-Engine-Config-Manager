ConfigManager = {}

local configs = {}

function ConfigManager.LoadConfigs()
    local listRaw = LoadResourceFile(GetCurrentResourceName(), "configs/list.json")
    if not listRaw then
        print("⚠️ list.json introuvable")
        return
    end

    local list = json.decode(listRaw)
    for _, file in pairs(list) do
        local configRaw = LoadResourceFile(GetCurrentResourceName(), "configs/" .. file)
        if configRaw then
            local chunk, err = load(configRaw, file, "t", {})
            if chunk then
                local config = chunk()
                local configName = string.gsub(file, "%.lua$", "")
                configs[configName] = config
                print("✅ Config chargée : " .. configName)
            else
                print("⚠️ Erreur de parsing dans " .. file .. ": " .. err)
            end
        else
            print("⚠️ Fichier non trouvé : " .. file)
        end
    end
end

function ConfigManager.GetConfig(resourceName)
    return configs[resourceName]
end