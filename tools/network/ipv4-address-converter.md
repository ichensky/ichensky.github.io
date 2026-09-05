# IPv4 Address Converter

<style>
    :root {
      --border-color: #3c3c3c;
      --accent-color: #007acc;
      --error-color: #f48771;
    }

    .controls {
      display: flex;
      gap: 12px;
      align-items: center;
    }

    .input-group {
      display: flex;
      gap: 6px;
      align-items: center;
      font-size: 0.85rem;
    }

    input[type="text"] {
      border: 1px solid var(--border-color);
      padding: 6px 12px;
      border-radius: 4px;
      font-size: 0.9rem;
      width: 200px;
    }

    input:focus {
      outline: 1px solid var(--accent-color);
    }

    .main-container {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 10px;
      overflow: hidden;
      min-height: 0;
      margin-top: 10px;
    }

    .panel {
      display: flex;
      flex-direction: column;
      border: 1px solid var(--border-color);
      border-radius: 4px;
      min-height: 0;
    }

    .panel-header {
      padding: 6px 15px;
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 1px;
      border-bottom: 1px solid var(--border-color);
    }

    pre {
      flex: 1;
      margin: 0;
      padding: 15px;
      font-size: 1.1rem;
      font-family: monospace;
      line-height: 1.5;
      overflow: auto;
      white-space: pre-wrap;
      word-wrap: break-word;
    }

    .status-bar {
      padding: 5px 20px;
      font-size: 0.85rem;
      border-top: 1px solid var(--border-color);
      min-height: 20px;
      margin-top: 10px;
    }

    .error-msg { color: var(--error-color); }

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
<div class="controls">
  <div class="input-group">
    <label for="ipInput">IPv4 Address:</label>
    <input type="text" id="ipInput" value="192.168.0.1" placeholder="192.168.0.1" />
  </div>
</div>

<div class="main-container">
  <div class="panel">
    <div class="panel-header">UInt32</div>
    <pre id="uintOutput">-</pre>
  </div>

  <div class="panel">
    <div class="panel-header">Hexadecimal</div>
    <pre id="hexOutput">-</pre>
  </div>

  <div class="panel">
    <div class="panel-header">Binary (Dotted)</div>
    <pre id="binOutput">-</pre>
  </div>

  <div class="panel">
    <div class="panel-header">IN-ADDR.ARPA</div>
    <pre id="arpaOutput">-</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const ipInput = document.getElementById('ipInput');
  const uintOutput = document.getElementById('uintOutput');
  const hexOutput = document.getElementById('hexOutput');
  const binOutput = document.getElementById('binOutput');
  const arpaOutput = document.getElementById('arpaOutput');
  const statusBar = document.getElementById('statusBar');

  function convertIP() {
    const ip = ipInput.value.trim();
    const octets = ip.split('.');

    if (octets.length !== 4) {
      updateStatus('IPv4 address must contain exactly 4 octets separated by dots.', 'error-msg');
      clearOutputs();
      return;
    }

    const numOctets = [];
    for (let i = 0; i < 4; i++) {
      if (octets[i] === '' || isNaN(octets[i])) {
        updateStatus('Octets must be numeric values.', 'error-msg');
        clearOutputs();
        return;
      }
      const num = Number(octets[i]);
      if (!Number.isInteger(num) || num < 0 || num > 255) {
        updateStatus(`Octet ${octets[i]} is out of valid range (0-255).`, 'error-msg');
        clearOutputs();
        return;
      }
      numOctets.push(num);
    }

    // 1. UInt32 (Unsigned 32-bit Integer)
    const uintVal = ((numOctets[0] << 24) >>> 0) + (numOctets[1] << 16) + (numOctets[2] << 8) + numOctets[3];

    // 2. Hexadecimal
    const hexVal = '0x' + uintVal.toString(16).toUpperCase();

    // 3. Binary split with dots
    const binVal = numOctets.map(o => o.toString(2).padStart(8, '0')).join('.');

    // 4. Reverse DNS IN-ADDR.ARPA
    const arpaVal = [...numOctets].reverse().join('.') + '.in-addr.arpa';

    uintOutput.textContent = uintVal.toString();
    hexOutput.textContent = hexVal;
    binOutput.textContent = binVal;
    arpaOutput.textContent = arpaVal;

    updateStatus('Ready');
  }

  function clearOutputs() {
    uintOutput.textContent = '-';
    hexOutput.textContent = '-';
    binOutput.textContent = '-';
    arpaOutput.textContent = '-';
  }

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  ipInput.addEventListener('input', convertIP);
  convertIP();
</script>