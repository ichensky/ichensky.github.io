# Text Editor

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

  button {
    border: 1px solid transparent;
    padding: 6px 12px;
    border-radius: 4px;
    font-size: 0.9rem;
    cursor: pointer;
    background-color: var(--accent-color);
    color: #fff;
  }

  button:focus {
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
  
  .panel-actions button {
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
        <button id="downloadBtn">Download Text</button>
        <button id="clearBtn">Clear</button>
      </div>
      <textarea id="textInput" placeholder="Start typing your text here..."></textarea>
    </div>
  </div>

  <div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const textInput = document.getElementById('textInput');
  const statusBar = document.getElementById('statusBar');
  const downloadBtn = document.getElementById('downloadBtn');
  const clearBtn = document.getElementById('clearBtn');

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

  // Input Tracking
  textInput.addEventListener('input', () => {
    const charCount = textInput.value.length;
    const wordCount = textInput.value.trim() ? textInput.value.trim().split(/\s+/).length : 0;
    updateStatus(`Words: ${wordCount} | Characters: ${charCount}`);
  });
</script>