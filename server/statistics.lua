-- Statistics System

if not Config.EnableStatistics then
    return
end

Statistics = {}

-- Update statistics
function Statistics.Update()
    if not Config.UseMySQL then return end
    
    local jobStats = {}
    
    -- Count players per job
    for _, playerId in ipairs(GetPlayers()) do
        local jobName, grade = Framework.GetPlayerJob(playerId)
        
        if jobName then
            if not jobStats[jobName] then
                jobStats[jobName] = {
                    player_count = 0,
                    total_salary = 0
                }
            end
            
            jobStats[jobName].player_count = jobStats[jobName].player_count + 1
            
            -- Get salary for this grade
            if Jobs.List[jobName] and Jobs.List[jobName].grades then
                for _, gradeData in ipairs(Jobs.List[jobName].grades) do
                    if gradeData.grade == grade then
                        jobStats[jobName].total_salary = jobStats[jobName].total_salary + (gradeData.salary or 0)
                        break
                    end
                end
            end
        end
    end
    
    -- Update database in a single thread to prevent overhead
    Citizen.CreateThread(function()
        for jobName, stats in pairs(jobStats) do
            MySQL.Async.execute('INSERT INTO jobcreator_statistics (job_name, player_count, total_salary) VALUES (@job_name, @player_count, @total_salary) ON DUPLICATE KEY UPDATE player_count = @player_count, total_salary = @total_salary',
            {
                ['@job_name'] = jobName,
                ['@player_count'] = stats.player_count,
                ['@total_salary'] = stats.total_salary
            }, function() end)
            Citizen.Wait(10) -- Small delay between queries
        end
    end)
end

-- Get statistics
RegisterServerEvent('jobcreator:server:getStatistics')
AddEventHandler('jobcreator:server:getStatistics', function()
    local source = source
    
    if not Framework.IsAdmin(source) then
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM jobcreator_statistics ORDER BY player_count DESC', {}, function(result)
        TriggerClientEvent('jobcreator:client:receiveStatistics', source, result)
    end)
end)

-- Update statistics periodically
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.StatisticsUpdateInterval)
        Statistics.Update()
    end
end)
