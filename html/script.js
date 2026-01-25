// Job Creator UI Script
let currentJobs = {};
let currentGrades = {};
let currentMarkers = [];
let currentStatistics = [];

// Message handler
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'openUI':
            openUI();
            break;
        case 'closeUI':
            closeUI();
            break;
        case 'receiveJobs':
            currentJobs = data.jobs;
            renderJobs();
            updateJobSelects();
            break;
        case 'receiveGrades':
            currentGrades = data.grades;
            renderGrades();
            break;
        case 'receiveMarkers':
            currentMarkers = data.markers;
            renderMarkers();
            break;
        case 'receiveStatistics':
            currentStatistics = data.statistics;
            renderStatistics();
            break;
        case 'receiveNexusJobs':
            renderNexusJobs(data.jobs);
            break;
        case 'showInventory':
            showInventoryModal(data.inventory);
            break;
        case 'showIdentity':
            showIdentityModal(data.identity);
            break;
        case 'openBillDialog':
            openBillModal(data.targetId);
            break;
    }
});

// Open/Close UI
function openUI() {
    document.getElementById('app').style.display = 'flex';
}

function closeUI() {
    document.getElementById('app').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        body: JSON.stringify({})
    });
}

// ESC key handler
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeUI();
    }
});

// Tab switching
function showTab(tabName) {
    // Hide all tabs
    const tabs = document.querySelectorAll('.tab-content');
    tabs.forEach(tab => tab.classList.remove('active'));
    
    // Remove active class from all buttons
    const buttons = document.querySelectorAll('.tab-btn');
    buttons.forEach(btn => btn.classList.remove('active'));
    
    // Show selected tab
    document.getElementById(tabName + '-tab').classList.add('active');
    
    // Add active class to clicked button
    event.target.classList.add('active');
}

// Render jobs
function renderJobs() {
    const jobsList = document.getElementById('jobs-list');
    jobsList.innerHTML = '';
    
    for (const [jobName, job] of Object.entries(currentJobs)) {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${job.label}</h3>
            <p><strong>Name:</strong> ${job.name}</p>
            <p><strong>Whitelisted:</strong> ${job.whitelisted ? 'Yes' : 'No'}</p>
            <div class="card-actions">
                <button class="btn btn-success" onclick="editJob('${jobName}')">Edit</button>
                <button class="btn btn-danger" onclick="deleteJob('${jobName}')">Delete</button>
                <button class="btn btn-primary" onclick="shareJob('${jobName}')">Share</button>
            </div>
        `;
        jobsList.appendChild(card);
    }
}

// Update job selects
function updateJobSelects() {
    const selects = document.querySelectorAll('#grade-job-select');
    selects.forEach(select => {
        select.innerHTML = '<option value="">Select a job</option>';
        for (const [jobName, job] of Object.entries(currentJobs)) {
            const option = document.createElement('option');
            option.value = jobName;
            option.textContent = job.label;
            select.appendChild(option);
        }
    });
}

// Render grades
function renderGrades() {
    const selectedJob = document.getElementById('grade-job-select').value;
    const gradesList = document.getElementById('grades-list');
    gradesList.innerHTML = '';
    
    if (!selectedJob || !currentJobs[selectedJob] || !currentJobs[selectedJob].grades) {
        gradesList.innerHTML = '<p style="color: white;">Select a job to view grades</p>';
        return;
    }
    
    const grades = currentJobs[selectedJob].grades;
    
    grades.forEach(grade => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${grade.label}</h3>
            <p><strong>Grade:</strong> ${grade.grade}</p>
            <p><strong>Name:</strong> ${grade.name}</p>
            <p><strong>Salary:</strong> $${grade.salary}</p>
            <div class="card-actions">
                <button class="btn btn-success" onclick="editGrade(${grade.id})">Edit</button>
                <button class="btn btn-danger" onclick="deleteGrade(${grade.id})">Delete</button>
            </div>
        `;
        gradesList.appendChild(card);
    });
}

