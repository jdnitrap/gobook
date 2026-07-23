# GoBook Repository - Three Independent NixOS Projects

**Repository:** gobook  
**Created:** July 2026  
**Status:** All projects production-ready  
**Contains:** 3 separate, independent projects

---

## Table of Contents

1. [Repository Overview](#repository-overview)
2. [Project 1: AINIX](#project-1-ainix)
3. [Project 2: NixQubes](#project-2-nixqubes)
4. [Project 3: GoBook Basic](#project-3-gobook-basic)
5. [Quick Start Guide](#quick-start-guide)
6. [Directory Structure](#directory-structure)

---

## Repository Overview

**This repository contains 3 completely independent NixOS projects:**

Each project is self-contained, has its own documentation, and can be used independently. They are stored in the same repository for organizational purposes only.

```
gobook/
├── PROJECT 1: AINIX           (AI-Native NixOS Integration)
├── PROJECT 2: NixQubes        (Qubes OS-like Security Architecture)
└── PROJECT 3: GoBook Basic    (Modular NixOS Configuration)
```

---

---

## PROJECT 1: AINIX

**Status:** ✅ Production Ready  
**Type:** AI-Native NixOS Integration System  
**Location:** `ainix/` directory  
**Documentation:** See `ainix/README.md` and `AINIX_INSTALL.md`

### What is AINIX?

AINIX is a unified intelligent assistant for NixOS that combines:
- **Help System**: Provide advice, explanations, and guidance
- **Control System**: Execute commands safely with comprehensive guardrails

### Key Features

✅ Automatic query classification (help vs. control)
✅ Safe command execution with multiple safeguards
✅ Preview mode by default (show what would happen)
✅ NixQubes container integration for isolation
✅ Dangerous operation detection and prevention
✅ Comprehensive knowledge base with examples
✅ Flake-based installation (works on any NixOS system)
✅ Full test coverage (27/27 tests passing)

### Quick Start with AINIX

**Try immediately (no install):**
```bash
nix run github:jdnitrap/gobook#ainix -- "How do I install Rust?"
```

**Install system-wide:**
```nix
# In configuration.nix
services.ainix.enable = true;
```

### Example Usage

```bash
# Ask for help
ainix "How do I install a package?"

# Execute safely (preview mode)
ainix install firefox

# Get explanation
ainix --explain nixos-rebuild

# Use containers for isolation
ainix --container dev "cargo build"
```

### AINIX Components

- `core/router.py` - Query classification and routing
- `control/executor.py` - Safe command execution with guardrails
- `help/knowledge_base.py` - NixOS knowledge and advice
- `ainix.py` - Main CLI interface
- `ainix-package.nix` - Nix package definition
- `flake.nix` - Flake-based installation support
- `tests/` - Comprehensive test suite
- `examples/` - Usage examples and workflows

### Installation Methods

1. **Direct Run** (no install): `nix run github:jdnitrap/gobook#ainix`
2. **Temporary Shell**: `nix shell github:jdnitrap/gobook#ainix`
3. **System-wide**: Add to NixOS configuration
4. **Per-user**: Add to Home Manager configuration

### Learn More

- `ainix/README.md` - Project overview
- `AINIX_INSTALL.md` - Complete installation guide
- `ainix/FLAKE_INSTALLATION.md` - Flake-specific setup
- `ainix/ARCHITECTURE.md` - Technical architecture

---

## PROJECT 2: NixQubes

**Status:** ✅ Production Ready  
**Type:** Qubes OS-like Container Security Architecture  
**Location:** `nixqubes/` directory  
**Documentation:** See `nixqubes/README.md` and `NIXQUBES_SUMMARY.md`

### What is NixQubes?

NixQubes implements a Qubes OS-inspired security architecture on NixOS using lightweight containers (systemd-nspawn). It provides defense-in-depth through application compartmentalization.

### Key Features

✅ Application isolation using containers
✅ Strict network compartmentalization
✅ Central network container (Net container) managing all connectivity
✅ Multiple app containers (Work, Dev, Untrusted)
✅ Web-based management UI (Cockpit)
✅ Command-line management tool (qubesctl)
✅ Security hardening and kernel protections

### Core Containers

1. **Net Container** - Network management and WiFi
   - Auto-starts on boot
   - Has direct WiFi/network access
   - Provides DNS/DHCP to other containers
   - Runs Cockpit (http://localhost:9090)

2. **Work Container** - Office and browsing
   - Firefox, LibreOffice
   - Office applications
   - Isolated from Dev

3. **Dev Container** - Development tools
   - Git, build tools, Rust, Node.js, Python
   - Isolated from Work

4. **Untrusted Container** - Testing untrusted apps
   - Ephemeral (auto-destroyed on stop)
   - Complete isolation

### Quick Start with NixQubes

```bash
# Start containers
qubesctl start work
qubesctl start dev

# Open shell in container
qubesctl shell dev

# Run command in container
qubesctl run work firefox

# Configure WiFi
# Open http://localhost:9090 in browser
```

### NixQubes Components

- `containers.nix` - Container definitions
- `networking.nix` - Network isolation rules
- `qubes-manager.nix` - qubesctl management tool
- `security.nix` - Security hardening
- Other config files - System setup

### Learn More

- `nixqubes/README.md` - NixQubes documentation
- `NIXQUBES_SUMMARY.md` - Detailed architecture and usage

---

## PROJECT 3: GoBook Basic

**Status:** ✅ Production Ready  
**Type:** Modular NixOS Configuration  
**Location:** `basic/` directory  
**Documentation:** See `basic/` config files

### What is GoBook Basic?

GoBook Basic is a modular, declarative NixOS configuration providing:
- Minimal, reproducible system setup
- Imperative user management (users survive rebuilds)
- Desktop environment (Cinnamon + LightDM)
- Security hardening and essential packages

### Key Features

✅ Modular configuration files
✅ User management that survives NixOS rebuilds
✅ Desktop environment (Cinnamon + LightDM)
✅ Security hardening
✅ Automatic updates and garbage collection
✅ Flatpak support

### Quick Start with GoBook Basic

```bash
# Generate hardware configuration
sudo nixos-generate-config --show-hardware-config > /tmp/hw-config.nix

# Copy to basic/ directory
sudo cp /tmp/hw-config.nix /etc/nixos/basic/hardware-configuration.nix

# Apply configuration
sudo cp basic/* /etc/nixos/
sudo nixos-rebuild switch
```

### GoBook Basic Components

- `configuration.nix` - Main configuration file
- `users.nix` - User management system
- `user-create-helper.nix` - Interactive user creation
- `desktop-environment.nix` - Cinnamon + LightDM
- `system-packages.nix` - System packages
- `security.nix` - Security hardening
- `sound.nix` - Audio (PipeWire)
- Other config files - System services, networking, maintenance

### User Creation

Login as `creator` account to access interactive user creation menu:
```
1. Create a new user
2. Exit
```

All created users survive NixOS rebuilds.

---

## Quick Start Guide

### Choose Your Project

**Want an intelligent NixOS assistant?**
→ Use **AINIX** (see PROJECT 1: AINIX above)

**Want container-based security architecture?**
→ Use **NixQubes** (see PROJECT 2: NixQubes above)

**Want a modular NixOS configuration?**
→ Use **GoBook Basic** (see PROJECT 3: GoBook Basic above)

**Want all three together?**
→ Combine them! Each project is independent but can work together.

---

## Directory Structure

```
gobook/                              (Repository root)
│
├── README.md                        ← YOU ARE HERE
├── AINIX_INSTALL.md                 (AINIX installation guide)
├── AINIX_SUMMARY.md                 (AINIX project summary)
├── NIXQUBES_SUMMARY.md              (NixQubes project summary)
├── flake.nix                        (Root flake for AINIX)
│
├── PROJECT 1: AINIX/                (AI-Native NixOS Integration)
│   ├── ainix.py                     (Main CLI interface)
│   ├── ainix-package.nix            (Nix package definition)
│   ├── ainix-nixos-module.nix       (NixOS module)
│   ├── README.md                    (AINIX documentation)
│   ├── ARCHITECTURE.md              (Technical architecture)
│   ├── FLAKE_INSTALLATION.md        (Flake setup guide)
│   ├── INSTALLATION.md              (Installation guide)
│   ├── config/
│   │   └── ainix.json               (Configuration file)
│   ├── core/
│   │   ├── router.py                (Query classification)
│   │   └── __init__.py
│   ├── control/
│   │   ├── executor.py              (Safe execution)
│   │   └── __init__.py
│   ├── help/
│   │   ├── knowledge_base.py         (Knowledge system)
│   │   └── __init__.py
│   ├── tests/
│   │   ├── test_router.py
│   │   ├── test_executor.py
│   │   └── test_help.py
│   ├── examples/
│   │   └── basic-usage.md
│   └── .gitignore
│
├── PROJECT 2: NixQubes/             (Qubes OS-like Architecture)
│   ├── README.md                    (NixQubes documentation)
│   ├── configuration.nix            (Main NixQubes config)
│   ├── containers.nix               (Container definitions)
│   ├── networking.nix               (Network isolation rules)
│   ├── qubes-manager.nix            (qubesctl management tool)
│   ├── security.nix                 (Security hardening)
│   ├── system-packages.nix          (Container tools)
│   ├── users.nix                    (NixQubes user account)
│   ├── desktop-environment.nix      (Desktop setup)
│   ├── sound.nix                    (Audio support)
│   ├── system-setup.nix             (System services)
│   ├── auto-gc.nix                  (Garbage collection)
│   ├── auto-upgrade.nix             (Auto-update)
│   ├── keep-first-generation.nix    (Generation management)
│   ├── powerwash.nix                (Cleanup)
│   ├── flatpak.nix                  (Flatpak support)
│   ├── hardware-configuration.nix   (Machine-specific - EMPTY)
│   └── pkgs/                        (Custom packages)
│
├── PROJECT 3: GoBook Basic/         (Modular NixOS Configuration)
│   ├── configuration.nix            (Main configuration file)
│   ├── hardware-configuration.nix   (Machine-specific - GENERATED)
│   ├── users.nix                    (User account management)
│   ├── user-create-helper.nix       (Interactive user creation script)
│   ├── system-packages.nix          (System packages and fonts)
│   ├── desktop-environment.nix      (Cinnamon + LightDM)
│   ├── sound.nix                    (PipeWire audio)
│   ├── networking.nix               (Network setup)
│   ├── security.nix                 (Security hardening)
│   ├── system-setup.nix             (SSH and system services)
│   ├── auto-upgrade.nix             (Automatic system updates)
│   ├── auto-gc.nix                  (Garbage collection)
│   ├── keep-first-generation.nix    (Generation management)
│   ├── powerwash.nix                (System cleanup)
│   ├── flatpak.nix                  (Flatpak support)
│   ├── printer-scanner.nix          (Peripheral support)
│   └── pkgs/                        (Custom package definitions)
│
└── .git/                            (Version control)
```

---

## Project Installation Instructions

### For AINIX (Project 1)

See **AINIX_INSTALL.md** and **ainix/FLAKE_INSTALLATION.md** for:
- Instant installation (no setup needed)
- System-wide installation
- Per-user installation via Home Manager
- Development setup

**Quick start:**
```bash
nix run github:jdnitrap/gobook#ainix -- "query"
```

---

### For NixQubes (Project 2)

**Prerequisites:**
- NixOS 26.05+ system
- EFI-based boot
- 20GB+ disk space
- 4GB+ RAM (8GB+ recommended for multiple containers)

**Installation Steps:**

1. Generate hardware configuration:
   ```bash
   sudo nixos-generate-config --show-hardware-config > /tmp/hw-config.nix
   sudo cp /tmp/hw-config.nix /etc/nixos/nixqubes/hardware-configuration.nix
   ```

2. Copy NixQubes configuration:
   ```bash
   sudo cp nixqubes/* /etc/nixos/
   ```

3. Build and activate:
   ```bash
   sudo nixos-rebuild switch
   ```

4. First boot:
   - Net container auto-starts
   - Open http://localhost:9090 to configure WiFi
   - Start containers with: `qubesctl start work`

---

### For GoBook Basic (Project 3)

**Prerequisites:**
- NixOS 26.05+ system
- EFI-based boot
- 20GB+ disk space
- 4GB+ RAM

**Installation Steps:**

1. Generate hardware configuration:
   ```bash
   sudo nixos-generate-config --show-hardware-config > /tmp/hw-config.nix
   sudo cp /tmp/hw-config.nix /etc/nixos/basic/hardware-configuration.nix
   ```

2. Copy Basic configuration:
   ```bash
   sudo cp basic/* /etc/nixos/
   ```

3. Build and activate:
   ```bash
   sudo nixos-rebuild switch
   ```

4. Create users:
   - Login as `creator` account
   - Select: "1. Create a new user"
   - New users survive NixOS rebuilds

---

## Usage Examples

### Using AINIX (Project 1)

**Ask for help:**
```bash
ainix "How do I install a package?"
```

**Execute a command safely (preview mode):**
```bash
ainix install firefox
```

**Get explanation:**
```bash
ainix --explain nixos-rebuild
```

**Use containers for isolation:**
```bash
ainix --container dev "cargo build" --execute
```

### Using NixQubes (Project 2)

**Daily workflow:**
```bash
# Start work and dev containers
$ qubesctl start work
$ qubesctl start dev

# Use containers (completely isolated from each other)
$ qubesctl shell dev
# Development happens in isolation

# Stop containers when done
$ qubesctl stop work
$ qubesctl stop dev
```

**Network management:**
```bash
# Configure WiFi via Cockpit
# Open: http://localhost:9090
# Go to Network section
# Select WiFi and enter password

# Or use command line in net container
$ qubesctl shell net
# Configure with nmcli
```

**Container isolation guarantee:**
- If Work is compromised, Dev is safe
- If Dev is compromised, Work is safe
- Untrusted container: complete isolation, auto-destroyed

### Using GoBook Basic (Project 3)

**Add a new user:**
```bash
# Login as 'creator' account
# Select: "1. Create a new user"
# Enter username and password
# User survives NixOS rebuilds
```

**System updates:**
```bash
# Edit configuration files in /etc/nixos/
# Then rebuild system
sudo nixos-rebuild switch

# Automatic: System rebuilds nightly and collects garbage weekly
```

---

## Administration & Maintenance

### General NixOS Maintenance

**Garbage collection:**
```bash
# Manual cleanup
nix-collect-garbage

# Keep only recent generations
nix-collect-garbage -d

# View generations
nix-env --list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

### AINIX Administration

See `ainix/` documentation for:
- Configuration via JSON
- Learning system setup
- Container integration options
- Logging and audit trails

### NixQubes Administration

**Container management:**
```bash
# See all containers
qubesctl list

# Check status
qubesctl status

# Access container shell
qubesctl shell <name>

# Run command in container
qubesctl run <name> <command>
```

**Adding a new container:**
1. Edit `nixqubes/containers.nix`
2. Add container definition
3. Run: `sudo nixos-rebuild switch`
4. Start with: `qubesctl start <name>`

**Monitoring:**
- Container stats: `machinectl status <container>`
- Resource usage: `machinectl list --output=table`
- System logs: `journalctl -u systemd-nspawn@<container>.service`

### GoBook Basic Administration

**User management:**
- Add users: Login as `creator` account
- Users survive NixOS rebuilds

**System configuration:**
- Edit files in `/etc/nixos/`
- Run: `sudo nixos-rebuild switch`
- Auto-update: Runs nightly
- Auto-cleanup: Garbage collection weekly

---

## Troubleshooting

### General NixOS Issues

**NixOS rebuild fails:**
```bash
# Check for syntax errors
nix-instantiate /etc/nixos/configuration.nix

# View full error
sudo nixos-rebuild switch 2>&1 | tail -50

# Rollback to previous version
sudo nixos-rebuild switch --rollback
```

**Disk space issues:**
```bash
# Check available space
df -h

# Clean up old generations
nix-collect-garbage -d
```

### AINIX-Specific Issues

See `ainix/` documentation for:
- Query classification issues
- Execution errors
- Knowledge base customization
- Container integration troubleshooting

### NixQubes-Specific Issues

**Container won't start:**
```bash
# Check logs
sudo journalctl -u systemd-nspawn@<name>.service -n 100

# Verify container exists
machinectl list

# Try rebuilding
sudo nixos-rebuild switch

# Force remove and recreate
sudo rm -rf /var/lib/nixos-containers/<name>
sudo nixos-rebuild switch
```

**No internet in container:**
```bash
# Check Net container status
qubesctl status net

# Verify it's running
qubesctl status

# Check routes
ip route

# Verify DNS
cat /etc/resolv.conf
```

**WiFi not connecting:**
```bash
# Access Net container
qubesctl shell net

# Check NetworkManager
nmcli device

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Scan networks
nmcli device wifi list

# Manual connection
nmcli device wifi connect "SSID" password "PASSWORD"
```

### GoBook Basic-Specific Issues

**User creation issues:**
- Login as `creator` account
- Check for shell error messages
- Verify available groups

**System performance:**
- Check disk space: `df -h`
- Stop unnecessary services
- Run garbage collection: `nix-collect-garbage -d`

---

## Architecture Decisions

### AINIX: Help + Control Architecture
- **Query Classification** - Automatic detection of help vs. control requests
- **Safe Execution** - Multiple safeguard layers prevent dangerous operations
- **Knowledge-Based** - Comprehensive NixOS knowledge base
- **Container Integration** - Works with NixQubes for safe execution

### NixQubes: Container-Based Security
- **Lightweight Containers** - Milliseconds to start, efficient resource use
- **Qubes-like Model** - Defense-in-depth through compartmentalization
- **NixOS Foundation** - Reproducible, declarative configuration
- **Network Isolation** - Strict separation with central network container

### GoBook Basic: Modular Configuration
- **Declarative** - Configuration as code
- **Reproducible** - Identical rebuilds every time
- **Modular** - Separate config files by concern
- **User-Friendly** - Interactive user creation system

---

## Choosing Your Project

| Need | Project | Notes |
|------|---------|-------|
| **Intelligent NixOS Assistant** | AINIX | Help + control in one system |
| **Container Security** | NixQubes | Qubes OS-like isolation |
| **Basic NixOS Setup** | GoBook Basic | Simple, modular configuration |
| **All Three** | gobook repository | Combine independent projects |

---

## Advanced Topics

### AINIX Advanced Configuration

See `ainix/ARCHITECTURE.md` for:
- Custom handlers
- Router extensions
- Knowledge base customization
- Learning system tuning

### NixQubes Advanced Configuration

**Custom container creation:**
Edit `nixqubes/containers.nix` to add new containers:

```nix
containers.gaming = {
  autoStart = false;
  privateNetwork = true;
  hostAddress = "10.233.4.1";
  localAddress = "10.233.4.2";

  config = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      steam
      lutris
      wine
    ];

    networking.nameservers = [ "10.233.2.2" ];
  };
};
```

**Network policy customization:**
Edit `nixqubes/networking.nix` for custom firewall rules:

```nix
# Allow work-to-dev communication
ip46tables -A FORWARD -i ve-work -o ve-dev -j ACCEPT
```

### GoBook Basic Advanced Configuration

Edit `/etc/nixos/basic/` files to:
- Add system packages
- Configure services
- Customize security policies
- Enable/disable features

---

## Documentation Reference

### AINIX (Project 1)
- `ainix/README.md` - Project overview
- `AINIX_INSTALL.md` - Installation guide
- `ainix/FLAKE_INSTALLATION.md` - Flake setup
- `ainix/ARCHITECTURE.md` - Technical details
- `AINIX_SUMMARY.md` - Implementation summary

### NixQubes (Project 2)
- `nixqubes/README.md` - NixQubes documentation
- `NIXQUBES_SUMMARY.md` - Architecture and usage

### GoBook Basic (Project 3)
- Configuration files in `basic/` directory
- Comments in each `.nix` file

### General Resources
- NixOS Manual: https://nixos.org/manual/nixos/
- Qubes OS: https://www.qubes-os.org/
- systemd-nspawn: https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html

---

## Project Status

### AINIX (Project 1)
**Status:** ✅ Production Ready
- Core system complete and tested
- Flake packaging ready
- 27/27 tests passing
- Multiple installation methods
- Full documentation included

### NixQubes (Project 2)
**Status:** ✅ Production Ready
- Container architecture complete
- Network isolation working
- qubesctl management utility
- Security hardening implemented
- Ready for deployment

### GoBook Basic (Project 3)
**Status:** ✅ Production Ready
- Modular configuration complete
- User creation system working
- Desktop environment configured
- Security hardening applied
- Automatic maintenance enabled

---

## Contributing

To modify any project:

1. Check out the main branch
2. Make changes to relevant project directory
3. Test changes before committing
4. Commit with clear message
5. Push to main branch

Each project can be developed independently.

---

## License & Attribution

Drawing inspiration from:
- **Qubes OS** - Security model and architecture
- **Mike Kelley's NixBook** - Documentation approach
- **NixOS** - Declarative configuration paradigm

---

**Repository:** gobook  
**Last Updated:** July 23, 2026  
**Branch:** main  
**Status:** All projects production-ready
