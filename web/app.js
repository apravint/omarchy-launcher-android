// Omarchy Android Launcher Client Logic with Native Android Bridge
let INSTALLED_APPS = [];
let CURRENT_APP_SELECTED = null;

const THEMES_LIST = [
  { id: 'tokyonight', name: 'Tokyo Night', color: '#7aa2f7' },
  { id: 'catppuccin', name: 'Catppuccin', color: '#c6a0f6' },
  { id: 'nord', name: 'Nord Dark', color: '#88c0d0' },
  { id: 'cyberpunk', name: 'Cyberpunk 2077', color: '#ff007f' },
  { id: 'dracula', name: 'Dracula', color: '#ff79c6' },
  { id: 'sunset', name: 'Sunset Neon', color: '#fb7185' },
  { id: 'oled', name: 'OLED Pure Black', color: '#38bdf8' }
];

const MOCK_FALLBACK_APPS = [
  { name: 'Termux', packageName: 'com.termux', icon: '⚡', category: 'Dev & AI' },
  { name: 'Chrome', packageName: 'com.android.chrome', icon: '🌐', category: 'System' },
  { name: 'Settings', packageName: 'com.android.settings', icon: '⚙️', category: 'System' },
  { name: 'Camera', packageName: 'com.android.camera', icon: '📷', category: 'System' },
  { name: 'YouTube', packageName: 'com.google.android.youtube', icon: '▶️', category: 'User' },
  { name: 'WhatsApp', packageName: 'com.whatsapp', icon: '💬', category: 'User' },
  { name: 'GitHub', packageName: 'com.github.android', icon: '🐙', category: 'Dev & AI' },
  { name: 'Files', packageName: 'com.google.android.documentsui', icon: '📁', category: 'System' }
];

document.addEventListener('DOMContentLoaded', () => {
  updateClock();
  setInterval(updateClock, 1000);

  loadDeviceInfo();
  loadSavedTheme();
  loadRealInstalledApps();

  // Category Filter Pills
  document.querySelectorAll('.category-pills .pill').forEach(pill => {
    pill.addEventListener('click', () => {
      document.querySelectorAll('.category-pills .pill').forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
      
      const cat = pill.dataset.category;
      filterAppsByCategory(cat);
    });
  });

  // AI Prompt & App Search Bar
  const aiInput = document.getElementById('ai-prompt-input');
  const clearBtn = document.getElementById('search-clear');

  if (aiInput) {
    aiInput.addEventListener('input', () => {
      const query = aiInput.value.toLowerCase().trim();
      clearBtn.style.display = query ? 'block' : 'none';
      if (!query) {
        renderAppGrid(INSTALLED_APPS);
      } else {
        const filtered = INSTALLED_APPS.filter(a => 
          a.name.toLowerCase().includes(query) || 
          (a.packageName && a.packageName.toLowerCase().includes(query))
        );
        renderAppGrid(filtered);
      }
    });

    aiInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        const query = aiInput.value.trim();
        if (query) {
          // If query matches exact package or app, launch it directly!
          const match = INSTALLED_APPS.find(a => a.name.toLowerCase() === query.toLowerCase());
          if (match) {
            triggerAppLaunch(match);
          } else {
            alert(`⚡ Omarchy AI Prompt Executed:\n"${query}"`);
          }
          aiInput.value = '';
          clearBtn.style.display = 'none';
          renderAppGrid(INSTALLED_APPS);
        }
      }
    });
  }

  // Setup Theme Modal Grid
  renderThemeGrid();
});

function loadDeviceInfo() {
  const badge = document.getElementById('device-badge');
  if (window.AndroidLauncher && window.AndroidLauncher.getDeviceInfo) {
    try {
      const info = JSON.parse(window.AndroidLauncher.getDeviceInfo());
      if (info && info.model) {
        badge.innerText = `⚡ ${info.manufacturer || ''} ${info.model} • Android ${info.androidVersion || ''}`;
        return;
      }
    } catch (e) {
      console.error(e);
    }
  }
  badge.innerText = `⚡ Omarchy OS • Motorola Edge`;
}

function loadRealInstalledApps() {
  if (window.AndroidLauncher && window.AndroidLauncher.getInstalledApps) {
    try {
      const jsonStr = window.AndroidLauncher.getInstalledApps();
      const rawList = JSON.parse(jsonStr);

      if (rawList && rawList.length > 0) {
        INSTALLED_APPS = rawList.map(item => {
          let cat = 'User';
          const pkg = item.packageName || '';
          if (pkg.includes('android') || pkg.includes('google') || pkg.includes('system') || pkg.includes('motorola')) {
            cat = 'System';
          }
          if (pkg.includes('termux') || pkg.includes('github') || item.name.toLowerCase().includes('dev') || item.name.toLowerCase().includes('ai')) {
            cat = 'Dev & AI';
          }
          return {
            name: item.name,
            packageName: item.packageName,
            iconUrl: item.icon,
            category: cat
          };
        });
        
        // Sort alphabetically
        INSTALLED_APPS.sort((a, b) => a.name.localeCompare(b.name));
        updateCategoryCounts();
        renderAppGrid(INSTALLED_APPS);
        return;
      }
    } catch (err) {
      console.error("Native apps load error:", err);
    }
  }

  // Fallback for Web preview
  INSTALLED_APPS = MOCK_FALLBACK_APPS;
  updateCategoryCounts();
  renderAppGrid(INSTALLED_APPS);
}