// Render markers
function renderMarkers() {
    const markersList = document.getElementById('markers-list');
    markersList.innerHTML = '';
    
    if (currentMarkers.length === 0) {
        markersList.innerHTML = '<p style="color: white;">No markers created yet</p>';
        return;
    }
    
    currentMarkers.forEach(marker => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${marker.label}</h3>
            <p><strong>Type:</strong> ${marker.type}</p>
            <p><strong>Job:</strong> ${marker.job_name}</p>
            <p><strong>Position:</strong> ${marker.x.toFixed(2)}, ${marker.y.toFixed(2)}, ${marker.z.toFixed(2)}</p>
            <div class="card-actions">
                <button class="btn btn-danger" onclick="deleteMarker(${marker.id})">Delete</button>
            </div>
        `;
        markersList.appendChild(card);
    });
}

// Render statistics
function renderStatistics() {
    const statsContent = document.getElementById('statistics-content');
    statsContent.innerHTML = '';
    
    if (currentStatistics.length === 0) {
        statsContent.innerHTML = '<p style="color: white;">No statistics available</p>';
        return;
    }
    
    const statsGrid = document.createElement('div');
    statsGrid.className = 'stats-grid';
    
    currentStatistics.forEach(stat => {
        const card = document.createElement('div');
        card.className = 'stat-card';
        card.innerHTML = `
            <h4>${stat.job_name}</h4>
            <div class="stat-value">${stat.player_count}</div>
            <p style="color: rgba(255,255,255,0.8); margin-top: 10px;">Players Online</p>
            <p style="color: rgba(255,255,255,0.8);">Total Salary: $${stat.total_salary}</p>
        `;
        statsGrid.appendChild(card);
    });
    
    statsContent.appendChild(statsGrid);
}

// Render Nexus jobs
function renderNexusJobs(jobs) {
    const nexusList = document.getElementById('nexus-list');
    nexusList.innerHTML = '';
    
    if (jobs.length === 0) {
        nexusList.innerHTML = '<p style="color: white;">No jobs available on Nexus</p>';
        return;
    }
    
    jobs.forEach(job => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${job.label}</h3>
            <p><strong>Name:</strong> ${job.name}</p>
            <p><strong>Created by:</strong> ${job.author || 'Unknown'}</p>
            <div class="card-actions">
                <button class="btn btn-primary" onclick="importJob('${job.id}')">Import</button>
            </div>
        `;
        nexusList.appendChild(card);
    });
}

// Modal functions
function createModal(title, content, onSubmit) {
    // Remove existing modal
    const existingModal = document.querySelector('.modal');
    if (existingModal) {
        existingModal.remove();
    }
    
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.innerHTML = `
        <div class="modal-content">
            <div class="modal-header">
                <h2>${title}</h2>
                <button class="close-btn" onclick="this.closest('.modal').remove()">×</button>
            </div>
            <div class="modal-body">
                ${content}
            </div>
            <div class="modal-footer">
                <button class="btn btn-danger" onclick="this.closest('.modal').remove()">Cancel</button>
                <button class="btn btn-primary" id="modal-submit">Submit</button>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    document.getElementById('modal-submit').addEventListener('click', function() {
        onSubmit();
        modal.remove();
    });
}

// Job CRUD
function openCreateJobModal() {
    const content = `
        <div class="form-group">
            <label>Job Name</label>
            <input type="text" id="job-name" placeholder="e.g., police">
        </div>
        <div class="form-group">
            <label>Job Label</label>
            <input type="text" id="job-label" placeholder="e.g., Police Department">
        </div>
        <div class="form-group">
            <label>
                <input type="checkbox" id="job-whitelist"> Enable Whitelist
            </label>
        </div>
    `;
    
    createModal('Create New Job', content, function() {
        const data = {
            name: document.getElementById('job-name').value,
            label: document.getElementById('job-label').value,
            whitelisted: document.getElementById('job-whitelist').checked
        };
        
        fetch(`https://${GetParentResourceName()}/createJob`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    });
}

