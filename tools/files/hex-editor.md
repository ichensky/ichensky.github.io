# Hex Editor

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
  }

  .controls {
    display: flex;
    gap: 10px;
    align-items: center;
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
  }

  .panel-header {
    padding: 6px 15px;
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    border-bottom: 1px solid var(--border-color);
  }

  .hex-container {
    flex: 1;
    margin: 0;
    padding: 15px;
    font-family: monospace;
    font-size: 0.9rem;
    line-height: 1.5;
    border: none;
    outline: none;
    overflow-y: auto;
    overflow-x: hidden;
    box-sizing: border-box;
    min-height: 0;
    display: flex;
    gap: 20px;
    background-color: var(--bg-color);
    color: var(--text-color);
    align-items: flex-start;
  }

  .hex-offsets {
    color: var(--offset-color);
    user-select: none;
    white-space: pre;
    flex-shrink: 0;
  }

  .hex-bytes-input {
    flex: 1;
    background: transparent;
    border: none;
    color: inherit;
    font-family: inherit;
    font-size: inherit;
    line-height: inherit;
    resize: none;
    outline: none;
    padding: 0;
    white-space: pre-wrap;
    word-break: break-all;
    overflow: hidden;
    height: auto;
  }

  .hex-ascii {
    color: var(--text-color);
    user-select: none;
    white-space: pre;
    flex-shrink: 0;
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
      <div class="panel-header">Hex Editor</div>
      <div class="panel-actions">
        <label for="fileInput" class="button-label">Upload File</label>
        <input type="file" id="fileInput" />
        <button id="downloadBtn">Download Binary</button>
        <button id="clearBtn">Clear</button>
      </div>
      <div class="hex-container" id="hexContainer">
        <div class="hex-offsets" id="hexOffsets">00000000</div>
        <textarea id="hexBytesInput" class="hex-bytes-input" placeholder="Enter hex pairs (e.g. 48 65 6c 6c 6f)..." spellcheck="false" rows="1"></textarea>
        <div class="hex-ascii" id="hexAscii"></div>
      </div>
    </div>
  </div>

  <div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const hexBytesInput = document.getElementById('hexBytesInput');
  const hexOffsets = document.getElementById('hexOffsets');
  const hexAscii = document.getElementById('hexAscii');
  const statusBar = document.getElementById('statusBar');
  const downloadBtn = document.getElementById('downloadBtn');
  const clearBtn = document.getElementById('clearBtn');
  const fileInput = document.getElementById('fileInput');
  const hexContainer = document.getElementById('hexContainer');

  let currentFileName = 'file.bin';

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  function adjustTextareaHeight() {
    hexBytesInput.style.height = 'auto';
    hexBytesInput.style.height = hexBytesInput.scrollHeight + 'px';
  }

  function parseHex(rawHex) {
    const cleanHex = rawHex.replace(/[^0-9a-fA-F]/g, '');
    const bytes = new Uint8Array(Math.floor(cleanHex.length / 2));
    for (let i = 0; i < bytes.length; i++) {
      bytes[i] = parseInt(cleanHex.substr(i * 2, 2), 16);
    }
    return bytes;
  }

  function renderHexView() {
    const bytes = parseHex(hexBytesInput.value);
    
    if (bytes.length === 0) {
      hexOffsets.textContent = '00000000';
      hexAscii.textContent = '';
      adjustTextareaHeight();
      updateStatus('Ready');
      return;
    }

    const linesCount = Math.ceil(bytes.length / 16);
    let offsetsText = '';
    let asciiText = '';

    for (let i = 0; i < linesCount; i++) {
      const offset = (i * 16).toString(16).padStart(8, '0').toUpperCase();
      offsetsText += offset + '\n';

      let lineAscii = '';
      for (let j = 0; j < 16; j++) {
        const index = i * 16 + j;
        if (index < bytes.length) {
          const byte = bytes[index];
          lineAscii += (byte >= 32 && byte <= 126) ? String.fromCharCode(byte) : '.';
        }
      }
      asciiText += lineAscii + '\n';
    }

    hexOffsets.textContent = offsetsText.trimEnd();
    hexAscii.textContent = asciiText.trimEnd();
    adjustTextareaHeight();
    updateStatus(`Size: ${bytes.length} bytes`);
  }

  fileInput.addEventListener('change', (event) => {
    const file = event.target.files[0];
    if (!file) return;

    currentFileName = file.name;
    const reader = new FileReader();
    reader.onload = (e) => {
      const arrayBuffer = e.target.result;
      const bytes = new Uint8Array(arrayBuffer);
      
      let hexString = '';
      for (let i = 0; i < bytes.length; i++) {
        const hex = bytes[i].toString(16).padStart(2, '0').toUpperCase();
        hexString += hex + ' ';
      }

      hexBytesInput.value = hexString.trim();
      renderHexView();
      updateStatus(`Uploaded "${file.name}" (${bytes.length} bytes)`, 'success-msg');
      fileInput.value = '';
    };

    reader.onerror = () => updateStatus('Error reading binary file.', 'error-msg');
    reader.readAsArrayBuffer(file);
  });

  downloadBtn.addEventListener('click', () => {
    const bytes = parseHex(hexBytesInput.value);
    if (bytes.length === 0) {
      updateStatus('Cannot download empty buffer.', 'error-msg');
      return;
    }

    const blob = new Blob([bytes], { type: 'application/octet-stream' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = currentFileName;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    updateStatus(`Downloaded "${currentFileName}" (${bytes.length} bytes)`, 'success-msg');
  });

  clearBtn.addEventListener('click', () => {
    hexBytesInput.value = '';
    currentFileName = 'file.bin';
    renderHexView();
  });

  hexBytesInput.addEventListener('input', renderHexView);
</script>