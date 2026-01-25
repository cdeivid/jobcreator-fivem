# Job Creator for FiveM

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![FiveM](https://img.shields.io/badge/FiveM-Compatible-orange)

A comprehensive job creation and management system for FiveM servers, inspired by Jaksam's Jobs Creator. Compatible with both ESX and QBCore frameworks.

[🇪🇸 Documentación en Español](README_ES.md)

## 🌟 Features

### ✨ Easy Installation
- **Minimal configuration** required
- **Drag & drop installation** - just drop the files
- Simple configuration in `server.cfg`:
  ```
  ensure jobcreator
  ```

### 🌍 Multilingual Support
Supports 12 languages:
- 🇬🇧 English
- 🇮🇹 Italian
- 🇩🇪 German
- 🇬🇷 Greek
- 🇧🇦 Bosnian
- 🇵🇹 Portuguese
- 🇪🇸 Spanish
- 🇫🇷 French
- 🇸🇰 Slovak
- 🇩🇰 Danish
- 🇨🇿 Czech
- 🇵🇱 Polish

### 💼 Job Management
- ✅ Create jobs quickly
- ✅ Edit jobs in real-time
- ✅ Delete jobs without errors
- ✅ Whitelist system
- ✅ Auto-unemployed when job is deleted
- ✅ Automatic ID synchronization

### 📊 Rank/Grade Management
- Create ranks with custom permissions
- Edit ranks live
- Delete ranks safely
- Configure salaries per rank

### 🌐 Nexus (Job Sharing)
- Share jobs between servers
- Import jobs easily
- Community of shared jobs

### 🎯 Interactive Markers
Available marker types:
- 💰 Deposits
- 🔫 Arsenals
- 🔒 Safes
- 🚗 Public/Private Garages
- 🏪 Job Shops
- 🔨 Crafting Tables
- 📍 Teleporters
- 🏪 Markets
- 🌾 Harvest Points
- ⚙️ Processing Points
- 🛡️ Enhanced Armories

Marker features:
- Customizable 3D text
- Custom colors
- OX Target compatible
- QB Target compatible

### 🎮 Job Actions
- 👮 Handcuff/Uncuff players
- 💵 Bill players
- 🔍 Search players
- 🔓 Lockpick vehicles
- 🧽 Clean vehicles
- 🔧 Repair vehicles
- 🚓 Impound vehicles
- 📋 Check vehicle owners
- 🆔 Check player identity
- 📜 Check licenses
- 💊 Heal players
- ❤️ Revive players

### 📈 Statistics System
- Track job popularity
- Server economic balance
- Rank distribution
- Player count per job
- Automatic periodic updates

## 🔧 Requirements

### Required Dependencies
- **FiveM Server** (latest version)
- **mysql-async** or **oxmysql** or **ghmattimysql**
- One of the following frameworks:
  - **ESX Legacy** or **ES Extended**
  - **QBCore**

### Optional Dependencies
- **ox_target** (for OX Target compatibility)
- **qb-target** (for QB Target compatibility)
- **jsfour-idcard** (for ID card integration)

## 📥 Installation

### Step 1: Download
Download the latest version from [Releases](#).

### Step 2: Install
1. Extract the ZIP file
2. Place the `jobcreator` folder in your `resources` directory
3. Ensure the structure is:
   ```
   resources/
   └── jobcreator/
       ├── client/
       ├── server/
       ├── html/
       ├── locales/
       ├── config.lua
       └── fxmanifest.lua
   ```

### Step 3: Configure Database
The script will automatically create the necessary tables on startup. Ensure you have `mysql-async` configured correctly.

### Step 4: Configure server.cfg
Add these lines to your `server.cfg`:
```cfg
ensure mysql-async  # or oxmysql/ghmattimysql
ensure jobcreator
```

### Step 5: Configure the Script
Edit `config.lua` according to your needs:
```lua
Config.Framework = 'auto'  -- 'auto', 'esx', 'qbcore'
Config.Locale = 'en'       -- Default language
Config.EnableWhitelist = true
Config.AutoUnemployed = true
-- ... more options
```

### Step 6: Start the Server
Restart your FiveM server and the script will start automatically.

## 🎮 Usage

### Access the Menu
- **Command:** `/jobcreator`
- **Key:** `F6` (configurable)
- **Requires:** Administrator permissions

### Create a Job
1. Open the menu with `/jobcreator`
2. Go to the "Jobs" tab
3. Click "Create Job"
4. Fill in the data:
   - Job name (e.g., `police`)
   - Job label (e.g., `Police Department`)
   - Enable whitelist (optional)
5. Click "Submit"

### Create Ranks
1. Open the menu and go to "Grades"
2. Select a job
3. Click "Create Grade"
4. Configure:
   - Rank number (0, 1, 2, etc.)
   - Rank name
   - Rank label
   - Salary

### Create Markers
1. Position yourself where you want the marker
2. Open the menu and go to "Markers"
3. Click "Create Marker at Current Position"
4. Configure:
   - Associated job
   - Marker type
   - Label
   - Size and color

### Use Job Actions
- **Method 1:** Open main menu → "Actions" tab
- **Method 2:** Press `F7` for quick actions menu
- Get close to the target player/vehicle
- Select the desired action

### Nexus System
1. **Share a job:**
   - Open menu → "Jobs" tab
   - Click "Share" on the desired job
   
2. **Import a job:**
   - Open menu → "Nexus" tab
   - Click "Load Jobs from Nexus"
   - Select the job to import

### View Statistics
1. Open menu → "Statistics" tab
2. Click "Refresh Statistics"
3. You'll see:
   - Most popular jobs
   - Player count per job
   - Economic balance

## 📜 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

**Version:** 1.0.0  
**Last Updated:** 2024  
**Compatibility:** FiveM Latest, ESX Legacy, QBCore

Like this script? ⭐ Give it a star on GitHub!
