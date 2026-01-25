# JobCreator UI Guide

## Overview
The JobCreator UI has been completely redesigned with a modern, intuitive interface that provides comprehensive job management capabilities for your FiveM server.

## Accessing the UI
- **Command**: `/jobcreator`
- **Keybind**: `F6` (configurable in config.lua)
- **Requirements**: Admin permissions

## Main Navigation

The UI features a **sidebar navigation** with 5 main sections:

### 1. 💼 Jobs
Manage all jobs on your server.

**Features:**
- View all existing jobs with their labels and IDs
- See rank count for each job
- View whitelist status
- Click any job to access detailed management

**Creating a Job:**
1. Click "+ Create Job" button
2. Enter job label (e.g., "Police Department")
3. Enter job ID/name (e.g., "police")
4. Toggle whitelist if needed
5. Click "Confirm"

**Managing a Job:**
Click on any job card to open the detailed view with 4 tabs:

#### Ranks Tab
- Create job ranks/grades with:
  - Rank label
  - Rank name (ID)
  - Grade number (0-99)
  - Salary amount
- View all existing ranks
- Delete ranks

#### Markers Tab
- Create job-specific markers
- Configure marker properties:
  - Label
  - Type (Stash, Armory, Safe, Garage, etc.)
  - Coordinates (use "Current Position" button)
  - Minimum grade requirement
- View all job markers
- Delete markers

#### Statistics Tab
- View job-specific statistics
- Player count
- Economic data

#### Settings Tab
Configure job permissions:

**General Settings:**
- Whitelisted access
- Actions menu enabled

**Player Interactions:**
- Search players
- Handcuff players
- Heal players
- Revive players
- Bill players

**Identity & License Checks:**
- View identities
- View driver licenses
- View weapon licenses

**Vehicle Actions:**
- Force vehicle locks
- Repair vehicles
- Clean vehicles
- Impound vehicles
- View vehicle owners

### 2. 📍 Public Markers
Create public markers accessible to all players or specific jobs.

**Available Marker Types:**
1. **Stash** - Storage containers
2. **Armory** - Weapon storage
3. **Safe** - Secure storage
4. **Garage** - Vehicle storage/spawning
5. **Wardrobe** - Clothing changes
6. **Job Outfit** - Job-specific uniforms
7. **Shop** - Purchase items
8. **Market** - Trading system
9. **Harvest Point** - Gather resources
10. **Process Point** - Convert materials
11. **Crafting Table** - Create items
12. **Teleport Point** - Location teleportation
13. **Weapon Upgrader** - Upgrade weapons
14. **Job Shop** - Job-specific purchases

**Creating a Public Marker:**
1. Click on desired marker type
2. Enter marker label
3. Click "Current Position" to set coordinates
4. Select access level (Everyone/Specific Job)
5. Click "Confirm"

### 3. 📊 Statistics
View global server statistics.

**Information Displayed:**
- Total jobs created
- Total players online
- Active jobs
- Total markers

Click "🔄 Refresh" to update statistics.

### 4. 🌐 Nexus
Job sharing network (Coming Soon).

This feature will allow you to:
- Share jobs with the community
- Import jobs from other servers
- Browse job templates

### 5. ⚙️ Settings
Configure global system settings.

#### General Settings
- **Menu Language**: Select from 7+ supported languages
  - English, Español, Français, Deutsch, Italiano, Português, Polski

#### Menu Configuration
- **Player Menu Script**: Choose your menu system
  - Default, ESX Menu Default, ESX Menu Dialog, QB Menu
- **Targeting Script**: Select targeting integration
  - None, OX Target, QB Target
- **Help Notification Style**: Configure help text display
  - Default, 3D Text, None

#### Unemployment Configuration
- **Unemployed Job ID**: Set the default unemployed job
- **Unemployed Grade**: Set the default unemployed grade level

#### Permissions
- **Use ACE Permissions**: Toggle ACE permission system

#### Advanced Options
- **Enable Cash Safe for Old ESX Versions**: Compatibility toggle for legacy ESX

**Saving Settings:**
Click "💾 Save Settings" to apply all changes.

## Tips & Best Practices

### Job Creation
1. Use descriptive labels for easy identification
2. Use simple, lowercase IDs (e.g., "police" not "Police_Department")
3. Create a default rank (grade 0) before creating higher ranks
4. Plan your rank structure before implementation

### Marker Placement
1. Stand at the exact location before creating a marker
2. Use the "Current Position" button to auto-fill coordinates
3. Set appropriate grade requirements to control access
4. Label markers clearly for players

### Rank Management
1. Start grades from 0 (recruit/entry level)
2. Use incremental numbers (0, 1, 2, 3...)
3. Set realistic salaries based on your economy
4. Create at least 3-5 ranks for good progression

### Settings Configuration
1. Configure targeting scripts to match your server setup
2. Set language to match your primary player base
3. Test permission changes with non-admin accounts
4. Save settings after any modifications

## Keyboard Shortcuts
- **ESC**: Close modals or UI
- **Click outside modal**: Close modal

## Troubleshooting

### UI Won't Open
- Verify you have admin permissions
- Check console (F8) for errors
- Ensure resource is started: `ensure jobcreator`

### Jobs Not Appearing
- Refresh the UI (close and reopen)
- Check database connection
- Verify MySQL/oxmysql is running

### Coordinates Not Setting
- Ensure you're standing at desired location
- Try clicking "Current Position" again
- Check client console for errors

### Settings Not Saving
- Verify admin permissions
- Check server console for errors
- Note: Some settings require resource restart

## Advanced Features

### Whitelist Management
When a job is whitelisted:
1. Only approved players can access the job
2. Manage whitelist via job settings
3. Add/remove players from whitelist

### Grade-Specific Markers
1. Set minimum grade on markers
2. Lower ranks cannot access restricted markers
3. Use for progression systems

### Multi-Language Support
1. Change language in Settings
2. All text updates automatically
3. Supports ES, EN, FR, DE, IT, PT, PL

## Future Enhancements
- Nexus job sharing network
- Marker customization (colors, size, blips)
- Advanced statistics and analytics
- Job templates and presets
- Bulk operations

## Support
For issues or questions:
- Check server console for errors
- Review client console (F8)
- Consult installation documentation
- Contact server administrators

---

**Version**: 1.0.0  
**Last Updated**: January 2024  
**Compatible**: ESX Legacy, QBCore
