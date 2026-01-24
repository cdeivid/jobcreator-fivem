-- Nexus System (Job Sharing between servers)

if not Config.EnableNexus then
    return
end

Nexus = {}

-- Share job to Nexus
RegisterNetEvent('jobcreator:server:shareJob')
AddEventHandler('jobcreator:server:shareJob', function(jobName)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    if not Config.NexusAPIKey or Config.NexusAPIKey == '' then
        Framework.Notify(source, 'Nexus API key not configured', 'error')
        return
    end
    
    -- Get job data
    Database.GetJob(jobName, function(job)
        if not job then
            Framework.Notify(source, _('job_not_found'), 'error')
            return
        end
        
        -- Get grades
        Database.GetGrades(jobName, function(grades)
            -- Get markers
            Database.GetMarkers(jobName, function(markers)
                local jobData = {
                    job = job,
                    grades = grades,
                    markers = markers
                }
                
                -- Send to Nexus API
                PerformHttpRequest(Config.NexusServerURL .. '/api/jobs/share', function(statusCode, response, headers)
                    if statusCode == 200 then
                        Framework.Notify(source, _('job_shared'), 'success')
                    else
                        Framework.Notify(source, 'Failed to share job: ' .. statusCode, 'error')
                    end
                end, 'POST', json.encode(jobData), {
                    ['Content-Type'] = 'application/json',
                    ['Authorization'] = 'Bearer ' .. Config.NexusAPIKey
                })
            end)
        end)
    end)
end)

-- Import job from Nexus
RegisterNetEvent('jobcreator:server:importJob')
AddEventHandler('jobcreator:server:importJob', function(jobId)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    if not Config.NexusAPIKey or Config.NexusAPIKey == '' then
        Framework.Notify(source, 'Nexus API key not configured', 'error')
        return
    end
    
    -- Get job from Nexus API
    PerformHttpRequest(Config.NexusServerURL .. '/api/jobs/' .. jobId, function(statusCode, response, headers)
        if statusCode == 200 then
            local jobData = json.decode(response)
            
            -- Create job
            Database.CreateJob(jobData.job.name, jobData.job.label, jobData.job.whitelisted, function(success)
                if success then
                    -- Create grades
                    for _, grade in ipairs(jobData.grades) do
                        Database.CreateGrade(jobData.job.name, grade.grade, grade.name, grade.label, grade.salary, function() end)
                    end
                    
                    -- Create markers
                    for _, marker in ipairs(jobData.markers) do
                        marker.job_name = jobData.job.name
                        Database.CreateMarker(marker, function() end)
                    end
                    
                    -- Reload
                    Jobs.LoadAll()
                    Markers.LoadAll()
                    
                    Framework.Notify(source, _('job_imported'), 'success')
                    TriggerClientEvent('jobcreator:client:refreshJobs', -1)
                else
                    Framework.Notify(source, 'Failed to import job', 'error')
                end
            end)
        else
            Framework.Notify(source, 'Failed to fetch job: ' .. statusCode, 'error')
        end
    end, 'GET', '', {
        ['Authorization'] = 'Bearer ' .. Config.NexusAPIKey
    })
end)

-- Get available jobs from Nexus
RegisterServerEvent('jobcreator:server:getNexusJobs')
AddEventHandler('jobcreator:server:getNexusJobs', function()
    local source = source
    
    if not Framework.IsAdmin(source) then
        return
    end
    
    if not Config.NexusAPIKey or Config.NexusAPIKey == '' then
        Framework.Notify(source, 'Nexus API key not configured', 'error')
        return
    end
    
    PerformHttpRequest(Config.NexusServerURL .. '/api/jobs', function(statusCode, response, headers)
        if statusCode == 200 then
            local jobs = json.decode(response)
            TriggerClientEvent('jobcreator:client:receiveNexusJobs', source, jobs)
        else
            Framework.Notify(source, 'Failed to fetch Nexus jobs', 'error')
        end
    end, 'GET', '', {
        ['Authorization'] = 'Bearer ' .. Config.NexusAPIKey
    })
end)
