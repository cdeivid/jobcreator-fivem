-- Client Marker Management
ClientMarkers = {}
ClientMarkers.List = {}
ClientMarkers.Active = {}

-- Receive markers from server
RegisterNetEvent('jobcreator:client:receiveMarkers')
AddEventHandler('jobcreator:client:receiveMarkers', function(markers)
    ClientMarkers.List = markers
end)

-- Process markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local playerData = ClientFramework.GetPlayerData()
        local playerJob = playerData and playerData.job and playerData.job.name
        
        local nearMarker = false
        
        for _, marker in ipairs(ClientMarkers.List) do
            -- Check if marker belongs to player's job or is public
            if marker.job_name == playerJob or marker.job_name == 'public' then
                local markerCoords = vector3(marker.x, marker.y, marker.z)
                local distance = #(coords - markerCoords)
                
                if distance < 50.0 then
                    -- Parse color
                    local colors = {}
                    for color in string.gmatch(marker.marker_color, '([^,]+)') do
                        table.insert(colors, tonumber(color))
                    end
                    
                    -- Draw marker
                    Utils.DrawMarker(
                        marker.marker_type or 1,
                        marker.x, marker.y, marker.z,
                        marker.marker_size or 1.5,
                        colors[1] or 255, colors[2] or 0, colors[3] or 0,
                        150
                    )
                    
                    -- Draw 3D text
                    if Config.Marker3DText and distance < 10.0 then
                        Utils.Draw3DText(marker.x, marker.y, marker.z + 1.0, marker.label)
                    end
                    
                    -- Interaction
                    if distance < 2.0 then
                        nearMarker = true
                        ClientFramework.ShowHelpNotification(_('press_e_to_interact'))
                        
                        if IsControlJustReleased(0, 38) then -- E key
                            HandleMarkerInteraction(marker)
                        end
                    end
                end
            end
        end
        
        if not nearMarker then
            Citizen.Wait(500)
        end
    end
end)

-- Handle marker interaction
function HandleMarkerInteraction(marker)
    if marker.type == 'deposit' then
        -- Open deposit menu
        TriggerEvent('jobcreator:client:openDeposit', marker)
    elseif marker.type == 'arsenal' then
        -- Open arsenal menu
        TriggerEvent('jobcreator:client:openArsenal', marker)
    elseif marker.type == 'safe' then
        -- Open safe menu
        TriggerEvent('jobcreator:client:openSafe', marker)
    elseif marker.type == 'garage_public' or marker.type == 'garage_private' then
        -- Open garage menu
        TriggerEvent('jobcreator:client:openGarage', marker)
    elseif marker.type == 'shop' then
        -- Open shop menu
        TriggerEvent('jobcreator:client:openShop', marker)
    elseif marker.type == 'crafting' then
        -- Open crafting menu
        TriggerEvent('jobcreator:client:openCrafting', marker)
    elseif marker.type == 'teleporter' then
        -- Teleport player
        if marker.data and marker.data.target then
            SetEntityCoords(PlayerPedId(), marker.data.target.x, marker.data.target.y, marker.data.target.z)
        end
    elseif marker.type == 'market' then
        -- Open market menu
        TriggerEvent('jobcreator:client:openMarket', marker)
    elseif marker.type == 'harvest' then
        -- Start harvest
        TriggerEvent('jobcreator:client:startHarvest', marker)
    elseif marker.type == 'processing' then
        -- Start processing
        TriggerEvent('jobcreator:client:startProcessing', marker)
    elseif marker.type == 'armory' then
        -- Open armory menu
        TriggerEvent('jobcreator:client:openArmory', marker)
    end
end

-- OX Target integration
if Config.UseOXTarget then
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        
        for _, marker in ipairs(ClientMarkers.List) do
            exports.ox_target:addBoxZone({
                coords = vector3(marker.x, marker.y, marker.z),
                size = vector3(2, 2, 2),
                rotation = 0,
                debug = Config.Debug,
                options = {
                    {
                        name = 'jobcreator_' .. marker.id,
                        label = marker.label,
                        onSelect = function()
                            HandleMarkerInteraction(marker)
                        end
                    }
                }
            })
        end
    end)
end

-- QB Target integration
if Config.UseQBTarget then
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        
        for _, marker in ipairs(ClientMarkers.List) do
            exports['qb-target']:AddBoxZone('jobcreator_' .. marker.id, vector3(marker.x, marker.y, marker.z), 2, 2, {
                name = 'jobcreator_' .. marker.id,
                heading = 0,
                debugPoly = Config.Debug,
                minZ = marker.z - 1,
                maxZ = marker.z + 1,
            }, {
                options = {
                    {
                        type = "client",
                        label = marker.label,
                        action = function()
                            HandleMarkerInteraction(marker)
                        end
                    }
                },
                distance = 2.5
            })
        end
    end)
end
