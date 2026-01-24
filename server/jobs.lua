-- Job Management Server
Jobs = {}
Jobs.List = {}

-- Load all jobs from database
function Jobs.LoadAll()
    if not Config.UseMySQL then return end
    
    Database.GetAllJobs(function(jobs)
        Jobs.List = {}
        for _, job in ipairs(jobs) do
            Jobs.List[job.name] = job
            -- Load grades for each job
            Database.GetGrades(job.name, function(grades)
                Jobs.List[job.name].grades = grades
            end)
        end
        print('[JobCreator] Loaded ' .. #jobs .. ' jobs')
    end)
end

-- Create a new job
RegisterNetEvent('jobcreator:server:createJob')
AddEventHandler('jobcreator:server:createJob', function(data)
    local source = source
    
    -- Check permission
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    -- Validate input
    if not data.name or not data.label then
        Framework.Notify(source, _('invalid_input'), 'error')
        return
    end
    
    -- Create job in database
    Database.CreateJob(data.name, data.label, data.whitelisted or false, function(success)
        if success then
            -- Reload jobs
            Jobs.LoadAll()
            
            -- Create default grade
            Database.CreateGrade(data.name, 0, 'recruit', 'Recruit', 0, function(gradeSuccess)
                Framework.Notify(source, _('job_created'), 'success')
                TriggerClientEvent('jobcreator:client:refreshJobs', -1)
            end)
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

-- Update job
RegisterNetEvent('jobcreator:server:updateJob')
AddEventHandler('jobcreator:server:updateJob', function(jobName, data)
    local source = source
    
    -- Check permission
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    Database.UpdateJob(jobName, data, function(success)
        if success then
            Jobs.LoadAll()
            Framework.Notify(source, _('job_updated'), 'success')
            TriggerClientEvent('jobcreator:client:refreshJobs', -1)
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

-- Delete job
RegisterNetEvent('jobcreator:server:deleteJob')
AddEventHandler('jobcreator:server:deleteJob', function(jobName)
    local source = source
    
    -- Check permission
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    Database.DeleteJob(jobName, function(success)
        if success then
            -- Auto-unemployed feature
            if Config.AutoUnemployed then
                for _, playerId in ipairs(GetPlayers()) do
                    local playerJob, playerGrade = Framework.GetPlayerJob(playerId)
                    if playerJob == jobName then
                        Framework.SetPlayerJob(playerId, Config.DefaultUnemployedJob, Config.DefaultUnemployedGrade)
                    end
                end
            end
            
            Jobs.LoadAll()
            Framework.Notify(source, _('job_deleted'), 'success')
            TriggerClientEvent('jobcreator:client:refreshJobs', -1)
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

-- Get all jobs
RegisterServerEvent('jobcreator:server:getJobs')
AddEventHandler('jobcreator:server:getJobs', function()
    local source = source
    TriggerClientEvent('jobcreator:client:receiveJobs', source, Jobs.List)
end)

-- Whitelist management
RegisterNetEvent('jobcreator:server:addToWhitelist')
AddEventHandler('jobcreator:server:addToWhitelist', function(jobName, targetIdentifier)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    local adminIdentifier = Framework.GetIdentifier(source)
    
    Database.AddToWhitelist(jobName, targetIdentifier, adminIdentifier, function(success)
        if success then
            Framework.Notify(source, _('success'), 'success')
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

RegisterNetEvent('jobcreator:server:removeFromWhitelist')
AddEventHandler('jobcreator:server:removeFromWhitelist', function(jobName, targetIdentifier)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    Database.RemoveFromWhitelist(jobName, targetIdentifier, function(success)
        if success then
            Framework.Notify(source, _('success'), 'success')
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

-- Check if player can access job
function Jobs.CanAccessJob(source, jobName, callback)
    local job = Jobs.List[jobName]
    if not job then 
        if callback then callback(false) end
        return 
    end
    
    if not job.whitelisted or job.whitelisted == 0 then
        if callback then callback(true) end
        return
    end
    
    local identifier = Framework.GetIdentifier(source)
    Database.IsWhitelisted(jobName, identifier, function(isWhitelisted)
        if callback then callback(isWhitelisted) end
    end)
end

-- Initialize
Citizen.CreateThread(function()
    Citizen.Wait(2000) -- Wait for database
    Jobs.LoadAll()
end)
