# Chmod Permissions Calculator

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
      margin-bottom: 10px;
    }

    .table-container {
      overflow-x: auto;
    }

    table.perm-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.9rem;
      text-align: center;
    }

    table.perm-table th, 
    table.perm-table td {
      border: 1px solid var(--border-color);
      padding: 8px;
    }

    table.perm-table th {
      text-transform: uppercase;
      letter-spacing: 0.5px;
      font-size: 0.8rem;
    }

    table.perm-table tr td:first-child {
      text-align: left;
      font-weight: bold;
    }

    input[type="checkbox"] {
      width: 18px;
      height: 18px;
      cursor: pointer;
      accent-color: var(--accent-color);
    }

    .main-container {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
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
  <div class="table-container" style="width: 100%;">
    <table class="perm-table">
      <thead>
        <tr>
          <th>Role</th>
          <th>Read (4)</th>
          <th>Write (2)</th>
          <th>Execute (1)</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Owner (u)</td>
          <td><input type="checkbox" class="perm-cb" data-role="owner" data-val="4" checked></td>
          <td><input type="checkbox" class="perm-cb" data-role="owner" data-val="2" checked></td>
          <td><input type="checkbox" class="perm-cb" data-role="owner" data-val="1" checked></td>
        </tr>
        <tr>
          <td>Group (g)</td>
          <td><input type="checkbox" class="perm-cb" data-role="group" data-val="4" checked></td>
          <td><input type="checkbox" class="perm-cb" data-role="group" data-val="2"></td>
          <td><input type="checkbox" class="perm-cb" data-role="group" data-val="1"></td>
        </tr>
        <tr>
          <td>Other (o)</td>
          <td><input type="checkbox" class="perm-cb" data-role="other" data-val="4" checked></td>
          <td><input type="checkbox" class="perm-cb" data-role="other" data-val="2"></td>
          <td><input type="checkbox" class="perm-cb" data-role="other" data-val="1"></td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<div class="main-container">
  <div class="panel">
    <div class="panel-header">Octal Notation</div>
    <pre id="octalOutput">-</pre>
  </div>

  <div class="panel">
    <div class="panel-header">Symbolic Notation</div>
    <pre id="symbolicOutput">-</pre>
  </div>

  <div class="panel">
    <div class="panel-header">Command</div>
    <pre id="commandOutput">-</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const checkboxes = document.querySelectorAll('.perm-cb');
  const octalOutput = document.getElementById('octalOutput');
  const symbolicOutput = document.getElementById('symbolicOutput');
  const commandOutput = document.getElementById('commandOutput');
  const statusBar = document.getElementById('statusBar');

  function calculateChmod() {
    let roles = {
      owner: 0,
      group: 0,
      other: 0
    };

    let flags = {
      owner: { r: false, w: false, x: false },
      group: { r: false, w: false, x: false },
      other: { r: false, w: false, x: false }
    };

    checkboxes.forEach(cb => {
      const role = cb.dataset.role;
      const val = parseInt(cb.dataset.val, 10);
      if (cb.checked) {
        roles[role] += val;
        if (val === 4){ flags[role].r = true; }
        if (val === 2){ flags[role].w = true; }
        if (val === 1){ flags[role].x = true; }
      }
    });

    // 1. Octal Notation
    const octalVal = `${roles.owner}${roles.group}${roles.other}`;

    // 2. Symbolic Notation (-rwxr-xr--)
    function getSymbolicTriplet(f) {
      return (f.r ? 'r' : '-') + (f.w ? 'w' : '-') + (f.x ? 'x' : '-');
    }
    const symbolicVal = '-' + getSymbolicTriplet(flags.owner) + getSymbolicTriplet(flags.group) + getSymbolicTriplet(flags.other);

    // 3. Command Example
    const commandVal = `chmod ${octalVal} file`;

    octalOutput.textContent = octalVal;
    symbolicOutput.textContent = symbolicVal;
    commandOutput.textContent = commandVal;

    updateStatus('Ready');
  }

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  checkboxes.forEach(cb => cb.addEventListener('change', calculateChmod));
  
  calculateChmod();
</script>