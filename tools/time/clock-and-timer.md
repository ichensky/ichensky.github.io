## Digital Clock & Timer

<style>
  :root {
    --border-color: #3c3c3c;
    --accent-color: #007acc;
    --error-color: #f48771;
    --success-color: #89d4a1;
  }

  .tool {
    max-height: 80vh;
    height: stretch;
    display: flex;
    flex-direction: column;
    padding-top: 10px;
    padding-bottom: 10px;
  }

  .main-container {
    display: flex;
    flex-direction: column;
    gap: 10px;
    overflow-y: auto;
    min-height: 0;
    flex: 1;
  }

  .grid-layout {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
  }

  @media (max-width: 600px) {
    .grid-layout {
      grid-template-columns: 1fr;
    }
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
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .panel-body {
    padding: 15px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }

  .digital-display {
    font-family: monospace;
    font-weight: bold;
    font-size: 2.2rem;
  }

  .date-display {
    font-size: 0.95rem;
    opacity: 0.7;
    margin-top: 4px;
    font-family: monospace;
  }

  .timer-display {
    font-family: monospace;
    font-size: 2.5rem;
  }

  .info-value {
    font-size: 0.95rem;
    font-family: monospace;
    word-break: break-word;
  }

  .controls {
    display: flex;
    gap: 10px;
    margin-top: 12px;
  }

  button, select {
    border: 1px solid var(--border-color);
    background-color: var(--accent-color);
    color: #ffffff;
    padding: 6px 12px;
    border-radius: 4px;
    font-size: 0.85rem;
    cursor: pointer;
  }

  select {
    background-color: transparent;
    color: inherit;
    padding: 2px 6px;
  }

  button:hover, select:hover {
    opacity: 0.9;
  }

  button:focus, select:focus {
    outline: 1px solid var(--accent-color);
  }

  .btn-secondary {
    background-color: transparent;
    color: inherit;
  }

  .status-bar {
    padding: 5px 20px;
    font-size: 0.85rem;
    border-top: 1px solid var(--border-color);
    min-height: 20px;
    margin-top: 10px;
  }
</style>

<div class="tool">
  <div class="main-container">
    <div class="grid-layout">
      <div class="panel">
        <div class="panel-header">
          <span>Local Time</span>
          <select id="formatSelect">
            <option value="24" selected>24-Hour</option>
            <option value="12">12-Hour</option>
          </select>
        </div>
        <div class="panel-body">
          <div id="localClockDisplay" class="digital-display">00:00:00</div>
          <div id="localDateDisplay" class="date-display">----- --- ---</div>
        </div>
      </div>
      <div class="panel">
        <div class="panel-header">
          <span>UTC Time</span>
        </div>
        <div class="panel-body">
          <div id="utcClockDisplay" class="digital-display">00:00:00</div>
          <div id="utcDateDisplay" class="date-display">----- --- ---</div>
        </div>
      </div>
    </div>
    <div class="panel">
      <div class="panel-header">Timezone Information</div>
      <div class="panel-body">
        <div id="timezoneDisplay" class="info-value">Detecting Timezone...</div>
      </div>
    </div>
    <div class="panel">
      <div class="panel-header">Timer / Stopwatch</div>
      <div class="panel-body">
        <div id="timerDisplay" class="timer-display">00:00:00.0</div>
        <div class="controls">
          <button id="startBtn">Start</button>
          <button id="stopBtn" class="btn-secondary">Stop</button>
          <button id="resetBtn" class="btn-secondary">Reset</button>
        </div>
      </div>
    </div>
  </div>

  <div class="status-bar" id="statusBar">Ready</div>
</div>

<script>
  // DOM Elements
  const localClockDisplay = document.getElementById('localClockDisplay');
  const localDateDisplay = document.getElementById('localDateDisplay');
  const utcClockDisplay = document.getElementById('utcClockDisplay');
  const utcDateDisplay = document.getElementById('utcDateDisplay');
  const timezoneDisplay = document.getElementById('timezoneDisplay');
  const formatSelect = document.getElementById('formatSelect');
  const statusBar = document.getElementById('statusBar');

  // Helper function to format date as YYYY-MMM-DD
  function formatDate(date, isUTC = false) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const year = isUTC ? date.getUTCFullYear() : date.getFullYear();
    const month = months[isUTC ? date.getUTCMonth() : date.getMonth()];
    const day = String(isUTC ? date.getUTCDate() : date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  // Clock Update Function
  function updateClocks() {
    const now = new Date();
    const is24Hour = formatSelect.value === '24';

    // Local Time & Date
    const localOptions = {
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hour12: !is24Hour
    };
    localClockDisplay.textContent = now.toLocaleTimeString([], localOptions);
    localDateDisplay.textContent = formatDate(now, false);

    // UTC Time & Date
    const utcOptions = {
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      timeZone: 'UTC',
      hour12: !is24Hour
    };
    utcClockDisplay.textContent = now.toLocaleTimeString([], utcOptions);
    utcDateDisplay.textContent = formatDate(now, true);
  }

  // Timezone Details Detection
  function updateTimezoneInfo() {
    try {
      const tzName = Intl.DateTimeFormat().resolvedOptions().timeZone || 'Unknown TZ';
      
      const now = new Date();
      const offsetMinutes = -now.getTimezoneOffset();
      const offsetHours = Math.floor(Math.abs(offsetMinutes) / 60);
      const remainingMinutes = Math.abs(offsetMinutes) % 60;
      const sign = offsetMinutes >= 0 ? '+' : '-';
      
      const pad = (n) => String(n).padStart(2, '0');
      const offsetFormatted = `UTC${sign}${pad(offsetHours)}:${pad(remainingMinutes)}`;

      timezoneDisplay.textContent = `${tzName} (${offsetFormatted})`;
    } catch (e) {
      timezoneDisplay.textContent = 'Unable to determine timezone';
    }
  }

  // Initialize and run clocks
  setInterval(updateClocks, 1000);
  updateClocks();
  updateTimezoneInfo();

  // Format selection change listener
  formatSelect.addEventListener('change', updateClocks);

  // Timer Functionality
  const timerDisplay = document.getElementById('timerDisplay');
  const startBtn = document.getElementById('startBtn');
  const stopBtn = document.getElementById('stopBtn');
  const resetBtn = document.getElementById('resetBtn');

  let timerInterval = null;
  let elapsedTime = 0;
  let startTime = 0;

  function formatTimer(ms) {
    const totalSeconds = Math.floor(ms / 1000);
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const seconds = totalSeconds % 60;
    const tenths = Math.floor((ms % 1000) / 100);

    const pad = (num) => String(num).padStart(2, '0');

    return `${pad(hours)}:${pad(minutes)}:${pad(seconds)}.${tenths}`;
  }

  startBtn.addEventListener('click', () => {
    if (!timerInterval) {
      startTime = Date.now() - elapsedTime;
      timerInterval = setInterval(() => {
        elapsedTime = Date.now() - startTime;
        timerDisplay.textContent = formatTimer(elapsedTime);
      }, 100);
      statusBar.textContent = 'Timer running...';
    }
  });

  stopBtn.addEventListener('click', () => {
    if (timerInterval) {
      clearInterval(timerInterval);
      timerInterval = null;
      statusBar.textContent = 'Timer stopped';
    }
  });

  resetBtn.addEventListener('click', () => {
    clearInterval(timerInterval);
    timerInterval = null;
    elapsedTime = 0;
    timerDisplay.textContent = '00:00:00.0';
    statusBar.textContent = 'Timer reset';
  });
</script>