// JobCreator UI Script
let currentJobs = [];
let currentJob = null;
let currentSettings = {};

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    console.log('JobCreator UI initialized');
});

// NUI Message Handler
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'openUI':
            openUI();
            break;
        case 'closeUI':
            closeUIInternal();
            break;
        case 'receiveJobs':
            currentJobs = data.jobs || [];
            renderJobs();
            break;
        case 'receiveStatistics':
            renderStatistics(data.statistics || {});
            break;
        case 'receiveNexusJobs':
            renderNexusJobs(data.jobs || []);
            break;
        case 'updateSettings':
            currentSettings = data.settings || {};
            renderSettings();
            break;
    }
});

// Open UI
function openUI() {
    document.getElementById('app').style.display = 'flex';
    showSection('jobs');
}

// Close UI
function closeUI() {
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
    closeUIInternal();
}

function closeUIInternal() {
    document.getElementById('app').style.display = 'none';
}

// Get current resource name
function GetParentResourceName() {
    let resourceName = 'jobcreator';
    if (window.location.href.includes('://nui_')) {
        resourceName = window.location.href.split('://nui_')[1].split('/')[0];
    }
    return resourceName;
}

// Section Navigation
function showSection(sectionId) {
    // Hide all sections
    document.querySelectorAll('.section').forEach(section => {
        section.classList.remove('active');
    });
    
    // Hide job detail if showing
    if (document.getElementById('job-detail-section')) {
        document.getElementById('job-detail-section').style.display = 'none';
    }
    
    // Show selected section
    const section = document.getElementById(sectionId + '-section');
    if (section) {
        section.classList.add('active');
        if (sectionId !== 'jobs') {
            section.style.display = 'block';
        }
    }
    
    // Update sidebar buttons
    document.querySelectorAll('.sidebar-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.getAttribute('data-section') === sectionId) {
            btn.classList.add('active');
        }
    });
}

// Jobs Section
function renderJobs() {
    const jobsList = document.getElementById('jobs-list');
    if (!jobsList) return;
    
    jobsList.innerHTML = '';
    
    const jobsArray = Object.values(currentJobs);
    
    if (jobsArray.length === 0) {
        jobsList.innerHTML = '<p style="color: rgba(255,255,255,0.7); text-align: center; padding: 40px;">No jobs created yet. Create your first job!</p>';
        return;
    }
    
    jobsArray.forEach(job => {
        const card = document.createElement('div');
        card.className = 'job-card';
        card.onclick = () => openJobDetail(job);
        
        const ranksCount = job.grades ? job.grades.length : 0;
        
        card.innerHTML = `
            <h3>${job.label || job.name}</h3>
            <p class="job-id">ID: ${job.name}</p>
            ${job.whitelisted ? '<span class="badge badge-warning">Whitelisted</span>' : ''}
            <p class="ranks-count">📊 ${ranksCount} rank(s)</p>
        `;
        
        jobsList.appendChild(card);
    });
}

function openCreateJobModal() {
    showModal('Create New Job', `
        <div class="form-group">
            <label>Job Label</label>
            <input type="text" id="job-label" class="input" placeholder="e.g., Police Department" required>
        </div>
        <div class="form-group">
            <label>Job ID (name)</label>
            <input type="text" id="job-name" class="input" placeholder="e.g., police" required>
        </div>
        <div class="form-group">
            <div class="setting-item checkbox-item">
                <input type="checkbox" id="job-whitelist">
                <label for="job-whitelist">Enable Whitelist</label>
            </div>
        </div>
    `, () => {
        const label = document.getElementById('job-label').value;
        const name = document.getElementById('job-name').value;
        const whitelisted = document.getElementById('job-whitelist').checked;
        
        if (!label || !name) {
            alert('Please fill in all fields');
            return false;
        }
        
        fetch(`https://${GetParentResourceName()}/createJob`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ name, label, whitelisted })
        });
        
        return true;
    });
}

// Job Detail View
function openJobDetail(job) {
    currentJob = job;
    
    // Hide jobs section
    document.getElementById('jobs-section').classList.remove('active');
    
    // Show job detail section
    const detailSection = document.getElementById('job-detail-section');
    detailSection.style.display = 'block';
    detailSection.classList.add('active');
    
    // Update title
    document.getElementById('job-detail-title').textContent = job.label || job.name;
    
    // Show ranks tab by default
    showJobTab('ranks');
    
    // Render job data
    renderJobRanks();
    renderJobMarkers();
    renderJobSettings();
}

function backToJobsList() {
    document.getElementById('job-detail-section').style.display = 'none';
    document.getElementById('jobs-section').classList.add('active');
    currentJob = null;
}

