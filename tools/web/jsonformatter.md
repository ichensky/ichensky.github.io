# Json formatter

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
    <div class="panel-header">Raw Input</div>
    <div class="panel-actions">
      <button id="clearBtn">Clear</button>
    </div>
    <textarea id="jsonInput" placeholder="Paste JSON here..."></textarea>
  </div>
  <!-- Output Panel -->
  <div class="panel">
    <div class="panel-header">Formatted Output</div>
    <div class="panel-actions">
      <button id="copyBtn">Copy</button>
    </div>
    <pre id="jsonOutput">Formatted JSON...</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const jsonInput = document.getElementById('jsonInput');
  const jsonOutput = document.getElementById('jsonOutput');
  const indentSpacing = document.getElementById('indentSpacing');
  const statusBar = document.getElementById('statusBar');
  const copyBtn = document.getElementById('copyBtn');
  const clearBtn = document.getElementById('clearBtn');
  const outputText = 'Formatted JSON...';
  const errorText = 'Error parsing JSON...';

  // Main Formatting Logic
  function processJSON() {
    const rawValue = jsonInput.value.trim();
    
    if (!rawValue) {
      updateStatus('Input is empty.', 'error-msg');
      jsonOutput.textContent = outputText;
      return;
    }

    try {
      // Parse the raw text to verify valid JSON
      const parsed = JSON.parse(rawValue);
      
      // Grab selected space/tab depth
      const spaces = parseInt(indentSpacing.value, 10);
      
      // Stringify back into a pretty string
      const formatted = JSON.stringify(parsed, null, spaces);
      
      // Render to preview panel
      jsonOutput.textContent = formatted;
      updateStatus('Valid JSON. Formatted successfully!', 'success-msg');
    } catch (error) {
      // Handle parsing errors gracefully
      jsonOutput.textContent = errorText;
      updateStatus(error.message, 'error-msg');
    }
  }

  // Status Bar Helper
  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  // Event Listeners
  jsonInput.addEventListener('input', processJSON);
  indentSpacing.addEventListener('change', processJSON);

  // Copy to Clipboard
  copyBtn.addEventListener('click', () => {
    const outputText = jsonOutput.textContent;
    if (outputText && outputText !== outputText && outputText !== errorText) {
      navigator.clipboard.writeText(outputText).then(() => {
        const originalText = copyBtn.textContent;
        copyBtn.textContent = 'Copied!';
        setTimeout(() => copyBtn.textContent = originalText, 2000);
      });
    }
  });

  // Clear 
  clearBtn.addEventListener('click', () => {
    jsonInput.value = '';
    jsonOutput.textContent = outputText;
    updateStatus('Ready');
  });
</script>