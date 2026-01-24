-- Main Client File

print('[JobCreator] Client initialized')

-- Register key for opening menu
RegisterCommand(Config.UICommand, function()
    TriggerEvent('jobcreator:client:openUI')
end, false)

-- Register key mapping
RegisterKeyMapping(Config.UICommand, 'Open Job Creator', 'keyboard', Config.UIKey)
