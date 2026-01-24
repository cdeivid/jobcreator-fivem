-- Marker Management Server
Markers = {}
Markers.List = {}

-- Load all markers
function Markers.LoadAll()
    if not Config.UseMySQL then return end
    
    Database.GetAllMarkers(function(markers)
        Markers.List = markers
        print('[JobCreator] Loaded ' .. #markers .. ' markers')
        
        -- Send to all clients
        TriggerClientEvent('jobcreator:client:receiveMarkers', -1, markers)
    end)
end

-- Create marker
RegisterNetEvent('jobcreator:server:createMarker')
AddEventHandler('jobcreator:server:createMarker', function(data)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    if not data.job_name or not data.type or not data.label then
        Framework.Notify(source, _('invalid_input'), 'error')
        return
    end
    
    Database.CreateMarker(data, function(success)
        if success then
            Markers.LoadAll()
            Framework.Notify(source, _('marker_created'), 'success')
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

-- Delete marker
RegisterNetEvent('jobcreator:server:deleteMarker')
AddEventHandler('jobcreator:server:deleteMarker', function(markerId)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    Database.DeleteMarker(markerId, function(success)
        if success then
            Markers.LoadAll()
            Framework.Notify(source, _('marker_deleted'), 'success')
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

-- Get markers for a job
RegisterServerEvent('jobcreator:server:getMarkers')
AddEventHandler('jobcreator:server:getMarkers', function(jobName)
    local source = source
    
    if jobName then
        Database.GetMarkers(jobName, function(markers)
            TriggerClientEvent('jobcreator:client:receiveMarkers', source, markers)
        end)
    else
        TriggerClientEvent('jobcreator:client:receiveMarkers', source, Markers.List)
    end
end)

-- Initialize
Citizen.CreateThread(function()
    Citizen.Wait(3000)
    Markers.LoadAll()
end)
