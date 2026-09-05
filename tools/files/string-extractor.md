# String Extractor

<style>
  :root {
    --border-color: #3c3c3c;
    --accent-color: #007acc;
    --error-color: #f48771;
    --success-color: #89d4a1;
    --bg-color: #1e1e1e;
    --text-color: #d4d4d4;
    --offset-color: #569cd6;
  }

  :root[data-bs-theme='light'] {
--border-color: #e0e0e0;
    --accent-color: #007acc;
    --error-color: #d93025;
    --success-color: #188038;
    --bg-color: #ffffff;
    --text-color: #202124;
    --offset-color: #005fb8;
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
    color: var(--text-color);
  }

  button, .button-label {
    border: 1px solid transparent;
    padding: 6px 12px;
    border-radius: 4px;
    font-size: 0.9rem;
    cursor: pointer;
    background-color: var(--accent-color);
    color: #fff;
    display: inline-block;
    box-sizing: border-box;
  }

  button:focus, .button-label:focus-within {
    outline: 1px solid var(--accent-color);
  }

  #fileInput {
    display: none;
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
    background-color: var(--panel-bg);
  }

  .panel-header {
    padding: 6px 15px;
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    border-bottom: 1px solid var(--border-color);
    color: var(--text-color);
  }

  textarea {
    flex: 1;
    margin: 0;
    padding: 15px;
    font-family: monospace;
    font-size: 0.9rem;
    line-height: 1.5;
    border: none;
    outline: none;
    resize: none;
    overflow: auto;
    box-sizing: border-box;
    min-height: 0;
    background-color: var(--bg-color);
    color: var(--text-color);
  }

  .status-bar {
    padding: 5px 20px;
    font-size: 0.85rem;
    border-top: 1px solid var(--border-color);
    min-height: 20px;
    background-color: var(--panel-bg);
    color: var(--text-color);
  }

  .error-msg { color: var(--error-color); }
  .success-msg { color: var(--success-color); }

  .panel-actions {
    position: absolute;
    top: 5px;
    right: 15px;
    z-index: 10;
    display: flex;
    gap: 8px;
  }
  
  .panel-actions button, .panel-actions .button-label {
    font-size: 0.8rem;
    padding: 4px 8px;
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
  <div class="main-container">
    <div class="panel">
      <div class="panel-header">Extracted Strings</div>
      <div class="panel-actions">
        <label for="fileInput" class="button-label">Upload File</label>
        <input type="file" id="fileInput" />
        <button id="downloadBtn">Download Strings</button>
        <button id="clearBtn">Clear</button>
      </div>
      
      <textarea id="textDisplay" placeholder="Upload a file or type text to view extracted strings..." readonly></textarea>
    </div>
  </div>

  <div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const textDisplay = document.getElementById('textDisplay');
  const statusBar = document.getElementById('statusBar');
  const downloadBtn = document.getElementById('downloadBtn');
  const clearBtn = document.getElementById('clearBtn');
  const fileInput = document.getElementById('fileInput');

  let currentFileName = 'strings.txt';
  let extractedStrings = [];

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  // Extract strings (minimum length of 4 printable ASCII characters)
  function extractStrings(bytes, minLen = 4) {
    const extracted = [];
    let currentStr = '';
    let startOffset = 0;

    for (let i = 0; i < bytes.length; i++) {
      const byte = bytes[i];
      // Printable ASCII (32-126) plus Tab (9)
      if ((byte >= 32 && byte <= 126) || byte === 9) {
        if (currentStr.length === 0) startOffset = i;
        currentStr += String.fromCharCode(byte);
      } else {
        if (currentStr.length >= minLen) {
          const offsetHex = startOffset.toString(16).padStart(8, '0').toUpperCase();
          extracted.push(`${offsetHex}: ${currentStr}`);
        }
        currentStr = '';
      }
    }

    if (currentStr.length >= minLen) {
      const offsetHex = startOffset.toString(16).padStart(8, '0').toUpperCase();
      extracted.push(`${offsetHex}: ${currentStr}`);
    }

    return extracted;
  }

  // File Upload Handler
  fileInput.addEventListener('change', (event) => {
    const file = event.target.files[0];
    if (!file) return;

    currentFileName = file.name.replace(/\.[^/.]+$/, '') + '_strings.txt';
    const reader = new FileReader();
    
    reader.onload = (e) => {
      const bytes = new Uint8Array(e.target.result);
      extractedStrings = extractStrings(bytes);
      
      if (extractedStrings.length > 0) {
        textDisplay.value = extractedStrings.join('\n');
        updateStatus(`Extracted ${extractedStrings.length} string(s) from "${file.name}"`, 'success-msg');
      } else {
        textDisplay.value = 'No printable ASCII strings found (min length: 4).';
        updateStatus(`No strings found in "${file.name}"`, 'error-msg');
      }
      fileInput.value = '';
    };

    reader.onerror = () => updateStatus('Error reading file.', 'error-msg');
    reader.readAsArrayBuffer(file);
  });

  // Download Handler
  downloadBtn.addEventListener('click', () => {
    if (extractedStrings.length === 0 || !textDisplay.value) {
      updateStatus('Nothing to download.', 'error-msg');
      return;
    }

    const content = extractedStrings.join('\n');
    const blob = new Blob([content], { type: 'text/plain;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = currentFileName;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    updateStatus(`Downloaded "${currentFileName}"`, 'success-msg');
  });

  // Clear Handler
  clearBtn.addEventListener('click', () => {
    textDisplay.value = '';
    extractedStrings = [];
    currentFileName = 'strings.txt';
    updateStatus('Ready');
  });
</script>