function showJobTab(tabId) {
    // Hide all tabs
    document.querySelectorAll('.job-tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Show selected tab
    const tab = document.getElementById(tabId + '-tab');
    if (tab) {
        tab.classList.add('active');
    }
    
    // Update tab buttons
    document.querySelectorAll('.job-tab-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Find and activate the clicked button
    const clickedBtn = Array.from(document.querySelectorAll('.job-tab-btn')).find(btn => {
        const onclick = btn.getAttribute('onclick');
        return onclick && onclick.includes(`'${tabId}'`);
    });
    if (clickedBtn) {
        clickedBtn.classList.add('active');
    }
}

function renderJobRanks() {
    const ranksList = document.getElementById('ranks-list');
    if (!ranksList || !currentJob) return;
    
    ranksList.innerHTML = '';
    
    const grades = currentJob.grades || [];
    
    if (grades.length === 0) {
        ranksList.innerHTML = '<p style="color: rgba(255,255,255,0.7); padding: 20px;">No ranks created yet.</p>';
        return;
    }
    
    grades.forEach(grade => {
        const card = document.createElement('div');
        card.className = 'rank-card';
        card.innerHTML = `
            <h4>${grade.label}</h4>
            <p>Grade: ${grade.grade}</p>
            <p>Name: ${grade.name}</p>
            <p>Salary: $${grade.salary || 0}</p>
            <div class="rank-actions">
                <button class="btn btn-danger" onclick="deleteRank(${grade.id})">Delete</button>
            </div>
        `;
        ranksList.appendChild(card);
    });
}

function renderJobMarkers() {
    const markersList = document.getElementById('job-markers-list');
    if (!markersList) return;
    
    markersList.innerHTML = '<p style="color: rgba(255,255,255,0.7); padding: 20px;">Markers for this job will appear here.</p>';
}

function renderJobSettings() {
    if (!currentJob) return;
    
    // Load job settings into checkboxes
    document.getElementById('job-whitelisted').checked = currentJob.whitelisted || false;
    document.getElementById('job-actions-menu').checked = currentJob.actions_menu !== false;
    document.getElementById('job-can-search').checked = currentJob.can_search !== false;
    document.getElementById('job-can-handcuff').checked = currentJob.can_handcuff !== false;
    document.getElementById('job-can-heal').checked = currentJob.can_heal !== false;
    document.getElementById('job-can-revive').checked = currentJob.can_revive !== false;
    document.getElementById('job-can-bill').checked = currentJob.can_bill !== false;
    document.getElementById('job-can-check-identity').checked = currentJob.can_check_identity !== false;
    document.getElementById('job-can-check-license').checked = currentJob.can_check_license !== false;
    document.getElementById('job-can-check-weapon-license').checked = currentJob.can_check_weapon_license !== false;
    document.getElementById('job-can-lockpick').checked = currentJob.can_lockpick !== false;
    document.getElementById('job-can-repair').checked = currentJob.can_repair !== false;
    document.getElementById('job-can-clean').checked = currentJob.can_clean !== false;
    document.getElementById('job-can-impound').checked = currentJob.can_impound !== false;
    document.getElementById('job-can-check-owner').checked = currentJob.can_check_owner !== false;
}

function openCreateRankModal() {
    if (!currentJob) return;
    
    showModal('Create Rank', `
        <div class="form-group">
            <label>Rank Label</label>
            <input type="text" id="rank-label" class="input" placeholder="e.g., Officer" required>
        </div>
        <div class="form-group">
            <label>Rank Name (ID)</label>
            <input type="text" id="rank-name" class="input" placeholder="e.g., officer" required>
        </div>
        <div class="form-row">
            <div class="form-group">
                <label>Grade</label>
                <input type="number" id="rank-grade" class="input" placeholder="0" required>
            </div>
            <div class="form-group">
                <label>Salary</label>
                <input type="number" id="rank-salary" class="input" placeholder="1000" required>
            </div>
        </div>
    `, () => {
        const label = document.getElementById('rank-label').value;
        const name = document.getElementById('rank-name').value;
        const grade = parseInt(document.getElementById('rank-grade').value);
        const salary = parseInt(document.getElementById('rank-salary').value);
        
        if (!label || !name || isNaN(grade) || isNaN(salary)) {
            alert('Please fill in all fields correctly');
            return false;
        }
        
        fetch(`https://${GetParentResourceName()}/createGrade`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ 
                jobName: currentJob.name,
                label, 
                name, 
                grade, 
                salary 
            })
        });
        
        return true;
    });
}

