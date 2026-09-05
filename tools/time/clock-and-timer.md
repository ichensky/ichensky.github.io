# Digital Clock & Timer

<style>
  :root {
    --bg-surface: rgba(255, 255, 255, 0.05);
    --border-color: rgba(255, 255, 255, 0.15);
    --accent-color: #007acc;
    --stop-color: #d16969;
    --success-color: #4ec9b0;
    --btn-bg: #7a00cc;
    --btn-text: #ffffff;
    --select-bg: #2d2d2d;
  }

  :root[data-bs-theme='light'] {
    --bg-surface: rgba(0, 0, 0, 0.05);
    --border-color: rgba(0, 0, 0, 0.15);
  }

  .tool {
    max-height: 85vh;
    display: flex;
    flex-direction: column;
    padding: 20px;
    background-color: transparent;
    gap: 16px;
    box-sizing: border-box;
    overflow-y: auto;
  }

  .grid-layout {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
  }

  @media (max-width: 600px) {
    .grid-layout {
      grid-template-columns: 1fr;
    }
  }

  .clock-section, .timer-section, .info-section {
    background-color: var(--bg-surface);
    border: 1px solid var(--border-color);
    border-radius: 8px;
    padding: 16px;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    backdrop-filter: blur(4px);
  }

  .full-width {
    grid-column: 1 / -1;
  }

  .section-header {
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
  }

  .section-label {
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 1.2px;
    font-weight: 600;
  }

  .digital-display {
    font-family: 'Courier New', Courier, monospace;
    font-weight: bold;
    color: var(--text-primary);
  }

  .clock-display {
    font-size: 2.8rem;
  }

  .date-display {
    font-size: 1.1rem;
    color: var(--text-secondary);
    margin-top: 4px;
    font-family: monospace;
    font-weight: 600;
  }

  .timer-display {
    font-family: 'Courier New', Courier, monospace;
    font-size: 3rem;
    color: var(--success-color);
  }

  .info-value {
    font-size: 1.1rem;
    color: var(--text-primary);
    margin-top: 4px;
    font-family: monospace;
    font-weight: 600;
  }

  .controls {
    display: flex;
    gap: 10px;
    margin-top: 12px;
  }

  button, select {
    border: 1px solid var(--border-color);
    padding: 6px 14px;
    border-radius: 4px;
    font-size: 0.9rem;
    font-weight: 500;
    cursor: pointer;
  }

  button:hover, select:hover {
    opacity: 0.8;
  }

  .btn-start {
    background-color: var(--accent-color);
    color: #ffffff;
    border: none;
  }

  .btn-stop {
    background-color: var(--stop-color);
    color: #ffffff;
    border: none;
  }

  .btn-reset {
    background-color: var(--btn-bg);
    color: var(--btn-text);
  }

  .status-bar {
    padding: 8px 12px;
    font-size: 0.85rem;
    border-top: 1px solid var(--border-color);
    color: var(--text-secondary);
    font-weight: 500;
  }
</style>

<div class="tool">
  <div class="grid-layout">
    <div class="clock-section">
      <div class="section-header">
        <span class="section-label">Local Time</span>
        <select id="formatSelect">
          <option value="24" selected>24-Hour</option>
          <option value="12">12-Hour</option>
        </select>
      </div>
      <div id="localClockDisplay" class="digital-display clock-display">00:00:00</div>
      <div id="localDateDisplay" class="date-display">----- --- ---</div>
    </div>
    <div class="clock-section">
      <div class="section-header">
        <span class="section-label">UTC Time</span>
      </div>
      <div id="utcClockDisplay" class="digital-display clock-display">00:00:00</div>
      <div id="utcDateDisplay" class="date-display">----- --- ---</div>
    </div>
    <div class="info-section full-width">
      <div class="section-label">Timezone Information</div>
      <div id="timezoneDisplay" class="info-value">Detecting Timezone...</div>
    </div>
    <div class="timer-section full-width">
      <div class="section-label">Timer / Stopwatch</div>
      <div id="timerDisplay" class="digital-display timer-display">00:00:00.0</div>
      <div class="controls">
        <button id="startBtn" class="btn-start">Start</button>
        <button id="stopBtn" class="btn-stop">Stop</button>
        <button id="resetBtn" class="btn-reset">Reset</button>
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
  const statusBar = document.getElementById('statusBar');

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