# GUID/UUID Generator

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
      --bg-color: #ffffff;
      --text-color: #202124;
    }

    .controls {
      display: flex;
      gap: 12px;
      align-items: center;
    }

    select, button {
      border: 1px solid transparent;
      background-color: var(--bg-color);
      color: var(--text-color);
      padding: 6px 12px;
      border-radius: 4px;
      font-size: 0.9rem;
      cursor: pointer;
    }

    select option {
      background-color: var(--bg-color);
      color: var(--text-color);
    }

    button.primary-btn {
      background-color: var(--accent-color);
      color: #ffffff;
      font-weight: 500;
    }

    button.primary-btn:hover {
      opacity: 0.9;
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

    .panel-header {
      padding: 6px 15px;
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 1px;
      border-bottom: 1px solid var(--border-color);
    }

    pre {
      flex: 1;
      margin: 0;
      padding: 15px;
      font-size: 1.1rem;
      font-family: monospace;
      line-height: 1.5;
      border: none;
      outline: none;
      overflow: auto;
      box-sizing: border-box;
      min-height: 0;
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
  <label for="formatSelect">Format:</label>
  <select id="formatSelect">
    <option value="D" selected>Hyphenated (d) — 00000000-0000-0000-0000-000000000000</option>
    <option value="N">No Hyphens (n) — 00000000000000000000000000000000</option>
    <option value="B">Braces (b) — {00000000-0000-0000-0000-000000000000}</option>
    <option value="P">Parentheses (p) — (00000000-0000-0000-0000-000000000000)</option>
    <option value="X">Hex Struct (x) — {0x00000000, 0x0000, ...}</option>
    <option value="UPPER">Uppercase — 00000000-0000-0000-0000-000000000000</option>
    <option value="CSHARP">C# Code — Guid.NewGuid()</option>
  </select>

  <button id="generateBtn" class="primary-btn">Generate GUID</button>
</div>
<div class="main-container">
  <!-- Output Panel -->
  <div class="panel">
    <div class="panel-header">Generated GUID / UUID v4</div>
    <div class="panel-actions">
      <button id="copyBtn">Copy</button>
    </div>
    <pre id="guidOutput">Click "Generate GUID" to create a new UUID...</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const guidOutput = document.getElementById('guidOutput');
  const statusBar = document.getElementById('statusBar');
  const copyBtn = document.getElementById('copyBtn');
  const generateBtn = document.getElementById('generateBtn');
  const formatSelect = document.getElementById('formatSelect');
  const defaultText = 'Click "Generate GUID" to create a new UUID...';
  
  let rawGuid = '';

  // Get raw UUID v4 string (hyphenated, lowercase)
  function getRawUUID() {
    if (crypto && typeof crypto.randomUUID === 'function') {
      return crypto.randomUUID();
    }
    return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
      (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (c / 4))).toString(16)
    );
  }

  // Format a raw GUID according to the selected spec
  function formatGuid(guidStr, formatSpec) {
    const clean = guidStr.replace(/-/g, '');
    const parts = [
      clean.substring(0, 8),
      clean.substring(8, 12),
      clean.substring(12, 16),
      clean.substring(16, 20),
      clean.substring(20, 32)
    ];

    switch (formatSpec) {
      case 'N': // 32 digits, no hyphens
        return clean;
      case 'B': // Braces: {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}
        return `{${parts.join('-')}}`;
      case 'P': // Parentheses: (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)
        return `(${parts.join('-')})`;
      case 'X': // Hex struct: {0x00000000,0x0000,0x0000,{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}}
        const p4 = parts[3];
        const p5 = parts[4];
        const lastBytes = [
          p4.substring(0, 2), p4.substring(2, 4),
          p5.substring(0, 2), p5.substring(2, 4), p5.substring(4, 6), p5.substring(6, 8), p5.substring(8, 10), p5.substring(10, 12)
        ].map(b => `0x${b}`).join(', ');
        return `{0x${parts[0]}, 0x${parts[1]}, 0x${parts[2]}, {${lastBytes}}}`;
      case 'UPPER': // Hyphenated, uppercase
        return parts.join('-').toUpperCase();
      case 'CSHARP': // C# Guid code literal
        return `Guid.Parse("${parts.join('-')}")`;
      case 'D': // Standard hyphenated (default)
      default:
        return parts.join('-');
    }
  }

  function generateUUID() {
    rawGuid = getRawUUID();
    renderFormattedGuid();
    updateStatus('New GUID generated successfully.', 'success-msg');
  }

  function renderFormattedGuid() {
    if (!rawGuid) return;
    const formatted = formatGuid(rawGuid, formatSelect.value);
    guidOutput.textContent = formatted;
  }

  // Event Listeners
  generateBtn.addEventListener('click', generateUUID);
  formatSelect.addEventListener('change', () => {
    if (rawGuid) {
      renderFormattedGuid();
      updateStatus('Format updated.', 'success-msg');
    }
  });

  // Copy to Clipboard
  copyBtn.addEventListener('click', () => {
    const outputText = guidOutput.textContent;
    if (outputText && outputText !== defaultText) {
      navigator.clipboard.writeText(outputText).then(() => {
        const originalText = copyBtn.textContent;
        copyBtn.textContent = 'Copied!';
        updateStatus('GUID copied to clipboard.', 'success-msg');
        setTimeout(() => copyBtn.textContent = originalText, 2000);
      });
    }
  });
</script>