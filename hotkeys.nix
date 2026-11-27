{ config, pkgs, ... }:

let

  #######################
  # Maintenance Hotkeys  #
  #######################

  # Factory reset: rolls back to first generation, wipes all /home
  powerwashScript = pkgs.writeShellScript "powerwash" ''
    set -euo pipefail

    profile=/nix/var/nix/profiles/system

    first=$(${pkgs.nix}/bin/nix-env -p "$profile" --list-generations \
      | ${pkgs.gawk}/bin/awk '{print $1}' | head -n1)

    ${pkgs.nix}/bin/nix-env -p "$profile" --switch-generation "$first"
    "$profile"/bin/switch-to-configuration boot

    for home in /home/*; do
      [ -d "$home" ] || continue
      ${pkgs.findutils}/bin/find "$home" -mindepth 1 -delete
    done

    ${pkgs.systemd}/bin/systemctl reboot
  '';

  powerwashConfirm = pkgs.writeShellScript "powerwash-confirm" ''
    set -euo pipefail

    if ${pkgs.zenity}/bin/zenity --question --title="Powerwash (Factory Reset)" \
      --text="This erases ALL user data and rolls the system back to its first generation.\n\nThis is like a factory reset. This cannot be undone.\n\nContinue?" \
      --width=420
    then
      exec ${pkgs.polkit}/bin/pkexec ${powerwashScript}
    fi
  '';

  # System update
  updateConfirm = pkgs.writeShellScript "update-confirm" ''
    set -euo pipefail

    if ${pkgs.zenity}/bin/zenity --question --title="System Update" \
      --text="Update NixOS system to the latest generation?\n\nThis may take several minutes." \
      --width=350
    then
      ${pkgs.libnotify}/bin/notify-send "System Update" "Starting system update..." --icon=system-software-update

      if sudo nixos-rebuild switch 2>&1 | ${pkgs.zenity}/bin/zenity --progress --pulsate --title="System Update" --text="Updating system..." --no-cancel --width=400
      then
        ${pkgs.libnotify}/bin/notify-send "System Update" "Update completed successfully!" --icon=dialog-information
      else
        ${pkgs.zenity}/bin/zenity --error --title="Update Failed" --text="System update failed. Check logs for details." --width=350
      fi
    fi
  '';

  # System repair and diagnostics
  repairConfirm = pkgs.writeShellScript "repair-confirm" ''
    set -euo pipefail

    if ${pkgs.zenity}/bin/zenity --question --title="System Repair & Diagnostics" \
      --text="Run system repair and diagnostics?\n\nThis will check configuration and store integrity." \
      --width=350
    then
      ${pkgs.libnotify}/bin/notify-send "System Repair" "Starting diagnostics..." --icon=system-help
      system-repair
    fi
  '';

  # List generations for rollback
  listGenConfirm = pkgs.writeShellScript "list-gen-confirm" ''
    set -euo pipefail
    list-generations
  '';

  # Create new user
  createUserConfirm = pkgs.writeShellScript "create-user-confirm" ''
    set -euo pipefail
    create-user
  '';

  # Consolidated xbindkeys configuration
  xbindkeysConfig = pkgs.writeText "xbindkeysrc" ''
    # Powerwash (Factory Reset)
    # Ctrl+Esc+Space - Full system reset with data wipe
    "${powerwashConfirm}"
        Control + Escape + space

    # System Update
    # Ctrl+Alt+U - Update system to latest generation
    "${updateConfirm}"
        Control + alt + u

    # System Repair
    # Ctrl+Alt+R - Run diagnostics and repair
    "${repairConfirm}"
        Control + alt + r

    # List Generations
    # Ctrl+Alt+G - Show available system generations for rollback
    "${listGenConfirm}"
        Control + alt + g

    # Create New User
    # Ctrl+Alt+N - Create a new user account
    "${createUserConfirm}"
        Control + alt + n
  '';

in

{

##########################################################
#System Maintenance Hotkeys (Chromebook-inspired)       #
##########################################################
#
# Hotkey Reference:
#   Ctrl+Esc+Space  → Powerwash (factory reset)
#   Ctrl+Alt+U      → Update system
#   Ctrl+Alt+R      → Repair & diagnostics
#   Ctrl+Alt+G      → List generations (rollback)
#   Ctrl+Alt+N      → Create new user account
#
##########################################################

  environment.systemPackages = with pkgs; [
    xbindkeys
    zenity
    libnotify
  ];

  # Start xbindkeys for every X session
  # (polkit/dbus already enabled in configuration.nix)
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xbindkeys}/bin/xbindkeys -f ${xbindkeysConfig}
  '';

##########################################################
#End of System Maintenance Hotkeys                      #
##########################################################

}
