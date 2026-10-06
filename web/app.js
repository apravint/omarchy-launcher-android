// Omarchy Multi-OS Android Launcher (Omarchy / Windows 11 / macOS Modes)
let INSTALLED_APPS = [];
let PINNED_HOTSEAT_PKGS = JSON.parse(localStorage.getItem('omarchy_hotseat') || '["com.android.chrome", "com.whatsapp", "com.termux", "com.android.camera", "com.android.settings"]');
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
  loadSavedIconShape();
  loadSavedGridDensity();
  loadSavedOSMode();
  loadRealInstalledApps();

  // Home key handler from native Java
  window.onHomePressed = () => {
    scrollToTop();
    closeAppModal();
    closeThemeModal();
    closeWin11StartMenu();
    triggerHaptic();
  };

  // Category Filter Pills
  document.querySelectorAll('.category-pills .pill').forEach(pill => {
    pill.addEventListener('click', () => {
      triggerHaptic();
      document.querySelectorAll('.category-pills .pill').forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
      
      const cat = pill.dataset.category;
      filterAppsByCategory(cat);
    });
  });

  // AI Prompt & App Search Bar with Web/Store Fallback Shortcuts
  const aiInput = document.getElementById('ai-prompt-input');
  const clearBtn = document.getElementById('search-clear');
  const searchShortcuts = document.getElementById('search-shortcuts');
  const btnWeb = document.getElementById('btn-web-search');
  const btnStore = document.getElementById('btn-store-search');

  if (aiInput) {
    aiInput.addEventListener('input', () => {
      const query = aiInput.value.toLowerCase().trim();
      clearBtn.style.display = query ? 'block' : 'none';
      searchShortcuts.style.display = query ? 'flex' : 'none';

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
        triggerHaptic();
        const query = aiInput.value.trim();
        if (query) {
          const match = INSTALLED_APPS.find(a => a.name.toLowerCase() === query.toLowerCase());
          if (match) {
            triggerAppLaunch(match);
          } else {
            searchWeb(query);
          }
          clearSearch();
        }
      }
    });
  }

  if (btnWeb) {
    btnWeb.onclick = () => {
      triggerHaptic();
      const query = aiInput.value.trim();
      if (query) searchWeb(query);
    };
  }

  if (btnStore) {
    btnStore.onclick = () => {
      triggerHaptic();
      const query = aiInput.value.trim();
      if (query) searchPlayStore(query);
    };
  }

  renderThemeGrid();
  buildAlphabetIndexer();
});

function triggerHaptic() {
  if (window.AndroidLauncher && window.AndroidLauncher.performHaptics) {
    try { window.AndroidLauncher.performHaptics(); } catch (e) {}
  }
}

// OS Launcher Experience Switcher (Omarchy / Windows 11 / macOS)
function setOSMode(mode) {
  triggerHaptic();
  document.body.classList.remove('mode-omarchy', 'mode-win11', 'mode-macos');
  document.body.classList.add(`mode-${mode}`);

  document.querySelectorAll('.os-btn').forEach(btn => {
    if (btn.dataset.os === mode) {
      btn.classList.add('active');
    } else {
      btn.classList.remove('active');
    }
  });

  const macosBar = document.getElementById('macos-bar');
  const win11Btn = document.getElementById('dock-btn-win11');
  const searchIcon = document.getElementById('search-mode-icon');

  if (mode === 'macos') {
    macosBar.style.display = 'flex';
    win11Btn.style.display = 'none';
    searchIcon.innerText = '';
  } else if (mode === 'win11') {
    macosBar.style.display = 'none';
    win11Btn.style.display = 'inline-block';
    searchIcon.innerText = '🪟';
    renderWin11Apps(INSTALLED_APPS);
  } else {
    macosBar.style.display = 'none';
    win11Btn.style.display = 'none';
    searchIcon.innerText = '⚡';
  }

  localStorage.setItem('omarchy_os_mode', mode);
}

