# ⚛ HTML & JavaScript Live Playground

<style>
  :root {
    --border-color: #3c3c3c;
    --accent-color: #007acc;
    --accent-hover: #1177bb;
    --error-color: #f48771;
    --success-color: #89d4a1;
    --bg-color: #1e1e1e;
    --header-bg: #2d2d2d;
    --text-color: #d4d4d4;
    --title-bg: #252526;
    --title-text: #ffffff;
    --preview-bg: #ffffff;
  }

  :root[data-bs-theme='light'] {
    --border-color: #e0e0e0;
    --accent-color: #007acc;
    --accent-hover: #005999;
    --error-color: #d93025;
    --success-color: #188038;
    --bg-color: #ffffff;
    --header-bg: #f3f3f3;
    --text-color: #202124;
    --title-bg: #f8f9fa;
    --title-text: #202124;
    --preview-bg: #ffffff;
  }

  .main-container {
    display: flex;
    flex: 1;
    width: 100%;
    height: calc(100% - 45px);
  }

  .playground-toolbar {
    display: flex;
    justify-content: flex-end;
    gap: 6px;
    padding: 6px 8px;
    background-color: var(--header-bg);
    border-bottom: 1px solid var(--border-color);
  }

  .playground-toolbar.is-expanded {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1051;
  }

  .main-container.is-expanded {
    position: fixed;
    inset: 0;
    width: 100vw;
    height: 100vh;
    background-color: var(--bg-color);
    z-index: 1050;
  }

  .panel {
    flex: 1;
    display: flex;
    flex-direction: column;
    height: 100%;
    min-width: 0;
    border-right: 1px solid var(--border-color);
  }

  .editor-panel {
    flex: 0 0 50%;
  }

  .splitter {
    flex: 0 0 8px;
    background-color: var(--header-bg);
    border-right: 1px solid var(--border-color);
    border-left: 1px solid var(--border-color);
    cursor: col-resize;
    touch-action: none;
  }

  .splitter:hover,
  .splitter.is-dragging {
    background-color: var(--accent-color);
  }

  .panel:last-child {
    border-right: none;
  }

  .panel-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 12px;
    background-color: var(--header-bg);
    border-bottom: 1px solid var(--border-color);
    font-weight: 600;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .btn-group {
    display: flex;
    gap: 6px;
  }

  .btn {
    background-color: var(--accent-color);
    color: #ffffff;
    border: none;
    padding: 4px 10px;
    font-size: 0.75rem;
    border-radius: 3px;
    cursor: pointer;
    transition: background-color 0.2s ease;
  }

  .btn:hover {
    background-color: var(--accent-hover);
  }

  #htmlInput {
    flex: 1;
    width: 100%;
    padding: 12px;
    border: none;
    outline: none;
    resize: none;
    background-color: var(--bg-color);
    color: var(--text-color);
    font-size: 14px;
    line-height: 1.5;
  }

  #previewFrame {
    flex: 1;
    width: 100%;
    height: 100%;
    border: none;
    background-color: var(--preview-bg);
  }

  @media (max-width: 768px) {
    .main-container {
      flex-direction: column;
    }

    .panel {
      border-right: none;
      border-bottom: 1px solid var(--border-color);
    }

    .editor-panel {
      flex-basis: auto;
    }

    .splitter {
      display: none;
    }
  }
</style>

<div class="playground-toolbar">
  <button id="shareBtn" class="btn">Share</button>
  <button id="expandBtn" class="btn" type="button" aria-label="Expand playground" aria-pressed="false">Expand</button>
</div>

<div class="main-container">
  <div class="panel editor-panel">
    <div class="panel-header">
      <span>Source Code (HTML + JS)</span>
      <div class="btn-group">
        <button id="clearBtn" class="btn">Clear</button>
      </div>
    </div>
    <textarea id="htmlInput" placeholder="Enter HTML/JS code here..."></textarea>
  </div>
  <div class="splitter" id="splitter" role="separator" aria-label="Resize editor and preview" aria-orientation="vertical" tabindex="0"></div>
  <div class="panel">
    <div class="panel-header">
      <span>Rendered Preview</span>
    </div>
    <iframe id="previewFrame" sandbox="allow-scripts allow-modals"></iframe>
  </div>
</div>

