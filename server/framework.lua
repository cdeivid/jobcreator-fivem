-- Framework Detection and Compatibility Layer
Framework = {}
Framework.Type = nil
Framework.Object = nil

-- Detect framework
local function DetectFramework()
    if Config.Framework == 'esx' then
        return 'esx'
    elseif Config.Framework == 'qbcore' then
        return 'qbcore'
    elseif Config.Framework == 'auto' then
        -- Auto-detect
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
    Framework.Type = DetectFramework()
    
    if Framework.Type == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        Framework.Object = ESX
        print('[JobCreator] ESX Framework detected')
    elseif Framework.Type == 'qbcore' then
        QBCore = exports['qb-core']:GetCoreObject()
        Framework.Object = QBCore
        print('[JobCreator] QBCore Framework detected')
    else
        print('[JobCreator] ERROR: No compatible framework detected!')
    end
end)

-- Get player from source
function Framework.GetPlayer(source)
    if Framework.Type == 'esx' then
        return Framework.Object.GetPlayerFromId(source)
    elseif Framework.Type == 'qbcore' then
        return Framework.Object.Functions.GetPlayer(source)
    end
    return nil
end

-- Get player identifier
function Framework.GetIdentifier(source)
    if Framework.Type == 'esx' then
        local xPlayer = Framework.GetPlayer(source)
        return xPlayer and xPlayer.identifier or nil
    elseif Framework.Type == 'qbcore' then
        local Player = Framework.GetPlayer(source)
        return Player and Player.PlayerData.citizenid or nil
    end
    return nil
end

-- Get player job
function Framework.GetPlayerJob(source)
    if Framework.Type == 'esx' then
        local xPlayer = Framework.GetPlayer(source)
        if xPlayer then
            return xPlayer.job.name, xPlayer.job.grade
        end
    elseif Framework.Type == 'qbcore' then
        local Player = Framework.GetPlayer(source)
        if Player then
            return Player.PlayerData.job.name, Player.PlayerData.job.grade.level
        end
    end
    return nil, nil
end

-- Set player job
function Framework.SetPlayerJob(source, job, grade)
    if Framework.Type == 'esx' then
        local xPlayer = Framework.GetPlayer(source)
        if xPlayer then
            xPlayer.setJob(job, grade)
            return true
        end
    elseif Framework.Type == 'qbcore' then
        local Player = Framework.GetPlayer(source)
        if Player then
            Player.Functions.SetJob(job, grade)
            return true
        end
    end
    return false
end

-- Check if player has permission
function Framework.HasPermission(source, permission)
    if Framework.Type == 'esx' then
        local xPlayer = Framework.GetPlayer(source)
        if xPlayer then
            return xPlayer.getGroup() == permission
        end
    elseif Framework.Type == 'qbcore' then
        local Player = Framework.GetPlayer(source)
        if Player then
            return QBCore.Functions.HasPermission(source, permission)
        end
    end
    return false
end

-- Check if player is admin
function Framework.IsAdmin(source)
    for _, group in ipairs(Config.AdminGroups) do
        if Framework.HasPermission(source, group) then
            return true
        end
    end
    return false
end

-- Add money to player
function Framework.AddMoney(source, moneyType, amount)
    if Framework.Type == 'esx' then
        local xPlayer = Framework.GetPlayer(source)
        if xPlayer then
            xPlayer.addAccountMoney(moneyType, amount)
            return true
        end
    elseif Framework.Type == 'qbcore' then
        local Player = Framework.GetPlayer(source)
        if Player then
            Player.Functions.AddMoney(moneyType, amount)
            return true
        end
    end
    return false
end

-- Remove money from player
function Framework.RemoveMoney(source, moneyType, amount)
    if Framework.Type == 'esx' then
        local xPlayer = Framework.GetPlayer(source)
        if xPlayer then
            xPlayer.removeAccountMoney(moneyType, amount)
            return true
        end
    elseif Framework.Type == 'qbcore' then
        local Player = Framework.GetPlayer(source)
        if Player then
            Player.Functions.RemoveMoney(moneyType, amount)
            return true
        end
    end
    return false
end

-- Get player money
function Framework.GetMoney(source, moneyType)
    if Framework.Type == 'esx' then
        local xPlayer = Framework.GetPlayer(source)
        if xPlayer then
            return xPlayer.getAccount(moneyType).money
        end
    elseif Framework.Type == 'qbcore' then
        local Player = Framework.GetPlayer(source)
        if Player then
            return Player.Functions.GetMoney(moneyType)
        end
    end
    return 0
end

-- Show notification
function Framework.Notify(source, message, type)
    if Framework.Type == 'esx' then
        local xPlayer = Framework.GetPlayer(source)
        if xPlayer then
            xPlayer.showNotification(message)
        end
    elseif Framework.Type == 'qbcore' then
        TriggerClientEvent('QBCore:Notify', source, message, type)
    end
end
