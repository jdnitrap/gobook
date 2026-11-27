# Implementation 3: System Maintenance Hotkeys & Scripts

## Overview
Implemented a comprehensive hotkey-driven maintenance system inspired by Chromebook simplicity and NixBook automation, with the following features:

- **User Creation**: Interactive account creation at login (first install/post-powerwash) and in-session via hotkey
- **System Maintenance Hotkeys**: Desktop-agnostic hotkey bindings for common operations
- **Maintenance Scripts**: Command-line tools for system operations
- **User Notifications**: Desktop notifications for system events

---

## New Files Created

### 1. `hotkeys.nix`
**Purpose**: Consolidated hotkey system using xbindkeys
**Key Features**:
- Five maintenance hotkeys (see reference below)
- Uses Zenity for GUI dialogs and confirmations
- Integrates with polkit for privilege escalation
- Desktop-agnostic (works with any window manager)

**Hotkey Reference**:
```
Ctrl+Esc+Space  → Powerwash (factory reset - wipe home dirs, roll back to gen 1)
Ctrl+Alt+U      → Update system (nixos-rebuild switch)
Ctrl+Alt+R      → Repair & diagnostics (check config, store integrity, disk space)
Ctrl+Alt+G      → List generations (show available system versions for rollback)
Ctrl+Alt+N      → Create new user account (GUI-driven)
```

### 2. `maintenance-scripts.nix`
**Purpose**: Provides command-line tools for system maintenance
**Scripts Available**:
- `system-update` — Update system to latest generation
- `system-update-shutdown` — Update and shutdown
- `list-generations` — Show available system generations
- `system-repair` — Run diagnostics and repair:
  - Check configuration syntax
  - Verify Nix store integrity
  - Show disk space usage
  - Display Nix store size
  - Show system uptime
  - Display recent journal errors
- `create-user` — Interactive user account creation (GUI with password confirmation)

**Usage**:
```bash
system-update
system-repair
list-generations
create-user
```

---

## Modified Files

### 1. `configuration.nix`
**Changes**:
- Replaced `./powerwash.nix` import with `./hotkeys.nix` and `./maintenance-scripts.nix`
- Maintains all existing functionality plus new hotkey system

### 2. `users.nix`
**Changes**:
- Added `creator` system account
- Wired user-create-helper to `creator` login shell
- Displays account creation menu on first login (fresh install or post-powerwash)
- Menu offers: (1) Create new user, (2) Continue to desktop
- Uses imperative Linux method (useradd) for account creation

**Creator Account Features**:
- Automatic menu on login
- Interactive user creation flow
- Exit to desktop option
- Users created this way persist across NixOS rebuilds

---

## User Workflows

### Scenario 1: Fresh Installation
1. Boot system
2. Login as `creator` account
3. Menu appears automatically
4. Option 1: Create new user account (enters name, password, password confirmation)
5. Account created with groups: networkmanager, audio, video, input
6. Logout and login as new user

### Scenario 2: Post-Powerwash (Factory Reset)
1. Boot system (all /home data wiped, system reverted to generation 1)
2. Same flow as Scenario 1

### Scenario 3: Existing User Adds Family Member
1. Press `Ctrl+Alt+N` while logged in
2. GUI dialog appears (or run `create-user` from terminal)
3. Enter username, password, confirm password
4. New user account created immediately
5. New user can logout/login to their account

---

## Design Principles Implemented

### ✅ Chromebook Inspiration
- Simple, discoverable user interface
- Account creation visible at multiple entry points (login screen + hotkey)
- System feels polished and user-friendly
- Minimal technical jargon

### ✅ NixBook Automation
- Automatic user creation menu on first boot
- Hotkey-driven operations
- System diagnostics available on-demand
- Desktop notifications for events

### ✅ GoBook Improvements
- **Modular hotkey system**: Each operation is independent, easy to understand
- **Consistent UX**: Same user creation flow in all scenarios
- **Local-only**: No git-based sync required (you customize in /etc/nixos)
- **Improves on both**: Better UX than raw NixBook, more automated than typical NixOS

---

## Technical Details

### Account Creation Flow
1. GUI dialog prompts for username
2. Checks if username already exists
3. GUI dialogs for password and confirmation
4. Uses `useradd -m -G` to create account with standard groups
5. Uses `chpasswd` to set password
6. User can immediately login

### Hotkey Implementation
- Uses `xbindkeys` for desktop-agnostic hotkey grabbing
- Runs for every X session via `sessionCommands`
- Zenity provides GUI dialogs for confirmations
- `pkexec` handles privilege escalation (triggers polkit auth)
- All operations are non-blocking and user-cancellable

### Maintenance Scripts
- Stateless (no stored configuration)
- Idempotent where possible
- Use absolute paths to tool binaries (NixOS best practice)
- Display results in Zenity info dialogs or terminal output

---

## Notes

### What Changed From Before
1. **Powerwash.nix**: Functionality moved to `hotkeys.nix`, old file no longer imported
   - You can delete `powerwash.nix` if desired (kept for reference)
   - Consider running: `git rm powerwash.nix`

2. **Users.nix**: Now handles creator account setup and user creation integration

3. **Configuration.nix**: Cleaner imports, consolidated maintenance features

### What's NOT Implemented (Kept Modular)
- Git-based config auto-sync (would need explicit permission)
- ISO installer (can be added later)
- Desktop shortcuts for scripts (can be added to desktop-environment.nix)
- Automatic Flatpak app installation (kept optional)

---

## Testing Checklist

Before deploying:
```bash
# 1. Verify syntax
nix-instantiate /etc/nixos/configuration.nix

# 2. Test rebuild (dry-run first)
sudo nixos-rebuild dry-build

# 3. If good, apply changes
sudo nixos-rebuild switch -v

# 4. Test hotkeys (in X session)
Ctrl+Alt+N          # Test new user creation hotkey
Ctrl+Alt+G          # Test list generations
Ctrl+Alt+R          # Test repair dialog
Ctrl+Alt+U          # Test update dialog

# 5. Test creator account
# Logout and login as 'creator', verify menu appears

# 6. Test script commands
system-repair
list-generations
create-user         # Test GUI dialog
```

---

## Files Changed Summary
- ✅ **Created**: `hotkeys.nix`, `maintenance-scripts.nix`, `IMPLEMENTATION_3_SUMMARY.md`
- ✅ **Modified**: `configuration.nix`, `users.nix`
- ⚠️  **Deprecated**: `powerwash.nix` (can be deleted)

---

## Next Steps (Optional)

If you want to extend this further:
1. **Desktop integration**: Add .desktop files for maintenance tools
2. **System tray indicator**: Show update status in system tray
3. **Automated user defaults**: Pre-populate /etc/skel with configs
4. **Email notifications**: For scheduled maintenance (requires mail setup)
5. **Remote management**: SSH-based user management for sysadmins

---

**Status**: Implementation 3 Complete ✓
Hotkey system is modular, maintainable, and ready for real-world testing.