function openCreateJobMarkerModal() {
    if (!currentJob) return;
    
    showModal('Create Job Marker', `
        <div class="form-group">
            <label>Marker Label</label>
            <input type="text" id="marker-label" class="input" placeholder="e.g., Police Armory" required>
        </div>
        <div class="form-group">
            <label>Marker Type</label>
            <select id="marker-type" class="input">
                <option value="stash">Stash</option>
                <option value="armory">Armory</option>
                <option value="safe">Safe</option>
                <option value="garage">Garage</option>
                <option value="wardrobe">Wardrobe</option>
                <option value="shop">Shop</option>
                <option value="market">Market</option>
                <option value="harvest">Harvest Point</option>
                <option value="process">Process Point</option>
                <option value="crafting">Crafting Table</option>
                <option value="teleport">Teleport Point</option>
            </select>
        </div>
        <div class="form-group">
            <label>Coordinates</label>
            <div class="input-with-button">
                <input type="text" id="marker-coords" class="input" placeholder="X, Y, Z" readonly>
                <button class="btn btn-secondary" onclick="getCurrentCoords()">Current Position</button>
            </div>
        </div>
        <div class="form-group">
            <label>Minimum Grade (0 = all)</label>
            <input type="number" id="marker-grade" class="input" placeholder="0" value="0">
        </div>
    `, () => {
        const label = document.getElementById('marker-label').value;
        const type = document.getElementById('marker-type').value;
        const coords = document.getElementById('marker-coords').value;
        const minGrade = parseInt(document.getElementById('marker-grade').value) || 0;
        
        if (!label || !coords) {
            alert('Please fill in all fields and select coordinates');
            return false;
        }
        
        const [x, y, z] = coords.split(',').map(c => parseFloat(c.trim()));
        
        fetch(`https://${GetParentResourceName()}/createMarker`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ 
                jobName: currentJob.name,
                label,
                type,
                x, y, z,
                minGrade
            })
        });
        
        return true;
    });
}

function deleteRank(rankId) {
    if (confirm('Are you sure you want to delete this rank?')) {
        fetch(`https://${GetParentResourceName()}/deleteGrade`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ gradeId: rankId })
        });
    }
}

function saveJobChanges() {
    if (!currentJob) return;
    
    const updates = {
        whitelisted: document.getElementById('job-whitelisted').checked,
        actions_menu: document.getElementById('job-actions-menu').checked,
        can_search: document.getElementById('job-can-search').checked,
        can_handcuff: document.getElementById('job-can-handcuff').checked,
        can_heal: document.getElementById('job-can-heal').checked,
        can_revive: document.getElementById('job-can-revive').checked,
        can_bill: document.getElementById('job-can-bill').checked,
        can_check_identity: document.getElementById('job-can-check-identity').checked,
        can_check_license: document.getElementById('job-can-check-license').checked,
        can_check_weapon_license: document.getElementById('job-can-check-weapon-license').checked,
        can_lockpick: document.getElementById('job-can-lockpick').checked,
        can_repair: document.getElementById('job-can-repair').checked,
        can_clean: document.getElementById('job-can-clean').checked,
        can_impound: document.getElementById('job-can-impound').checked,
        can_check_owner: document.getElementById('job-can-check-owner').checked
    };
    
    fetch(`https://${GetParentResourceName()}/updateJob`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ jobName: currentJob.name, updates })
    });
    
    alert('Job settings saved!');
}

function deleteCurrentJob() {
    if (!currentJob) return;
    
    if (confirm(`Are you sure you want to delete the job "${currentJob.label}"? This action cannot be undone.`)) {
        fetch(`https://${GetParentResourceName()}/deleteJob`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ jobName: currentJob.name })
        });
        
        backToJobsList();
    }
}

// Public Markers
function openCreateMarkerModal(markerType) {
    showModal(`Create ${markerType.charAt(0).toUpperCase() + markerType.slice(1)} Marker`, `
        <div class="form-group">
            <label>Marker Label</label>
            <input type="text" id="public-marker-label" class="input" placeholder="e.g., City Stash" required>
        </div>
        <div class="form-group">
            <label>Coordinates</label>
            <div class="input-with-button">
                <input type="text" id="public-marker-coords" class="input" placeholder="X, Y, Z" readonly>
                <button class="btn btn-secondary" onclick="getCurrentCoordsPublic()">Current Position</button>
            </div>
        </div>
        <div class="form-group">
            <label>Public Access</label>
            <select id="public-marker-access" class="input">
                <option value="all">Everyone</option>
                <option value="job">Specific Job</option>
            </select>
        </div>
    `, () => {
        const label = document.getElementById('public-marker-label').value;
        const coords = document.getElementById('public-marker-coords').value;
        const access = document.getElementById('public-marker-access').value;
        
        if (!label || !coords) {
            alert('Please fill in all fields and select coordinates');
            return false;
        }
        
        const [x, y, z] = coords.split(',').map(c => parseFloat(c.trim()));
        
        fetch(`https://${GetParentResourceName()}/createMarker`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ 
                label,
                type: markerType,
                x, y, z,
                public: access === 'all'
            })
        });
        
        return true;
    });
}

