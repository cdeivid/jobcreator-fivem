-- Client Framework Compatibility Layer
ClientFramework = {}
ClientFramework.Type = nil
ClientFramework.Object = nil

-- Detect framework
local function DetectFramework()
    if Config.Framework == 'esx' then
        return 'esx'
    elseif Config.Framework == 'qbcore' then
        return 'qbcore'
    elseif Config.Framework == 'auto' then
        if GetResourceState('es_extended') == 'started' then
            return 'esx'
        elseif GetResourceState('qb-core') == 'started' then
            return 'qbcore'
        end
    end
    return nil
end

-- Initialize framework
Citizen.CreateThread(function()
    ClientFramework.Type = DetectFramework()
    
    if ClientFramework.Type == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        ClientFramework.Object = ESX
    elseif ClientFramework.Type == 'qbcore' then
        QBCore = exports['qb-core']:GetCoreObject()
        ClientFramework.Object = QBCore
    end
end)

-- Show notification
function ClientFramework.Notify(message, type)
    if ClientFramework.Type == 'esx' then
        ClientFramework.Object.ShowNotification(message)
    elseif ClientFramework.Type == 'qbcore' then
        ClientFramework.Object.Functions.Notify(message, type)
    end
end

-- Get player data
function ClientFramework.GetPlayerData()
    if ClientFramework.Type == 'esx' then
        return ClientFramework.Object.GetPlayerData()
    elseif ClientFramework.Type == 'qbcore' then
        return ClientFramework.Object.Functions.GetPlayerData()
    end
    return nil
end

-- Show help notification
function ClientFramework.ShowHelpNotification(message)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
