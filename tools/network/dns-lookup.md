# DNS Lookup Tool

This DNS Lookup Tool allows you to query Domain Name System (DNS) records directly from your browser without needing command-line tools like dig or nslookup.

- Resolves DNS Records: Fetches common DNS record types, including A, AAAA, CNAME, MX, TXT, NS, SOA, and PTR.

- Uses DNS-over-HTTPS (DoH): Directs queries through secure DoH APIs provided by Cloudflare (1.1.1.1) or Google (8.8.8.8).

- Inspects Raw Responses: Displays the full structured JSON response from the DNS provider, showing metrics like TTL (Time-To-Live) and status codes (RCODEs).

<style>
    :root {
      --border-color: #3c3c3c;
      --accent-color: #007acc;
      --error-color: #f48771;
      --success-color: #89d4a1;
      --bg-color: #1e1e1e;
      --text-color: #d4d4d4;
    }

    :root[data-bs-theme='light'] {
      --border-color: #e0e0e0;
      --accent-color: #007acc;
      --error-color: #d93025;
      --success-color: #188038;
      --bg-color: #ffffff;
      --text-color: #202124;
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
      color: var(--text-color);
    }

    .controls {
      display: flex;
      gap: 10px;
      align-items: center;
      color: var(--text-color);
      flex-wrap: wrap;
    }

    .controls label {
      color: var(--text-color);
    }

    select, button, input[type="text"] {
      border: 1px solid var(--border-color);
      background-color: var(--bg-color);
      color: var(--text-color);
      padding: 6px 12px;
      border-radius: 4px;
      font-size: 0.9rem;
    }

    input[type="text"] {
      flex: 1;
      min-width: 200px;
    }

    button {
      background-color: var(--accent-color);
      color: #fff;
      border: 1px solid transparent;
      cursor: pointer;
    }

    select:focus, button:focus, input:focus {
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
    }

    .panel-header {
      padding: 6px 15px;
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 1px;
      border-bottom: 1px solid var(--border-color);
      color: var(--text-color);
    }

    textarea, pre {
      flex: 1;
      margin: 0;
      padding: 15px;
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

    pre {
      white-space: pre-wrap;
      word-wrap: break-word;
    }

    .status-bar {
      padding: 5px 20px;
      font-size: 0.85rem;
      border-top: 1px solid var(--border-color);
      min-height: 20px;
      color: var(--text-color);
    }

    .error-msg { color: var(--error-color); }
    .success-msg { color: var(--success-color); }

    .panel-actions {
      position: absolute;
      top: 35px;
      right: 15px;
      z-index: 10;
    }
    
    .panel-actions button {
      opacity: 0.8;
      font-size: 0.8rem;
      padding: 4px 8px;
    }
    .panel-actions button:hover {
      opacity: 1;
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
  <input type="text" id="domainInput" placeholder="Enter domain name (e.g. example.com)...">
  
  <label for="recordType">Record Type:</label>
  <select id="recordType">
    <option value="A" selected>A</option>
    <option value="AAAA">AAAA</option>
    <option value="CNAME">CNAME</option>
    <option value="MX">MX</option>
    <option value="TXT">TXT</option>
    <option value="NS">NS</option>
    <option value="SOA">SOA</option>
    <option value="PTR">PTR</option>
  </select>

  <label for="provider">DNS Server:</label>
  <select id="provider">
    <option value="cloudflare" selected>Cloudflare (1.1.1.1)</option>
    <option value="google">Google (8.8.8.8)</option>
  </select>

  <button id="lookupBtn">Lookup DNS</button>
</div>

<div class="main-container">
  <div class="panel">
    <div class="panel-header">DNS Query Response</div>
    <div class="panel-actions">
      <button id="copyBtn">Copy</button>
    </div>
    <pre id="dnsOutput">DNS results will appear here...</pre>
  </div>
</div>

<div class="status-bar" id="statusBar">Ready</div>
</div>

<br>
<br>
<br>

## DNS Record Types Explained

`A, AAAA, CNAME, MX, TXT, NS, SOA, and PTR` are fundamental **DNS (Domain Name System) record types**. They act as instructions stored on DNS servers to map human-readable domain names (like `example.com`) to IP addresses and other services.

* **A (Address):** Maps a domain name to an **IPv4 address** (e.g., `192.0.2.1`). Used to route web traffic to a server.
* **AAAA (IPv6 Address):** Maps a domain name to an **IPv6 address** (e.g., `2001:db8::1`). Works identically to an A record but for the newer, longer IP format.
* **CNAME (Canonical Name):** Creates an **alias** pointing one domain name to another domain name (e.g., pointing `[www.example.com](https://www.example.com)` to `example.com`), rather than directly to an IP address.
* **MX (Mail Exchange):** Specifies the **mail servers** responsible for receiving emails sent to your domain, along with priority values to determine primary and backup servers.
* **TXT (Text):** Stores human- or machine-readable **text notes**. Commonly used for domain ownership verification, security protocols (SPF, DKIM, DMARC), and preventing email spoofing.
* **NS (Name Server):** Identifies the **authoritative DNS servers** responsible for handling and answering DNS queries for your domain.
* **SOA (Start of Authority):** Contains **administrative metadata** about the DNS zone, including the primary name server, domain administrator email, serial number (for updates), and refresh intervals.
* **PTR (Pointer):** Performs a **reverse DNS lookup**, mapping an IP address back to a domain name. Most commonly used by mail servers to verify that an incoming connection comes from a legitimate host.



<script>
  const domainInput = document.getElementById('domainInput');
  const recordType = document.getElementById('recordType');
  const provider = document.getElementById('provider');
  const lookupBtn = document.getElementById('lookupBtn');
  const dnsOutput = document.getElementById('dnsOutput');
  const statusBar = document.getElementById('statusBar');
  const copyBtn = document.getElementById('copyBtn');

  const defaultOutputText = 'DNS results will appear here...';
  const errorText = 'Error executing DNS lookup...';

  const DNS_PROVIDERS = {
    cloudflare: 'https://cloudflare-dns.com/dns-query',
    google: 'https://dns.google/resolve'
  };

  async function performDNSLookup() {
    let domain = domainInput.value.trim();
    const type = recordType.value;
    const selectedProvider = provider.value;

    if (!domain) {
      updateStatus('Please enter a domain name.', 'error-msg');
      dnsOutput.textContent = defaultOutputText;
      return;
    }

    // Basic cleaning of URL prefixes if entered
    domain = domain.replace(/^https?:\/\//i, '').replace(/\/.*$/, '');

    updateStatus(`Querying ${type} records for ${domain}...`);
    dnsOutput.textContent = 'Fetching DNS records...';

    try {
      let endpoint = '';
      if (selectedProvider === 'cloudflare') {
        endpoint = `${DNS_PROVIDERS.cloudflare}?name=${encodeURIComponent(domain)}&type=${type}`;
      } else {
        endpoint = `${DNS_PROVIDERS.google}?name=${encodeURIComponent(domain)}&type=${type}`;
      }

      const response = await fetch(endpoint, {
        headers: {
          'Accept': 'application/dns-json'
        }
      });

      if (!response.ok) {
        throw new Error(`HTTP Error ${response.status}`);
      }

      const data = await response.json();

      if (data.Status === 0) {
        dnsOutput.textContent = JSON.stringify(data, null, 2);
        const recordCount = data.Answer ? data.Answer.length : 0;
        updateStatus(`Lookup successful. ${recordCount} record(s) found.`, 'success-msg');
      } else {
        dnsOutput.textContent = JSON.stringify(data, null, 2);
        updateStatus(`Lookup returned response code (RCODE): ${data.Status}`, 'error-msg');
      }

    } catch (error) {
      dnsOutput.textContent = errorText;
      updateStatus('DNS Lookup failed: ' + error.message, 'error-msg');
    }
  }

  function updateStatus(message, className = '') {
    statusBar.textContent = message;
    statusBar.className = 'status-bar ' + className;
  }

  lookupBtn.addEventListener('click', performDNSLookup);
  domainInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
      performDNSLookup();
    }
  });

  copyBtn.addEventListener('click', () => {
    const currentText = dnsOutput.textContent;
    if (currentText && currentText !== defaultOutputText && currentText !== errorText) {
      navigator.clipboard.writeText(currentText).then(() => {
        const originalText = copyBtn.textContent;
        copyBtn.textContent = 'Copied!';
        setTimeout(() => copyBtn.textContent = originalText, 2000);
      });
    }
  });
</script>