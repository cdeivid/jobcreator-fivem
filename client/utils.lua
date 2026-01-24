-- Client Utilities

Utils = {}

-- Draw 3D Text
function Utils.Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
end

-- Draw marker
function Utils.DrawMarker(type, x, y, z, scale, r, g, b, alpha)
    DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, scale, scale, r, g, b, alpha, false, true, 2, false, nil, nil, false)
end

-- Get closest player
function Utils.GetClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    for _, player in ipairs(players) do
        local target = GetPlayerPed(player)

        if target ~= ped then
            local targetCoords = GetEntityCoords(target)
            local distance = #(coords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

-- Get closest vehicle
function Utils.GetClosestVehicle()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicles = {}
    local vehicle = nil
    
    for veh in EnumerateVehicles() do
        table.insert(vehicles, veh)
    end
    
    local closestDistance = -1
    local closestVehicle = -1
    
    for _, veh in ipairs(vehicles) do
        local vehCoords = GetEntityCoords(veh)
        local distance = #(coords - vehCoords)
        
        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = veh
            closestDistance = distance
        end
    end
    
    return closestVehicle, closestDistance
end

-- Enumerate vehicles
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

-- Get vehicle in front
function Utils.GetVehicleInDirection()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    
    local rayHandle = StartShapeTestCapsule(coords.x, coords.y, coords.z, offset.x, offset.y, offset.z, 1.0, 10, ped, 7)
    local _, hit, _, _, vehicle = GetShapeTestResult(rayHandle)
    
    if hit and vehicle ~= 0 then
        return vehicle
    end
    
    return nil
end

-- Request animation dict
function Utils.RequestAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end
end

-- Play animation
function Utils.PlayAnim(ped, dict, anim, flag)
    Utils.RequestAnimDict(dict)
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, flag or 0, 0, false, false, false)
end
