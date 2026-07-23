# GoBook - A Comprehensive NixOS System Architecture

**Project Type:** Integrated NixOS Configuration  
**Created:** July 2026  
**Status:** Core configuration complete, testing phase  
**Inspiration:** Mike Kelley's NixBook architecture  

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Directory Structure](#directory-structure)
4. [Setup & Deployment](#setup--deployment)
5. [User Workflows](#user-workflows)
6. [Administration](#administration)
7. [Troubleshooting](#troubleshooting)

---

## Project Overview

**GoBook** is a complete, production-ready NixOS system architecture that combines:

1. **basic/** - A modular, declarative NixOS configuration
   - Minimal, reproducible system setup
   - Imperative user management (users survive rebuilds)
   - Desktop environment (Cinnamon + LightDM)
   - Security hardening and essential packages

2. **nixqubes/** - Qubes OS-inspired container architecture
   - Application compartmentalization using systemd-nspawn
   - Strict network isolation between containers
   - Central network container managing all connectivity
   - Web-based UI (Cockpit) for easy management

3. **bnt/** - Training and educational materials
   - Thermodynamic cycles study guides with embedded diagrams
   - Question banks and lesson materials
   - De-identified educational content

**Core Philosophy:** 
- Security through isolation
- Reproducibility through declarative configuration
- Ease of use through automation
- Simplicity through modular design

---

## Architecture

### Three-Tier System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  Management Layer                       │
│  (Cinnamon Desktop, System Control, Admin Tools)        │
│                                                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │  NixQubes Container Orchestration Layer          │   │
│  │  ├─ Net Container (Network Management)          │   │
│  │  ├─ Work Container (Office/Browsing)            │   │
│  │  ├─ Dev Container (Development)                 │   │
│  │  └─ Untrusted Container (Testing)               │   │
│  └──────────────────────────────────────────────────┘   │
│                                                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │  NixOS Base Configuration Layer                  │   │
│  │  ├─ Hardware abstraction                        │   │
│  │  ├─ System services                             │   │
│  │  ├─ Security policies                           │   │
│  │  └─ User management                             │   │
│  └──────────────────────────────────────────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### System Components

#### 1. Base System (basic/)
Provides the foundation:
- **configuration.nix** - Central configuration hub
- **hardware-configuration.nix** - Machine-specific settings (generated)
- **users.nix** - User management system
- **security.nix** - Kernel hardening, Polkit, Dbus
- **desktop-environment.nix** - Cinnamon desktop + LightDM
- **sound.nix** - PipeWire audio system
- **networking.nix** - Network configuration
- **system-packages.nix** - Essential tools and utilities
- **[other modules]** - Auto-upgrade, garbage collection, etc.

#### 2. NixQubes (nixqubes/)
Security and isolation layer:
- **Net Container** - Handles ALL network connectivity
  - WiFi management via NetworkManager
  - Web-based UI (Cockpit on port 9090)
  - DNS/DHCP services
  - Acts as gateway for all other containers

- **App Containers** - Isolated application environments
  - Work: Office suite, Firefox, collaboration tools
  - Dev: Git, build tools, Rust, Node.js, Python
  - Untrusted: Ephemeral container for untrusted apps

- **Management Tools**
  - qubesctl: Command-line container management
  - Cockpit: Web-based system dashboard

#### 3. Training Materials (bnt/)
Educational content:
- Study guides with embedded diagrams
- Question banks for testing
- Lesson topics and materials
- Training records and tracking

---

## Directory Structure

```
gobook/
│
├── README.md                      ← YOU ARE HERE
├── NIXQUBES_SUMMARY.md            (NixQubes-specific documentation)
├── BNT_MASTER_V44.txt             (Master training content)
│
├── basic/                         (NixOS Base Configuration)
│   ├── README.md                  (Basic setup documentation)
│   ├── configuration.nix          (Main configuration file)
│   ├── hardware-configuration.nix (Machine-specific - GENERATED)
│   ├── users.nix                  (User account management)
│   ├── user-create-helper.nix     (Interactive user creation script)
│   ├── system-packages.nix        (System packages and fonts)
│   ├── desktop-environment.nix    (Cinnamon + LightDM)
│   ├── sound.nix                  (PipeWire audio)
│   ├── networking.nix             (Network setup)
│   ├── security.nix               (Security hardening)
│   ├── system-setup.nix           (SSH and system services)
│   ├── auto-upgrade.nix           (Automatic system updates)
│   ├── auto-gc.nix                (Garbage collection)
│   ├── keep-first-generation.nix  (Generation management)
│   ├── powerwash.nix              (System cleanup)
│   ├── flatpak.nix                (Flatpak support)
│   ├── printer-scanner.nix        (Peripheral support)
│   └── pkgs/                      (Custom package definitions)
│
├── nixqubes/                      (Qubes OS-like Container Architecture)
│   ├── README.md                  (NixQubes documentation)
│   ├── configuration.nix          (Main NixQubes config)
│   ├── containers.nix             (Container definitions)
│   ├── networking.nix             (Network isolation rules)
│   ├── qubes-manager.nix          (qubesctl management tool)
│   ├── security.nix               (Security hardening)
│   ├── system-packages.nix        (Container tools)
│   ├── users.nix                  (NixQubes user account)
│   ├── desktop-environment.nix    (Desktop setup)
│   ├── sound.nix                  (Audio support)
│   ├── system-setup.nix           (System services)
│   ├── auto-gc.nix                (Garbage collection)
│   ├── auto-upgrade.nix           (Auto-update)
│   ├── keep-first-generation.nix  (Generation management)
│   ├── powerwash.nix              (Cleanup)
│   ├── flatpak.nix                (Flatpak support)
│   ├── hardware-configuration.nix (Machine-specific - EMPTY)
│   └── pkgs/                      (Custom packages)
│
├── bnt/                           (Training & Educational Materials)
│   ├── README.md                  (BNT documentation)
│   ├── LESSON_TOPICS.md           (Main lesson content)
│   ├── TH05.md                    (Thermodynamic cycles - study guide)
│   ├── TH05_study_guide.html      (HTML artifact with diagrams)
│   ├── QUESTION_BANK.md           (Test questions)
│   ├── PIG_TEST_FORMAT.md         (Testing format guide)
│   ├── TRAINING_RECORD.md         (Progress tracking)
│   ├── RULES.md                   (Training rules)
│   └── images/                    (Reference materials)
│
└── .git/                          (Version control)
```

---

## Setup & Deployment

### Quick Start

#### Prerequisites
- NixOS 26.05+ system
- EFI-based boot
- 20GB+ disk space
- 4GB+ RAM (8GB+ recommended for multiple containers)

#### Step 1: Generate Hardware Configuration

On your target machine:
```bash
sudo nixos-generate-config --show-hardware-config > /tmp/hw-config.nix
```

Copy the generated config to both:
```bash
sudo cp /tmp/hw-config.nix /etc/nixos/basic/hardware-configuration.nix
sudo cp /tmp/hw-config.nix /etc/nixos/nixqubes/hardware-configuration.nix
```

#### Step 2: Choose Your Configuration

**Option A: Basic NixOS Setup**
```bash
sudo cp basic/* /etc/nixos/
sudo nixos-rebuild switch
```

**Option B: NixQubes (Full Setup)**
```bash
sudo cp nixqubes/* /etc/nixos/
sudo nixos-rebuild switch
```

#### Step 3: Configure WiFi (NixQubes only)

After first boot:
1. Open browser: `http://localhost:9090`
2. Go to Network section
3. Select WiFi network
4. Enter password
5. Connected!

#### Step 4: Create Additional Users (Basic only)

Login to `creator` account:
```
Username: creator
Password: [set during initial setup]
```

The `creator` account presents an interactive menu:
```
1. Create a new user
2. Exit
```

All created users will survive NixOS rebuilds.

---

## User Workflows

### Scenario 1: Tommy's Daily NixQubes Workflow

**Morning - System Boot**
```
1. Machine boots
2. Net container auto-starts (handles WiFi)
3. Desktop appears (Cinnamon)
4. Open Firefox to check mail
```

**Work Session - Start Isolated Containers**
```
$ qubesctl start work
# Work container boots (Firefox, LibreOffice available)

$ qubesctl start dev
# Dev container boots (Git, VSCode, Python available)
```

**Using Containers**
```
Work Container:
  • Browser is isolated
  • Cannot see Dev files
  • Cannot reach Dev applications
  
Dev Container:
  • Code editor is isolated
  • Cannot see Work files
  • Cannot reach Work applications

Both can access internet through Net container
```

**Cleanup - Stop Containers**
```
$ qubesctl stop work
$ qubesctl stop dev
```

**Security Guarantee:**
- If Work container is compromised, Dev is safe
- If Dev is compromised, Work is safe
- Untrusted container: complete isolation, auto-destroyed

### Scenario 2: System Administration

**Adding a new user (Basic setup)**
```bash
# Login as 'creator'
# Select: "1. Create a new user"
# Enter username: john
# Auto-assigned groups: networkmanager, audio, video, input
# User 'john' now exists and survives rebuilds
```

**Managing containers (NixQubes)**
```bash
# See all containers
qubesctl list

# Check status
qubesctl status

# Create and manage containers - edit nixqubes/containers.nix
# Then rebuild: sudo nixos-rebuild switch

# Access container shell
qubesctl shell work

# Run command in container
qubesctl run work "git clone https://example.com/repo"
```

**System Updates**
```bash
# Pull latest changes
git pull origin claude/repo-access-scope-cedp7h

# Apply changes
sudo nixos-rebuild switch -I nixos-config=/etc/nixos/configuration.nix

# Automatic: System rebuilds nightly and collects garbage weekly
```

### Scenario 3: Developer Workflow

**In Dev Container**
```bash
$ qubesctl start dev
$ qubesctl shell dev

[root@dev:~]# git clone https://github.com/project/repo
[root@dev:~]# cd repo
[root@dev:~]# cargo build

# Development happens in complete isolation
# Cannot affect Work or other containers
```

---

## Administration

### Common Administration Tasks

#### Viewing System Status
```bash
# Overall status
qubesctl status

# Container resource usage
machinectl list --output=table

# Network status
nmcli device status
```

#### Restarting Services
```bash
# Restart networking
sudo systemctl restart networking

# Restart a container
sudo systemctl restart systemd-nspawn@work.service

# Check service logs
sudo journalctl -u systemd-nspawn@work.service -n 50
```

#### Managing Containers

**To add a new container:**
1. Edit `nixqubes/containers.nix`
2. Add new container definition (copy from existing)
3. Run: `sudo nixos-rebuild switch`
4. Start with: `qubesctl start <name>`

**To modify container packages:**
1. Edit `nixqubes/containers.nix`
2. Modify `environment.systemPackages` section
3. Run: `sudo nixos-rebuild switch`

**To configure WiFi permanently:**
- Edit inside Net container: `qubesctl shell net`
- Configure with: `nmcli` or Cockpit UI

#### System Maintenance
```bash
# Manual garbage collection
nix-collect-garbage

# Keep only recent generations
nix-collect-garbage -d

# View generations
nix-env --list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

### Monitoring

**System Resources:**
- CPU/Memory: `htop` or Cockpit dashboard
- Disk space: `df -h`
- Container stats: `machinectl status <container>`

**Network:**
- Connection status: `nmcli connection show`
- DNS: `systemctl status systemd-resolved`
- Firewall: `sudo nft list ruleset` (if using nftables)

---

## Troubleshooting

### Container Won't Start
```bash
# Check logs
sudo journalctl -u systemd-nspawn@work.service -n 100

# Verify container exists
machinectl list

# Try rebuilding
sudo nixos-rebuild switch

# Force remove and recreate
sudo rm -rf /var/lib/nixos-containers/work
sudo nixos-rebuild switch
```

### No Internet in Container
```bash
# Check Net container status
qubesctl status net

# Verify Net container is running
qubesctl status

# Check routes
ip route

# Verify DNS
cat /etc/resolv.conf
```

### WiFi Not Connecting (NixQubes)
```bash
# Access Net container
qubesctl shell net

# Check NetworkManager status
nmcli device

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Scan for networks
nmcli device wifi list

# Manual connection
nmcli device wifi connect "SSID" password "PASSWORD"
```

### Slow System Performance
```bash
# Check disk space
df -h

# Check running containers
qubesctl status

# Check resource usage
htop

# Stop unused containers
qubesctl stop <name>

# Perform cleanup
nix-collect-garbage -d
```

### NixOS Rebuild Fails
```bash
# Check for syntax errors
nix-instantiate /etc/nixos/configuration.nix

# View full error
sudo nixos-rebuild switch 2>&1 | tail -50

# Rollback to previous version
sudo nixos-rebuild switch --rollback
```

---

## Architecture Decisions

### Why Containers, Not VMs?
- **Lighter weight** - Milliseconds to start, not seconds
- **Resource efficient** - Shared kernel and /nix/store
- **Reproducible** - NixOS ensures identical setup
- **Manageable** - Single configuration file for all

### Why Qubes-like Isolation?
- **Defense in depth** - Application compartmentalization
- **Practical security** - Real-world threat model focus
- **User-friendly** - Easy to manage and understand
- **Proven model** - Based on Qubes OS principles

### Why NixOS?
- **Declarative** - Configuration as code
- **Reproducible** - Bit-identical rebuilds
- **Atomic** - Updates succeed or fail completely
- **Rollback** - Easy revert to previous versions

---

## Comparison: basic/ vs nixqubes/

| Aspect | basic/ | nixqubes/ |
|--------|--------|-----------|
| **Use Case** | Standard desktop NixOS | Security-focused isolated desktop |
| **Containers** | None | Multiple (work, dev, net, untrusted) |
| **Network** | Host network | Isolated per container, routed through Net |
| **Isolation** | None | Strong (namespace-based) |
| **Complexity** | Low | Medium |
| **Resource Use** | Minimal | Moderate (multiple containers) |
| **WiFi Setup** | Standard NixOS | Through Net container (Cockpit) |
| **User Creation** | Interactive creator account | Same, plus NixQubes admin account |

**Choose basic/ for:** Single-user desktop, minimal overhead, standard setup  
**Choose nixqubes/ for:** Multi-application use, security concerns, isolated workflows

---

## Advanced Topics

### Custom Container Creation
Create a new container by editing `nixqubes/containers.nix`:

```nix
containers.gaming = {
  autoStart = false;
  privateNetwork = true;
  hostAddress = "10.233.4.1";
  localAddress = "10.233.4.2";

  config = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Gaming tools
      steam
      lutris
      wine
    ];

    networking.nameservers = [ "10.233.2.2" ];
    # ... routing configuration
  };
};
```

### Extending with Flakes
NixQubes includes flakes support. To use flakes:

```bash
cd /etc/nixos
nix flake init
nix flake update
nixos-rebuild switch --flake .
```

### Network Policy Customization
Edit `nixqubes/networking.nix` to allow/deny container communication:

```nix
# Allow work-to-dev communication
ip46tables -A FORWARD -i ve-work -o ve-dev -j ACCEPT
```

---

## File Contributions & Git Workflow

### Making Changes
```bash
# Pull latest
git fetch origin

# Create branch
git checkout -b claude/feature-name origin/main

# Make changes
# Edit files...

# Commit
git add .
git commit -m "Description of changes"

# Push
git push -u origin claude/feature-name

# Create PR when ready
```

### Commit Message Format
```
[Type] Brief description

Longer explanation if needed.

Related to: [issue/feature]
```

---

## Getting Help

### Self-Service Documentation
1. **NIXQUBES_SUMMARY.md** - NixQubes-specific details
2. **basic/README.md** - Basic setup documentation
3. **nixqubes/README.md** - Container architecture
4. **bnt/README.md** - Training materials

### External Resources
- NixOS Manual: https://nixos.org/manual/nixos/
- Qubes OS: https://www.qubes-os.org/
- systemd-nspawn: https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html

### Viewing System Logs
```bash
# Recent system logs
journalctl -n 50

# Follow logs
journalctl -f

# Container-specific logs
journalctl -u systemd-nspawn@work.service

# Since specific time
journalctl --since "2 hours ago"
```

---

## Project Status

### Completed ✅
- Basic NixOS configuration (modular)
- User creation system (imperative, survives rebuilds)
- NixQubes container architecture
- Network isolation and routing
- Security hardening
- qubesctl management utility
- Cockpit integration for network UI
- Training materials (TH05 thermodynamics)

### Testing Phase 🔄
- Container isolation verification
- WiFi connectivity through Net container
- qubesctl command functionality
- Multi-container workflows
- System stability under load

### Future Enhancements 🚀
- GUI support in containers (X11/Wayland forwarding)
- MicroVM option (KVM-based VMs instead of containers)
- Web-based container creation UI
- Advanced monitoring dashboard
- VPN integration in Net container

---

## License & Attribution

This project draws inspiration from:
- **Qubes OS** - Security architecture model
- **Mike Kelley's NixBook** - Documentation and structure
- **NixOS** - Declarative system configuration

---

## Contact & Feedback

For issues, questions, or suggestions:
1. Check this README and related documentation
2. Review git commit history for context
3. Check NixOS manual and Qubes OS documentation
4. File issues or create discussions in repo

---

**Last Updated:** July 23, 2026  
**Current Branch:** claude/repo-access-scope-cedp7h  
**Status:** Ready for testing and deployment