function getCurrentCoords() {
    fetch(`https://${GetParentResourceName()}/getCurrentCoords`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then(() => {
        // Coords will be set via NUI callback
    });
}

function getCurrentCoordsPublic() {
    getCurrentCoords();
}

// Listen for coords update
window.addEventListener('message', function(event) {
    if (event.data.action === 'setCoords') {
        const input = document.getElementById('marker-coords') || document.getElementById('public-marker-coords');
        if (input) {
            input.value = `${event.data.x.toFixed(2)}, ${event.data.y.toFixed(2)}, ${event.data.z.toFixed(2)}`;
        }
    }
});

// Statistics
function loadStatistics() {
    fetch(`https://${GetParentResourceName()}/getStatistics`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

function renderStatistics(stats) {
    const statsContent = document.getElementById('statistics-content');
    if (!statsContent) return;
    
    statsContent.innerHTML = `
        <div class="stat-card">
            <h4>Total Jobs</h4>
            <div class="stat-value">${stats.totalJobs || 0}</div>
        </div>
        <div class="stat-card">
            <h4>Total Players</h4>
            <div class="stat-value">${stats.totalPlayers || 0}</div>
        </div>
        <div class="stat-card">
            <h4>Active Jobs</h4>
            <div class="stat-value">${stats.activeJobs || 0}</div>
        </div>
        <div class="stat-card">
            <h4>Total Markers</h4>
            <div class="stat-value">${stats.totalMarkers || 0}</div>
        </div>
    `;
}

// Settings
function renderSettings() {
    document.getElementById('setting-language').value = currentSettings.language || 'en';
    document.getElementById('setting-player-menu').value = currentSettings.playerMenu || 'default';
    document.getElementById('setting-targeting').value = currentSettings.targeting || 'none';
    document.getElementById('setting-help-notification').value = currentSettings.helpNotification || 'default';
    document.getElementById('setting-unemployed-job').value = currentSettings.unemployedJob || 'unemployed';
    document.getElementById('setting-unemployed-grade').value = currentSettings.unemployedGrade || 0;
    document.getElementById('setting-use-ace').checked = currentSettings.useAce || false;
    document.getElementById('setting-old-esx-safe').checked = currentSettings.oldEsxSafe || false;
}

function saveSettings() {
    const settings = {
        language: document.getElementById('setting-language').value,
        playerMenu: document.getElementById('setting-player-menu').value,
        targeting: document.getElementById('setting-targeting').value,
        helpNotification: document.getElementById('setting-help-notification').value,
        unemployedJob: document.getElementById('setting-unemployed-job').value,
        unemployedGrade: parseInt(document.getElementById('setting-unemployed-grade').value),
        useAce: document.getElementById('setting-use-ace').checked,
        oldEsxSafe: document.getElementById('setting-old-esx-safe').checked
    };
    
    fetch(`https://${GetParentResourceName()}/saveSettings`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(settings)
    });
    
    alert('Settings saved!');
}

// Modal System
function showModal(title, content, onConfirm) {
    const modalContainer = document.getElementById('modal-container');
    
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.innerHTML = `
        <div class="modal-content">
            <div class="modal-header">
                <h2>${title}</h2>
                <button class="modal-close" onclick="closeModal()">×</button>
            </div>
            <div class="modal-body">
                ${content}
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                <button class="btn btn-primary" onclick="confirmModal()">Confirm</button>
            </div>
        </div>
    `;
    
    modalContainer.innerHTML = '';
    modalContainer.appendChild(modal);
    
    // Store callback
    window.currentModalCallback = onConfirm;
}

function closeModal() {
    const modalContainer = document.getElementById('modal-container');
    modalContainer.innerHTML = '';
    window.currentModalCallback = null;
}

function confirmModal() {
    if (window.currentModalCallback) {
        const result = window.currentModalCallback();
        if (result !== false) {
            closeModal();
        }
    } else {
        closeModal();
    }
}

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        const modalContainer = document.getElementById('modal-container');
        if (modalContainer && modalContainer.innerHTML) {
            closeModal();
        } else {
            closeUI();
        }
    }
});

// Initialize on load
console.log('JobCreator UI script loaded');