# Security Subsystems and Primitives in Linux

## 1. Isolation Subsystems

* **Namespaces (Isolation):** Virtualizes system resources per process group.
* **PID Namespace:** Isolates process ID spaces (processes inside see themselves starting at PID 1).
* **Network Namespace:** Isolates network stacks, interfaces, routes, and firewall rules.
* **Mount Namespace:** Isolates filesystem mount points.
* **User Namespace:** Maps UIDs/GIDs (enables an unprivileged host user to act as `root` inside the container while remaining unprivileged on the host).
* **IPC Namespace:** Isolates Inter-Process Communication resources (System V IPC, POSIX queues).
* **UTS Namespace:** Isolates hostnames and domain names.
* **Cgroup Namespace:** Hides the host's physical cgroup hierarchy structures from sub-processes.
* **Time Namespace:** Isolates system clocks (`CLOCK_MONOTONIC` and `CLOCK_BOOTTIME`), allowing container suspension/migration without clock skew.

### Namespaces

Namespaces provide process-level isolation for various system resources. Each namespace type isolates a specific aspect of the kernel state, allowing processes to have their own independent instance of that resource. This is the fundamental building block for containerization (Docker, Podman, LXC).

#### Command Examples

```sh
# List all namespaces currently active on the system
lsns

# Create an isolated environment (PID, Mount, and Network namespaces)
# `--mount-proc` ensures /proc is re-mounted for the new isolated PID namespace
sudo unshare -p -f -m -n --mount-proc /bin/bash

# Create a new network namespace
sudo ip netns add mynamespace

# Create a virtual ethernet (veth) pair to safely connect the host to the namespace
# (Safer than moving a physical interface like eth0, which severs host connectivity)
sudo ip link add veth_host type veth peer name veth_ns
sudo ip link set veth_ns netns mynamespace

# Verify the interface is in the new namespace
sudo ip netns exec mynamespace ip addr show veth_ns

# Run a specific command inside a network namespace
sudo ip netns exec mynamespace /bin/bash

# Enter the namespaces of a running process by its PID with a bash shell
sudo nsenter --target 1234 --mount --uts --ipc --net --pid /bin/bash

```

---

## 2. Resource Governance

* **Control Groups (cgroups v1/v2):** Manages, limits, and accounts for hardware resource usage. Linux is rapidly moving to the **unified hierarchy of cgroups v2**.
* **Resource Throttling:** Restricts CPU usage, RAM allocations, and disk I/O rates per process tree.
* **DoS & OOM Isolation:** Limits fork-bomb impact (via `pids.max`) and confines Out-Of-Memory (OOM) killings to specific container process groups.
* **Device Cgroup (eBPF in v2):** Controls access to device nodes (`/dev/`). In cgroups v2, this is handled via eBPF programs attached to the cgroup.

### Cgroups (Control Groups)

Cgroups allocate, prioritize, and limit system resources for groups of tasks. While namespaces isolate *what a process can see*, cgroups govern *what a process can use*.

#### Command Examples

```sh
# Display the hierarchy of control groups as a tree
systemd-cgls

# Display real-time resource usage of control groups (similar to 'top')
systemd-cgtop

# Display the cgroup membership of a specific process by its PID
cat /proc/<PID>/cgroup

# Explore via the Virtual Filesystem (VFS)
# (Cgroups are managed through a pseudo-filesystem natively mounted under /sys)
ls -l /sys/fs/cgroup/

```

---

## 3. Sandboxing & Syscall Filtering

* **Seccomp (Secure Computing Mode):** Filters system calls executed by processes, reducing the kernel attack surface.
* **Strict Mode (`SECCOMP_MODE_STRICT`):** Restricts execution strictly to `read()`, `write()`, `_exit()`, and `sigreturn()`. Any other syscall results in a `SIGKILL`.
* **Seccomp-BPF (`SECCOMP_MODE_FILTER`):** Uses Berkeley Packet Filters to inspect syscall numbers and arguments, selectively allowing, logging, blocking, or terminating process behavior based on granular rules.

### Seccomp

Seccomp transitions a process into a one-way state where its ability to request kernel services is permanently crippled based on predefined rules.

#### Code & Command Examples

```sh
# Check if seccomp is supported by the kernel
grep SECCOMP /boot/config-$(uname -r)

```

