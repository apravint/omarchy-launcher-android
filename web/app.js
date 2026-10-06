// Omarchy Android Launcher Client Logic

const APPS = [
  { id: 'termux', name: 'Termux', icon: '⚡', category: 'Dev & AI', action: 'launchTermux' },
  { id: 'openclaw', name: 'OpenClaw AI', icon: '🦅', category: 'Dev & AI', action: 'launchOpenClaw' },
  { id: 'devpulse', name: 'AI-DevPulse', icon: '🛡️', category: 'Dev & AI', action: 'launchDevPulse' },
  { id: 'tamilai', name: 'Tamil AI', icon: '🌺', category: 'Dev & AI', action: 'launchTamilAI' },
  { id: 'chrome', name: 'Browser', icon: '🌐', category: 'System', action: 'openBrowser' },
  { id: 'github', name: 'GitHub', icon: '🐙', category: 'Dev & AI', action: 'openGitHub' },
  { id: 'camera', name: 'Camera', icon: '📷', category: 'System', action: 'openCamera' },
  { id: 'gallery', name: 'Photos', icon: '🖼️', category: 'Media', action: 'openGallery' },
  { id: 'music', name: 'Music', icon: '🎵', category: 'Media', action: 'openMusic' },
  { id: 'settings', name: 'Settings', icon: '⚙️', category: 'System', action: 'openSettings' },
  { id: 'telegram', name: 'Messages', icon: '💬', category: 'Media', action: 'openMessages' },
  { id: 'themes', name: 'Omarchy Themes', icon: '🎨', category: 'System', action: 'openThemeSwitcher' }
];

const THEMES = {
  'tokyo-night': { primary: '#7aa2f7', secondary: '#bb9af7', bg: 'radial-gradient(circle at top right, #1e1b4b, #0f172a, #090d16)' },
  'catppuccin': { primary: '#cba6f7', secondary: '#89b4fa', bg: 'radial-gradient(circle at top right, #241e38, #1e1e2e, #11111b)' },
  'nord': { primary: '#88c0d0', secondary: '#81a1c1', bg: 'radial-gradient(circle at top right, #2e3440, #1b212c, #0f141d)' },
  'cyberpunk': { primary: '#ff0055', secondary: '#00ffcc', bg: 'radial-gradient(circle at top right, #380016, #080811, #000000)' }
};

document.addEventListener('DOMContentLoaded', () => {
  updateClock();
  setInterval(updateClock, 1000);

  renderAppGrid(APPS);

  // Category Filter Pills
  document.querySelectorAll('.pill').forEach(pill => {
    pill.addEventListener('click', (e) => {
      document.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
      
      const cat = pill.dataset.category;
      if (cat === 'All') {
        renderAppGrid(APPS);
      } else {
        const filtered = APPS.filter(a => a.category === cat);
        renderAppGrid(filtered);
      }
    });
  });

  // AI Prompt Bar listener
  const aiInput = document.getElementById('ai-prompt-input');
  if (aiInput) {
    aiInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        const query = aiInput.value.trim();
        if (query) {
          alert(`⚡ Omarchy AI Prompt Sent:\n"${query}"\nExecuting via local AI engine...`);
          aiInput.value = '';
        }
      }
    });
  }
});

function updateClock() {
  const now = new Date();
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  
  const timeStr = `${hours}:${minutes}`;
  const options = { weekday: 'long', month: 'short', day: 'numeric' };
  const dateStr = now.toLocaleDateString('en-US', options);

  document.getElementById('time-val').innerText = timeStr;
  document.getElementById('date-val').innerText = dateStr;
}

function renderAppGrid(appList) {
  const grid = document.getElementById('app-grid-container');
  if (!grid) return;
  grid.innerHTML = '';

  appList.forEach(app => {
    const item = document.createElement('div');
    item.className = 'app-item';
    item.onclick = () => triggerAppAction(app);

    item.innerHTML = `
      <div class="app-icon">${app.icon}</div>
      <div class="app-label">${app.name}</div>
    `;
    grid.appendChild(item);
  });
}

function triggerAppAction(app) {
  if (app.id === 'themes') {
    switchThemeModal();
  } else {
    alert(`🚀 Launching ${app.name}...`);
  }
}

function switchThemeModal() {
  const keys = Object.keys(THEMES);
  const choice = prompt(`Select Omarchy Theme:\n${keys.join(', ')}`, 'catppuccin');
  if (choice && THEMES[choice.toLowerCase()]) {
    const theme = THEMES[choice.toLowerCase()];
    document.documentElement.style.setProperty('--accent-primary', theme.primary);
    document.documentElement.style.setProperty('--accent-secondary', theme.secondary);
    document.body.style.background = theme.bg;
    alert(`✔ Switched to ${choice} theme!`);
  }
}
