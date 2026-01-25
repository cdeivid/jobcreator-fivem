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
... [REMAINING_CODE] ...