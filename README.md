# GoBook - Classical NixOS Configuration

**Repository:** gobook  
**Created:** July 2026  
**Status:** Ready for testing (not yet validated)  
**Type:** Modular NixOS configuration using traditional channels (non-flake)

⚠️ **IMPORTANT:** This project is **NOT PRODUCTION READY**. It is in development/testing phase and has NOT been validated through real-world deployment. Use at your own risk. Feedback and bug reports are welcome.

---

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Quick Start](#quick-start)
4. [Directory Structure](#directory-structure)
5. [Installation](#installation)
6. [Usage](#usage)
7. [Troubleshooting](#troubleshooting)

---

## Overview

GoBook is a modular, declarative NixOS configuration using traditional channels (not flakes). It provides a reproducible, minimal system setup with a focus on clean separation of concerns through modular configuration files.

This is a **classical NixOS setup** - no flakes, no bleeding-edge experimental features. Just solid, reproducible configuration management through NixOS channels.

---

## Features

✅ **Modular Configuration** - Separate concerns into individual `.nix` files  
✅ **Default Admin User** - admin/a account for first login  
⚠️ **User Creation** - Implemented but NOT FULLY TESTED/VALIDATED  
⚠️ **System Hotkeys** - Configured but NOT FULLY TESTED/VALIDATED  
✅ **Desktop Environment** - Cinnamon + LightDM  
✅ **Security Hardening** - Security policies and protections  
✅ **Automatic Updates** - Nightly system rebuilds and garbage collection  
✅ **Flatpak Support** - Container app support  
✅ **Audio & Multimedia** - PipeWire audio, printer/scanner support  
✅ **Classical NixOS** - Traditional channels, no flakes needed

---

## Quick Start

### Prerequisites
- NixOS 26.05+ system
- EFI-based boot
- 20GB+ disk space
- 4GB+ RAM

### Installation Steps

1. **Generate hardware configuration:**
   ```bash
   sudo nixos-generate-config --show-hardware-config > /tmp/hw-config.nix
   ```

2. **Copy to gobook directory:**
   ```bash
   sudo cp /tmp/hw-config.nix /home/John/github-projects/gobook/hardware-configuration.nix
   ```

3. **Apply the configuration:**
   ```bash
   cd /home/John/github-projects/gobook
   sudo nixos-rebuild switch -I nixos-config=$PWD/configuration.nix
   ```

### First Login

After the system builds:
1. **Login as `admin`** with password `a`
2. **Desktop environment loads** - Cinnamon desktop with LightDM

⚠️ **User Creation:** Hotkey and automated user creation features are NOT YET TESTED. Additional users must be created using standard NixOS methods or CLI tools.

## Directory Structure

```
gobook/                              (Repository root)
│
├── README.md                         ← YOU ARE HERE
├── configuration.nix                 (Main configuration - imports all modules)
├── hardware-configuration.nix        (Machine-specific - GENERATED)
├── users.nix                         (User account management)
├── user-create-helper.nix            (Interactive user creation script)
├── system-packages.nix               (System packages and fonts)
├── desktop-environment.nix           (Cinnamon + LightDM)
├── sound.nix                         (PipeWire audio)
├── networking.nix                    (Network setup)
├── system-setup.nix                  (Locale, timezone, keyboard)
├── firstboot-setup.nix               (First-boot setup service)
├── auto-upgrade.nix                  (Automatic system updates at 04:00)
├── auto-gc.nix                       (Automatic garbage collection)
├── keep-first-generation.nix         (Preserve first generation as gc-root)
├── hotkeys.nix                       (System maintenance hotkeys)
├── maintenance-scripts.nix           (Maintenance scripts and tools)
├── flatpak.nix                       (Flatpak support)
├── printer-scanner.nix               (Printer and scanner support)
├── IMPLEMENTATION_3_SUMMARY.md       (Implementation notes)
├── pkgs/                             (Custom packages directory)
├── .git/                             (Version control)
└── .gitignore                        (Git ignore rules)
```

## Installation

### Generate and Copy Hardware Configuration

```bash
# Generate your hardware-specific config
sudo nixos-generate-config --show-hardware-config > /tmp/hw-config.nix

# Copy to the basic directory
sudo cp /tmp/hw-config.nix /etc/nixos/basic/hardware-configuration.nix
```

### Deploy the Configuration

```bash
# Copy all configuration files
sudo cp /home/John/github-projects/gobook/*.nix /etc/nixos/

# Generate hardware config if not already done
sudo nixos-generate-config --show-hardware-config > /tmp/hw.nix
sudo cp /tmp/hw.nix /etc/nixos/hardware-configuration.nix

# Build and switch to new configuration
sudo nixos-rebuild switch
```

### Create Users

After rebuild, login with default credentials:
- **Username**: `admin`
- **Password**: `a`

Then press `Ctrl+Alt+N` to create your own user account.

## Usage

### System Maintenance Hotkeys

⚠️ **NOT YET TESTED** - The following hotkeys are configured but NOT VALIDATED:

| Hotkey | Function | Expected Behavior |
|--------|----------|-------------------|
| `Ctrl+Alt+N` | Create User | ⚠️ Interactive menu to create new user (NOT TESTED) |
| `Ctrl+Alt+U` | Update System | ⚠️ Update NixOS to latest generation (NOT TESTED) |
| `Ctrl+Alt+R` | Repair System | ⚠️ Run diagnostics and repair checks (NOT TESTED) |
| `Ctrl+Alt+G` | List Generations | ⚠️ Show available system generations (NOT TESTED) |
| `Ctrl+Esc+Space` | Powerwash | ⚠️ Factory reset system (NOT TESTED) |

### Add a New User

**Using standard NixOS method:**
```bash
# As admin user with sudo access
sudo useradd -m -s /bin/bash <username>
sudo passwd <username>

# Or use declarative configuration in users.nix
```

**Automated approaches (configured but NOT TESTED):**
- Hotkey `Ctrl+Alt+N` - may or may not work
- Command `create-user` - may or may not work
- First-boot setup service - does not currently work

### System Updates

Edit any configuration files in `/etc/nixos/`:

```bash
# Apply changes
sudo nixos-rebuild switch

# View build log
sudo nixos-rebuild switch -v

# Rollback to previous generation if needed
sudo nixos-rebuild switch --rollback
```

**Automatic maintenance:**
- System rebuilds nightly (can be customized)
- Garbage collection runs weekly
- Old generations are preserved for rollback

## Maintenance

### Manual Garbage Collection

```bash
# Collect unused store paths
nix-collect-garbage

# Remove all old generations (aggressive)
nix-collect-garbage -d

# View all generations
nix-env --list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

### System Configuration

**To modify the system:**
1. Edit configuration files in `/etc/nixos/`
2. Run: `sudo nixos-rebuild switch`
3. Changes take effect immediately

**Configuration is modular:**
- `configuration.nix` - Imports and main settings
- Individual `.nix` files - Each handles one concern
- Edit the appropriate file for your change
- Run `nixos-rebuild switch` to apply

### User Management

**Create users:**
- Login as `creator` account
- Select "1. Create a new user" from menu

**Users are persistent:**
- Survive NixOS rebuilds
- Home directories stored in `/root` (mutable state)

## Implementation Notes

### Status: NOT YET PRODUCTION READY

⚠️ **Important:** This configuration has NOT been fully tested in real-world deployment. The following features are CONFIGURED but NOT VALIDATED:

1. **User Creation Hotkey** (`Ctrl+Alt+N`)
   - Configured in hotkeys.nix
   - Expected: Create user via interactive menu
   - Status: **NOT TESTED** - may not work as expected
   - Configuration present but requires validation

2. **System Maintenance Hotkeys** (`Ctrl+Alt+U`, `R`, `G`, `Ctrl+Esc+Space`)
   - Configured in hotkeys.nix
   - Expected: System update, repair, list generations, powerwash
   - Status: **NOT TESTED** - may not work as expected
   - Configuration present but requires validation

3. **First-Boot Setup Service**
   - Configured in firstboot-setup.nix
   - Expected: Interactive setup on first boot
   - Status: **NOT WORKING** - multiple approaches attempted
   - Challenges: systemd TTY handling, display manager interference

### Known Working Features

✅ **Configuration compiles successfully** - All .nix files validated
✅ **VM builds without errors** - System can be built
✅ **Admin account exists** - Default login: admin/a
✅ **Desktop environment loads** - Cinnamon + LightDM available
✅ **System structure is sound** - Modular and organized

### What Needs Testing/Fixing

❌ User creation workflow - needs real-world validation
❌ Hotkey system - needs real-world validation  
❌ First-boot setup - architecture not working as intended
❌ User creation from display manager - LightDM architectural limitation
❌ Full feature validation - end-to-end testing required

---

## Troubleshooting

### NixOS Rebuild Fails

**Check for syntax errors:**
```bash
nix-instantiate /etc/nixos/configuration.nix
```

**View full error output:**
```bash
sudo nixos-rebuild switch 2>&1 | tail -50
```

**Rollback to previous version:**
```bash
sudo nixos-rebuild switch --rollback
```

### Disk Space Issues

**Check available space:**
```bash
df -h

# Check Nix store size
du -sh /nix/store
```

**Clean up old generations:**
```bash
nix-collect-garbage -d
```

### Hardware or Boot Issues

**Check boot logs:**
```bash
journalctl -b
```

**Check if system is using correct configuration:**
```bash
nixos-version
```

**Verify hardware configuration:**
```bash
cat /etc/nixos/hardware-configuration.nix
```

## Design Philosophy

**Declarative** - Configuration as code, committed to version control  
**Reproducible** - Identical rebuilds every time, bit-for-bit  
**Modular** - Separate files by concern for easy maintenance  
**Classical** - Traditional NixOS channels, not experimental features  
**User-Focused** - Interactive tools, persistent user accounts  
**Minimal** - Only what you need, nothing forced

## Customization

### Adding System Packages

Edit `basic/system-packages.nix`:

```nix
environment.systemPackages = with pkgs; [
  # Existing packages...
  your-new-package
];
```

Then run: `sudo nixos-rebuild switch`

### Enabling Services

Edit `basic/system-setup.nix` or create a new module:

```nix
services.your-service.enable = true;
```

Then run: `sudo nixos-rebuild switch`

### Customizing Users

Edit `basic/users.nix` to adjust user defaults, groups, or permissions.

### Modifying Desktop Environment

Edit `basic/desktop-environment.nix` to change:
- Display manager (currently LightDM)
- Desktop environment (currently Cinnamon)
- Session options

## Resources

**NixOS Documentation:**
- [NixOS Manual](https://nixos.org/manual/nixos/)
- [NixOS Wiki](https://wiki.nixos.org/)
- [nixpkgs Manual](https://nixos.org/manual/nixpkgs/)

**Configuration Examples:**
- Comments in each `.nix` file in `basic/`
- Configuration.nix(5) man page on your system
- NixOS options search: https://search.nixos.org/

**Community:**
- NixOS Discourse: https://discourse.nixos.org/
- NixOS Wiki Community: https://wiki.nixos.org/

## Status

**GoBook - Classical NixOS Configuration**  
🔄 Ready for Testing

**What's implemented:**
- ✅ Modular configuration system
- ✅ User account management with persistence
- ✅ Desktop environment (Cinnamon + LightDM)
- ✅ Security hardening
- ✅ Automatic system updates and garbage collection
- ✅ Printer/scanner support
- ✅ Audio and multimedia support

**What's tested:**
- ✅ Configuration syntax and structure
- ✅ Build process and module loading

**What still needs real-world validation:**
- ❌ Full hardware deployment
- ❌ Long-term stability
- ❌ Performance in various environments
- ❌ User workflow verification

## Feedback & Testing

This configuration needs real-world testing. If you use GoBook:

1. **Report bugs** - Open an issue with error messages and steps to reproduce
2. **Share successes** - What hardware/setup works well?
3. **Suggest improvements** - What features would help?
4. **Test thoroughly** - Before deploying to production
5. **Have a rollback plan** - Keep recovery media handy

Your feedback helps improve the configuration for everyone.

## Contributing

To contribute improvements:

1. Test changes thoroughly on actual hardware
2. Create a descriptive commit message
3. Explain why the change is needed
4. Keep changes focused and minimal
5. Push to main branch

**Before committing:**
- Verify syntax: `nix-instantiate /etc/nixos/basic/configuration.nix`
- Test the full rebuild: `sudo nixos-rebuild switch`
- Document any new options in comments

## Attribution

Drawing inspiration from:
- **Mike Kelley's NixBook** - Documentation and configuration approach
- **NixOS** - Declarative configuration paradigm
- **NixOS Community** - Best practices and examples

**Repository:** gobook  
**Type:** Classical NixOS (channels-based, non-flake)  
**Last Updated:** November 26, 2026  
**Branch:** main  
**Status:** Ready for testing (awaiting real-world validation)