<script>
  const htmlInput = document.getElementById('htmlInput');
  const previewFrame = document.getElementById('previewFrame');
  const clearBtn = document.getElementById('clearBtn');
  const shareBtn = document.getElementById('shareBtn');
  const expandBtn = document.getElementById('expandBtn');
  const playground = document.querySelector('.main-container');
  const toolbar = document.querySelector('.playground-toolbar');
  const editorPanel = document.querySelector('.editor-panel');
  const splitter = document.getElementById('splitter');

  function updateExpandButton() {
    const isExpanded = playground.classList.contains('is-expanded');
    expandBtn.textContent = isExpanded ? 'Collapse' : 'Expand';
    expandBtn.setAttribute('aria-label', isExpanded ? 'Collapse playground' : 'Expand playground');
    expandBtn.setAttribute('aria-pressed', String(isExpanded));
  }

  expandBtn.addEventListener('click', () => {
    playground.classList.toggle('is-expanded');
    toolbar.classList.toggle('is-expanded', playground.classList.contains('is-expanded'));
    updateExpandButton();
  });

  splitter.addEventListener('pointerdown', event => {
    if (window.matchMedia('(max-width: 768px)').matches) return;
    splitter.setPointerCapture(event.pointerId);
    splitter.classList.add('is-dragging');
  });

  splitter.addEventListener('pointermove', event => {
    if (!splitter.hasPointerCapture(event.pointerId)) return;
    const bounds = playground.getBoundingClientRect();
    const splitterWidth = splitter.getBoundingClientRect().width;
    const availableWidth = bounds.width - splitterWidth;
    const editorWidth = event.clientX - bounds.left;
    const editorPercent = Math.min(80, Math.max(20, (editorWidth / availableWidth) * 100));
    editorPanel.style.flexBasis = `${editorPercent}%`;
  });

  splitter.addEventListener('pointerup', event => {
    if (splitter.hasPointerCapture(event.pointerId)) {
      splitter.releasePointerCapture(event.pointerId);
    }
    splitter.classList.remove('is-dragging');
  });

  splitter.addEventListener('pointercancel', () => {
    splitter.classList.remove('is-dragging');
  });

  function updatePreview() {
    previewFrame.srcdoc = htmlInput.value;
  }

  // Compress & Base64 Encode
  async function compressText(text) {
    const stream = new Blob([text]).stream().pipeThrough(new CompressionStream('gzip'));
    const response = new Response(stream);
    const buffer = await response.arrayBuffer();
    const bytes = new Uint8Array(buffer);
    let binary = '';
    bytes.forEach(b => binary += String.fromCharCode(b));
    return btoa(binary).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
  }

  // Decompress & Base64 Decode
  async function decompressText(base64) {
    let str = base64.replace(/-/g, '+').replace(/_/g, '/');
    while (str.length % 4) str += '=';
    const binary = atob(str);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i++) {
      bytes[i] = binary.charCodeAt(i);
    }
    const stream = new Blob([bytes]).stream().pipeThrough(new DecompressionStream('gzip'));
    const response = new Response(stream);
    return await response.text();
  }

  // Update URL with compressed code and copy link to clipboard
  shareBtn.addEventListener('click', async () => {
    if (!htmlInput.value.trim()) return;
    try {
      const compressed = await compressText(htmlInput.value);
      const shareUrl = `${window.location.origin}${window.location.pathname}#code=${compressed}`;
      window.history.replaceState(null, '', shareUrl);
      
      await navigator.clipboard.writeText(shareUrl);
      const originalText = shareBtn.textContent;
      shareBtn.textContent = 'Copied!';
      setTimeout(() => shareBtn.textContent = originalText, 2000);
    } catch (err) {
      console.error('Failed to share:', err);
    }
  });

  // Load state from URL hash if available
  async function loadFromURL() {
    const hash = window.location.hash;
    if (hash.startsWith('#code=')) {
      try {
        const compressed = hash.replace('#code=', '');
        const decompressed = await decompressText(compressed);
        htmlInput.value = decompressed;
        updatePreview();
      } catch (err) {
        console.error('Failed to decompress URL parameter:', err);
      }
    }
  }

  htmlInput.addEventListener('input', updatePreview);
  
  clearBtn.addEventListener('click', () => {
    htmlInput.value = '';
    window.history.replaceState(null, '', window.location.pathname);
    updatePreview();
  });

  // Initialize
  loadFromURL();
</script>