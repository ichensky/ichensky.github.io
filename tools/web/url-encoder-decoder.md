# URL Encoder / Decoder & Query Parser

<style>
    :root {
      --border-color: #3c3c3c;
      --accent-color: #007acc;
      --error-color: #f48771;
      --success-color: #89d4a1;
      --bg-color: #1e1e1e;
      --text-color: #d4d4d4;
    }

    :root[data-bs-theme='light'] {
      --border-color: #e0e0e0;
      --accent-color: #007acc;
      --error-color: #d93025;
      --success-color: #188038;
      --bg-color: #ffffff;
      --text-color: #202124;
    }

    .controls {
      display: flex;
      gap: 10px;
      align-items: center;
      flex-wrap: wrap;
    }

    select, button {
      border: 1px solid var(--border-color);
      background-color: var(--bg-color);
      color: var(--text-color);
      padding: 6px 12px;
      border-radius: 4px;
      font-size: 0.9rem;
      cursor: pointer;
    }

    /* Dark theme drop-down item styling */
    select option {
      background-color: var(--bg-color);
      color: var(--text-color);
    }

    button {
      background-color: var(--accent-color);
      color: #fff;
      border: 1px solid transparent;
    }

    select:focus, button:focus {
      outline: 1px solid var(--accent-color);
    }

    .main-container {
      display: flex;
      flex: 1;
      overflow: hidden;
      min-height: 0;
    }

    .panel {
      flex: 1;
      display: flex;
      flex-direction: column;
      position: relative;
      min-height: 0;
    }

    .panel:first-child {
      border-right: 1px solid var(--border-color);
    }

    .panel-header {
      padding: 6px 15px;
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 1px;
      border-bottom: 1px solid var(--border-color);
    }

    textarea, pre {
      flex: 1;
      margin: 0;
      padding: 15px;
      font-size: 0.95rem;
      line-height: 1.5;
      border: none;
      resize: none;
      outline: none;
      overflow: auto;
      box-sizing: border-box;
      min-height: 0;
      background-color: var(--bg-color);
      color: var(--text-color);
    }

    pre {
      white-space: pre-wrap;
      word-wrap: break-word;
    }

    .status-bar {
      padding: 5px 20px;
      font-size: 0.85rem;
      border-top: 1px solid var(--border-color);
      min-height: 20px;
    }

    .error-msg { color: var(--error-color); }
    .success-msg { color: var(--success-color); }

    .panel-actions {
      position: absolute;
      top: 35px;
      right: 15px;
      z-index: 10;
    }
    
    .panel-actions button {
      opacity: 0.8;
      font-size: 0.8rem;
      padding: 4px 8px;
    }
    .panel-actions button:hover {
      opacity: 1;
    }
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
  <label for="modeSelect">Mode:</label>
  <select id="modeSelect">
    <option value="decode" selected>Decode URL / Component</option>
    <option value="encode">Encode URL / Component</option>
    <option value="parse">Parse Query Parameters</option>
  </select>
  
  <label for="componentCheck" id="componentCheckLabel" style="font-size: 0.85rem; display: flex; align-items: center; gap: 4px; cursor: pointer;">
    <input type="checkbox" id="componentCheck" checked> Strict Component Encoding (encodeURIComponent)
  </label>
  
  <label for="formatJsonCheck" id="formatJsonCheckLabel" style="font-size: 0.85rem; display: flex; align-items: center; gap: 4px; cursor: pointer;">
    <input type="checkbox" id="formatJsonCheck" checked> Format as JSON
  </label>
</div>

