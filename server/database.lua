-- Database Management
Database = {}

-- Initialize database tables
function Database.Init()
    if not Config.UseMySQL then
        print('[JobCreator] MySQL is disabled, database features will not work')
        return
    end
    
    -- Create jobs table
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `jobcreator_jobs` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `name` VARCHAR(50) NOT NULL UNIQUE,
            `label` VARCHAR(100) NOT NULL,
            `whitelisted` TINYINT(1) DEFAULT 0,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {})
    
    -- Create grades table
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `jobcreator_grades` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `job_name` VARCHAR(50) NOT NULL,
            `grade` INT NOT NULL,
            `name` VARCHAR(50) NOT NULL,
            `label` VARCHAR(100) NOT NULL,
            `salary` INT DEFAULT 0,
            `skin_male` LONGTEXT,
            `skin_female` LONGTEXT,
            PRIMARY KEY (`id`),
            UNIQUE KEY `job_grade_unique` (`job_name`, `grade`),
            FOREIGN KEY (`job_name`) REFERENCES `jobcreator_jobs`(`name`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {})
    
    -- Create markers table
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `jobcreator_markers` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `job_name` VARCHAR(50) NOT NULL,
            `type` VARCHAR(50) NOT NULL,
            `label` VARCHAR(100) NOT NULL,
            `x` FLOAT NOT NULL,
            `y` FLOAT NOT NULL,
            `z` FLOAT NOT NULL,
            `marker_type` INT DEFAULT 1,
            `marker_size` FLOAT DEFAULT 1.5,
            `marker_color` VARCHAR(20) DEFAULT '255,0,0',
            `data` LONGTEXT,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            FOREIGN KEY (`job_name`) REFERENCES `jobcreator_jobs`(`name`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {})
    
    -- Create whitelist table
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `jobcreator_whitelist` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `job_name` VARCHAR(50) NOT NULL,
            `identifier` VARCHAR(100) NOT NULL,
            `added_by` VARCHAR(100),
            `added_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `job_identifier_unique` (`job_name`, `identifier`),
            FOREIGN KEY (`job_name`) REFERENCES `jobcreator_jobs`(`name`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {})
    
    -- Create statistics table
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `jobcreator_statistics` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `job_name` VARCHAR(50) NOT NULL,
            `player_count` INT DEFAULT 0,
            `total_salary` BIGINT DEFAULT 0,
            `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `job_unique` (`job_name`),
            FOREIGN KEY (`job_name`) REFERENCES `jobcreator_jobs`(`name`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {})
    
    print('[JobCreator] Database tables initialized')
end

-- Job operations
function Database.CreateJob(name, label, whitelisted, cb)
    MySQL.Async.execute('INSERT INTO jobcreator_jobs (name, label, whitelisted) VALUES (@name, @label, @whitelisted)',
    {
        ['@name'] = name,
        ['@label'] = label,
        ['@whitelisted'] = whitelisted and 1 or 0
    }, function(result)
        if cb then cb(result > 0) end
    end)
end

function Database.GetJob(name, cb)
    MySQL.Async.fetchAll('SELECT * FROM jobcreator_jobs WHERE name = @name', {
        ['@name'] = name
    }, function(result)
        if cb then cb(result[1]) end
    end)
end

function Database.GetAllJobs(cb)
    MySQL.Async.fetchAll('SELECT * FROM jobcreator_jobs', {}, function(result)
        if cb then cb(result) end
    end)
end

function Database.UpdateJob(name, data, cb)
    local query = 'UPDATE jobcreator_jobs SET '
    local params = {['@name'] = name}
    local updates = {}
    
    if data.label then
        table.insert(updates, 'label = @label')
        params['@label'] = data.label
    end
    
    if data.whitelisted ~= nil then
        table.insert(updates, 'whitelisted = @whitelisted')
        params['@whitelisted'] = data.whitelisted and 1 or 0
    end
    
    query = query .. table.concat(updates, ', ') .. ' WHERE name = @name'
    
    MySQL.Async.execute(query, params, function(result)
        if cb then cb(result > 0) end
    end)
end

function Database.DeleteJob(name, cb)
    MySQL.Async.execute('DELETE FROM jobcreator_jobs WHERE name = @name', {
        ['@name'] = name
    }, function(result)
        if cb then cb(result > 0) end
    end)
end

