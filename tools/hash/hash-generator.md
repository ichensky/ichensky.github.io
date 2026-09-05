# Hash Generator (SHA-1, SHA-256)

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
  <label for="casingSelect">Output Format:</label>
  <select id="casingSelect">
    <option value="lowercase" selected>Lowercase</option>
    <option value="uppercase">Uppercase</option>
  </select>
</div>
<div class="main-container">
  <!-- Input Panel -->
  <div class="panel">
    <div class="panel-header">Input Text</div>
    <div class="panel-actions">
      <button id="clearBtn">Clear</button>
    </div>
    <textarea id="textInput" placeholder="Enter text to hash..."></textarea>
  </div>
  <!-- Output Panel -->
  <div class="panel">
    <div class="panel-header">Calculated Checksums</div>
    <div class="panel-actions">
      <button id="copyBtn">Copy All</button>
    </div>
    <pre id="hashOutput">Hashes will appear here...</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const textInput = document.getElementById('textInput');
  const hashOutput = document.getElementById('hashOutput');
  const casingSelect = document.getElementById('casingSelect');
  const statusBar = document.getElementById('statusBar');
  const copyBtn = document.getElementById('copyBtn');
  const clearBtn = document.getElementById('clearBtn');
  const defaultOutputText = 'Hashes will appear here...';

  // Compute checksums strictly via Native Web Crypto API
  async function computeCryptoDigest(algorithm, bytes) {
    const hashBuffer = await window.crypto.subtle.digest(algorithm, bytes);
    return Array.from(new Uint8Array(hashBuffer))
      .map(b => b.toString(16).padStart(2, '0'))
      .join('');
  }

  // Main Calculation Routine
  async function calculateChecksums() {
    const rawValue = textInput.value;
    
    if (!rawValue) {
      updateStatus('Input is empty.', 'error-msg');
      hashOutput.textContent = defaultOutputText;
      return;
    }

    try {
      const encoder = new TextEncoder();
      const inputBytes = encoder.encode(rawValue);
      const isUppercase = casingSelect.value === 'uppercase';

      const [sha1Result, sha256Result] = await Promise.all([
        computeCryptoDigest('SHA-1', inputBytes),
        computeCryptoDigest('SHA-256', inputBytes)
      ]);

      const format = val => isUppercase ? val.toUpperCase() : val.toLowerCase();

      hashOutput.textContent = 
        `SHA-1:\n${format(sha1Result)}\n\n` +
        `SHA-256:\n${format(sha256Result)}`;

      updateStatus('Checksums calculated using Web Crypto API.', 'success-msg');
    } catch (error) {
      hashOutput.textContent = 'Error calculating checksums...';
      updateStatus('Failed to calculate checksums: ' + error.message, 'error-msg');
    }
  }

  // Status Bar Helper
  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  // Event Listeners
  textInput.addEventListener('input', calculateChecksums);
  casingSelect.addEventListener('change', calculateChecksums);

  // Copy to Clipboard
  copyBtn.addEventListener('click', () => {
    const outputText = hashOutput.textContent;
    if (outputText && outputText !== defaultOutputText && !outputText.startsWith('Error')) {
      navigator.clipboard.writeText(outputText).then(() => {
        const originalText = copyBtn.textContent;
        copyBtn.textContent = 'Copied!';
        setTimeout(() => copyBtn.textContent = originalText, 2000);
      });
    }
  });

  // Clear 
  clearBtn.addEventListener('click', () => {
    textInput.value = '';
    hashOutput.textContent = defaultOutputText;
    updateStatus('Ready');
  });
</script>