# File Diff Checker

<style>
    :root {
      --border-color: #3c3c3c;
      --accent-color: #007acc;
      --error-color: #f48771;
      --success-color: #89d4a1;
      --diff-add-bg: rgba(137, 212, 161, 0.15);
      --diff-add-text: #89d4a1;
      --diff-remove-bg: rgba(244, 135, 113, 0.15);
      --diff-remove-text: #f48771;
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
      gap: 15px;
      align-items: center;
      flex-wrap: wrap;
    }

    .control-group {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 0.85rem;
    }

    select, button, input[type="file"] {
      border: 1px solid var(--border-color);
      background: transparent;
      color: inherit;
      padding: 5px 10px;
      border-radius: 4px;
      font-size: 0.85rem;
      cursor: pointer;
    }

    select:focus, button:focus {
      outline: 1px solid var(--accent-color);
    }

    .main-container {
      display: flex;
      flex-direction: column;
      flex: 1;
      overflow: hidden;
      min-height: 0;
      gap: 10px;
    }

    .inputs-wrapper {
      display: flex;
      flex: 1;
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
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    textarea, .diff-container {
      flex: 1;
      margin: 0;
      padding: 12px;
      font-size: 0.9rem;
      font-family: monospace;
      line-height: 1.5;
      border: none;
      resize: none;
      outline: none;
      overflow: auto;
      box-sizing: border-box;
      min-height: 0;
    }

    .diff-output-panel {
      flex: 1.2;
      display: flex;
      flex-direction: column;
      border-top: 1px solid var(--border-color);
      min-height: 0;
    }

    .diff-line {
      display: flex;
      white-space: pre-wrap;
      word-break: break-all;
    }

    .diff-line-number {
      width: 40px;
      color: #777;
      user-select: none;
      text-align: right;
      padding-right: 10px;
      flex-shrink: 0;
    }

    .diff-line-content {
      flex: 1;
    }

    .line-added {
      background-color: var(--diff-add-bg);
      color: var(--diff-add-text);
    }

    .line-removed {
      background-color: var(--diff-remove-bg);
      color: var(--diff-remove-text);
    }

    .status-bar {
      padding: 5px 20px;
      font-size: 0.85rem;
      border-top: 1px solid var(--border-color);
      min-height: 20px;
    }

    .error-msg { color: var(--error-color); }
    .success-msg { color: var(--success-color); }

    .file-input {
      display: none;
    }

    .file-btn {
      font-size: 0.75rem;
      padding: 2px 6px;
    }

    .tool {
      max-height: 85vh;
      height: stretch;
      display: flex;
      flex-direction: column;
      padding-top: 10px;
      padding-bottom: 10px;
    }
</style>
<div class="tool">
<div class="controls">
  <div class="control-group">
    <input type="checkbox" id="ignoreWhitespace" />
    <label for="ignoreWhitespace">Ignore Whitespace</label>
  </div>
  <div class="control-group">
    <input type="checkbox" id="ignoreCase" />
    <label for="ignoreCase">Ignore Case</label>
  </div>
  <button id="clearAllBtn">Clear Both</button>
</div>
<div class="main-container">
  <!-- Side-by-Side Input Panels -->
  <div class="inputs-wrapper">
    <div class="panel">
      <div class="panel-header">
        <span>Original File / Text (A)</span>
        <button class="file-btn" onclick="document.getElementById('fileA').click()">Upload File</button>
        <input type="file" id="fileA" class="file-input" />
      </div>
      <textarea id="textA" placeholder="Paste original text or upload file..."></textarea>
    </div>
    <div class="panel">
      <div class="panel-header">
        <span>Modified File / Text (B)</span>
        <button class="file-btn" onclick="document.getElementById('fileB').click()">Upload File</button>
        <input type="file" id="fileB" class="file-input" />
      </div>
      <textarea id="textB" placeholder="Paste modified text or upload file..."></textarea>
    </div>
  </div>
  <!-- Differences Output Panel -->
  <div class="diff-output-panel">
    <div class="panel-header">
      <span>Line-by-Line Differences</span>
    </div>
    <div class="diff-container" id="diffContainer">
      <div style="color: #777;">Differences will be highlighted here automatically...</div>
    </div>
  </div>
</div>
<div class="status-bar" id="statusBar">Ready</div>
</div>
<script>
  const textA = document.getElementById('textA');
  const textB = document.getElementById('textB');
  const fileA = document.getElementById('fileA');
  const fileB = document.getElementById('fileB');
  const diffContainer = document.getElementById('diffContainer');
  const ignoreWhitespace = document.getElementById('ignoreWhitespace');
  const ignoreCase = document.getElementById('ignoreCase');
  const statusBar = document.getElementById('statusBar');
  const clearAllBtn = document.getElementById('clearAllBtn');
  // File Upload Handlers
  function handleFileUpload(input, targetTextArea) {
    input.addEventListener('change', (e) => {
      const file = e.target.files[0];
      if (!file) return;
      const reader = new FileReader();
      reader.onload = (evt) => {
        targetTextArea.value = evt.target.result;
        compareTexts();
      };
      reader.readAsText(file);
    });
  }
  handleFileUpload(fileA, textA);
  handleFileUpload(fileB, textB);
  // Line-by-Line LCS (Longest Common Subsequence) Diff Algorithm
  function computeDiff(linesA, linesB) {
    const N = linesA.length;
    const M = linesB.length;
    // DP Table for LCS
    const L = Array.from({ length: N + 1 }, () => new Int32Array(M + 1));
    const norm = (str) => {
      let res = str;
      if (ignoreWhitespace.checked) res = res.trim().replace(/\s+/g, ' ');
      if (ignoreCase.checked) res = res.toUpperCase();
      return res;
    };
    for (let i = N - 1; i >= 0; i--) {
      for (let j = M - 1; j >= 0; j--) {
        if (norm(linesA[i]) === norm(linesB[j])) {
          L[i][j] = L[i + 1][j + 1] + 1;
        } else {
          L[i][j] = Math.max(L[i + 1][j], L[i][j + 1]);
        }
      }
    }
    const result = [];
    let i = 0, j = 0;
    while (i < N && j < M) {
      if (norm(linesA[i]) === norm(linesB[j])) {
        result.push({ type: 'same', val: linesA[i] });
        i++;
        j++;
      } else if (L[i + 1][j] >= L[i][j + 1]) {
        result.push({ type: 'removed', val: linesA[i] });
        i++;
      } else {
        result.push({ type: 'added', val: linesB[j] });
        j++;
      }
    }
    while (i < N) {
      result.push({ type: 'removed', val: linesA[i] });
      i++;
    }
    while (j < M) {
      result.push({ type: 'added', val: linesB[j] });
      j++;
    }
    return result;
  }
  function compareTexts() {
    const valA = textA.value;
    const valB = textB.value;
    if (!valA && !valB) {
      diffContainer.innerHTML = '<div style="color: #777;">Differences will be highlighted here automatically...</div>';
      updateStatus('Ready');
      return;
    }
    const linesA = valA.split(/\r?\n/);
    const linesB = valB.split(/\r?\n/);
    const diff = computeDiff(linesA, linesB);
    diffContainer.innerHTML = '';
    let additions = 0;
    let deletions = 0;
    diff.forEach((item, idx) => {
      const lineDiv = document.createElement('div');
      lineDiv.className = 'diff-line';
      const prefix = item.type === 'added' ? '+ ' : item.type === 'removed' ? '- ' : '  ';
      if (item.type === 'added') {
        lineDiv.classList.add('line-added');
        additions++;
      } else if (item.type === 'removed') {
        lineDiv.classList.add('line-removed');
        deletions++;
      }
      const numSpan = document.createElement('span');
      numSpan.className = 'diff-line-number';
      numSpan.textContent = idx + 1;
      const contentSpan = document.createElement('span');
      contentSpan.className = 'diff-line-content';
      contentSpan.textContent = prefix + item.val;
      lineDiv.appendChild(numSpan);
      lineDiv.appendChild(contentSpan);
      diffContainer.appendChild(lineDiv);
    });
    if (additions === 0 && deletions === 0) {
      updateStatus('Files are identical.', 'success-msg');
    } else {
      updateStatus(`Found differences: +${additions} additions, -${deletions} deletions.`, 'error-msg');
    }
  }
  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }
  // Event Listeners
  textA.addEventListener('input', compareTexts);
  textB.addEventListener('input', compareTexts);
  ignoreWhitespace.addEventListener('change', compareTexts);
  ignoreCase.addEventListener('change', compareTexts);
  clearAllBtn.addEventListener('click', () => {
    textA.value = '';
    textB.value = '';
    fileA.value = '';
    fileB.value = '';
    compareTexts();
  });
</script>