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

  .editor-textarea {
    background: transparent;
    border: none;
    color: inherit;
    font-family: inherit;
    font-size: inherit;
    line-height: inherit;
    resize: none;
    outline: none;
    padding: 0;
    overflow: hidden;
    height: auto;
  }

  .hex-bytes-input {
    width: 48ch; /* Exact width for 16 hex pairs + spaces */
    white-space: pre-wrap;
    word-break: break-all;
    flex-shrink: 0;
  }

  .hex-ascii-input {
    width: 16ch; /* Fixed 16 characters width */
    white-space: pre;
    word-break: break-all;
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
      <div class="panel-header">Hex & ASCII Editor (16-Byte Wrap)</div>
      <div class="panel-actions">
        <label for="fileInput" class="button-label">Upload File</label>
        <input type="file" id="fileInput" />
        <button id="downloadBtn">Download Binary</button>
        <button id="clearBtn">Clear</button>
      </div>
      <div class="hex-container" id="hexContainer">
        <div class="hex-offsets" id="hexOffsets">00000000</div>
        <textarea id="hexBytesInput" class="editor-textarea hex-bytes-input" placeholder="48 65 6c 6c 6f..." spellcheck="false" rows="1"></textarea>
        <textarea id="hexAsciiInput" class="editor-textarea hex-ascii-input" placeholder="ASCII..." spellcheck="false" rows="1"></textarea>
      </div>
    </div>
  </div>

  <div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const hexBytesInput = document.getElementById('hexBytesInput');
  const hexAsciiInput = document.getElementById('hexAsciiInput');
  const hexOffsets = document.getElementById('hexOffsets');
  const statusBar = document.getElementById('statusBar');
  const downloadBtn = document.getElementById('downloadBtn');
  const clearBtn = document.getElementById('clearBtn');
  const fileInput = document.getElementById('fileInput');

  let currentFileName = 'file.bin';
  let rawBytes = new Uint8Array(0);
  let activeEditor = null;

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  function adjustTextareaHeights() {
    hexBytesInput.style.height = 'auto';
    hexAsciiInput.style.height = 'auto';
    const targetHeight = Math.max(hexBytesInput.scrollHeight, hexAsciiInput.scrollHeight) + 'px';
    hexBytesInput.style.height = targetHeight;
    hexAsciiInput.style.height = targetHeight;
  }

  function parseHex(rawHex) {
    const cleanHex = rawHex.replace(/[^0-9a-fA-F]/g, '');
    const bytes = new Uint8Array(Math.floor(cleanHex.length / 2));
    for (let i = 0; i < bytes.length; i++) {
      bytes[i] = parseInt(cleanHex.substr(i * 2, 2), 16);
    }
    return bytes;
  }

  function renderViews() {
    if (rawBytes.length === 0) {
      hexOffsets.textContent = '00000000';
      if (activeEditor !== 'hex') hexBytesInput.value = '';
      if (activeEditor !== 'ascii') hexAsciiInput.value = '';
      adjustTextareaHeights();
      updateStatus('Ready');
      return;
    }

    const linesCount = Math.ceil(rawBytes.length / 16);
    let offsetsText = '';
    let hexText = '';
    let asciiText = '';

    for (let i = 0; i < linesCount; i++) {
      const offset = (i * 16).toString(16).padStart(8, '0').toUpperCase();
      offsetsText += offset + '\n';

      let lineHex = '';
      let lineAscii = '';
      for (let j = 0; j < 16; j++) {
        const index = i * 16 + j;
        if (index < rawBytes.length) {
          const byte = rawBytes[index];
          lineHex += byte.toString(16).padStart(2, '0').toUpperCase() + ' ';
          lineAscii += (byte >= 32 && byte <= 126) ? String.fromCharCode(byte) : '.';
        }
      }
      hexText += lineHex.trimEnd() + '\n';
      asciiText += lineAscii + '\n';
    }

    hexOffsets.textContent = offsetsText.trimEnd();

    if (activeEditor !== 'hex') {
      hexBytesInput.value = hexText.trimEnd();
    }
    if (activeEditor !== 'ascii') {
      hexAsciiInput.value = asciiText.trimEnd();
    }

    adjustTextareaHeights();
    updateStatus(`Size: ${rawBytes.length} bytes`);
  }

  // Handle Hex Input
  hexBytesInput.addEventListener('focus', () => activeEditor = 'hex');
  hexBytesInput.addEventListener('input', () => {
    activeEditor = 'hex';
    rawBytes = parseHex(hexBytesInput.value);
    renderViews();
  });

  // Handle ASCII Input
  hexAsciiInput.addEventListener('focus', () => activeEditor = 'ascii');
  hexAsciiInput.addEventListener('input', () => {
    activeEditor = 'ascii';
    const lines = hexAsciiInput.value.split('\n');
    let byteList = [];

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const lineLen = Math.min(line.length, 16);
      for (let j = 0; j < lineLen; j++) {
        const globalIndex = i * 16 + j;
        const charCode = line.charCodeAt(j);

        if (globalIndex < rawBytes.length) {
          const originalByte = rawBytes[globalIndex];
          const isNonPrintable = (originalByte < 32 || originalByte > 126);

          if (line[j] === '.' && isNonPrintable) {
            byteList.push(originalByte);
          } else {
            byteList.push(charCode <= 255 ? charCode : 46);
          }
        } else {
          byteList.push(charCode <= 255 ? charCode : 46);
        }
      }
    }

    rawBytes = new Uint8Array(byteList);
    renderViews();
  });

  fileInput.addEventListener('change', (event) => {
    const file = event.target.files[0];
    if (!file) return;

    currentFileName = file.name;
    const reader = new FileReader();
    reader.onload = (e) => {
      rawBytes = new Uint8Array(e.target.result);
      activeEditor = null;
      renderViews();
      updateStatus(`Uploaded "${file.name}" (${rawBytes.length} bytes)`, 'success-msg');
      fileInput.value = '';
    };

    reader.onerror = () => updateStatus('Error reading binary file.', 'error-msg');
    reader.readAsArrayBuffer(file);
  });

  downloadBtn.addEventListener('click', () => {
    if (rawBytes.length === 0) {
      updateStatus('Cannot download empty buffer.', 'error-msg');
      return;
    }

    const blob = new Blob([rawBytes], { type: 'application/octet-stream' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = currentFileName;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    updateStatus(`Downloaded "${currentFileName}" (${rawBytes.length} bytes)`, 'success-msg');
  });

  clearBtn.addEventListener('click', () => {
    rawBytes = new Uint8Array(0);
    hexBytesInput.value = '';
    hexAsciiInput.value = '';
    currentFileName = 'file.bin';
    activeEditor = null;
    renderViews();
  });
</script>