function updateCategoryCounts() {
  const allCount = INSTALLED_APPS.length;
  const sysCount = INSTALLED_APPS.filter(a => a.category === 'System').length;
  const devCount = INSTALLED_APPS.filter(a => a.category === 'Dev & AI').length;
  const userCount = INSTALLED_APPS.filter(a => a.category === 'User').length;

  document.getElementById('count-all').innerText = allCount;
  document.getElementById('count-system').innerText = sysCount;
  document.getElementById('count-dev').innerText = devCount;
  document.getElementById('count-user').innerText = userCount;
}

function filterAppsByCategory(category) {
  if (category === 'All') {
    renderAppGrid(INSTALLED_APPS);
  } else {
    const filtered = INSTALLED_APPS.filter(a => a.category === category);
    renderAppGrid(filtered);
  }
}

function renderAppGrid(appList) {
  const grid = document.getElementById('app-grid-container');
  grid.innerHTML = '';

  if (!appList || appList.length === 0) {
    grid.innerHTML = `<div class="loading-spinner">No matching apps found.</div>`;
    return;
  }

  appList.forEach(app => {
    const item = document.createElement('div');
    item.className = 'app-item';

    let pressTimer;

    item.addEventListener('click', () => triggerAppLaunch(app));

    // Long press to view details
    item.addEventListener('touchstart', () => {
      pressTimer = setTimeout(() => openAppModal(app), 600);
    });
    item.addEventListener('touchend', () => clearTimeout(pressTimer));
    item.addEventListener('contextmenu', (e) => {
      e.preventDefault();
      openAppModal(app);
    });

    const iconHtml = app.iconUrl 
      ? `<img src="${app.iconUrl}" style="width:38px; height:38px; object-fit:contain;" />`
      : app.icon || '📱';

    item.innerHTML = `
      <div class="app-icon">${iconHtml}</div>
      <div class="app-label" title="${app.name}">${app.name}</div>
    `;
    grid.appendChild(item);
  });
}

function triggerAppLaunch(app) {
  if (app.packageName && window.AndroidLauncher && window.AndroidLauncher.launchApp) {
    const launched = window.AndroidLauncher.launchApp(app.packageName);
    if (!launched) {
      alert(`Unable to launch ${app.name}`);
    }
  } else {
    alert(`🚀 Launching ${app.name}...`);
  }
}

function updateClock() {
  const now = new Date();
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  
  const timeElem = document.getElementById('time-val');
  const dateElem = document.getElementById('date-val');

  if (timeElem) timeElem.innerText = `${hours}:${minutes}`;
  if (dateElem) dateElem.innerText = `${days[now.getDay()]}, ${months[now.getMonth()]} ${now.getDate()}`;
}

function clearSearch() {
  const aiInput = document.getElementById('ai-prompt-input');
  const clearBtn = document.getElementById('search-clear');
  aiInput.value = '';
  clearBtn.style.display = 'none';
  renderAppGrid(INSTALLED_APPS);
}

function scrollToTop() {
  const container = document.querySelector('.main-content-area');
  if (container) container.scrollTo({ top: 0, behavior: 'smooth' });
}

// System Bridge Shortcuts
function openSystemSettings() {
  if (window.AndroidLauncher && window.AndroidLauncher.openSettings) {
    window.AndroidLauncher.openSettings();
  } else {
    alert('⚙️ Opening Android Settings...');
  }
}

function openWallpaper() {
  if (window.AndroidLauncher && window.AndroidLauncher.openWallpaperPicker) {
    window.AndroidLauncher.openWallpaperPicker();
  } else {
    alert('🖼️ Select Wallpaper from Device Gallery');
  }
}

// Theme Modal Logic
function openThemeModal() {
  document.getElementById('theme-modal').classList.add('active');
}

function closeThemeModal() {
  document.getElementById('theme-modal').classList.remove('active');
}

function renderThemeGrid() {
  const container = document.getElementById('theme-grid-container');
  if (!container) return;
  container.innerHTML = '';

  THEMES_LIST.forEach(t => {
    const item = document.createElement('div');
    item.className = 'theme-item';
    item.onclick = () => applyTheme(t.id);

    item.innerHTML = `
      <div class="theme-dot" style="background: ${t.color}"></div>
      <div class="theme-name">${t.name}</div>
    `;
    container.appendChild(item);
  });
}

function applyTheme(themeId) {
  document.body.className = `theme-${themeId}`;
  localStorage.setItem('omarchy_theme', themeId);
  closeThemeModal();
}

function loadSavedTheme() {
  const saved = localStorage.getItem('omarchy_theme') || 'tokyonight';
  document.body.className = `theme-${saved}`;
}

// App Details Context Modal
function openAppModal(app) {
  CURRENT_APP_SELECTED = app;
  document.getElementById('app-modal-title').innerText = app.name;
  document.getElementById('app-modal-pkg').innerText = app.packageName || 'com.example.app';

  const iconContainer = document.getElementById('app-modal-icon');
  if (app.iconUrl) {
    iconContainer.innerHTML = `<img src="${app.iconUrl}" style="width:48px; height:48px; object-fit:contain;" />`;
  } else {
    iconContainer.innerHTML = app.icon || '📱';
  }

  document.getElementById('btn-launch-modal').onclick = () => {
    closeAppModal();
    triggerAppLaunch(app);
  };

  document.getElementById('btn-info-modal').onclick = () => {
    closeAppModal();
    if (app.packageName && window.AndroidLauncher && window.AndroidLauncher.openAppDetails) {
      window.AndroidLauncher.openAppDetails(app.packageName);
    } else {
      alert(`App Info: ${app.packageName}`);
    }
  };

  document.getElementById('app-modal').classList.add('active');
}

function closeAppModal() {
  document.getElementById('app-modal').classList.remove('active');
}