-- Grade operations
function Database.CreateGrade(jobName, grade, name, label, salary, cb)
    MySQL.Async.execute('INSERT INTO jobcreator_grades (job_name, grade, name, label, salary) VALUES (@job_name, @grade, @name, @label, @salary)',
    {
        ['@job_name'] = jobName,
        ['@grade'] = grade,
        ['@name'] = name,
        ['@label'] = label,
        ['@salary'] = salary
    }, function(result)
        if cb then cb(result > 0) end
    end)
end

function Database.GetGrades(jobName, cb)
    MySQL.Async.fetchAll('SELECT * FROM jobcreator_grades WHERE job_name = @job_name ORDER BY grade', {
        ['@job_name'] = jobName
    }, function(result)
        if cb then cb(result) end
    end)
end

function Database.UpdateGrade(id, data, cb)
    local query = 'UPDATE jobcreator_grades SET '
    local params = {['@id'] = id}
    local updates = {}
    
    if data.name then
        table.insert(updates, 'name = @name')
        params['@name'] = data.name
    end
    
    if data.label then
        table.insert(updates, 'label = @label')
        params['@label'] = data.label
    end
    
    if data.salary then
        table.insert(updates, 'salary = @salary')
        params['@salary'] = data.salary
    end
    
    query = query .. table.concat(updates, ', ') .. ' WHERE id = @id'
    
    MySQL.Async.execute(query, params, function(result)
        if cb then cb(result > 0) end
    end)
end

function Database.DeleteGrade(id, cb)
    MySQL.Async.execute('DELETE FROM jobcreator_grades WHERE id = @id', {
        ['@id'] = id
    }, function(result)
        if cb then cb(result > 0) end
    end)
end

-- Marker operations
function Database.CreateMarker(data, cb)
    MySQL.Async.execute('INSERT INTO jobcreator_markers (job_name, type, label, x, y, z, marker_type, marker_size, marker_color, data) VALUES (@job_name, @type, @label, @x, @y, @z, @marker_type, @marker_size, @marker_color, @data)',
    {
        ['@job_name'] = data.job_name,
        ['@type'] = data.type,
        ['@label'] = data.label,
        ['@x'] = data.x,
        ['@y'] = data.y,
        ['@z'] = data.z,
        ['@marker_type'] = data.marker_type or 1,
        ['@marker_size'] = data.marker_size or 1.5,
        ['@marker_color'] = data.marker_color or '255,0,0',
        ['@data'] = data.data and json.encode(data.data) or '{}'
    }, function(result)
        if cb then cb(result > 0) end
    end)
end

function Database.GetMarkers(jobName, cb)
    MySQL.Async.fetchAll('SELECT * FROM jobcreator_markers WHERE job_name = @job_name', {
        ['@job_name'] = jobName
    }, function(result)
        for i = 1, #result do
            if result[i].data then
                result[i].data = json.decode(result[i].data)
            end
        end
        if cb then cb(result) end
    end)
end

function Database.GetAllMarkers(cb)
    MySQL.Async.fetchAll('SELECT * FROM jobcreator_markers', {}, function(result)
        for i = 1, #result do
            if result[i].data then
                result[i].data = json.decode(result[i].data)
            end
        end
        if cb then cb(result) end
    end)
end

function Database.DeleteMarker(id, cb)
    MySQL.Async.execute('DELETE FROM jobcreator_markers WHERE id = @id', {
        ['@id'] = id
    }, function(result)
        if cb then cb(result > 0) end
    end)
end

-- Whitelist operations
function Database.AddToWhitelist(jobName, identifier, addedBy, cb)
    MySQL.Async.execute('INSERT INTO jobcreator_whitelist (job_name, identifier, added_by) VALUES (@job_name, @identifier, @added_by)',
    {
        ['@job_name'] = jobName,
        ['@identifier'] = identifier,
        ['@added_by'] = addedBy
    }, function(result)
        if cb then cb(result > 0) end
    end)
end

function Database.RemoveFromWhitelist(jobName, identifier, cb)
    MySQL.Async.execute('DELETE FROM jobcreator_whitelist WHERE job_name = @job_name AND identifier = @identifier', {
        ['@job_name'] = jobName,
        ['@identifier'] = identifier
    }, function(result)
        if cb then cb(result > 0) end
    end)
end

function Database.IsWhitelisted(jobName, identifier, cb)
    MySQL.Async.fetchAll('SELECT * FROM jobcreator_whitelist WHERE job_name = @job_name AND identifier = @identifier', {
        ['@job_name'] = jobName,
        ['@identifier'] = identifier
    }, function(result)
        if cb then cb(#result > 0) end
    end)
end

-- Initialize on resource start
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Wait for MySQL to be ready
    Database.Init()
end)
