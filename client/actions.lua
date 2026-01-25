-- Client Job Actions
ClientActions = {}
ClientActions.IsHandcuffed = false

-- Handcuff
RegisterNetEvent('jobcreator:client:getHandcuffed')
AddEventHandler('jobcreator:client:getHandcuffed', function(officerId)
    ClientActions.IsHandcuffed = not ClientActions.IsHandcuffed
    
    local ped = PlayerPedId()
    
    if ClientActions.IsHandcuffed then
        Utils.RequestAnimDict('mp_arresting')
        TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
        SetEnableHandcuffs(ped, true)
        DisablePlayerFiring(ped, true)
        SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
    else
        ClearPedTasksImmediately(ped)
        SetEnableHandcuffs(ped, false)
        DisablePlayerFiring(ped, false)
    end
end)

RegisterNetEvent('jobcreator:client:getUncuffed')
AddEventHandler('jobcreator:client:getUncuffed', function()
    ClientActions.IsHandcuffed = false
    
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    SetEnableHandcuffs(ped, false)
    DisablePlayerFiring(ped, false)
end)

-- Control handcuff movement
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if ClientActions.IsHandcuffed then
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 31, true) -- S
            DisableControlAction(0, 30, true) -- D
            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also 'Enter'
            DisableControlAction(0, 288, true) -- F1
            DisableControlAction(0, 289, true) -- F2
            DisableControlAction(0, 170, true) -- F3
            DisableControlAction(0, 167, true) -- F6
            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen
            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        else
            Citizen.Wait(500)
        end
    end
end)

-- Heal
RegisterNetEvent('jobcreator:client:getHealed')
AddEventHandler('jobcreator:client:getHealed', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClientFramework.Notify(_('player_healed'), 'success')
end)

-- Revive
RegisterNetEvent('jobcreator:client:getRevived')
AddEventHandler('jobcreator:client:getRevived', function()
    local ped = PlayerPedId()
    
    if ClientFramework.Type == 'esx' then
        TriggerEvent('esx_ambulancejob:revive')
    elseif ClientFramework.Type == 'qbcore' then
        TriggerEvent('hospital:client:Revive')
    else
        -- Basic revive
        local coords = GetEntityCoords(ped)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0.0, true, false)
        SetEntityHealth(ped, GetEntityMaxHealth(ped))
        ClearPedTasksImmediately(ped)
    end
    
    ClientFramework.Notify(_('player_revived'), 'success')
end)

-- Lockpick vehicle
RegisterNetEvent('jobcreator:client:lockpickVehicle')
AddEventHandler('jobcreator:client:lockpickVehicle', function()
    local vehicle = Utils.GetVehicleInDirection()
    
    if vehicle then
        Utils.PlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 16)
        
        Citizen.Wait(5000)
        
        ClearPedTasksImmediately(PlayerPedId())
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        ClientFramework.Notify('Vehicle unlocked', 'success')
    else
        ClientFramework.Notify('No vehicle nearby', 'error')
    end
end)

-- Clean vehicle
RegisterNetEvent('jobcreator:client:cleanVehicle')
AddEventHandler('jobcreator:client:cleanVehicle', function()
    local vehicle = Utils.GetVehicleInDirection()
    
    if vehicle then
        SetVehicleDirtLevel(vehicle, 0.0)
    end
end)

-- Repair vehicle
RegisterNetEvent('jobcreator:client:repairVehicle')
AddEventHandler('jobcreator:client:repairVehicle', function()
    local vehicle = Utils.GetVehicleInDirection()
    
    if vehicle then
        Utils.PlayAnim(PlayerPedId(), 'mini@repair', 'fixing_a_player', 16)
        
        Citizen.Wait(10000)
        
        ClearPedTasksImmediately(PlayerPedId())
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
    end
end)

-- Impound vehicle
RegisterNetEvent('jobcreator:client:impoundVehicle')
AddEventHandler('jobcreator:client:impoundVehicle', function()
    local vehicle = Utils.GetVehicleInDirection()
    
    if vehicle then
        DeleteVehicle(vehicle)
    end
end)

-- Show inventory
RegisterNetEvent('jobcreator:client:showInventory')
AddEventHandler('jobcreator:client:showInventory', function(inventory)
    -- Send to UI
    SendNUIMessage({
        action = 'showInventory',
        inventory = inventory
    })
    SetNuiFocus(true, true)
end)

-- Show identity
RegisterNetEvent('jobcreator:client:showIdentity')
AddEventHandler('jobcreator:client:showIdentity', function(identity)
    -- Send to UI
    SendNUIMessage({
        action = 'showIdentity',
        identity = identity
    })
    SetNuiFocus(true, true)
end)

-- Show vehicle owner
RegisterNetEvent('jobcreator:client:showVehicleOwner')
AddEventHandler('jobcreator:client:showVehicleOwner', function(owner, plate)
    ClientFramework.Notify('Owner: ' .. owner .. ' | Plate: ' .. plate, 'info')
end)

-- Job action menu
function OpenJobActionsMenu()
    local playerData = ClientFramework.GetPlayerData()
    
    if not playerData or not playerData.job then
        return
    end
    
    local elements = {}
    
    if Config.JobActions.handcuff then
        table.insert(elements, {label = _('handcuff'), value = 'handcuff'})
    end
    
    if Config.JobActions.bill then
        table.insert(elements, {label = _('bill'), value = 'bill'})
    end
    
    if Config.JobActions.search then
        table.insert(elements, {label = _('search'), value = 'search'})
    end
    
    if Config.JobActions.heal then
        table.insert(elements, {label = _('heal'), value = 'heal'})
    end
    
    if Config.JobActions.revive then
        table.insert(elements, {label = _('revive'), value = 'revive'})
    end
    
    if Config.JobActions.check_identity then
        table.insert(elements, {label = _('check_identity'), value = 'check_identity'})
    end
    
    -- Send to NUI
    SendNUIMessage({
        action = 'openJobActions',
        actions = elements
    })
    SetNuiFocus(true, true)
end

-- Register key mapping
RegisterCommand('+jobactions', function()
    OpenJobActionsMenu()
end, false)

RegisterKeyMapping('+jobactions', 'Open Job Actions Menu', 'keyboard', 'F7')
