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
async function openUI() {
    document.getElementById('app').style.display = 'flex';
}

async function closeUI() {
    document.getElementById('app').style.display = 'none';
    try {
        const response = await fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST',
            body: JSON.stringify({})
        });

        if (!response.ok) {
            console.error('Failed to close UI, server responded with:', response.status);
        }
    } catch (error) {
        console.error('Error with fetch request:', error);
    }
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

// Other functions remain the same or would be tested for proper working in context.