# Permutation vs Combination

**Permutations vs. Combinations**

* **Permutation (Order Matters):** Picking and arranging items where position counts.
* *Example:* From {A, B, C}, choosing 2 gives **6** arrangements: AB, BA, AC, CA, BC, CB.
* *Formula:* $P(n, r) = \frac{n!}{(n - r)!}$


* **Combination (Order Doesn't Matter):** Choosing a group where position does not count.
* *Example:* From {A, B, C}, choosing 2 gives **3** groups: AB, AC, BC.
* *Formula:* $C(n, r) = \frac{n!}{r!(n - r)!}$



---

> **Quick Memory Trick:**
> * **Lock combination** $\rightarrow$ Order matters (it's actually a permutation).
> * **Fruit salad** $\rightarrow$ Order doesn't matter (apples + bananas = bananas + apples).

## Permutations & Combinations Calculator

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

    input[type="number"] {
      border: 1px solid var(--border-color);
      padding: 6px 12px;
      border-radius: 4px;
      font-size: 0.9rem;
      width: 150px;
    }

    input:focus {
      outline: 1px solid var(--accent-color);
    }

    .main-container {
      display: flex;
      flex: 1;
      gap: 10px;
      overflow: hidden;
      min-height: 0;
      margin-top: 10px;
    }

    .panel {
      flex: 1;
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
    <label for="mInput">M:</label>
    <input type="number" id="mInput" value="5" min="0" max="1000" />
  </div>

  <div class="input-group">
    <label for="nInput">N:</label>
    <input type="number" id="nInput" value="3" min="0" max="1000" />
  </div>
</div>

<div class="main-container">
  <div class="panel">
    <div class="panel-header">Permutations P(M, N)</div>
    <pre id="permOutput">-</pre>
  </div>

  <div class="panel">
    <div class="panel-header">Combinations C(M, N)</div>
    <pre id="combOutput">-</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const mInput = document.getElementById('mInput');
  const nInput = document.getElementById('nInput');
  const permOutput = document.getElementById('permOutput');
  const combOutput = document.getElementById('combOutput');
  const statusBar = document.getElementById('statusBar');

  function calculateCombinatorics() {
    const m = parseInt(mInput.value, 10);
    const n = parseInt(nInput.value, 10);

    if (isNaN(m) || isNaN(n) || m < 0 || n < 0) {
      updateStatus('M and N must be non-negative integers.', 'error-msg');
      clearOutputs();
      return;
    }

    if (n > m) {
      updateStatus('N cannot be greater than M.', 'error-msg');
      clearOutputs();
      return;
    }

    // P(M, N) = M! / (M - N)!
    let perm = 1n;
    for (let i = 0; i < n; i++) {
      perm *= BigInt(m - i);
    }

    // C(M, N) = P(M, N) / N!
    let factN = 1n;
    for (let i = 1; i <= n; i++) {
      factN *= BigInt(i);
    }
    const comb = perm / factN;

    permOutput.textContent = formatBigInt(perm);
    combOutput.textContent = formatBigInt(comb);
    updateStatus('Ready');
  }

  function clearOutputs() {
    permOutput.textContent = '-';
    combOutput.textContent = '-';
  }

  function formatBigInt(val) {
    return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  }

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  // Calculate automatically on input change
  mInput.addEventListener('input', calculateCombinatorics);
  nInput.addEventListener('input', calculateCombinatorics);

  // Initial calculation
  calculateCombinatorics();
</script>
