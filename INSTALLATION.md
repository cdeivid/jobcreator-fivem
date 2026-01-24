# Installation Guide - Job Creator FiveM

This guide will walk you through the complete installation process for the Job Creator script.

## Prerequisites

Before installing, ensure you have:
- A FiveM server (build 2802 or higher recommended)
- Access to your server files
- MySQL database configured
- One of the following frameworks:
  - ESX Legacy or ES Extended
  - QBCore
- Basic knowledge of FiveM server management

## Step-by-Step Installation

### 1. Download the Resource

1. Download the latest release from the repository
2. Extract the ZIP file to get the `jobcreator` folder

### 2. Install the Resource

1. Navigate to your FiveM server's `resources` directory
2. Copy the entire `jobcreator` folder into `resources`
3. Your structure should look like:
   ```
   resources/
   ├── [other resources]
   └── jobcreator/
       ├── client/
       ├── server/
       ├── html/
       ├── locales/
       ├── config.lua
       ├── fxmanifest.lua
       └── ...
   ```

### 3. Configure MySQL

The script uses MySQL to store job data. Ensure you have one of the following installed:
- `mysql-async` (recommended)
- `oxmysql`
- `ghmattimysql`

The script will automatically create all necessary tables on first startup.

### 4. Configure server.cfg

Add the following to your `server.cfg` file:

```cfg
# Database (choose one)
ensure mysql-async
# OR
# ensure oxmysql
# OR
# ensure ghmattimysql

# Framework (must be loaded before jobcreator)
ensure es_extended   # If using ESX
# OR
ensure qb-core       # If using QBCore

# Job Creator
ensure jobcreator
```

**Important:** Make sure your framework is loaded BEFORE jobcreator!

### 5. Configure the Script

Open `config.lua` and adjust the settings to your preferences:

```lua
Config = {}

-- Framework (auto-detect recommended)
Config.Framework = 'auto'  -- Options: 'auto', 'esx', 'qbcore'

-- Language
Config.Locale = 'en'  -- Available: en, es, fr, pt, it, de, pl, etc.

-- Database
Config.UseMySQL = true  -- Set to false to disable MySQL features

-- Features
Config.EnableWhitelist = true      -- Allow job whitelisting
Config.AutoUnemployed = true       -- Auto-set to unemployed when job deleted
Config.EnableNexus = false         -- Enable job sharing (configure API key first)
Config.EnableStatistics = true     -- Enable statistics tracking

-- UI
Config.UIKey = 'F6'               -- Key to open menu
Config.UICommand = 'jobcreator'   -- Command to open menu

-- Admin permissions
Config.AdminGroups = {'admin', 'superadmin', 'owner'}

-- Target systems (optional)
Config.UseOXTarget = false   -- Enable if you have ox_target
Config.UseQBTarget = false   -- Enable if you have qb-target

-- Debug
Config.Debug = false  -- Set to true for debugging
```

### 6. Optional: Configure Nexus (Job Sharing)

If you want to use the Nexus feature to share jobs between servers:

1. Register for a Nexus API key (contact the Nexus service provider)
2. In `config.lua`, set:
   ```lua
   Config.EnableNexus = true
   Config.NexusAPIKey = 'your-api-key-here'
   Config.NexusServerURL = 'https://nexus.example.com'
   ```

### 7. Start Your Server

1. Save all configuration changes
2. Restart your FiveM server
3. Watch the console for any errors during startup
4. You should see messages like:
   ```
   [JobCreator] Database tables initialized
   [JobCreator] ESX Framework detected
   [JobCreator] Loaded 0 jobs
   [JobCreator] Server initialized successfully
   ```

### 8. Verify Installation

1. Join your server
2. Ensure you have admin permissions in your framework
3. Type `/jobcreator` or press `F6`
4. The Job Creator menu should open

If the menu doesn't open:
- Check that you have admin permissions
- Look for errors in the F8 console
- Verify the script is running: `restart jobcreator`

## First Steps After Installation

### Create Your First Job

1. Open the menu (`/jobcreator` or `F6`)
2. Go to the "Jobs" tab
3. Click "Create Job"
4. Fill in:
   - Job Name: `police` (lowercase, no spaces)
   - Job Label: `Police Department`
   - Whitelist: Check if you want to restrict access
5. Click Submit

### Create Grades for the Job

1. Go to the "Grades" tab
2. Select your newly created job
3. Click "Create Grade"
4. Create grades starting from 0:
   - Grade 0: Recruit ($500 salary)
   - Grade 1: Officer ($1000 salary)
   - Grade 2: Sergeant ($1500 salary)
   - And so on...

