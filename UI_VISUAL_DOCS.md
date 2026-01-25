# JobCreator UI - Visual Documentation

## UI Layout Structure

### Main Interface
```
┌─────────────────────────────────────────────────────────────────────┐
│  Job Creator                                                      × │
├──────────┬──────────────────────────────────────────────────────────┤
│          │                                                          │
│  💼 Jobs │  Jobs Management                      [+ Create Job]    │
│          │                                                          │
│ 📍Public │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐   │
│  Markers │  │ Police Dept  │ │ EMS Service  │ │ Mechanic     │   │
│          │  │ ID: police   │ │ ID: ambulance│ │ ID: mechanic │   │
│ 📊Stats  │  │ Whitelisted  │ │              │ │              │   │
│          │  │ 5 ranks      │ │ 4 ranks      │ │ 3 ranks      │   │
│ 🌐 Nexus │  └──────────────┘ └──────────────┘ └──────────────┘   │
│          │                                                          │
│ ⚙️Settings│                                                         │
│          │                                                          │
└──────────┴──────────────────────────────────────────────────────────┘
```

### Job Detail View
```
┌─────────────────────────────────────────────────────────────────────┐
│  Job Creator                                                      × │
├──────────┬──────────────────────────────────────────────────────────┤
│          │ [← Back]  Police Department    [💾 Save] [🗑️ Delete]   │
│          ├──────────────────────────────────────────────────────────┤
│  💼 Jobs │ [Ranks] [Markers] [Statistics] [Settings]              │
│          ├──────────────────────────────────────────────────────────┤
│ 📍Public │                                                          │
│  Markers │  [+ Create Rank]                                        │
│          │                                                          │
│ 📊Stats  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐   │
│          │  │ Officer      │ │ Sergeant     │ │ Lieutenant   │   │
│ 🌐 Nexus │  │ Grade: 0     │ │ Grade: 1     │ │ Grade: 2     │   │
│          │  │ Salary: $500 │ │ Salary: $750 │ │ Salary: $1000│   │
│ ⚙️Settings│  │    [Delete]  │ │    [Delete]  │ │    [Delete]  │   │
│          │  └──────────────┘ └──────────────┘ └──────────────┘   │
│          │                                                          │
└──────────┴──────────────────────────────────────────────────────────┘
```

### Public Markers Section
```
┌─────────────────────────────────────────────────────────────────────┐
│  Job Creator                                                      × │
├──────────┬──────────────────────────────────────────────────────────┤
│          │  Public Markers                                          │
│  💼 Jobs │                                                          │
│          │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐     │
│ 📍Public │  │ 📦  │ │ 🔫  │ │ 🔒  │ │ 🚗  │ │ 👔  │ │ 👕  │     │
│  Markers │  │Stash│ │Armry│ │Safe │ │Garge│ │Wrdrb│ │Outft│     │
│          │  └─────┘ └─────┘ └─────┘ └─────┘ └─────┘ └─────┘     │
│ 📊Stats  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐     │
│          │  │ 🏪  │ │ 🛒  │ │ 🌾  │ │ ⚙️  │ │ 🔨  │ │ 🚪  │     │
│ 🌐 Nexus │  │Shop │ │Market│ │Hrvst│ │Procs│ │Craft│ │Telpt│     │
│          │  └─────┘ └─────┘ └─────┘ └─────┘ └─────┘ └─────┘     │
│ ⚙️Settings│  ┌─────┐ ┌─────┐                                      │
│          │  │ ⚔️  │ │ 🏬  │                                      │
│          │  │WpnUp│ │JbShp│                                      │
│          │  └─────┘ └─────┘                                      │
└──────────┴──────────────────────────────────────────────────────────┘
```

### Settings Section
```
┌─────────────────────────────────────────────────────────────────────┐
│  Job Creator                                                      × │
├──────────┬──────────────────────────────────────────────────────────┤
│          │  Settings                          [💾 Save Settings]   │
│  💼 Jobs │                                                          │
│          │  ┌─ General Settings ────────────────────────────────┐  │
│ 📍Public │  │ Menu Language:    [English ▼]                     │  │
│  Markers │  └────────────────────────────────────────────────────┘  │
│          │                                                          │
│ 📊Stats  │  ┌─ Menu Configuration ───────────────────────────────┐ │
│          │  │ Player Menu Script:  [Default ▼]                  │ │
│ 🌐 Nexus │  │ Targeting Script:    [OX Target ▼]               │ │
│          │  │ Help Notification:   [3D Text ▼]                 │ │
│ ⚙️Settings│  └────────────────────────────────────────────────────┘ │
│          │                                                          │
│          │  ┌─ Unemployment Configuration ──────────────────────┐  │
│          │  │ Unemployed Job ID:  [unemployed]                  │  │
│          │  │ Unemployed Grade:   [0]                           │  │
│          │  └────────────────────────────────────────────────────┘  │
└──────────┴──────────────────────────────────────────────────────────┘
```

