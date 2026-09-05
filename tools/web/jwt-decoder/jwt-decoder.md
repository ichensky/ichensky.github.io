# JWT Decoder

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
  <label for="indentSpacing">Tab Size:</label>
  <select id="indentSpacing">
    <option value="2" selected>2 Spaces</option>
    <option value="4">4 Spaces</option>
    <option value="8">8 Spaces</option>
  </select>
</div>
<div class="main-container">
  <!-- Input Panel -->
  <div class="panel">
    <div class="panel-header">JWT Token</div>
    <div class="panel-actions">
      <button id="clearBtn">Clear</button>
    </div>
    <textarea id="jwtInput" placeholder="Paste JWT token here..."></textarea>
  </div>
  <!-- Output Panel -->
  <div class="panel">
    <div class="panel-header">Decoded Output</div>
    <div class="panel-actions">
      <button id="copyBtn">Copy</button>
    </div>
    <pre id="jwtOutput">Decoded JWT will appear here...</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const jwtInput = document.getElementById('jwtInput');
  const jwtOutput = document.getElementById('jwtOutput');
  const indentSpacing = document.getElementById('indentSpacing');
  const statusBar = document.getElementById('statusBar');
  const copyBtn = document.getElementById('copyBtn');
  const clearBtn = document.getElementById('clearBtn');
  const defaultOutputText = 'Decoded JWT will appear here...';
  const errorText = 'Error decoding JWT token...';

  // Base64URL to UTF-8 Decoder
  function base64UrlDecode(str) {
    let base64 = str.replace(/-/g, '+').replace(/_/g, '/');
    while (base64.length % 4) {
      base64 += '=';
    }
    const decoded = atob(base64);
    return decodeURIComponent(
      Array.from(decoded)
        .map(c => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
        .join('')
    );
  }

  // Main JWT Decoding Logic
  function processJWT() {
    const rawValue = jwtInput.value.trim();
    
    if (!rawValue) {
      updateStatus('Input is empty.', 'error-msg');
      jwtOutput.textContent = defaultOutputText;
      return;
    }

    const parts = rawValue.split('.');
    if (parts.length < 2 || parts.length > 3) {
      jwtOutput.textContent = errorText;
      updateStatus('Invalid JWT structure. A JWT must contain 2 or 3 dot-separated segments.', 'error-msg');
      return;
    }

    try {
      const spaces = parseInt(indentSpacing.value, 10);
      
      const headerObj = JSON.parse(base64UrlDecode(parts[0]));
      const payloadObj = JSON.parse(base64UrlDecode(parts[1]));

      const decodedResult = {
        HEADER: headerObj,
        PAYLOAD: payloadObj,
        SIGNATURE: parts[2] || '[No Signature]'
      };

      jwtOutput.textContent = JSON.stringify(decodedResult, null, spaces);

      // Check Expiration
      if (payloadObj.exp) {
        const expDate = new Date(payloadObj.exp * 1000);
        const isExpired = Date.now() >= expDate.getTime();
        const statusText = `Valid JWT format. ${isExpired ? 'Expired on: ' : 'Expires: '}${expDate.toLocaleString()}`;
        updateStatus(statusText, isExpired ? 'error-msg' : 'success-msg');
      } else {
        updateStatus('Valid JWT format (No exp claim present).', 'success-msg');
      }

    } catch (error) {
      jwtOutput.textContent = errorText;
      updateStatus('Failed to decode token: ' + error.message, 'error-msg');
    }
  }

  // Status Bar Helper
  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  // Event Listeners
  jwtInput.addEventListener('input', processJWT);
  indentSpacing.addEventListener('change', processJWT);

  // Copy to Clipboard
  copyBtn.addEventListener('click', () => {
    const outputText = jwtOutput.textContent;
    if (outputText && outputText !== defaultOutputText && outputText !== errorText) {
      navigator.clipboard.writeText(outputText).then(() => {
        const originalText = copyBtn.textContent;
        copyBtn.textContent = 'Copied!';
        setTimeout(() => copyBtn.textContent = originalText, 2000);
      });
    }
  });

  // Clear 
  clearBtn.addEventListener('click', () => {
    jwtInput.value = '';
    jwtOutput.textContent = defaultOutputText;
    updateStatus('Ready');
  });
</script>