### Add Markers

1. Go to a location in-game where you want a marker
2. Open the menu → "Markers" tab
3. Click "Create Marker at Current Position"
4. Configure:
   - Select the job
   - Choose marker type (e.g., Arsenal)
   - Set label and appearance
5. The marker will appear immediately

### Set a Player's Job

Use your framework's commands:
- **ESX:** `/setjob [id] [job] [grade]`
- **QBCore:** `/job set [id] [job] [grade]`

Or use the admin commands from your framework's admin panel.

## Troubleshooting

### Database Tables Not Created

**Problem:** Tables don't exist in the database

**Solutions:**
1. Ensure `mysql-async` is running: `ensure mysql-async`
2. Check MySQL credentials in your server configuration
3. Manually import `jobcreator.sql` (optional, as script creates tables automatically)
4. Restart the resource: `restart jobcreator`

### Framework Not Detected

**Problem:** Console shows "No compatible framework detected"

**Solutions:**
1. Ensure ESX or QBCore is started before jobcreator
2. Check your `server.cfg` order:
   ```cfg
   ensure es_extended
   ensure jobcreator
   ```
3. Manually set framework in `config.lua`:
   ```lua
   Config.Framework = 'esx'  -- or 'qbcore'
   ```

### Menu Won't Open

**Problem:** `/jobcreator` or `F6` doesn't open the menu

**Solutions:**
1. Verify you have admin permissions in your framework
2. Check admin groups in `config.lua` match your permission level
3. Look for errors in F8 console
4. Try alternative command: `/jobcreator`
5. Check if key mapping conflicts exist

### Markers Not Appearing

**Problem:** Created markers don't show up in-game

**Solutions:**
1. Ensure you have the job assigned to your character
2. Restart the resource: `restart jobcreator`
3. Check that markers were created successfully (no database errors)
4. Verify marker coordinates are correct
5. Make sure you're close enough to the marker (<50 units)

### Actions Not Working

**Problem:** Job actions (handcuff, bill, etc.) don't work

**Solutions:**
1. Ensure actions are enabled in `config.lua`:
   ```lua
   Config.EnableJobActions = true
   Config.JobActions = {
       handcuff = true,
       bill = true,
       -- etc.
   }
   ```
2. Check that you're close enough to the target player/vehicle
3. Verify you have the correct job/permissions
4. Look for errors in F8 console

## Performance Optimization

### For Large Servers (100+ players)

1. Increase statistics update interval:
   ```lua
   Config.StatisticsUpdateInterval = 600000  -- 10 minutes
   ```

2. Disable unused features:
   ```lua
   Config.EnableNexus = false
   Config.EnableStatistics = false
   ```

3. Use OX Target or QB Target instead of marker threads:
   ```lua
   Config.UseOXTarget = true  -- More performance-friendly
   ```

### Database Optimization

For better performance with many jobs:
1. Add indexes to frequently queried columns (already included in schema)
2. Regularly clean up unused whitelist entries
3. Archive old statistics data

## Updating the Script

When a new version is released:

1. **Backup your data:**
   ```sql
   mysqldump -u username -p database_name jobcreator_* > jobcreator_backup.sql
   ```

2. Stop the server

3. Replace the old `jobcreator` folder with the new one

4. Compare your old `config.lua` with the new one and transfer your settings

5. Start the server and check for any migration messages

## Support

If you encounter issues not covered here:

1. Check the [GitHub Issues](https://github.com/cdeivid/jobcreator-fivem/issues)
2. Review the [full documentation](README.md)
3. Join our Discord community
4. Open a new issue with:
   - Your FiveM server version
   - Framework (ESX/QBCore) and version
   - Error messages from console
   - Steps to reproduce the issue

## Security Best Practices

1. **Restrict Admin Access:**
   - Only give admin permissions to trusted staff
   - Use specific admin groups in config

2. **Regular Backups:**
   - Back up your database regularly
   - Keep copies of your configuration

3. **Monitor Actions:**
   - Review job changes regularly
   - Check who's adding/removing from whitelists

4. **Update Regularly:**
   - Keep the script updated for security fixes
   - Subscribe to release notifications

## Next Steps

Now that your Job Creator is installed:

1. Create all your server jobs
2. Set up grades and salaries
3. Place markers around the map
4. Configure whitelists for restricted jobs
5. Test all features thoroughly
6. Train your staff on how to use it

Enjoy your new Job Creator system! 🎉