### Statistics Section
```
┌─────────────────────────────────────────────────────────────────────┐
│  Job Creator                                                      × │
├──────────┬──────────────────────────────────────────────────────────┤
│          │  Global Statistics                      [🔄 Refresh]    │
│  💼 Jobs │                                                          │
│          │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐   │
│ 📍Public │  │ Total Jobs   │ │Total Players │ │ Active Jobs  │   │
│  Markers │  │              │ │              │ │              │   │
│          │  │      12      │ │      48      │ │      8       │   │
│ 📊Stats  │  └──────────────┘ └──────────────┘ └──────────────┘   │
│          │                                                          │
│ 🌐 Nexus │  ┌──────────────┐                                       │
│          │  │Total Markers │                                       │
│ ⚙️Settings│  │              │                                       │
│          │  │      35      │                                       │
│          │  └──────────────┘                                       │
└──────────┴──────────────────────────────────────────────────────────┘
```

### Nexus Section
```
┌─────────────────────────────────────────────────────────────────────┐
│  Job Creator                                                      × │
├──────────┬──────────────────────────────────────────────────────────┤
│          │  Nexus                                                   │
│  💼 Jobs │                                                          │
│          │                                                          │
│ 📍Public │                    🚀                                    │
│  Markers │                                                          │
│          │              Coming Soon                                 │
│ 📊Stats  │                                                          │
│          │   Job sharing network feature will be                   │
│ 🌐 Nexus │      available in the next update                       │
│          │                                                          │
│ ⚙️Settings│                                                         │
│          │                                                          │
└──────────┴──────────────────────────────────────────────────────────┘
```

### Modal Examples

#### Create Job Modal
```
┌─────────────────────────────────────┐
│ Create New Job                    × │
├─────────────────────────────────────┤
│                                     │
│ Job Label:                          │
│ [Police Department            ]     │
│                                     │
│ Job ID (name):                      │
│ [police                       ]     │
│                                     │
│ ☐ Enable Whitelist                 │
│                                     │
├─────────────────────────────────────┤
│                   [Cancel] [Confirm]│
└─────────────────────────────────────┘
```

#### Create Rank Modal
```
┌─────────────────────────────────────┐
│ Create Rank                       × │
├─────────────────────────────────────┤
│                                     │
│ Rank Label:                         │
│ [Officer                      ]     │
│                                     │
│ Rank Name (ID):                     │
│ [officer                      ]     │
│                                     │
│ Grade:          Salary:             │
│ [0]             [500]               │
│                                     │
├─────────────────────────────────────┤
│                   [Cancel] [Confirm]│
└─────────────────────────────────────┘
```

#### Create Marker Modal
```
┌─────────────────────────────────────┐
│ Create Job Marker                 × │
├─────────────────────────────────────┤
│                                     │
│ Marker Label:                       │
│ [Police Armory                ]     │
│                                     │
│ Marker Type:                        │
│ [Armory              ▼]             │
│                                     │
│ Coordinates:                        │
│ [123.45, -456.78, 28.5][Current]    │
│                                     │
│ Minimum Grade (0 = all):            │
│ [0]                                 │
│                                     │
├─────────────────────────────────────┤
│                   [Cancel] [Confirm]│
└─────────────────────────────────────┘
```

## Color Scheme

### Primary Colors
- **Background**: Linear gradient (#1e3c72 to #2a5298)
- **Sidebar**: Dark overlay (rgba(0,0,0,0.3))
- **Active Button**: Purple gradient (#667eea to #764ba2)
- **Primary Button**: Purple gradient (#667eea to #764ba2)
- **Success Button**: Blue gradient (#4facfe to #00f2fe)
- **Danger Button**: Pink gradient (#f093fb to #f5576c)

### Typography
- **Font Family**: Segoe UI, Tahoma, Geneva, Verdana, sans-serif
- **Header**: 28px, bold
- **Section Title**: 26px, semi-bold
- **Body**: 14px, normal
- **Small**: 12px, normal

### Interactive Elements
- **Hover**: Slight lift (-5px translateY)
- **Active**: Box shadow glow
- **Transition**: All 0.3s ease

## Responsive Design

The UI is fully responsive and adapts to different screen sizes:
- Desktop (1400px): Full layout with sidebar
- Tablet (768px): Collapsed sidebar (icons only)
- Mobile: Single column layout

## Accessibility Features

- High contrast text on backgrounds
- Large clickable areas (min 40px)
- Keyboard navigation support (ESC to close)
- Clear visual feedback on interactions
- Readable font sizes (min 14px)

---

**Design System**: Modern Material Design inspired
**Animation**: Smooth CSS transitions
**Icons**: Unicode emoji for universal support
