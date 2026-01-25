Config = {}

-- Framework detection (auto-detect ESX or QBCore)
Config.Framework = 'auto' -- 'auto', 'esx', 'qbcore'

-- Locale/Language
Config.Locale = 'en' -- Available: en, it, de, el, bs, pt, es, fr, sk, da, cs, pl

-- Database settings
Config.UseMySQL = true -- Set to true if using mysql-async

-- Job Management
Config.EnableWhitelist = true -- Allow whitelist restrictions
Config.AutoUnemployed = true -- Automatically set players to unemployed when job is deleted
Config.DefaultUnemployedJob = 'unemployed'
Config.DefaultUnemployedGrade = 0

-- Nexus (Job Sharing)
Config.EnableNexus = true
Config.NexusAPIKey = '' -- API key for Nexus service
Config.NexusServerURL = '' -- URL for Nexus server

-- Markers
Config.MarkerTypes = {
    deposit = true,
    arsenal = true,
    safe = true,
    garage_public = true,
    garage_private = true,
    shop = true,
    crafting = true,
    teleporter = true,
    market = true,
    harvest = true,
    processing = true,
    armory = true
}

Config.Marker3DText = true -- Enable 3D text on markers
Config.UseOXTarget = false -- Enable OX Target compatibility
Config.UseQBTarget = false -- Enable QB Target compatibility

-- Actions
Config.EnableJobActions = true
Config.JobActions = {
    handcuff = true,
    bill = true,
    search = true,
    lockpick = true,
    clean_vehicle = true,
    repair_vehicle = true,
    impound_vehicle = true,
    check_owner = true,
    check_identity = true,
    check_license = true,
    heal = true,
    revive = true
}

-- Integrations
Config.UseJsfourIDCard = false -- Enable jsfour-idcard integration

-- Statistics
Config.EnableStatistics = true
Config.StatisticsUpdateInterval = 300000 -- Update every 5 minutes (in ms)

-- UI
Config.UIKey = 'F6' -- Key to open job management UI
Config.UICommand = 'jobcreator' -- Command to open UI

-- Permissions
Config.AdminGroups = {'admin', 'superadmin', 'owner'}

-- Debug
Config.Debug = false
