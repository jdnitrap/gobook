# NixQubes Project Summary

**Created:** July 23, 2026  
**Status:** Core configuration complete, awaiting testing  
**Model:** Claude Haiku 4.5

---

## Project Overview

**NixQubes** is a Qubes OS-like security architecture implemented on NixOS using lightweight containers (systemd-nspawn). It provides defense-in-depth through application compartmentalization while maintaining ease of use.

**Key Principle:** Isolation by default. Each application runs in its own isolated container with strict network compartmentalization.

---

## Architecture

### Container Types

1. **Net Container (NetQube)**
   - Auto-starts on boot
   - Has direct access to WiFi/network hardware
   - Runs NetworkManager for WiFi management
   - Runs Cockpit web UI (port 9090) for network configuration
   - Provides DNS/DHCP services to other containers
   - All internet traffic flows through this container

2. **Work Container (AppQube)**
   - Manual start: `qubesctl start work`
   - Contains: Firefox, LibreOffice, office tools
   - Private network (10.233.0.2/24)
   - Routes internet exclusively through Net container
   - Cannot communicate with Dev or Untrusted containers

3. **Dev Container (AppQube)**
   - Manual start: `qubesctl start dev`
   - Contains: Git, Vim, build tools, Rust, Node.js, Python3
   - Private network (10.233.1.2/24)
   - Routes internet exclusively through Net container
   - Cannot communicate with Work or Untrusted containers

4. **Untrusted Container (DisposableQube)**
   - Manual start: `qubesctl start untrusted`
   - Ephemeral (auto-destroyed when stopped)
   - Contains: Firefox, curl
   - Private network (10.233.3.2/24)
   - Complete isolation from other containers
   - Used for testing untrusted applications

### Networking Model

```
Tommy's Desktop
    ├─ Work Container (10.233.0.2)
    │  └─ Internet access only through Net Container
    ├─ Dev Container (10.233.1.2)
    │  └─ Internet access only through Net Container
    ├─ Untrusted Container (10.233.3.2)
    │  └─ Internet access only through Net Container
    │
    └─ Net Container (10.233.2.2) ← Handles ALL networking
       ├─ WiFi Hardware Access
       ├─ NetworkManager
       └─ Cockpit UI (http://localhost:9090)
```

**Network Isolation Rules:**
- Containers CAN reach Net container (for internet)
- Containers CANNOT reach each other
- Net container CAN access host network/WiFi
- App containers CANNOT access host network directly

---

## File Structure

```
gobook/
├── basic/                       (Original NixOS configuration)
│   ├── configuration.nix        (Main config with locale, hostname, etc.)
│   ├── users.nix                (Creator account for imperative user creation)
│   ├── user-create-helper.nix   (Interactive script for user creation)
│   ├── system-packages.nix      (Essential packages)
│   ├── desktop-environment.nix  (Cinnamon + LightDM)
│   ├── sound.nix                (PipeWire audio)
│   ├── networking.nix           (Basic networking)
│   ├── security.nix             (Security hardening)
│   └── [other config files...]
│
├── nixqubes/                    (Qubes OS-like configuration on NixOS)
│   ├── configuration.nix        (Main NixQubes config, imports all modules)
│   ├── containers.nix           (Container definitions: work, dev, net, untrusted)
│   ├── networking.nix           (Network isolation and routing rules)
│   ├── security.nix             (Kernel hardening, Polkit, Dbus)
│   ├── qubes-manager.nix        (qubesctl utility for container management)
│   ├── system-packages.nix      (Container management tools)
│   ├── users.nix                (User configuration)
│   ├── README.md                (NixQubes documentation)
│   ├── hardware-configuration.nix (Machine-specific - EMPTY, needs generation)
│   └── [other config files...]
│
├── bnt/                         (Training materials)
│   ├── TH05.md                  (Thermodynamic cycles study guide)
│   ├── TH05_study_guide.html    (HTML artifact with diagrams)
│   └── [other materials...]
│
└── NIXQUBES_SUMMARY.md          (This file - project documentation)
```

---

## Key Components

### qubesctl Command

Management utility for container lifecycle:

```bash
# List available containers
qubesctl list

# Start/stop containers
qubesctl start work
qubesctl stop dev

# Check container status
qubesctl status

# Open shell in running container
qubesctl shell work

# Run command in container
qubesctl run work firefox

# Show help
qubesctl help
```

### Cockpit Network UI

Tommy's primary interface for WiFi management:

- **Access:** http://localhost:9090
- **Location:** Runs inside Net container
- **Features:**
  - View available WiFi networks
  - Connect to WiFi with password
  - Manage network interfaces
  - System monitoring
  - Container management dashboard

### NetworkManager

Inside Net container, provides:
- WiFi hardware access
- Network connection management
- Multiple connection support
- VPN capabilities (if installed)

---

## User Experience (Tommy's Workflow)

### Initial Boot
1. System boots with NixOS
2. Net container auto-starts (handles WiFi)
3. Management Qube (host) is ready

### First Time WiFi Setup
1. Tommy opens browser: `http://localhost:9090`
2. Navigates to Network section
3. Selects WiFi network (e.g., "Home WiFi")
4. Enters WiFi password
5. Connected! All containers automatically have internet

