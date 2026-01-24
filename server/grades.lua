-- Grade/Rank Management Server

-- Create grade
RegisterNetEvent('jobcreator:server:createGrade')
AddEventHandler('jobcreator:server:createGrade', function(data)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    if not data.job_name or not data.grade or not data.name or not data.label then
        Framework.Notify(source, _('invalid_input'), 'error')
        return
    end
    
    Database.CreateGrade(data.job_name, data.grade, data.name, data.label, data.salary or 0, function(success)
        if success then
            Jobs.LoadAll()
            Framework.Notify(source, _('grade_created'), 'success')
            TriggerClientEvent('jobcreator:client:refreshJobs', -1)
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

-- Update grade
RegisterNetEvent('jobcreator:server:updateGrade')
AddEventHandler('jobcreator:server:updateGrade', function(gradeId, data)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    Database.UpdateGrade(gradeId, data, function(success)
        if success then
            Jobs.LoadAll()
            Framework.Notify(source, _('grade_updated'), 'success')
            TriggerClientEvent('jobcreator:client:refreshJobs', -1)
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

-- Delete grade
RegisterNetEvent('jobcreator:server:deleteGrade')
AddEventHandler('jobcreator:server:deleteGrade', function(gradeId)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    Database.DeleteGrade(gradeId, function(success)
        if success then
            Jobs.LoadAll()
            Framework.Notify(source, _('grade_deleted'), 'success')
            TriggerClientEvent('jobcreator:client:refreshJobs', -1)
        else
            Framework.Notify(source, _('action_failed'), 'error')
        end
    end)
end)

-- Get grades for a job
RegisterServerEvent('jobcreator:server:getGrades')
AddEventHandler('jobcreator:server:getGrades', function(jobName)
    local source = source
    
    Database.GetGrades(jobName, function(grades)
        TriggerClientEvent('jobcreator:client:receiveGrades', source, grades)
    end)
end)

-- Set player job and grade
RegisterNetEvent('jobcreator:server:setJob')
AddEventHandler('jobcreator:server:setJob', function(targetId, jobName, grade)
    local source = source
    
    if not Framework.IsAdmin(source) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    -- Check if job exists
    if not Jobs.List[jobName] then
        Framework.Notify(source, _('job_not_found'), 'error')
        return
    end
    
    -- Check whitelist
    if not Jobs.CanAccessJob(targetId, jobName) then
        Framework.Notify(source, _('no_permission'), 'error')
        return
    end
    
    -- Set job
    local success = Framework.SetPlayerJob(targetId, jobName, grade)
    
    if success then
        Framework.Notify(source, _('success'), 'success')
        Framework.Notify(targetId, _('job_updated'), 'info')
    else
        Framework.Notify(source, _('action_failed'), 'error')
    end
end)
