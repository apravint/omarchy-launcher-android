// Omarchy Android Launcher Client Logic with Native Android Bridge

let INSTALLED_APPS = [];

const MOCK_FALLBACK_APPS = [
  { id: 'termux', name: 'Termux', icon: '⚡', category: 'Dev & AI', packageName: 'com.termux' },
  { id: 'openclaw', name: 'OpenClaw AI', icon: '🦅', category: 'Dev & AI' },
  { id: 'devpulse', name: 'AI-DevPulse', icon: '🛡️', category: 'Dev & AI' },
  { id: 'tamilai', name: 'Tamil AI', icon: '🌺', category: 'Dev & AI' },
  { id: 'chrome', name: 'Browser', icon: '🌐', category: 'System', packageName: 'com.android.chrome' },
  { id: 'github', name: 'GitHub', icon: '🐙', category: 'Dev & AI', packageName: 'com.github.android' },
  { id: 'camera', name: 'Camera', icon: '📷', category: 'System' },
  { id: 'gallery', name: 'Photos', icon: '🖼️', category: 'Media' },
  { id: 'settings', name: 'Settings', icon: '⚙️', category: 'System', packageName: 'com.android.settings' }
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

  loadRealInstalledApps();

  // Category Filter Pills
  document.querySelectorAll('.pill').forEach(pill => {
    pill.addEventListener('click', (e) => {
      document.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
      
      const cat = pill.dataset.category;
      if (cat === 'All') {
        renderAppGrid(INSTALLED_APPS);
      } else {
        const filtered = INSTALLED_APPS.filter(a => a.category === cat);
        renderAppGrid(filtered);
      }
    });
  });

  // AI Prompt & App Search Bar listener
  const aiInput = document.getElementById('ai-prompt-input');
  if (aiInput) {
    aiInput.addEventListener('input', (e) => {
      const query = aiInput.value.toLowerCase().trim();
      if (!query) {
        renderAppGrid(INSTALLED_APPS);
      } else {
        const filtered = INSTALLED_APPS.filter(a => a.name.toLowerCase().includes(query));
        renderAppGrid(filtered);
      }
    });

    aiInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        const query = aiInput.value.trim();
        if (query) {
          alert(`⚡ Omarchy AI Prompt Executed:\n"${query}"`);
          aiInput.value = '';
          renderAppGrid(INSTALLED_APPS);
        }
      }
    });
  }
});

function loadRealInstalledApps() {
  if (window.AndroidLauncher && window.AndroidLauncher.getInstalledApps) {
    try {
      const jsonStr = window.AndroidLauncher.getInstalledApps();
      const rawList = JSON.parse(jsonStr);

      if (rawList && rawList.length > 0) {
        INSTALLED_APPS = rawList.map(item => ({
          name: item.name,
          packageName: item.packageName,
          iconUrl: item.icon,
          category: 'All'
        }));
        renderAppGrid(INSTALLED_APPS);
        return;
      }
    } catch (err) {
      console.error("Native apps load error:", err);
    }
  }

  // Fallback to mock preview apps if web preview
  INSTALLED_APPS = MOCK_FALLBACK_APPS;
  renderAppGrid(INSTALLED_APPS);
}

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

    const iconHtml = app.iconUrl 
      ? `<img src="${app.iconUrl}" style="width:40px; height:40px; object-fit:contain;" />`
      : app.icon || '📱';

    item.innerHTML = `
      <div class="app-icon">${iconHtml}</div>
      <div class="app-label">${app.name}</div>
    `;
    grid.appendChild(item);
  });
}

function triggerAppAction(app) {
  if (app.packageName && window.AndroidLauncher && window.AndroidLauncher.launchApp) {
    const launched = window.AndroidLauncher.launchApp(app.packageName);
    if (!launched) {
      alert(`Unable to launch ${app.name}`);
    }
  } else if (app.id === 'themes') {
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