function editJob(jobName) {
    const job = currentJobs[jobName];
    
    const content = `
        <div class="form-group">
            <label>Job Label</label>
            <input type="text" id="job-label" value="${job.label}">
        </div>
        <div class="form-group">
            <label>
                <input type="checkbox" id="job-whitelist" ${job.whitelisted ? 'checked' : ''}> Enable Whitelist
            </label>
        </div>
    `;
    
    createModal('Edit Job', content, function() {
        const data = {
            jobName: jobName,
            updates: {
                label: document.getElementById('job-label').value,
                whitelisted: document.getElementById('job-whitelist').checked
            }
        };
        
        fetch(`https://${GetParentResourceName()}/updateJob`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    });
}

function deleteJob(jobName) {
    if (confirm(`Are you sure you want to delete the job "${jobName}"?`)) {
        fetch(`https://${GetParentResourceName()}/deleteJob`, {
            method: 'POST',
            body: JSON.stringify({ jobName })
        });
    }
}

function shareJob(jobName) {
    fetch(`https://${GetParentResourceName()}/shareJob`, {
        method: 'POST',
        body: JSON.stringify({ jobName })
    });
}

// Grade CRUD
function openCreateGradeModal() {
    const selectedJob = document.getElementById('grade-job-select').value;
    
    if (!selectedJob) {
        alert('Please select a job first');
        return;
    }
    
    const content = `
        <div class="form-group">
            <label>Grade Number</label>
            <input type="number" id="grade-number" placeholder="0">
        </div>
        <div class="form-group">
            <label>Grade Name</label>
            <input type="text" id="grade-name" placeholder="e.g., recruit">
        </div>
        <div class="form-group">
            <label>Grade Label</label>
            <input type="text" id="grade-label" placeholder="e.g., Recruit">
        </div>
        <div class="form-group">
            <label>Salary</label>
            <input type="number" id="grade-salary" placeholder="0">
        </div>
    `;
    
    createModal('Create New Grade', content, function() {
        const data = {
            job_name: selectedJob,
            grade: parseInt(document.getElementById('grade-number').value),
            name: document.getElementById('grade-name').value,
            label: document.getElementById('grade-label').value,
            salary: parseInt(document.getElementById('grade-salary').value)
        };
        
        fetch(`https://${GetParentResourceName()}/createGrade`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    });
}

function editGrade(gradeId) {
    // Find grade
    let grade = null;
    for (const job of Object.values(currentJobs)) {
        if (job.grades) {
            grade = job.grades.find(g => g.id === gradeId);
            if (grade) break;
        }
    }
    
    if (!grade) return;
    
    const content = `
        <div class="form-group">
            <label>Grade Name</label>
            <input type="text" id="grade-name" value="${grade.name}">
        </div>
        <div class="form-group">
            <label>Grade Label</label>
            <input type="text" id="grade-label" value="${grade.label}">
        </div>
        <div class="form-group">
            <label>Salary</label>
            <input type="number" id="grade-salary" value="${grade.salary}">
        </div>
    `;
    
    createModal('Edit Grade', content, function() {
        const data = {
            gradeId: gradeId,
            updates: {
                name: document.getElementById('grade-name').value,
                label: document.getElementById('grade-label').value,
                salary: parseInt(document.getElementById('grade-salary').value)
            }
        };
        
        fetch(`https://${GetParentResourceName()}/updateGrade`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    });
}

function deleteGrade(gradeId) {
    if (confirm('Are you sure you want to delete this grade?')) {
        fetch(`https://${GetParentResourceName()}/deleteGrade`, {
            method: 'POST',
            body: JSON.stringify({ gradeId })
        });
    }
}

// Marker CRUD
function openCreateMarkerModal() {
    const content = `
        <div class="form-group">
            <label>Job Name</label>
            <select id="marker-job">
                ${Object.entries(currentJobs).map(([name, job]) => 
                    `<option value="${name}">${job.label}</option>`
                ).join('')}
            </select>
        </div>
        <div class="form-group">
            <label>Marker Type</label>
            <select id="marker-type">
                <option value="deposit">Deposit</option>
                <option value="arsenal">Arsenal</option>
                <option value="safe">Safe</option>
                <option value="garage_public">Public Garage</option>
                <option value="garage_private">Private Garage</option>
                <option value="shop">Shop</option>
                <option value="crafting">Crafting</option>
                <option value="teleporter">Teleporter</option>
                <option value="market">Market</option>
                <option value="harvest">Harvest</option>
                <option value="processing">Processing</option>
                <option value="armory">Armory</option>
            </select>
        </div>
        <div class="form-group">
            <label>Marker Label</label>
            <input type="text" id="marker-label" placeholder="e.g., Police Arsenal">
        </div>
        <div class="form-group">
            <label>Marker Size</label>
            <input type="number" step="0.1" id="marker-size" value="1.5">
        </div>
        <div class="form-group">
            <label>Marker Color (R,G,B)</label>
            <input type="text" id="marker-color" value="255,0,0" placeholder="255,0,0">
        </div>
    `;
    
    createModal('Create Marker at Current Position', content, function() {
        const data = {
            job_name: document.getElementById('marker-job').value,
            type: document.getElementById('marker-type').value,
            label: document.getElementById('marker-label').value,
            marker_size: parseFloat(document.getElementById('marker-size').value),
            marker_color: document.getElementById('marker-color').value
        };
        
        fetch(`https://${GetParentResourceName()}/createMarker`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    });
}

function deleteMarker(markerId) {
    if (confirm('Are you sure you want to delete this marker?')) {
        fetch(`https://${GetParentResourceName()}/deleteMarker`, {
            method: 'POST',
            body: JSON.stringify({ markerId })
        });
    }
}

// Actions
function performAction(action) {
    fetch(`https://${GetParentResourceName()}/jobAction`, {
        method: 'POST',
        body: JSON.stringify({ action })
    });
}

function performVehicleAction(action) {
    fetch(`https://${GetParentResourceName()}/vehicleAction`, {
        method: 'POST',
        body: JSON.stringify({ action })
    });
}

// Bill modal
function openBillModal(targetId) {
    const content = `
        <div class="form-group">
            <label>Amount</label>
            <input type="number" id="bill-amount" placeholder="0">
        </div>
        <div class="form-group">
            <label>Reason</label>
            <input type="text" id="bill-reason" placeholder="Reason for bill">
        </div>
    `;
    
    createModal('Bill Player', content, function() {
        const data = {
            targetId: targetId,
            amount: parseInt(document.getElementById('bill-amount').value),
            reason: document.getElementById('bill-reason').value
        };
        
        fetch(`https://${GetParentResourceName()}/submitBill`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    });
}

// Inventory modal
function showInventoryModal(inventory) {
    let content = '<div class="list">';
    
    inventory.forEach(item => {
        content += `
            <div class="card">
                <h3>${item.label}</h3>
                <p>Count: ${item.count}</p>
            </div>
        `;
    });
    
    content += '</div>';
    
    createModal('Player Inventory', content, function() {});
}

// Identity modal
function showIdentityModal(identity) {
    const content = `
        <div class="form-group">
            <p><strong>Name:</strong> ${identity.name}</p>
            <p><strong>Date of Birth:</strong> ${identity.dob || 'N/A'}</p>
            <p><strong>Sex:</strong> ${identity.sex || 'N/A'}</p>
            <p><strong>Height:</strong> ${identity.height || 'N/A'}</p>
        </div>
    `;
    
    createModal('Player Identity', content, function() {});
}

// Statistics
function loadStatistics() {
    fetch(`https://${GetParentResourceName()}/getStatistics`, {
        method: 'POST',
        body: JSON.stringify({})
    });
}

// Nexus
function loadNexusJobs() {
    fetch(`https://${GetParentResourceName()}/getNexusJobs`, {
        method: 'POST',
        body: JSON.stringify({})
    });
}

function importJob(jobId) {
    fetch(`https://${GetParentResourceName()}/importJob`, {
        method: 'POST',
        body: JSON.stringify({ jobId })
    });
}

// Helper function
function GetParentResourceName() {
    return window.location.hostname === 'nui-game-internal' ? 
        window.location.pathname.split('/')[2] : 'jobcreator';
}

// Grade job select change handler
document.addEventListener('DOMContentLoaded', function() {
    const gradeJobSelect = document.getElementById('grade-job-select');
    if (gradeJobSelect) {
        gradeJobSelect.addEventListener('change', renderGrades);
    }
});