```c
// Example C snippet applying a strict seccomp filter to the current process
#include <sys/prctl.h>
#include <linux/seccomp.h>
#include <stdio.h>

int main(void) {
    // Enable strict seccomp mode. Once called, the process is sandboxed.
    if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_STRICT) != 0) {
        return 1; 
    }

    // Process can now only issue read(), write(), _exit(), sigreturn()
    // Calling printf() might crash the program if it attempts to malloc() or stat()
    return 0;
}

```

---

## 4. Privilege Management

* **Capabilities (POSIX Capabilities):** Splits monolithic `root` privileges into granular units, granting processes only the specific administrative powers they need.
* **SafeSetID:** LSM module enforcing policies on user/group ID transitions during `setuid`/`setgid` calls to prevent arbitrary privilege escalation.
* **POSIX File ACLs:** Extends Discretionary Access Control (DAC) with per-user and per-group file permissions beyond standard Unix `rwxrwxrwx`.
* **File Capabilities (`xattr`):** Binds capabilities directly to executable binaries on disk, eliminating the severe security risks associated with legacy SUID binaries.

### Core Capabilities

* `CAP_NET_BIND_SERVICE`: Bind to privileged ports (below 1024).
* `CAP_SYS_ADMIN`: Broad administrative capabilities (often considered equivalent to root; used for mounting, namespace manipulation).
* `CAP_SYS_PTRACE`: Allows tracing/debugging of other processes (highly dangerous if compromised).
* `CAP_BPF`: Modern capability introduced to allow loading eBPF programs without full `CAP_SYS_ADMIN`.

#### Command Examples

```sh
# View capabilities of the current shell process
capsh --print

# View capabilities of a specific process by its PID
getpcaps <pid>

# View capabilities currently set on a specific executable file
getcap /usr/bin/ping

# Example: Grant `CAP_NET_RAW` capability to `tcpdump`
# (Allows the binary to open raw sockets for packet inspection without sudo/root)
sudo setcap 'cap_net_raw=ep' /usr/bin/tcpdump

```

---

## 5. Mandatory Access Control (MAC) & LSMs

* **AppArmor:** Path-based MAC profiles enforcing file and network access rules. Popular on Debian/Ubuntu.
* **SELinux:** Type-enforcement MAC system assigning cryptographic-style security labels to processes, files, ports, and inodes. Popular on RHEL/Fedora.
* **Landlock:** Modern unprivileged LSM enabling applications to self-sandbox their own filesystem access dynamically without requiring root permissions.
* **Yama:** Specialized LSM restricting process-tracing capabilities (`ptrace`) to prevent credential scraping from memory.
* **LoadPin:** LSM ensuring modules, firmware, and security policies load strictly from a single read-only backing file system.
* **Smack / TOMOYO:** Lightweight MAC architectures primarily tailored for embedded and IoT platforms.

### AppArmor

* **Profiles:** Define access rules, specifying allowed file paths, network operations, and POSIX capabilities.
* **Modes:** **Enforce mode** actively restricts and blocks unauthorized actions; **Complain mode** allows the action but logs a violation for auditing/profile-building.

#### Command Examples

```sh
# Check the status of AppArmor profiles
sudo aa-status

# Switch a profile to complain mode (accepts binary path or profile name)
sudo aa-complain /usr/bin/ping

# Switch a profile to enforce mode
sudo aa-enforce /usr/bin/ping

# Load or reload a profile directly from its configuration file
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.ping

```

---

## 6. Kernel & Process Self-Protection

* **ASLR & KASLR:** Randomizes user-space and kernel memory layouts upon execution to prevent hardcoded memory offset exploits (e.g., buffer overflows).
* **Stack Canaries / SSP:** Places randomized cryptographic values on the stack to detect overflow attempts before function returns execute.
* **Control Flow Integrity (CFI / kCFI):** Validates function-call targets at runtime to disrupt Return-Oriented Programming (ROP) exploit chains.
* **Kernel Lockdown Mode:** Restricts user-space access to running kernel memory (`/dev/mem`, raw MSRs, unsigned kernel modules, kexec) even if the user is `root`.
* **KPTI (Kernel Page Table Isolation):** Hardware vulnerability mitigation (e.g., Meltdown) that completely separates user and kernel page tables.
* **IOMMU / DMA Protection:** Blocks direct memory access from rogue or compromised hardware peripherals (e.g., malicious Thunderbolt/USB-C devices).

---

## 7. Storage & File System Security