function loadSavedOSMode() {
  const saved = localStorage.getItem('omarchy_os_mode') || 'omarchy';
  setOSMode(saved);
}

// Windows 11 Start Menu Modal Handlers
function toggleWin11StartMenu() {
  triggerHaptic();
  const modal = document.getElementById('win11-modal');
  modal.classList.toggle('active');
}

function closeWin11StartMenu() {
  const modal = document.getElementById('win11-modal');
  if (modal) modal.classList.remove('active');
}

function renderWin11Apps(appList) {
  const grid = document.getElementById('win11-app-grid');
  if (!grid) return;
  grid.innerHTML = '';

  appList.forEach(app => {
    const item = document.createElement('div');
    item.className = 'app-item';
    item.onclick = () => {
      triggerHaptic();
      closeWin11StartMenu();
      triggerAppLaunch(app);
    };

    const iconHtml = app.iconUrl 
      ? `<img src="${app.iconUrl}" style="width:100%; height:100%; object-fit:contain;" />`
      : app.icon || '📱';

    item.innerHTML = `
      <div class="app-icon">${iconHtml}</div>
      <div class="app-label" title="${app.name}">${app.name}</div>
    `;
    grid.appendChild(item);
  });
}

function filterWin11Apps(query) {
  const q = query.toLowerCase().trim();
  if (!q) {
    renderWin11Apps(INSTALLED_APPS);
  } else {
    const filtered = INSTALLED_APPS.filter(a => a.name.toLowerCase().includes(q));
    renderWin11Apps(filtered);
  }
}

function renderHotseatDock() {
  const container = document.getElementById('hotseat-container');
  if (!container) return;
  container.innerHTML = '';

  const pinnedApps = INSTALLED_APPS.filter(a => PINNED_HOTSEAT_PKGS.includes(a.packageName));
  
  if (pinnedApps.length === 0) {
    container.style.display = 'none';
    return;
  }
  container.style.display = 'flex';

  pinnedApps.slice(0, 5).forEach(app => {
    const item = document.createElement('div');
    item.className = 'hotseat-item';
    item.onclick = () => {
      triggerHaptic();
      triggerAppLaunch(app);
    };

    const iconHtml = app.iconUrl 
      ? `<img src="${app.iconUrl}" style="width:100%; height:100%; object-fit:contain;" />`
      : app.icon || '📱';

    item.innerHTML = `<div class="app-icon">${iconHtml}</div>`;
    container.appendChild(item);
  });
}

function togglePinHotseat(app) {
  if (!app || !app.packageName) return;
  
  const index = PINNED_HOTSEAT_PKGS.indexOf(app.packageName);
  if (index > -1) {
    PINNED_HOTSEAT_PKGS.splice(index, 1);
  } else {
    if (PINNED_HOTSEAT_PKGS.length >= 5) {
      PINNED_HOTSEAT_PKGS.shift();
    }
    PINNED_HOTSEAT_PKGS.push(app.packageName);
  }

  localStorage.setItem('omarchy_hotseat', JSON.stringify(PINNED_HOTSEAT_PKGS));
  renderHotseatDock();
  closeAppModal();
}

function searchWeb(query) {
  const url = `https://www.google.com/search?q=${encodeURIComponent(query)}`;
  if (window.AndroidLauncher && window.AndroidLauncher.launchApp) {
    window.AndroidLauncher.launchApp('com.android.chrome');
  } else {
    window.open(url, '_blank');
  }
}

function searchPlayStore(query) {
  const url = `https://play.google.com/store/search?q=${encodeURIComponent(query)}&c=apps`;
  if (window.AndroidLauncher && window.AndroidLauncher.launchApp) {
    window.AndroidLauncher.launchApp('com.android.vending');
  } else {
    window.open(url, '_blank');
  }
}

