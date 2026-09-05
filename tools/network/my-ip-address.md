## My IP Address

<style>
  :root {
    --border-color: #3c3c3c;
    --accent-color: #007acc;
    --error-color: #f48771;
    --success-color: #89d4a1;
  }

  .controls {
    display: flex;
    gap: 12px;
    align-items: center;
    margin-bottom: 10px;
  }

  button {
    border: 1px solid var(--border-color);
    background-color: var(--accent-color);
    color: #fff;
    padding: 6px 12px;
    border-radius: 4px;
    font-size: 0.85rem;
    cursor: pointer;
  }

  button:hover {
    opacity: 0.9;
  }

  button:focus {
    outline: 1px solid var(--accent-color);
  }

  .btn-secondary {
    background-color: transparent;
    color: inherit;
  }

  .main-container {
    display: flex;
    flex-direction: column;
    gap: 10px;
    overflow-y: auto;
    min-height: 0;
    flex: 1;
  }

  .panel {
    display: flex;
    flex-direction: column;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    min-height: 0;
  }

  .panel-header {
    padding: 6px 15px;
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    border-bottom: 1px solid var(--border-color);
  }

  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 12px;
    padding: 15px;
  }

  .info-item {
    display: flex;
    flex-direction: column;
    gap: 4px;
  }

  .info-label {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    opacity: 0.7;
  }

  .info-value {
    font-size: 0.95rem;
    word-break: break-word;
    font-family: monospace;
  }

  .status-bar {
    padding: 5px 20px;
    font-size: 0.85rem;
    border-top: 1px solid var(--border-color);
    min-height: 20px;
    margin-top: 10px;
  }

  .error-msg { color: var(--error-color); }
  .success-msg { color: var(--success-color); }

  .tool {
    max-height: 80vh;
    height: stretch;
    display: flex;
    flex-direction: column;
    padding-top: 10px;
    padding-bottom: 10px;
  }
</style>

