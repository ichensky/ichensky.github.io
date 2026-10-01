# 🔑 Extended Chmod Permissions Calculator (4-Bit)

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

    table.perm-table td:not(:first-child) {
      vertical-align: middle;
    }

    table.perm-table input[type="checkbox"] {
      display: block;
      width: 18px;
      height: 18px;
      margin: 0 auto;
      cursor: pointer;
      accent-color: var(--accent-color);
    }

    table.perm-table label {
      display: block;
      margin-top: 5px;
      line-height: 1.25;
      cursor: pointer;
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

    .panel pre {
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
          <th>Category / Role</th>
          <th>Read (4) / SUID (4)</th>
          <th>Write (2) / SGID (2)</th>
          <th>Execute (1) / Sticky (1)</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Special Bits</td>
          <td><input type="checkbox" class="perm-cb" data-role="special" data-val="4" id="suid"> <label for="suid">SUID (setuid)</label></td>
          <td><input type="checkbox" class="perm-cb" data-role="special" data-val="2" id="sgid"> <label for="sgid">SGID (setgid)</label></td>
          <td><input type="checkbox" class="perm-cb" data-role="special" data-val="1" id="sticky"> <label for="sticky">Sticky Bit</label></td>
        </tr>
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
    <pre id="octalOutput">0744</pre>
  </div>

  <div class="panel">
    <div class="panel-header">Symbolic Notation</div>
    <pre id="symbolicOutput">-rwxr--r--</pre>
  </div>

  <div class="panel">
    <div class="panel-header">Command</div>
    <pre id="commandOutput">chmod 0744 file</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>


### Special Permissions

**4  SUID (Set User ID)**

Executes the file with the permissions of the file owner, rather than the user who ran it. (Commonly used for programs like passwd so regular users can temporarily act as root to change their password).

**2 SGID (Set Group ID)**

• On a file: Runs the file with the privileges of the file's group.

• On a directory: Forces any new file created inside to inherit the directory's group, rather than the creator's group (great for shared team folders).

**1 Sticky Bit**

Primarily used on directories. Restricts file deletion so that only the file's owner (or root) can delete or rename a file inside that directory, even if other users have write access. (Commonly used on the public /tmp folder).


<script>
  const checkboxes = document.querySelectorAll('.perm-cb');
  const octalOutput = document.getElementById('octalOutput');
  const symbolicOutput = document.getElementById('symbolicOutput');
  const commandOutput = document.getElementById('commandOutput');
  const statusBar = document.getElementById('statusBar');

  function calculateChmod() {
    let roles = {
      special: 0,
      owner: 0,
      group: 0,
      other: 0
    };

    let flags = {
      special: { suid: false, sgid: false, sticky: false },
      owner: { r: false, w: false, x: false },
      group: { r: false, w: false, x: false },
      other: { r: false, w: false, x: false }
    };

    checkboxes.forEach(cb => {
      const role = cb.dataset.role;
      const val = parseInt(cb.dataset.val, 10);
      if (cb.checked) {
        roles[role] += val;
        if (role === 'special') {
          if (val === 4) flags.special.suid = true;
          if (val === 2) flags.special.sgid = true;
          if (val === 1) flags.special.sticky = true;
        } else {
          if (val === 4) flags[role].r = true;
          if (val === 2) flags[role].w = true;
          if (val === 1) flags[role].x = true;
        }
      }
    });

    // 1. Octal Notation (4 Digits)
    const octalVal = `${roles.special}${roles.owner}${roles.group}${roles.other}`;

    // 2. Symbolic Notation (-rwsr-sr-t)
    function getOwnerExecSymbol(x, suid) {
      if (suid) return x ? 's' : 'S';
      return x ? 'x' : '-';
    }

    function getGroupExecSymbol(x, sgid) {
      if (sgid) return x ? 's' : 'S';
      return x ? 'x' : '-';
    }

    function getOtherExecSymbol(x, sticky) {
      if (sticky) return x ? 't' : 'T';
      return x ? 'x' : '-';
    }

    const uSymbolic = (flags.owner.r ? 'r' : '-') + (flags.owner.w ? 'w' : '-') + getOwnerExecSymbol(flags.owner.x, flags.special.suid);
    const gSymbolic = (flags.group.r ? 'r' : '-') + (flags.group.w ? 'w' : '-') + getGroupExecSymbol(flags.group.x, flags.special.sgid);
    const oSymbolic = (flags.other.r ? 'r' : '-') + (flags.other.w ? 'w' : '-') + getOtherExecSymbol(flags.other.x, flags.special.sticky);

    const symbolicVal = '-' + uSymbolic + gSymbolic + oSymbolic;

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