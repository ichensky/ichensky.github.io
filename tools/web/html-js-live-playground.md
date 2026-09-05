# HTML & JavaScript Live Playground

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

    .panel {
      flex: 1;
      display: flex;
      flex-direction: column;
      height: 100%;
      min-width: 0;
      border-right: 1px solid var(--border-color);
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

    #clearBtn {
      background-color: var(--accent-color);
      color: #ffffff;
      border: none;
      padding: 4px 10px;
      font-size: 0.75rem;
      border-radius: 3px;
      cursor: pointer;
      transition: background-color 0.2s ease;
    }

    #clearBtn:hover {
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
    }
  </style>
  <div class="main-container">
    <div class="panel">
      <div class="panel-header">
        <span>Source Code (HTML + JS)</span>
        <button id="clearBtn">Clear</button>
      </div>
      <textarea id="htmlInput" placeholder="Enter HTML/JS code here..."></textarea>
    </div>
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
    const root = document.documentElement;
    function updatePreview() {
      previewFrame.srcdoc = htmlInput.value;
    }
    htmlInput.addEventListener('input', updatePreview);
    clearBtn.addEventListener('click', () => {
      htmlInput.value = '';
      updatePreview();
    });
  </script>