function buildAlphabetIndexer() {
  const indexer = document.getElementById('alphabet-indexer');
  if (!indexer) return;

  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#'.split('');
  indexer.innerHTML = '';

  alphabet.forEach(letter => {
    const span = document.createElement('span');
    span.className = 'fast-letter';
    span.innerText = letter;
    span.onclick = () => {
      triggerHaptic();
      scrollToLetter(letter);
    };
    indexer.appendChild(span);
  });
}

function scrollToLetter(letter) {
  const grid = document.getElementById('app-grid-container');
  const items = grid.querySelectorAll('.app-item');
  
  for (let item of items) {
    const name = item.dataset.appName || '';
    if (letter === '#' && !isNaN(name.charAt(0))) {
      item.scrollIntoView({ behavior: 'smooth', block: 'start' });
      return;
    } else if (name.toUpperCase().startsWith(letter)) {
      item.scrollIntoView({ behavior: 'smooth', block: 'start' });
      return;
    }
  }
}

function setDefaultHomeLauncher() {
  triggerHaptic();
  if (window.AndroidLauncher && window.AndroidLauncher.setAsDefaultHome) {
    window.AndroidLauncher.setAsDefaultHome();
  } else {
    alert('📱 Select Omarchy Launcher as your Home app in Android Settings!');
  }
}

function setGridDensity(cols) {
  triggerHaptic();
  const grid = document.getElementById('app-grid-container');
  grid.className = `app-grid grid-cols-${cols}`;
  
  document.querySelectorAll('.density-btn').forEach(btn => {
    if (btn.dataset.cols == cols) {
      btn.classList.add('active');
    } else {
      btn.classList.remove('active');
    }
  });

  localStorage.setItem('omarchy_grid_cols', cols);
}

function loadSavedGridDensity() {
  const savedCols = localStorage.getItem('omarchy_grid_cols') || 5;
  setGridDensity(savedCols);
}

function setIconShape(shape) {
  triggerHaptic();
  document.body.classList.remove('shape-squircle', 'shape-circle', 'shape-rounded', 'shape-teardrop');
  document.body.classList.add(`shape-${shape}`);
  
  document.querySelectorAll('.shape-btn').forEach(btn => {
    if (btn.dataset.shape === shape) {
      btn.classList.add('active');
    } else {
      btn.classList.remove('active');
    }
  });

  localStorage.setItem('omarchy_icon_shape', shape);
}

function loadSavedIconShape() {
  const saved = localStorage.getItem('omarchy_icon_shape') || 'squircle';
  setIconShape(saved);
}

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
        
        INSTALLED_APPS.sort((a, b) => a.name.localeCompare(b.name));
        updateCategoryCounts();
        renderHotseatDock();
        renderAppGrid(INSTALLED_APPS);
        renderWin11Apps(INSTALLED_APPS);
        return;
      }
    } catch (err) {
      console.error("Native apps load error:", err);
    }
  }

  INSTALLED_APPS = MOCK_FALLBACK_APPS;
  updateCategoryCounts();
  renderHotseatDock();
  renderAppGrid(INSTALLED_APPS);
  renderWin11Apps(INSTALLED_APPS);
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
    item.dataset.appName = app.name;

    let pressTimer;

    item.addEventListener('click', () => {
      triggerHaptic();
      triggerAppLaunch(app);
    });

    item.addEventListener('touchstart', () => {
      pressTimer = setTimeout(() => {
        triggerHaptic();
        openAppModal(app);
      }, 550);
    });
    item.addEventListener('touchend', () => clearTimeout(pressTimer));
    item.addEventListener('contextmenu', (e) => {
      e.preventDefault();
      triggerHaptic();
      openAppModal(app);
    });

    const iconHtml = app.iconUrl 
      ? `<img src="${app.iconUrl}" style="width:100%; height:100%; object-fit:contain;" />`
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
  const macosClock = document.getElementById('macos-clock');

  const formattedTime = `${hours}:${minutes}`;
  if (timeElem) timeElem.innerText = formattedTime;
  if (dateElem) dateElem.innerText = `${days[now.getDay()]}, ${months[now.getMonth()]} ${now.getDate()}`;
  if (macosClock) macosClock.innerText = formattedTime;
}

