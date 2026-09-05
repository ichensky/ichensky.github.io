# File Entropy & Hash Calculator

<style>
    :root {
      --border-color: #3c3c3c;
      --accent-color: #007acc;
      --error-color: #f48771;
      --success-color: #89d4a1;
      --bg-color: #1e1e1e;
      --text-color: #d4d4d4;
      --panel-bg: #252526;
    }

    :root[data-bs-theme='light'] {
      --border-color: #e0e0e0;
      --accent-color: #007acc;
      --error-color: #d93025;
      --success-color: #188038;
      --bg-color: #ffffff;
      --text-color: #202124;
      --panel-bg: #f3f3f3;
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
      padding-bottom: 10px;
    }

    select, button, .button-label {
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

    select {
      background-color: var(--bg-color);
      color: var(--text-color);
      outline: none;
    }

    select:focus, button:focus, .button-label:focus-within {
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
      gap: 1px;
      background-color: var(--border-color);
    }

    .panel {
      flex: 1;
      display: flex;
      flex-direction: column;
      position: relative;
      min-height: 0;
      background-color: var(--bg-color);
      overflow-y: auto;
    }

    .panel-header {
      padding: 8px 15px;
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 1px;
      border-bottom: 1px solid var(--border-color);
      background-color: var(--bg-color);
      position: sticky;
      top: 0;
      z-index: 5;
    }

    .upload-section {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 20px;
      gap: 15px;
    }

    .file-info {
      font-size: 0.9rem;
      color: var(--text-color);
      text-align: left;
      width: 100%;
      max-width: 350px;
      word-break: break-all;
      background-color: var(--panel-bg);
      border: 1px solid var(--border-color);
      border-radius: 4px;
      padding: 12px;
    }

    .output-content {
      padding: 15px;
      display: flex;
      flex-direction: column;
      gap: 20px;
    }

    .metric-group {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .metric-label {
      font-size: 0.85rem;
      font-weight: 600;
      color: var(--text-color);
      opacity: 0.8;
    }

    .metric-value {
      font-family: monospace;
      font-size: 0.95rem;
      word-break: break-all;
      background-color: var(--panel-bg);
      padding: 8px 12px;
      border-radius: 4px;
      border: 1px solid var(--border-color);
    }

    /* Entropy Gauge & Charts */
    .gauge-container {
      width: 100%;
      height: 20px;
      background-color: var(--panel-bg);
      border: 1px solid var(--border-color);
      border-radius: 10px;
      overflow: hidden;
      position: relative;
    }

    .gauge-bar {
      height: 100%;
      width: 0%;
      transition: width 0.4s ease, background-color 0.4s ease;
    }

    .gauge-scale {
      display: flex;
      justify-content: space-between;
      font-size: 0.75rem;
      opacity: 0.7;
      margin-top: 4px;
    }

    canvas {
      width: 100%;
      height: 120px;
      background-color: var(--panel-bg);
      border: 1px solid var(--border-color);
      border-radius: 4px;
    }

    .status-bar {
      padding: 5px 20px;
      font-size: 0.85rem;
      border-top: 1px solid var(--border-color);
      min-height: 20px;
      background-color: var(--bg-color);
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
      background-color: var(--bg-color);
      color: var(--text-color);
    }
</style>

<div class="tool">
<div class="controls">
  <label for="casingSelect">Hash Format:</label>
  <select id="casingSelect">
    <option value="lowercase" selected>Lowercase</option>
    <option value="uppercase">Uppercase</option>
  </select>
</div>
<div class="main-container">
  <!-- Upload Panel -->
  <div class="panel">
    <div class="panel-header">File Selection</div>
    <div class="panel-actions">
      <button id="clearBtn">Clear</button>
    </div>
    <div class="upload-section">
      <label for="fileInput" class="button-label" style="padding: 10px 20px; font-size: 1rem;">Select File</label>
      <input type="file" id="fileInput" />
      <div class="file-info" id="fileDetails" style="display: none;"></div>
    </div>
  </div>

  <!-- Output Panel -->
  <div class="panel">
    <div class="panel-header">Entropy & Hashes</div>
    <div class="panel-actions">
      <button id="copyBtn">Copy Hashes</button>
    </div>
    <div class="output-content">
      <!-- Entropy Meter -->
      <div class="metric-group">
        <div class="metric-label">Shannon Entropy (0.0 to 8.0 bits/byte)</div>
        <div class="metric-value" id="entropyValue">0.0000 bits / byte</div>
        <div class="gauge-container">
          <div class="gauge-bar" id="gaugeBar"></div>
        </div>
        <div class="gauge-scale">
          <span>0 (Low - Plaintext/Structured)</span>
          <span>4</span>
          <span>8 (High - Compressed/Encrypted)</span>
        </div>
      </div>
      <!-- Byte Distribution Chart -->
      <div class="metric-group">
        <div class="metric-label">Byte Frequency Distribution (0-255)</div>
        <canvas id="histogramCanvas"></canvas>
      </div>
      <!-- Checksums -->
      <div class="metric-group">
        <div class="metric-label">SHA-1</div>
        <div class="metric-value" id="sha1Output">-</div>
      </div>
      <div class="metric-group">
        <div class="metric-label">SHA-256</div>
        <div class="metric-value" id="sha256Output">-</div>
      </div>
    </div>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready for file selection.</div>
</div>

<script>
  const fileInput = document.getElementById('fileInput');
  const fileDetails = document.getElementById('fileDetails');
  const casingSelect = document.getElementById('casingSelect');
  const statusBar = document.getElementById('statusBar');
  const copyBtn = document.getElementById('copyBtn');
  const clearBtn = document.getElementById('clearBtn');

  const entropyValue = document.getElementById('entropyValue');
  const gaugeBar = document.getElementById('gaugeBar');
  const sha1Output = document.getElementById('sha1Output');
  const sha256Output = document.getElementById('sha256Output');
  const canvas = document.getElementById('histogramCanvas');
  const ctx = canvas.getContext('2d');

  let activeFileBuffer = null;
  let activeFileName = '';

  // Calculate Shannon Entropy and Byte Frequencies
  function calculateEntropy(bytes) {
    if (bytes.length === 0) return { entropy: 0, frequencies: new Array(256).fill(0) };

    const frequencies = new Array(256).fill(0);
    for (let i = 0; i < bytes.length; i++) {
      frequencies[bytes[i]]++;
    }

    let entropy = 0;
    const len = bytes.length;
    for (let i = 0; i < 256; i++) {
      if (frequencies[i] > 0) {
        const p = frequencies[i] / len;
        entropy -= p * Math.log2(p);
      }
    }

    return { entropy, frequencies };
  }

  // Draw Byte Distribution Histogram
  function drawHistogram(frequencies, totalBytes) {
    const dpr = window.devicePixelRatio || 1;
    const width = canvas.clientWidth;
    const height = canvas.clientHeight;
    
    canvas.width = width * dpr;
    canvas.height = height * dpr;
    ctx.scale(dpr, dpr);

    ctx.clearRect(0, 0, width, height);

    if (!frequencies || totalBytes === 0) return;

    const maxCount = Math.max(...frequencies);
    const barWidth = width / 256;

    const styles = getComputedStyle(document.documentElement);
    const accentColor = styles.getPropertyValue('--accent-color').trim() || '#007acc';

    ctx.fillStyle = accentColor;

    for (let i = 0; i < 256; i++) {
      if (frequencies[i] > 0) {
        const barHeight = (frequencies[i] / maxCount) * (height - 10);
        const x = i * barWidth;
        const y = height - barHeight;
        ctx.fillRect(x, y, Math.max(barWidth, 1), barHeight);
      }
    }
  }

  // Calculate Cryptographic Hashes
  async function computeCryptoDigest(algorithm, bytes) {
    const hashBuffer = await window.crypto.subtle.digest(algorithm, bytes);
    return Array.from(new Uint8Array(hashBuffer))
      .map(b => b.toString(16).padStart(2, '0'))
      .join('');
  }

  // Main Processing Workflow
  async function processFile() {
    if (!activeFileBuffer) return;

    try {
      updateStatus('Calculating entropy and hashes...', '');
      const bytes = new Uint8Array(activeFileBuffer);

      // Entropy Calculation
      const { entropy, frequencies } = calculateEntropy(bytes);
      entropyValue.textContent = `${entropy.toFixed(4)} bits / byte (${((entropy / 8) * 100).toFixed(1)}% randomness)`;

      // Gauge Bar Animation & Dynamic Color
      const percentage = (entropy / 8) * 100;
      gaugeBar.style.width = `${percentage}%`;
      
      if (entropy < 3.5) {
        gaugeBar.style.backgroundColor = '#4caf50';
      } else if (entropy < 6.8) {
        gaugeBar.style.backgroundColor = '#ff9800';
      } else {
        gaugeBar.style.backgroundColor = '#f44336';
      }

      // Draw Graph
      drawHistogram(frequencies, bytes.length);

      // Hashes
      const isUppercase = casingSelect.value === 'uppercase';
      const [sha1Result, sha256Result] = await Promise.all([
        computeCryptoDigest('SHA-1', activeFileBuffer),
        computeCryptoDigest('SHA-256', activeFileBuffer)
      ]);

      const format = val => isUppercase ? val.toUpperCase() : val.toLowerCase();
      sha1Output.textContent = format(sha1Result);
      sha256Output.textContent = format(sha256Result);

      updateStatus(`Processed "${activeFileName}" (${bytes.length.toLocaleString()} bytes).`, 'success-msg');
    } catch (error) {
      updateStatus('Failed to process file: ' + error.message, 'error-msg');
    }
  }

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  fileInput.addEventListener('change', (e) => {
    if (e.target.files.length > 0) handleFileSelect(e.target.files[0]);
  });

  function handleFileSelect(file) {
    activeFileName = file.name;
    fileDetails.style.display = 'block';
    fileDetails.innerHTML = `<strong>Selected File:</strong><br>${file.name}<br><br><strong>Size:</strong> ${file.size.toLocaleString()} bytes`;

    const reader = new FileReader();
    reader.onload = (e) => {
      activeFileBuffer = e.target.result;
      processFile();
    };
    reader.onerror = () => updateStatus('Error reading file.', 'error-msg');
    reader.readAsArrayBuffer(file);
  }

  casingSelect.addEventListener('change', () => {
    if (activeFileBuffer) processFile();
  });

  // Copy Hashes
  copyBtn.addEventListener('click', () => {
    if (!sha1Output.textContent || sha1Output.textContent === '-') return;
    const textToCopy = `File: ${activeFileName}\nEntropy: ${entropyValue.textContent}\nSHA-1: ${sha1Output.textContent}\nSHA-256: ${sha256Output.textContent}`;
    
    navigator.clipboard.writeText(textToCopy).then(() => {
      const originalText = copyBtn.textContent;
      copyBtn.textContent = 'Copied!';
      setTimeout(() => copyBtn.textContent = originalText, 2000);
    });
  });

  // Clear Tool State
  clearBtn.addEventListener('click', (e) => {
    fileInput.value = '';
    activeFileBuffer = null;
    activeFileName = '';
    fileDetails.style.display = 'none';
    fileDetails.innerHTML = '';
    
    entropyValue.textContent = '0.0000 bits / byte';
    gaugeBar.style.width = '0%';
    sha1Output.textContent = '-';
    sha256Output.textContent = '-';
    
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    updateStatus('Ready for file selection.');
  });
</script>