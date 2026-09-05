# Password Generator

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
      flex-wrap: wrap;
    }

    .checkbox-group {
      display: flex;
      gap: 10px;
      align-items: center;
      font-size: 0.85rem;
    }

    .checkbox-group label {
      display: flex;
      align-items: center;
      gap: 4px;
      cursor: pointer;
    }

    input[type="number"], select, button {
      border: 1px solid transparent;
      background-color: var(--bs-body-bg, #1e1e1e);
      color: var(--bs-body-color, #d4d4d4);
      padding: 6px 12px;
      border-radius: 4px;
      font-size: 0.9rem;
      cursor: pointer;
    }

    select option {
      background-color: var(--bs-body-bg, #1e1e1e);
      color: var(--bs-body-color, #d4d4d4);
    }

    input[type="number"] {
      border: 1px solid var(--border-color);
      width: 100px;
    }

    button.primary-btn {
      background-color: var(--accent-color);
      color: #ffffff;
      font-weight: 500;
    }

    button.primary-btn:hover {
      opacity: 0.9;
    }

    input:focus, select:focus, button:focus {
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
  <label for="lengthInput">Length:</label>
  <input type="number" id="lengthInput" value="16" min="4" max="128" />

  <div class="checkbox-group">
    <label><input type="checkbox" id="incUpper" checked /> ABC</label>
    <label><input type="checkbox" id="incLower" checked /> abc</label>
    <label><input type="checkbox" id="incNumbers" checked /> 123</label>
    <label><input type="checkbox" id="incSymbols" checked /> !@#</label>
  </div>

  <button id="generateBtn" class="primary-btn">Generate Password</button>
</div>

<div class="main-container">
  <div class="panel">
    <div class="panel-header">Generated Password</div>
    <div class="panel-actions">
      <button id="copyBtn">Copy</button>
    </div>
    <pre id="passwordOutput">Click "Generate Password" to create a password...</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const passwordOutput = document.getElementById('passwordOutput');
  const statusBar = document.getElementById('statusBar');
  const copyBtn = document.getElementById('copyBtn');
  const generateBtn = document.getElementById('generateBtn');
  const lengthInput = document.getElementById('lengthInput');
  const incUpper = document.getElementById('incUpper');
  const incLower = document.getElementById('incLower');
  const incNumbers = document.getElementById('incNumbers');
  const incSymbols = document.getElementById('incSymbols');

  const defaultText = 'Click "Generate Password" to create a password...';

  const CHAR_SETS = {
    upper: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    lower: 'abcdefghijklmnopqrstuvwxyz',
    numbers: '0123456789',
    symbols: '!@#$%^&*()_+-=[]{}|;:,.<>?'
  };

  function generatePassword() {
    const length = parseInt(lengthInput.value, 10);
    
    if (isNaN(length) || length < 4 || length > 128) {
      updateStatus('Length must be between 4 and 128.', 'error-msg');
      return;
    }

    let validSets = [];
    if (incUpper.checked) validSets.push(CHAR_SETS.upper);
    if (incLower.checked) validSets.push(CHAR_SETS.lower);
    if (incNumbers.checked) validSets.push(CHAR_SETS.numbers);
    if (incSymbols.checked) validSets.push(CHAR_SETS.symbols);

    if (validSets.length === 0) {
      updateStatus('Select at least one character type.', 'error-msg');
      return;
    }

    const fullCharPool = validSets.join('');
    let passwordChars = [];

    // Guarantee at least one character from each selected category
    validSets.forEach(set => {
      const randomByte = new Uint32Array(1);
      crypto.getRandomValues(randomByte);
      passwordChars.push(set[randomByte[0] % set.length]);
    });

    // Fill the remaining length from the full combined pool
    const remainingCount = length - passwordChars.length;
    const randomBytes = new Uint32Array(remainingCount);
    crypto.getRandomValues(randomBytes);

    for (let i = 0; i < remainingCount; i++) {
      passwordChars.push(fullCharPool[randomBytes[i] % fullCharPool.length]);
    }

    // Cryptographically shuffle the resulting array
    const shuffleBytes = new Uint32Array(passwordChars.length);
    crypto.getRandomValues(shuffleBytes);
    for (let i = passwordChars.length - 1; i > 0; i--) {
      const j = shuffleBytes[i] % (i + 1);
      [passwordChars[i], passwordChars[j]] = [passwordChars[j], passwordChars[i]];
    }

    passwordOutput.textContent = passwordChars.join('');
    updateStatus('Password generated successfully.', 'success-msg');
  }

  // Status Bar Helper
  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  // Event Listeners
  generateBtn.addEventListener('click', generatePassword);

  // Copy to Clipboard
  copyBtn.addEventListener('click', () => {
    const outputText = passwordOutput.textContent;
    if (outputText && outputText !== defaultText) {
      navigator.clipboard.writeText(outputText).then(() => {
        const originalText = copyBtn.textContent;
        copyBtn.textContent = 'Copied!';
        updateStatus('Password copied to clipboard.', 'success-msg');
        setTimeout(() => copyBtn.textContent = originalText, 2000);
      });
    }
  });
</script>