function clearSearch() {
  const aiInput = document.getElementById('ai-prompt-input');
  const clearBtn = document.getElementById('search-clear');
  const searchShortcuts = document.getElementById('search-shortcuts');
  
  aiInput.value = '';
  clearBtn.style.display = 'none';
  searchShortcuts.style.display = 'none';
  renderAppGrid(INSTALLED_APPS);
}

function scrollToTop() {
  triggerHaptic();
  const container = document.getElementById('main-scroll-area');
  if (container) container.scrollTo({ top: 0, behavior: 'smooth' });
}

function openSystemSettings() {
  triggerHaptic();
  if (window.AndroidLauncher && window.AndroidLauncher.openSettings) {
    window.AndroidLauncher.openSettings();
  } else {
    alert('⚙️ Opening Android Settings...');
  }
}

function openWallpaper() {
  triggerHaptic();
  if (window.AndroidLauncher && window.AndroidLauncher.openWallpaperPicker) {
    window.AndroidLauncher.openWallpaperPicker();
  } else {
    alert('🖼️ Select Wallpaper from Device Gallery');
  }
}

function openThemeModal() {
  triggerHaptic();
  document.getElementById('theme-modal').classList.add('active');
}

function closeThemeModal() {
  triggerHaptic();
  document.getElementById('theme-modal').classList.remove('active');
}

function renderThemeGrid() {
  const container = document.getElementById('theme-grid-container');
  if (!container) return;
  container.innerHTML = '';

  THEMES_LIST.forEach(t => {
    const item = document.createElement('div');
    item.className = 'theme-item';
    item.onclick = () => {
      triggerHaptic();
      applyTheme(t.id);
    };

    item.innerHTML = `
      <div class="theme-dot" style="background: ${t.color}"></div>
      <div class="theme-name">${t.name}</div>
    `;
    container.appendChild(item);
  });
}

function applyTheme(themeId) {
  document.body.classList.remove(
    'theme-tokyonight', 'theme-catppuccin', 'theme-nord', 
    'theme-cyberpunk', 'theme-dracula', 'theme-sunset', 'theme-oled'
  );
  document.body.classList.add(`theme-${themeId}`);
  localStorage.setItem('omarchy_theme', themeId);
}

function loadSavedTheme() {
  const saved = localStorage.getItem('omarchy_theme') || 'tokyonight';
  applyTheme(saved);
}

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

  const isPinned = PINNED_HOTSEAT_PKGS.includes(app.packageName);
  const pinBtn = document.getElementById('btn-pin-hotseat');
  if (pinBtn) {
    pinBtn.innerText = isPinned ? '📌 Unpin from Dock' : '📌 Pin to Favorite Dock';
    pinBtn.onclick = () => {
      triggerHaptic();
      togglePinHotseat(app);
    };
  }

  document.getElementById('btn-launch-modal').onclick = () => {
    triggerHaptic();
    closeAppModal();
    triggerAppLaunch(app);
  };

  document.getElementById('btn-info-modal').onclick = () => {
    triggerHaptic();
    closeAppModal();
    if (app.packageName && window.AndroidLauncher && window.AndroidLauncher.openAppDetails) {
      window.AndroidLauncher.openAppDetails(app.packageName);
    } else {
      alert(`App Info: ${app.packageName}`);
    }
  };

  document.getElementById('btn-uninstall-modal').onclick = () => {
    triggerHaptic();
    closeAppModal();
    if (app.packageName && window.AndroidLauncher && window.AndroidLauncher.uninstallApp) {
      window.AndroidLauncher.uninstallApp(app.packageName);
    } else {
      alert(`Uninstall: ${app.packageName}`);
    }
  };

  document.getElementById('app-modal').classList.add('active');
}

function closeAppModal() {
  document.getElementById('app-modal').classList.remove('active');
}
