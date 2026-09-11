# &#128423; Graph Visualizer

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
      background-color: var(--bg-color);
    }

    .panel:first-child {
      border-right: 1px solid var(--border-color);
      max-width: 380px;
      min-width: 280px;
    }

    .panel-header {
      padding: 6px 15px;
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 1px;
      border-bottom: 1px solid var(--border-color);
      color: var(--text-color);
    }

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

    textarea {
      flex: 1;
      margin: 0;
      padding: 15px;
      font-family: monospace;
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

    /* Canvas styling */
    .canvas-container {
      flex: 1;
      position: relative;
      overflow: hidden;
    }

    canvas {
      width: 100%;
      height: 100%;
      display: block;
      background-color: var(--bg-color);
    }

    .status-bar {
      padding: 5px 20px;
      font-size: 0.85rem;
      border-top: 1px solid var(--border-color);
      min-height: 20px;
      color: var(--text-color);
      background-color: var(--bg-color);
    }

    .error-msg { color: var(--error-color); }
    .success-msg { color: var(--success-color); }

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
    <label for="graphTypeSelect">Graph Type:</label>
    <select id="graphTypeSelect">
      <option value="directed" selected>Directed</option>
      <option value="undirected">Undirected</option>
    </select>
    <label for="treeLayoutCheckbox">
      <input type="checkbox" id="treeLayoutCheckbox" />
      Draw as Tree
    </label>
  </div>

  <div class="main-container">
    <!-- Edge Data Textarea Panel -->
    <div class="panel">
      <div class="panel-header">Edge Data (Node1 Node2 [Weight])</div>
      <div class="panel-actions">
        <button id="copyBtn">Copy</button>
        <button id="clearBtn">Clear</button>
      </div>
      <textarea id="edgeInput" placeholder="Enter edges per line:&#10;Node1 Node2 Weight&#10;&#10;Examples:&#10;A B 5&#10;B C 3&#10;C A 10&#10;A D"></textarea>
    </div>
    <!-- Graph Visualization Panel -->
    <div class="panel">
      <div class="panel-header">Graph Visualization</div>
      <div class="canvas-container" id="canvasContainer">
        <canvas id="graphCanvas"></canvas>
      </div>
    </div>
  </div>

  <div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  const edgeInput = document.getElementById('edgeInput');
  const copyBtn = document.getElementById('copyBtn');
  const clearBtn = document.getElementById('clearBtn');
  const graphTypeSelect = document.getElementById('graphTypeSelect');
  const treeLayoutCheckbox = document.getElementById('treeLayoutCheckbox');
  const canvas = document.getElementById('graphCanvas');
  const ctx = canvas.getContext('2d');
  const container = document.getElementById('canvasContainer');
  const statusBar = document.getElementById('statusBar');

  let nodes = {};
  let edges = [];

  const defaultText = `A B 5\nB C 3\nC A 10\nA D`;

  function init() {
    resizeCanvas();
    window.addEventListener('resize', () => {
      resizeCanvas();
      drawGraph();
    });

    edgeInput.value = defaultText;
    updateGraphData();

    edgeInput.addEventListener('input', updateGraphData);
    graphTypeSelect.addEventListener('change', drawGraph);
    treeLayoutCheckbox.addEventListener('change', () => {
      // Discard previous positions so the layout is recomputed from scratch
      nodes = {};
      updateGraphData();
    });

    copyBtn.addEventListener('click', () => {
      if (edgeInput.value) {
        navigator.clipboard.writeText(edgeInput.value).then(() => {
          const originalText = copyBtn.textContent;
          copyBtn.textContent = 'Copied!';
          setTimeout(() => copyBtn.textContent = originalText, 2000);
        });
      }
    });

    clearBtn.addEventListener('click', () => {
      edgeInput.value = '';
      updateGraphData();
      updateStatus('Cleared data.');
    });
  }

  function resizeCanvas() {
    canvas.width = container.clientWidth;
    canvas.height = container.clientHeight;
  }

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  function updateGraphData() {
    const lines = edgeInput.value.split('\n');
    edges = [];
    const uniqueNodeNames = new Set();

    lines.forEach(line => {
      const trimmed = line.trim();
      if (!trimmed) return;

      const tokens = trimmed.split(/\s+/);
      const from = tokens[0] || '';
      const to = tokens[1] || '';
      const weight = tokens.slice(2).join(' ') || '';

      if (from) uniqueNodeNames.add(from);
      if (to) uniqueNodeNames.add(to);

      if (from || to) {
        edges.push({ from, to, weight });
      }
    });

    const nodeArray = Array.from(uniqueNodeNames);

    if (treeLayoutCheckbox.checked) {
      nodes = layoutTree(nodeArray);
    } else {
      // Layout nodes evenly on a circular layout, keeping existing positions
      const newNodes = {};
      const count = nodeArray.length;
      const centerX = canvas.width / 2;
      const centerY = canvas.height / 2;
      const radius = Math.min(centerX, centerY) - 60;

      nodeArray.forEach((name, i) => {
        if (nodes[name]) {
          newNodes[name] = nodes[name];
        } else {
          const angle = (i / (count || 1)) * 2 * Math.PI - Math.PI / 2;
          newNodes[name] = {
            x: centerX + (radius > 50 ? radius * Math.cos(angle) : 0),
            y: centerY + (radius > 50 ? radius * Math.sin(angle) : 0)
          };
        }
      });

      nodes = newNodes;
    }

    drawGraph();
    
    if (nodeArray.length === 0 && edges.length === 0) {
      updateStatus('Ready');
    } else {
      updateStatus(`Graph updated: ${Object.keys(nodes).length} nodes, ${edges.length} edges.`, 'success-msg');
    }
  }

  // Layout nodes by BFS depth from root(s) - nodes with no incoming edges, or first node if all have incoming edges
  function layoutTree(nodeArray) {
    const adjacency = {};
    nodeArray.forEach(name => adjacency[name] = []);

    const hasIncoming = new Set();
    edges.forEach(edge => {
      if (!edge.from || !edge.to) return;
      adjacency[edge.from].push(edge.to);
      if (graphTypeSelect.value !== 'directed') {
        adjacency[edge.to].push(edge.from);
      }
      hasIncoming.add(edge.to);
    });

    const roots = nodeArray.filter(name => !hasIncoming.has(name));
    const queue = roots.length ? [...roots] : nodeArray.slice(0, 1);
    const levels = {};
    queue.forEach(name => levels[name] = 0);

    while (queue.length) {
      const current = queue.shift();
      adjacency[current].forEach(next => {
        if (!(next in levels)) {
          levels[next] = levels[current] + 1;
          queue.push(next);
        }
      });
    }

    // Disconnected nodes not reached become their own root at level 0
    nodeArray.forEach(name => {
      if (!(name in levels)) levels[name] = 0;
    });

    const levelGroups = {};
    nodeArray.forEach(name => {
      const level = levels[name];
      (levelGroups[level] = levelGroups[level] || []).push(name);
    });

    const levelKeys = Object.keys(levelGroups).map(Number).sort((a, b) => a - b);
    const verticalSpacing = Math.max(80, (canvas.height - 100) / (levelKeys.length || 1));
    const newNodes = {};

    levelKeys.forEach((level, levelIndex) => {
      const nodesInLevel = levelGroups[level];
      const horizontalSpacing = canvas.width / (nodesInLevel.length + 1);
      nodesInLevel.forEach((name, idx) => {
        newNodes[name] = {
          x: horizontalSpacing * (idx + 1),
          y: 60 + verticalSpacing * levelIndex
        };
      });
    });

    return newNodes;
  }

  function drawGraph() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const isDirected = graphTypeSelect.value === 'directed';
    const computedStyle = getComputedStyle(document.documentElement);
    const textHex = computedStyle.getPropertyValue('--text-color').trim() || '#d4d4d4';
    const accentHex = computedStyle.getPropertyValue('--accent-color').trim() || '#007acc';

    const nodeRadius = 20;

    // Draw Edges
    edges.forEach(edge => {
      const src = nodes[edge.from];
      const tgt = nodes[edge.to];

      if (!src) return;

      if (src && !tgt) {
        // Isolated node handled in node loop
        return;
      }

      if (src === tgt) {
        // Self loop
        ctx.beginPath();
        ctx.arc(src.x, src.y - nodeRadius, nodeRadius, 0, Math.PI * 2);
        ctx.strokeStyle = textHex;
        ctx.lineWidth = 2;
        ctx.stroke();

        if (edge.weight) {
          ctx.fillStyle = textHex;
          ctx.font = '18px sans-serif';
          ctx.fillText(edge.weight, src.x, src.y - nodeRadius * 2.2);
        }
        return;
      }

      // Calculate direction vectors
      const dx = tgt.x - src.x;
      const dy = tgt.y - src.y;
      const angle = Math.atan2(dy, dx);

      const startX = src.x + nodeRadius * Math.cos(angle);
      const startY = src.y + nodeRadius * Math.sin(angle);
      const endX = tgt.x - nodeRadius * Math.cos(angle);
      const endY = tgt.y - nodeRadius * Math.sin(angle);

      // Line
      ctx.beginPath();
      ctx.moveTo(startX, startY);
      ctx.lineTo(endX, endY);
      ctx.strokeStyle = textHex;
      ctx.lineWidth = 2;
      ctx.stroke();

      // Arrowhead if directed
      if (isDirected) {
        const arrowSize = 16;
        ctx.beginPath();
        ctx.moveTo(endX, endY);
        ctx.lineTo(
          endX - arrowSize * Math.cos(angle - Math.PI / 6),
          endY - arrowSize * Math.sin(angle - Math.PI / 6)
        );
        ctx.lineTo(
          endX - arrowSize * Math.cos(angle + Math.PI / 6),
          endY - arrowSize * Math.sin(angle + Math.PI / 6)
        );
        ctx.closePath();
        ctx.fillStyle = textHex;
        ctx.fill();
      }

      // Weight Label
      if (edge.weight) {
        const midX = (startX + endX) / 2;
        const midY = (startY + endY) / 2;
        ctx.fillStyle = textHex;
        ctx.font = '16px sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        const labelWidth = ctx.measureText(edge.weight).width;
        
        // Background for readability
        ctx.save();
        ctx.fillStyle = computedStyle.getPropertyValue('--bg-color').trim() || '#1e1e1e';
        ctx.fillRect(midX - labelWidth / 2 - 4, midY - 10, labelWidth + 8, 20);
        ctx.restore();

        ctx.fillText(edge.weight, midX, midY);
      }
    });

    // Draw Nodes
    Object.keys(nodes).forEach(name => {
      const { x, y } = nodes[name];

      // Node Circle
      ctx.beginPath();
      ctx.arc(x, y, nodeRadius, 0, Math.PI * 2);
      ctx.fillStyle = accentHex;
      ctx.fill();
      ctx.strokeStyle = textHex;
      ctx.lineWidth = 2;
      ctx.stroke();

      // Node Label
      ctx.fillStyle = '#ffffff';
      ctx.font = 'bold 16px sans-serif';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(name, x, y);
    });
  }

  // Initialize tool
  init();
</script>