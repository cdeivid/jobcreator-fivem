-- Main Server File

print([[
^2
  _____       _        _____                 _             
 |_   _|     | |      /  __ \               | |            
   | |  ___  | |__    | /  \/_ __ ___  __ _| |_ ___  _ __ 
   | | / _ \ | '_ \   | |   | '__/ _ \/ _` | __/ _ \| '__|
  _| || (_) || |_) |  | \__/\ | |  __/ (_| | || (_) | |   
  \___/\___/ |_.__/    \____/_|  \___|\__,_|\__\___/|_|   
                                                           
  FiveM Job Creator - Version 1.0.0
  Compatible with ESX and QBCore
^0
]])

-- Register commands
RegisterCommand(Config.UICommand, function(source, args, rawCommand)
    if Framework.IsAdmin(source) then
        TriggerClientEvent('jobcreator:client:openUI', source)
    else
        Framework.Notify(source, _('no_permission'), 'error')
    end
end, false)

-- Player loaded event
if Framework.Type == 'esx' then
    AddEventHandler('esx:playerLoaded', function(source)
        TriggerClientEvent('jobcreator:client:receiveMarkers', source, Markers.List)
    end)
elseif Framework.Type == 'qbcore' then
    AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
        local source = Player.PlayerData.source
        TriggerClientEvent('jobcreator:client:receiveMarkers', source, Markers.List)
    end)
end

print('[JobCreator] Server initialized successfully')