### Daily Usage
1. Tommy starts Work container: `qubesctl start work`
2. Firefox opens (isolated, routed through Net)
3. Tommy starts Dev container: `qubesctl start dev`
4. VSCode opens (isolated, routed through Net)
5. Tommy can use both without them seeing each other
6. Stop containers when done: `qubesctl stop work`

### Security Guarantee
- Work container cannot see Dev files
- Dev container cannot spy on Work
- Untrusted container is completely isolated
- If one container is compromised, others are safe
- Net container is the only bridge to internet

---

## Configuration Details

### Container Isolation

**Namespace Isolation:**
- PID namespace (processes)
- IPC namespace (inter-process communication)
- Network namespace (network stack)
- Mount namespace (filesystem)
- UTS namespace (hostname)
- User namespace (user IDs)

**Firewall Rules (networking.nix):**
- Container ↔ Net Container: ALLOWED (both directions)
- Container ↔ Container: DENIED (strict isolation)
- Host ↔ Containers: ALLOWED (for system services)

### Network Configuration

Each container has:
- Private IP address (10.233.X.0/24)
- Own network namespace
- Route to Net container for internet access
- DNS pointing to Net container (10.233.2.2)

### Security Hardening (security.nix)

Kernel hardening enabled:
- `lockdown=confidentiality` (restrict kernel access)
- `kernel.sysrq = 0` (disable magic SysRq)
- `kernel.kptr_restrict = 2` (hide kernel pointers)
- `kernel.dmesg_restrict = 1` (restrict dmesg access)
- `kernel.modules_disabled = 1` (restrict module loading)
- ASLR enabled (address space layout randomization)

---

## Deployment Instructions

### Prerequisites
- NixOS 26.05 (or compatible version)
- EFI-based system
- KVM/libvirt support (for systemd-nspawn)

### Steps

1. **Generate hardware configuration:**
   ```bash
   sudo nixos-generate-config --show-hardware-config > /etc/nixos/hardware-configuration.nix
   ```

2. **Copy nixqubes configuration:**
   ```bash
   sudo cp -r nixqubes/* /etc/nixos/
   ```

3. **Build and activate:**
   ```bash
   sudo nixos-rebuild switch -I nixos-config=/etc/nixos/configuration.nix
   ```

4. **First boot:**
   - Net container auto-starts
   - Open http://localhost:9090
   - Configure WiFi through Cockpit
   - Start other containers as needed

---

## Testing Checklist

- [ ] System boots successfully
- [ ] Net container auto-starts
- [ ] Cockpit web UI accessible (http://localhost:9090)
- [ ] WiFi connection through Cockpit works
- [ ] Work container starts with `qubesctl start work`
- [ ] Dev container starts with `qubesctl start dev`
- [ ] Containers have internet access through Net container
- [ ] Containers cannot communicate with each other
- [ ] Containers are isolated (files not visible)
- [ ] Untrusted container ephemeral (destroyed on stop)
- [ ] qubesctl commands work properly
- [ ] Container shells accessible with `qubesctl shell <name>`

---

## Known Issues / Notes

1. **hardware-configuration.nix** is empty and machine-specific
   - Must be generated for target system
   - Run: `nixos-generate-config` on deployment machine

2. **Container Bootstrap**
   - First boot of new containers may take time (builds Nix store)
   - Subsequent boots are faster (cached)

3. **GUI Forwarding**
   - Current setup: Containers have CLI only
   - Optional: X11 socket forwarding can be added for GUI apps
   - Trade-off: More forwarding = more complexity/less isolation

4. **Persistent Storage**
   - Container filesystems in `/var/lib/nixos-containers/`
   - Ephemeral containers lose changes on stop
   - Manual containers persist across restarts

---

## Related Configurations

### basic/ Directory
- Original NixOS setup with:
  - User creation system (imperative users)
  - Experimental features enabled
  - Desktop environment (Cinnamon)
  - Audio (PipeWire)
  - Security hardening

---

## References & Similar Projects

- **Qubes OS:** https://www.qubes-os.org/
- **systemd-nspawn:** https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html
- **NixOS Containers:** https://nixos.org/manual/nixos/stable/index.html#ch-containers
- **Cockpit:** https://cockpit-project.org/

---

## Future Enhancements

Potential improvements (not yet implemented):

1. **GUI Support**
   - X11 forwarding from containers
   - Wayland protocol support
   - Integrated window manager

2. **VM Option**
   - Replace containers with MicroVMs (KVM-based)
   - Provides better isolation at cost of more resources

3. **Template System**
   - Create custom container templates
   - Pre-configured application sets

4. **Automation**
   - Auto-creation of new containers
   - Container templates in web UI

5. **Monitoring**
   - Container resource usage tracking
   - Network traffic monitoring per container

6. **Advanced Networking**
   - VPN support in Net container
   - Proxy configuration
   - Network statistics dashboard

---

## Contact / Questions

If reverting to this repo after conversation deletion:
- Review this summary first
- Check git log for commit messages with detailed changes
- nixqubes/README.md has technical details
- Check basic/README.md for user creation system details

---

**Status:** Ready for testing and deployment
**Last Updated:** July 23, 2026
