-- Client UI Management
local isUIOpen = false
local currentJobs = {}

-- Open UI
RegisterNetEvent('jobcreator:client:openUI')
AddEventHandler('jobcreator:client:openUI', function()
    isUIOpen = true
    SetNuiFocus(true, true)
    
    -- Request jobs data
    TriggerServerEvent('jobcreator:server:getJobs')
    
    SendNUIMessage({
        action = 'openUI'
    })
end)

-- Close UI
RegisterNUICallback('closeUI', function(data, cb)
    isUIOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Receive jobs
RegisterNetEvent('jobcreator:client:receiveJobs')
AddEventHandler('jobcreator:client:receiveJobs', function(jobs)
    currentJobs = jobs
    
    SendNUIMessage({
        action = 'receiveJobs',
        jobs = jobs
    })
end)

-- Refresh jobs
RegisterNetEvent('jobcreator:client:refreshJobs')
AddEventHandler('jobcreator:client:refreshJobs', function()
    TriggerServerEvent('jobcreator:server:getJobs')
end)

-- Create job
RegisterNUICallback('createJob', function(data, cb)
    TriggerServerEvent('jobcreator:server:createJob', data)
    cb('ok')
end)

-- Update job
RegisterNUICallback('updateJob', function(data, cb)
    TriggerServerEvent('jobcreator:server:updateJob', data.jobName, data.updates)
    cb('ok')
end)

-- Delete job
RegisterNUICallback('deleteJob', function(data, cb)
    TriggerServerEvent('jobcreator:server:deleteJob', data.jobName)
    cb('ok')
end)

-- Create grade
RegisterNUICallback('createGrade', function(data, cb)
    TriggerServerEvent('jobcreator:server:createGrade', data)
    cb('ok')
end)

-- Update grade
RegisterNUICallback('updateGrade', function(data, cb)
    TriggerServerEvent('jobcreator:server:updateGrade', data.gradeId, data.updates)
    cb('ok')
end)

-- Delete grade
RegisterNUICallback('deleteGrade', function(data, cb)
    TriggerServerEvent('jobcreator:server:deleteGrade', data.gradeId)
    cb('ok')
end)

-- Create marker
RegisterNUICallback('createMarker', function(data, cb)
    -- Get player coords
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    data.x = coords.x
    data.y = coords.y
    data.z = coords.z
    
    TriggerServerEvent('jobcreator:server:createMarker', data)
    cb('ok')
end)

-- Delete marker
RegisterNUICallback('deleteMarker', function(data, cb)
    TriggerServerEvent('jobcreator:server:deleteMarker', data.markerId)
    cb('ok')
end)

-- Get statistics
RegisterNUICallback('getStatistics', function(data, cb)
    TriggerServerEvent('jobcreator:server:getStatistics')
    cb('ok')
end)

-- Receive statistics
RegisterNetEvent('jobcreator:client:receiveStatistics')
AddEventHandler('jobcreator:client:receiveStatistics', function(stats)
    SendNUIMessage({
        action = 'receiveStatistics',
        statistics = stats
    })
end)

-- Nexus - Share job
RegisterNUICallback('shareJob', function(data, cb)
    TriggerServerEvent('jobcreator:server:shareJob', data.jobName)
    cb('ok')
end)

-- Nexus - Get jobs
RegisterNUICallback('getNexusJobs', function(data, cb)
    TriggerServerEvent('jobcreator:server:getNexusJobs')
    cb('ok')
end)

-- Nexus - Receive jobs
RegisterNetEvent('jobcreator:client:receiveNexusJobs')
AddEventHandler('jobcreator:client:receiveNexusJobs', function(jobs)
    SendNUIMessage({
        action = 'receiveNexusJobs',
        jobs = jobs
    })
end)

-- Nexus - Import job
RegisterNUICallback('importJob', function(data, cb)
    TriggerServerEvent('jobcreator:server:importJob', data.jobId)
    cb('ok')
end)

-- Whitelist management
RegisterNUICallback('addToWhitelist', function(data, cb)
    TriggerServerEvent('jobcreator:server:addToWhitelist', data.jobName, data.identifier)
    cb('ok')
end)

RegisterNUICallback('removeFromWhitelist', function(data, cb)
    TriggerServerEvent('jobcreator:server:removeFromWhitelist', data.jobName, data.identifier)
    cb('ok')
end)

-- Job actions
RegisterNUICallback('jobAction', function(data, cb)
    local action = data.action
    local targetId, _ = Utils.GetClosestPlayer()
    
    if targetId == -1 then
        ClientFramework.Notify(_('player_not_found'), 'error')
        cb('ok')
        return
    end
    
    local targetServerId = GetPlayerServerId(targetId)
    
    if action == 'handcuff' then
        TriggerServerEvent('jobcreator:server:handcuff', targetServerId)
    elseif action == 'bill' then
        -- Open bill input dialog
        SendNUIMessage({
            action = 'openBillDialog',
            targetId = targetServerId
        })
    elseif action == 'search' then
        TriggerServerEvent('jobcreator:server:search', targetServerId)
    elseif action == 'heal' then
        TriggerServerEvent('jobcreator:server:heal', targetServerId)
    elseif action == 'revive' then
        TriggerServerEvent('jobcreator:server:revive', targetServerId)
    elseif action == 'check_identity' then
        TriggerServerEvent('jobcreator:server:checkIdentity', targetServerId)
    end
    
    cb('ok')
end)

-- Submit bill
RegisterNUICallback('submitBill', function(data, cb)
    TriggerServerEvent('jobcreator:server:bill', data.targetId, data.amount, data.reason)
    cb('ok')
end)

-- Vehicle actions
RegisterNUICallback('vehicleAction', function(data, cb)
    local action = data.action
    
    if action == 'lockpick' then
        TriggerServerEvent('jobcreator:server:lockpickVehicle')
    elseif action == 'clean' then
        TriggerServerEvent('jobcreator:server:cleanVehicle')
    elseif action == 'repair' then
        TriggerServerEvent('jobcreator:server:repairVehicle')
    elseif action == 'impound' then
        local vehicle = Utils.GetVehicleInDirection()
        if vehicle then
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('jobcreator:server:impoundVehicle', plate)
        end
    elseif action == 'check_owner' then
        local vehicle = Utils.GetVehicleInDirection()
        if vehicle then
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('jobcreator:server:checkVehicleOwner', plate)
        end
    end
    
    cb('ok')
end)

-- ESC key to close UI
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if isUIOpen then
            if IsControlJustReleased(0, 322) then -- ESC key
                isUIOpen = false
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = 'closeUI'
                })
            end
        else
            Citizen.Wait(500)
        end
    end
end)