<div class="main-container">
  <!-- Input Panel -->
  <div class="panel">
    <div class="panel-header" id="inputHeader">URL Input</div>
    <div class="panel-actions">
      <button id="clearBtn">Clear</button>
    </div>
    <textarea id="urlInput" placeholder="Paste URL or string here..."></textarea>
  </div>
  <!-- Output Panel -->
  <div class="panel">
    <div class="panel-header" id="outputHeader">Output</div>
    <div class="panel-actions">
      <button id="copyBtn">Copy</button>
    </div>
    <pre id="urlOutput">Result will appear here...</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const urlInput = document.getElementById('urlInput');
  const urlOutput = document.getElementById('urlOutput');
  const modeSelect = document.getElementById('modeSelect');
  const componentCheck = document.getElementById('componentCheck');
  const componentCheckLabel = document.getElementById('componentCheckLabel');
  const formatJsonCheck = document.getElementById('formatJsonCheck');
  const formatJsonCheckLabel = document.getElementById('formatJsonCheckLabel');
  const statusBar = document.getElementById('statusBar');
  const copyBtn = document.getElementById('copyBtn');
  const clearBtn = document.getElementById('clearBtn');
  const inputHeader = document.getElementById('inputHeader');
  const outputHeader = document.getElementById('outputHeader');

  const defaultOutputText = 'Result will appear here...';
  const errorText = 'Error processing string...';

  // Extract query parameters from full URL or standalone query string
  function parseQueryParams(str, asJson) {
    let queryString = str.trim();
    
    // Extract query string part if a full URL is passed
    if (queryString.includes('?')) {
      queryString = queryString.split('?')[1];
    }
    // Remove hash fragment if present
    if (queryString.includes('#')) {
      queryString = queryString.split('#')[0];
    }

    const params = new URLSearchParams(queryString);
    const resultObj = {};
    let count = 0;

    for (const [key, value] of params.entries()) {
      count++;
      if (resultObj.hasOwnProperty(key)) {
        if (Array.isArray(resultObj[key])) {
          resultObj[key].push(value);
        } else {
          resultObj[key] = [resultObj[key], value];
        }
      } else {
        resultObj[key] = value;
      }
    }

    if (count === 0) {
      throw new Error('No query parameters found.');
    }

    if (asJson) {
      return JSON.stringify(resultObj, null, 2);
    } else {
      return Object.entries(resultObj)
        .map(([k, v]) => `${k}: ${Array.isArray(v) ? JSON.stringify(v) : v}`)
        .join('\n');
    }
  }

  // Main Logic
  function processData() {
    const rawValue = urlInput.value.trim();
    const mode = modeSelect.value;
    const isStrictComponent = componentCheck.checked;
    const shouldFormatJson = formatJsonCheck.checked;

    if (!rawValue) {
      updateStatus('Input is empty.', 'error-msg');
      urlOutput.textContent = defaultOutputText;
      return;
    }

    try {
      if (mode === 'decode') {
        let decoded = decodeURIComponent(rawValue.replace(/\+/g, ' '));
        
        if (shouldFormatJson) {
          try {
            const parsedJson = JSON.parse(decoded);
            decoded = JSON.stringify(parsedJson, null, 2);
            updateStatus('Successfully decoded URL (Valid JSON formatted).', 'success-msg');
          } catch {
            updateStatus('Successfully decoded URL component.', 'success-msg');
          }
        } else {
          updateStatus('Successfully decoded URL component.', 'success-msg');
        }

        urlOutput.textContent = decoded;
      } else if (mode === 'encode') {
        const encoded = isStrictComponent ? encodeURIComponent(rawValue) : encodeURI(rawValue);
        urlOutput.textContent = encoded;
        updateStatus(`Successfully encoded URL using ${isStrictComponent ? 'encodeURIComponent' : 'encodeURI'}.`, 'success-msg');
      } else if (mode === 'parse') {
        const parsed = parseQueryParams(rawValue, shouldFormatJson);
        urlOutput.textContent = parsed;
        updateStatus('Successfully extracted query parameters.', 'success-msg');
      }
    } catch (error) {
      urlOutput.textContent = errorText;
      updateStatus(`Failed to ${mode}: ${error.message}`, 'error-msg');
    }
  }

  // Dynamic UI updates based on mode
  function updateUIState() {
    const mode = modeSelect.value;

    if (mode === 'decode') {
      inputHeader.textContent = 'Encoded Input';
      outputHeader.textContent = 'Decoded Output';
      urlInput.placeholder = 'Paste URL or encoded component here...';
      componentCheckLabel.style.display = 'none';
      formatJsonCheckLabel.style.display = 'flex';
      formatJsonCheckLabel.querySelector('span')?.remove();
    } else if (mode === 'encode') {
      inputHeader.textContent = 'Raw Text / URL Input';
      outputHeader.textContent = 'Encoded URL Output';
      urlInput.placeholder = 'Enter plain string or URL to encode...';
      componentCheckLabel.style.display = 'flex';
      formatJsonCheckLabel.style.display = 'none';
    } else if (mode === 'parse') {
      inputHeader.textContent = 'URL / Query String Input';
      outputHeader.textContent = 'Extracted Parameters';
      urlInput.placeholder = 'Paste URL (e.g., https://example.com?param1=val1&param2=val2) or query string...';
      componentCheckLabel.style.display = 'none';
      formatJsonCheckLabel.style.display = 'flex';
    }
    
    processData();
  }

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  // Event Listeners
  urlInput.addEventListener('input', processData);
  modeSelect.addEventListener('change', updateUIState);
  componentCheck.addEventListener('change', processData);
  formatJsonCheck.addEventListener('change', processData);

  // Copy to Clipboard
  copyBtn.addEventListener('click', () => {
    const textToCopy = urlOutput.textContent;
    if (textToCopy && textToCopy !== defaultOutputText && textToCopy !== errorText) {
      navigator.clipboard.writeText(textToCopy).then(() => {
        const originalText = copyBtn.textContent;
        copyBtn.textContent = 'Copied!';
        setTimeout(() => copyBtn.textContent = originalText, 2000);
      });
    }
  });

  // Clear 
  clearBtn.addEventListener('click', () => {
    urlInput.value = '';
    urlOutput.textContent = defaultOutputText;
    updateStatus('Ready');
  });

  // Initialize UI state
  updateUIState();
</script>