* **`pivot_root` & `chroot`:** Rebases the root directory (`/`) for a process tree. `chroot` is the legacy UNIX standard; `pivot_root` physically unmounts the old root, making it the secure standard for modern Linux containers.
* **Mount Flags:** Hardens mounts by disabling risky behaviors (`nosuid` ignores SUID bits, `noexec` prevents binary execution, `nodev` blocks device files).
* **dm-crypt / LUKS:** Transparent full-block storage encryption.
* **dm-verity:** Kernel-level block integrity checking using cryptographic Merkle trees. Used heavily in Android and ChromeOS for verified boot.
* **dm-integrity:** Block-level target that calculates and verifies per-block checksums or HMACs at runtime to detect data corruption or unauthorized modifications.
* **`fs-verity`:** Per-file (rather than per-block) integrity measurement for read-only files (used extensively for Android APK validation).
* **`fscrypt`:** Filesystem-native encryption applied at the directory or file level (supported natively by ext4, f2fs, ubifs).

---

## 8. Network Security

* **`nftables` / `iptables`:** Netfilter-based frameworks for stateful packet filtering, NAT, and network access control. `nftables` is the modern, high-performance successor.
* **eBPF Security:** In-kernel sandboxed programs that execute custom bytecode to track runtime behavior, filter network traffic at wire-speed, and monitor threats (e.g., Cilium, Tetragon, Falco).
* **IPsec & WireGuard:** Kernel-native cryptographic VPN protocols for Layer 3 network transit protection. WireGuard is modern, lean, and integrated directly into the mainline kernel.

### nftables

* **Tables:** Top-level containers for chains, bound to an address family (`ip`, `ip6`, `inet` [both v4/v6], `bridge`, `arp`, `netdev`).
* **Chains:** Ordered lists of rules. **Base chains** attach directly to kernel networking hooks; **regular chains** serve as custom jump targets.
* **Sets:** High-performance O(1) memory structures for grouping IP addresses, ports, or subnets, allowing massive rule lists to be condensed into a single match.
* **Stateful Matching (`ct`):** Integrates with Linux connection tracking (`conntrack`) to evaluate packets based on stream state (`new`, `established`, `related`, `invalid`).

#### Command Examples

```sh
# View the entire active firewall configuration
sudo nft list ruleset

# Clear the firewall completely
sudo nft flush ruleset

# Atomically load rules from a configuration file
sudo nft -f /etc/nftables.conf

# Create a dual-stack (IPv4/IPv6) table named 'my_table'
sudo nft add table inet my_table

# Create a base input chain that drops incoming traffic by default
sudo nft 'add chain inet my_table my_input { type filter hook input priority filter; policy drop; }'

# Connection tracking: fast-track established/related packets (Essential for return traffic)
sudo nft add rule inet my_table my_input ct state established,related accept

# Allow incoming SSH traffic on port 22
sudo nft add rule inet my_table my_input tcp dport 22 accept

# Log and drop traffic on port 80
sudo nft add rule inet my_table my_input tcp dport 80 log prefix '"HTTP drop: "' drop

```

---

## 9. Modern Integrity, Auditing & Hardware Verification

* **IMA / EVM (Integrity Measurement Architecture):** Measures file hashes and validates extended attribute signatures before allowing binaries to execute or files to be read.
* **UEFI Secure Boot:** Cryptographically validates bootloaders and kernel signatures during hardware startup to establish an unbroken hardware-to-kernel chain of trust.
* **Linux Audit Subsystem (`auditd`):** Kernel-level logging of security events, syscall execution, and file accesses, essential for forensics and regulatory compliance (e.g., SOC2, PCI-DSS).

---

## 10. Key Management & Cryptography

* **Kernel Keyring (`keyrings`):** Securely retains cryptographic keys, authentication tokens, and credentials in isolated kernel memory to prevent theft from user-space memory dumps.
* **Linux Kernel Crypto API:** Provides in-kernel cryptographic ciphers and hashing primitives required by storage (dm-crypt) and networking (IPsec/WireGuard) subsystems.

---

## 11. Hardware-Enclave & Execution Shielding

* **Confidential Computing (TEEs):** Leverages Trusted Execution Environments (AMD SEV, Intel TDX, ARM CCA) to execute virtual machines inside hardware-encrypted memory spaces. This protects data in use, making memory contents illegible even to hostile hypervisors or malicious host administrators with physical access.