<div class="tool">
  <div class="controls">
    <button id="refreshBtn">Refresh Data</button>
    <button id="copyAllBtn" class="btn-secondary">Copy JSON</button>
  </div>

  <div class="main-container">
    <!-- IP & Location Section -->
    <div class="panel">
      <div class="panel-header">Network & Location</div>
      <div class="grid">
        <div class="info-item">
          <span class="info-label">Public IP Address</span>
          <span class="info-value" id="ipAddress">Fetching...</span>
        </div>
        <div class="info-item">
          <span class="info-label">ISP / Organization</span>
          <span class="info-value" id="isp">Fetching...</span>
        </div>
        <div class="info-item">
          <span class="info-label">Location</span>
          <span class="info-value" id="location">Fetching...</span>
        </div>
        <div class="info-item">
          <span class="info-label">Timezone</span>
          <span class="info-value" id="ipTimezone">Fetching...</span>
        </div>
      </div>
    </div>
    <!-- Browser & OS Section -->
    <div class="panel">
      <div class="panel-header">Browser & Environment</div>
      <div class="grid">
        <div class="info-item">
          <span class="info-label">Browser</span>
          <span class="info-value" id="browser">Detecting...</span>
        </div>
        <div class="info-item">
          <span class="info-label">Operating System</span>
          <span class="info-value" id="os">Detecting...</span>
        </div>
        <div class="info-item">
          <span class="info-label">Language</span>
          <span class="info-value" id="language">Detecting...</span>
        </div>
        <div class="info-item">
          <span class="info-label">Cookies Enabled</span>
          <span class="info-value" id="cookies">Detecting...</span>
        </div>
        <div class="info-item">
          <span class="info-label">Online Status</span>
          <span class="info-value" id="onlineStatus">Detecting...</span>
        </div>
        <div class="info-item">
          <span class="info-label">User Agent</span>
          <span class="info-value" id="userAgent" style="font-size: 0.8rem;">Detecting...</span>
        </div>
      </div>
    </div>
    <!-- Hardware & Display Section -->
    <div class="panel">
      <div class="panel-header">Display & Hardware</div>
      <div class="grid">
        <div class="info-item">
          <span class="info-label">Screen Resolution</span>
          <span class="info-value" id="screenRes">Detecting...</span>
        </div>
        <div class="info-item">
          <span class="info-label">Viewport Size</span>
          <span class="info-value" id="viewportRes">Detecting...</span>
        </div>
        <div class="info-item">
          <span class="info-label">Color Depth</span>
          <span class="info-value" id="colorDepth">Detecting...</span>
        </div>
        <div class="info-item">
          <span class="info-label">Device Memory</span>
          <span class="info-value" id="deviceMemory">Detecting...</span>
        </div>
        <div class="info-item">
          <span class="info-label">CPU Cores</span>
          <span class="info-value" id="cpuCores">Detecting...</span>
        </div>
      </div>
    </div>
  </div>

  <div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const statusBar = document.getElementById('statusBar');
  const refreshBtn = document.getElementById('refreshBtn');
  const copyAllBtn = document.getElementById('copyAllBtn');

  let currentData = {};

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  function detectBrowserOS() {
    const ua = navigator.userAgent;
    let browser = "Unknown";
    let os = "Unknown";

    if (ua.indexOf("Win") !== -1) os = "Windows";
    else if (ua.indexOf("Mac") !== -1) os = "macOS";
    else if (ua.indexOf("Linux") !== -1) os = "Linux";
    else if (ua.indexOf("Android") !== -1) os = "Android";
    else if (ua.indexOf("like Mac") !== -1) os = "iOS";

    if (ua.indexOf("Firefox") !== -1) browser = "Firefox";
    else if (ua.indexOf("SamsungBrowser") !== -1) browser = "Samsung Internet";
    else if (ua.indexOf("Opera") !== -1 || ua.indexOf("OPR") !== -1) browser = "Opera";
    else if (ua.indexOf("Trident") !== -1) browser = "Internet Explorer";
    else if (ua.indexOf("Edge") !== -1 || ua.indexOf("Edg") !== -1) browser = "Microsoft Edge";
    else if (ua.indexOf("Chrome") !== -1) browser = "Chrome";
    else if (ua.indexOf("Safari") !== -1) browser = "Safari";

    return { browser, os };
  }

  function collectClientDetails() {
    const { browser, os } = detectBrowserOS();

    const details = {
      browser,
      os,
      language: navigator.language || navigator.userLanguage,
      cookiesEnabled: navigator.cookieEnabled ? "Yes" : "No",
      onlineStatus: navigator.onLine ? "Online" : "Offline",
      userAgent: navigator.userAgent,
      screenResolution: `${window.screen.width} x ${window.screen.height}`,
      viewportResolution: `${window.innerWidth} x ${window.innerHeight}`,
      colorDepth: `${window.screen.colorDepth}-bit`,
      deviceMemory: navigator.deviceMemory ? `~${navigator.deviceMemory} GB` : "N/A",
      cpuCores: navigator.hardwareConcurrency || "N/A"
    };

    document.getElementById('browser').textContent = details.browser;
    document.getElementById('os').textContent = details.os;
    document.getElementById('language').textContent = details.language;
    document.getElementById('cookies').textContent = details.cookiesEnabled;
    document.getElementById('onlineStatus').textContent = details.onlineStatus;
    document.getElementById('userAgent').textContent = details.userAgent;

    document.getElementById('screenRes').textContent = details.screenResolution;
    document.getElementById('viewportRes').textContent = details.viewportResolution;
    document.getElementById('colorDepth').textContent = details.colorDepth;
    document.getElementById('deviceMemory').textContent = details.deviceMemory;
    document.getElementById('cpuCores').textContent = details.cpuCores;

    return details;
  }

  async function fetchIPDetails() {
    updateStatus('Fetching IP information...', '');
    try {
      const response = await fetch('https://ipapi.co/json/');
      
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data = await response.json();

      if (data.error) {
        throw new Error(data.reason || 'Failed to retrieve IP details.');
      }

      const ipDetails = {
        ip: data.ip || 'N/A',
        isp: data.org || data.asn || 'N/A',
        location: [data.city, data.region, data.country_name].filter(Boolean).join(', ') || 'N/A',
        timezone: data.timezone || 'N/A'
      };

      document.getElementById('ipAddress').textContent = ipDetails.ip;
      document.getElementById('isp').textContent = ipDetails.isp;
      document.getElementById('location').textContent = ipDetails.location;
      document.getElementById('ipTimezone').textContent = ipDetails.timezone;

      updateStatus('Data loaded successfully', 'success-msg');
      return ipDetails;
    } catch (error) {
      document.getElementById('ipAddress').textContent = 'Unavailable';
      document.getElementById('isp').textContent = 'Unavailable';
      document.getElementById('location').textContent = 'Unavailable';
      document.getElementById('ipTimezone').textContent = 'Unavailable';

      updateStatus(`Error: ${error.message}`, 'error-msg');
      return { error: error.message };
    }
  }

  async function refreshAllData() {
    const clientDetails = collectClientDetails();
    const ipDetails = await fetchIPDetails();

    currentData = {
      network: ipDetails,
      client: clientDetails,
      timestamp: new Date().toISOString()
    };
  }

  refreshBtn.addEventListener('click', refreshAllData);

  copyAllBtn.addEventListener('click', () => {
    if (Object.keys(currentData).length === 0) return;
    navigator.clipboard.writeText(JSON.stringify(currentData, null, 2)).then(() => {
      const origText = copyAllBtn.textContent;
      copyAllBtn.textContent = 'Copied!';
      setTimeout(() => copyAllBtn.textContent = origText, 2000);
    });
  });

  window.addEventListener('resize', () => {
    document.getElementById('viewportRes').textContent = `${window.innerWidth} x ${window.innerHeight}`;
  });

  refreshAllData();
</script>