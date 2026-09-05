# Text Editor

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
  }

  button, .button-label {
    border: 1px solid var(--border-color);
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

  /* Hide default file input */
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

  textarea {
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
      <div class="panel-header">Document Editor</div>
      <div class="panel-actions">
        <label for="fileInput" class="button-label">Upload Text</label>
        <input type="file" id="fileInput" accept=".txt,.md,.json,.csv,.log,text/*" />
        <button id="downloadBtn">Download Text</button>
        <button id="clearBtn">Clear</button>
      </div>
      <textarea id="textInput" placeholder="Start typing or upload a text file..."></textarea>
    </div>
  </div>

  <div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const textInput = document.getElementById('textInput');
  const statusBar = document.getElementById('statusBar');
  const downloadBtn = document.getElementById('downloadBtn');
  const clearBtn = document.getElementById('clearBtn');
  const fileInput = document.getElementById('fileInput');

  // Status Bar Helper
  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  // Generate file name based on the beginning of the text
  function generateFilename(text) {
    const trimmed = text.trim();
    if (!trimmed) return 'untitled.txt';

    // Get the first line or first 30 characters
    const firstLine = trimmed.split('\n')[0].slice(0, 30);
    
    // Replace invalid filename characters with underscores
    const sanitized = firstLine
      .replace(/[/\\?%*:|"<>]/g, '')
      .trim()
      .replace(/\s+/g, '_');

    return (sanitized || 'document') + '.txt';
  }

  // Upload Handler
  fileInput.addEventListener('change', (event) => {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e) => {
      textInput.value = e.target.result;
      updateTextMetrics();
      updateStatus(`Uploaded "${file.name}"`, 'success-msg');
      fileInput.value = ''; // Reset input to allow re-uploading the same file
    };
    reader.onerror = () => {
      updateStatus('Error reading file.', 'error-msg');
    };

    reader.readAsText(file);
  });

  // Download Handler
  downloadBtn.addEventListener('click', () => {
    const content = textInput.value;
    if (!content) {
      updateStatus('Cannot download empty text.', 'error-msg');
      return;
    }

    const filename = generateFilename(content);
    const blob = new Blob([content], { type: 'text/plain;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    updateStatus(`Downloaded as "${filename}"`, 'success-msg');
  });

  // Clear Handler
  clearBtn.addEventListener('click', () => {
    textInput.value = '';
    updateStatus('Ready');
  });

  // Helper to update word & char count
  function updateTextMetrics() {
    const charCount = textInput.value.length;
    const wordCount = textInput.value.trim() ? textInput.value.trim().split(/\s+/).length : 0;
    updateStatus(`Words: ${wordCount} | Characters: ${charCount}`);
  }

  // Input Tracking
  textInput.addEventListener('input', updateTextMetrics);
</script>