# Base64 Encoder / Decoder

<style>
    :root {
      --border-color: #3c3c3c;
      --accent-color: #007acc;
      --error-color: #f48771;
      --success-color: #89d4a1;
    }

    header {
      border-bottom: 1px solid var(--border-color);
      padding: 10px 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    h1 {
      margin: 0;
      font-size: 1.2rem;
      font-weight: 500;
    }

    .controls {
      display: flex;
      gap: 10px;
      align-items: center;
    }

    select, button {
      border: 1px solid transparent;
      padding: 6px 12px;
      border-radius: 4px;
      font-size: 0.9rem;
      cursor: pointer;
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

    /* Action buttons inside panels */
    .panel-actions {
      position: absolute;
      top: 35px;
      right: 15px;
      z-index: 10;
    }
    
    .panel-actions button {
      opacity: 0.6;
      font-size: 0.8rem;
      padding: 4px 8px;
    }
    .panel-actions button:hover {
      opacity: 1;
    }
    .tool{
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
    <option value="decode" selected>Decode (Base64 -> Text)</option>
    <option value="encode">Encode (Text -> Base64)</option>
  </select>
  
  <label for="urlSafeCheck" style="font-size: 0.85rem; display: flex; align-items: center; gap: 4px; cursor: pointer;">
    <input type="checkbox" id="urlSafeCheck"> URL-Safe
  </label>
  
  <label for="formatJsonCheck" style="font-size: 0.85rem; display: flex; align-items: center; gap: 4px; cursor: pointer;">
    <input type="checkbox" id="formatJsonCheck" checked> Pretty-print JSON
  </label>
</div>
<div class="main-container">
  <!-- Input Panel -->
  <div class="panel">
    <div class="panel-header" id="inputHeader">Base64 Input</div>
    <div class="panel-actions">
      <button id="clearBtn">Clear</button>
    </div>
    <textarea id="base64Input" placeholder="Paste Base64 encoded string here..."></textarea>
  </div>
  <!-- Output Panel -->
  <div class="panel">
    <div class="panel-header" id="outputHeader">Decoded Text Output</div>
    <div class="panel-actions">
      <button id="copyBtn">Copy</button>
    </div>
    <pre id="base64Output">Result will appear here...</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const base64Input = document.getElementById('base64Input');
  const base64Output = document.getElementById('base64Output');
  const modeSelect = document.getElementById('modeSelect');
  const urlSafeCheck = document.getElementById('urlSafeCheck');
  const formatJsonCheck = document.getElementById('formatJsonCheck');
  const statusBar = document.getElementById('statusBar');
  const copyBtn = document.getElementById('copyBtn');
  const clearBtn = document.getElementById('clearBtn');
  const inputHeader = document.getElementById('inputHeader');
  const outputHeader = document.getElementById('outputHeader');

  const defaultOutputText = 'Result will appear here...';
  const errorText = 'Error processing string...';

  // UTF-8 aware Base64 Decode
  function decodeUtf8Base64(str, isUrlSafe) {
    let cleanStr = str.trim();
    if (isUrlSafe) {
      cleanStr = cleanStr.replace(/-/g, '+').replace(/_/g, '/');
    }
    while (cleanStr.length % 4 !== 0) {
      cleanStr += '=';
    }
    const binaryStr = atob(cleanStr);
    const bytes = Uint8Array.from(binaryStr, char => char.charCodeAt(0));
    return new TextDecoder().decode(bytes);
  }

  // UTF-8 aware Base64 Encode
  function encodeUtf8Base64(str, isUrlSafe) {
    const bytes = new TextEncoder().encode(str);
    let binaryStr = '';
    bytes.forEach(b => binaryStr += String.fromCharCode(b));
    let base64 = btoa(binaryStr);
    if (isUrlSafe) {
      base64 = base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
    }
    return base64;
  }

  // Main Processing Logic
  function processData() {
    const rawValue = base64Input.value.trim();
    const mode = modeSelect.value;
    const isUrlSafe = urlSafeCheck.checked;
    const shouldFormatJson = formatJsonCheck.checked;

    if (!rawValue) {
      updateStatus('Input is empty.', 'error-msg');
      base64Output.textContent = defaultOutputText;
      return;
    }

    try {
      if (mode === 'decode') {
        let decoded = decodeUtf8Base64(rawValue, isUrlSafe);

        if (shouldFormatJson) {
          try {
            const parsedJson = JSON.parse(decoded);
            decoded = JSON.stringify(parsedJson, null, 2);
            updateStatus('Successfully decoded UTF-8 Base64 (Valid JSON formatted).', 'success-msg');
          } catch {
            updateStatus('Successfully decoded UTF-8 Base64.', 'success-msg');
          }
        } else {
          updateStatus('Successfully decoded UTF-8 Base64.', 'success-msg');
        }

        base64Output.textContent = decoded;
      } else {
        const encoded = encodeUtf8Base64(rawValue, isUrlSafe);
        base64Output.textContent = encoded;
        updateStatus('Successfully encoded to UTF-8 Base64.', 'success-msg');
      }
    } catch (error) {
      base64Output.textContent = errorText;
      updateStatus(`Failed to ${mode}: ${error.message}`, 'error-msg');
    }
  }

  // UI State Updates
  function updateUIState() {
    const isDecode = modeSelect.value === 'decode';
    inputHeader.textContent = isDecode ? 'Base64 Input' : 'Raw Text Input';
    outputHeader.textContent = isDecode ? 'Decoded Text Output' : 'Base64 Output';
    base64Input.placeholder = isDecode ? 'Paste Base64 encoded string here...' : 'Enter raw text to encode...';
    formatJsonCheck.disabled = !isDecode;
    processData();
  }

  // Status Bar Helper
  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  // Event Listeners
  base64Input.addEventListener('input', processData);
  modeSelect.addEventListener('change', updateUIState);
  urlSafeCheck.addEventListener('change', processData);
  formatJsonCheck.addEventListener('change', processData);

  // Copy to Clipboard
  copyBtn.addEventListener('click', () => {
    const textToCopy = base64Output.textContent;
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
    base64Input.value = '';
    base64Output.textContent = defaultOutputText;
    updateStatus('Ready');
  });
</script>