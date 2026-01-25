-- Job Actions Server (handcuff, bill, search, etc.)

-- Handcuff player
RegisterNetEvent('jobcreator:server:handcuff')
AddEventHandler('jobcreator:server:handcuff', function(targetId)
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.handcuff then
        return
    end
    
    TriggerClientEvent('jobcreator:client:getHandcuffed', targetId, source)
    Framework.Notify(source, _('player_handcuffed'), 'success')
end)

-- Uncuff player
RegisterNetEvent('jobcreator:server:uncuff')
AddEventHandler('jobcreator:server:uncuff', function(targetId)
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.handcuff then
        return
    end
    
    TriggerClientEvent('jobcreator:client:getUncuffed', targetId)
    Framework.Notify(source, _('player_uncuffed'), 'success')
end)

-- Bill player
RegisterNetEvent('jobcreator:server:bill')
AddEventHandler('jobcreator:server:bill', function(targetId, amount, reason)
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.bill then
        return
    end
    
    if not amount or amount <= 0 then
        Framework.Notify(source, _('invalid_input'), 'error')
        return
    end
    
    local targetMoney = Framework.GetMoney(targetId, 'money')
    
    if targetMoney >= amount then
        Framework.RemoveMoney(targetId, 'money', amount)
        
        -- Add money to job account or society (if available)
        local jobName, _ = Framework.GetPlayerJob(source)
        -- TODO: Add to society/job account if ESX society or similar is available
        
        Framework.Notify(source, _('success'), 'success')
        Framework.Notify(targetId, string.format(_('player_billed'), amount, reason or 'Unknown'), 'info')
    else
        Framework.Notify(source, _('not_enough_money'), 'error')
    end
end)

-- Search player
RegisterNetEvent('jobcreator:server:search')
AddEventHandler('jobcreator:server:search', function(targetId)
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.search then
        return
    end
    
    local target = Framework.GetPlayer(targetId)
    
    if target then
        -- Get player inventory
        local inventory = {}
        
        if Framework.Type == 'esx' then
            for _, item in ipairs(target.inventory) do
                if item.count > 0 then
                    table.insert(inventory, {name = item.name, count = item.count, label = item.label})
                end
            end
        elseif Framework.Type == 'qbcore' then
            for _, item in pairs(target.PlayerData.items) do
                if item.amount > 0 then
                    table.insert(inventory, {name = item.name, count = item.amount, label = item.label})
                end
            end
        end
        
        TriggerClientEvent('jobcreator:client:showInventory', source, inventory)
        Framework.Notify(source, _('player_searched'), 'success')
    else
        Framework.Notify(source, _('player_not_found'), 'error')
    end
end)

-- Heal player
RegisterNetEvent('jobcreator:server:heal')
AddEventHandler('jobcreator:server:heal', function(targetId)
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.heal then
        return
    end
    
    TriggerClientEvent('jobcreator:client:getHealed', targetId)
    Framework.Notify(source, _('player_healed'), 'success')
    Framework.Notify(targetId, _('player_healed'), 'info')
end)

-- Revive player
RegisterNetEvent('jobcreator:server:revive')
AddEventHandler('jobcreator:server:revive', function(targetId)
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.revive then
        return
    end
    
    TriggerClientEvent('jobcreator:client:getRevived', targetId)
    Framework.Notify(source, _('player_revived'), 'success')
    Framework.Notify(targetId, _('player_revived'), 'info')
end)

-- Check vehicle owner
RegisterNetEvent('jobcreator:server:checkVehicleOwner')
AddEventHandler('jobcreator:server:checkVehicleOwner', function(plate)
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.check_owner then
        return
    end
    
    -- Query vehicle owner from database
    if Framework.Type == 'esx' then
        MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        }, function(result)
            if result[1] then
                TriggerClientEvent('jobcreator:client:showVehicleOwner', source, result[1].owner, plate)
            else
                Framework.Notify(source, _('no_owner_found'), 'error')
            end
        end)
    elseif Framework.Type == 'qbcore' then
        MySQL.Async.fetchAll('SELECT citizenid FROM player_vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        }, function(result)
            if result[1] then
                TriggerClientEvent('jobcreator:client:showVehicleOwner', source, result[1].citizenid, plate)
            else
                Framework.Notify(source, _('no_owner_found'), 'error')
            end
        end)
    end
end)

-- Check player identity
RegisterNetEvent('jobcreator:server:checkIdentity')
AddEventHandler('jobcreator:server:checkIdentity', function(targetId)
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.check_identity then
        return
    end
    
    local target = Framework.GetPlayer(targetId)
    
    if target then
        local identity = {}
        
        if Framework.Type == 'esx' then
            identity = {
                name = target.getName(),
                dob = target.get('dateofbirth'),
                sex = target.get('sex'),
                height = target.get('height')
            }
        elseif Framework.Type == 'qbcore' then
            identity = {
                name = target.PlayerData.charinfo.firstname .. ' ' .. target.PlayerData.charinfo.lastname,
                dob = target.PlayerData.charinfo.birthdate,
                sex = target.PlayerData.charinfo.gender,
                nationality = target.PlayerData.charinfo.nationality
            }
        end
        
        TriggerClientEvent('jobcreator:client:showIdentity', source, identity)
    else
        Framework.Notify(source, _('player_not_found'), 'error')
    end
end)

-- Lockpick vehicle
RegisterNetEvent('jobcreator:server:lockpickVehicle')
AddEventHandler('jobcreator:server:lockpickVehicle', function()
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.lockpick then
        return
    end
    
    TriggerClientEvent('jobcreator:client:lockpickVehicle', source)
end)

-- Clean vehicle
RegisterNetEvent('jobcreator:server:cleanVehicle')
AddEventHandler('jobcreator:server:cleanVehicle', function()
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.clean_vehicle then
        return
    end
    
    TriggerClientEvent('jobcreator:client:cleanVehicle', source)
    Framework.Notify(source, _('vehicle_cleaned'), 'success')
end)

-- Repair vehicle
RegisterNetEvent('jobcreator:server:repairVehicle')
AddEventHandler('jobcreator:server:repairVehicle', function()
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.repair_vehicle then
        return
    end
    
    TriggerClientEvent('jobcreator:client:repairVehicle', source)
    Framework.Notify(source, _('vehicle_repaired'), 'success')
end)

-- Impound vehicle
RegisterNetEvent('jobcreator:server:impoundVehicle')
AddEventHandler('jobcreator:server:impoundVehicle', function(plate)
    local source = source
    
    if not Config.EnableJobActions or not Config.JobActions.impound_vehicle then
        return
    end
    
    TriggerClientEvent('jobcreator:client:impoundVehicle', source)
    Framework.Notify(source, _('vehicle_impounded'), 'success')
end)
