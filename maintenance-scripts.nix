{ pkgs, ... }:

let
  # Update system to latest generation
  updateScript = pkgs.writeShellScript "system-update" ''
    set -euo pipefail

    echo "Updating NixOS system..."
    sudo nixos-rebuild switch

    ${pkgs.libnotify}/bin/notify-send "System Updated" "NixOS system has been updated to the latest generation." --icon=dialog-information
  '';

  # Update and shutdown
  updateShutdownScript = pkgs.writeShellScript "system-update-shutdown" ''
    set -euo pipefail

    if ${pkgs.zenity}/bin/zenity --question --title="Update and Shutdown" \
      --text="Update system and shutdown?" \
      --width=300
    then
      echo "Updating NixOS system..."
      sudo nixos-rebuild switch

      ${pkgs.libnotify}/bin/notify-send "System Updated" "System will shutdown in 10 seconds." --icon=dialog-information
      sleep 10
      sudo ${pkgs.systemd}/bin/systemctl poweroff
    fi
  '';

  # List system generations for rollback
  listGenerationsScript = pkgs.writeShellScript "list-generations" ''
    set -euo pipefail

    ${pkgs.zenity}/bin/zenity --info --title="System Generations" \
      --text="$( \
        ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --list-generations \
        | ${pkgs.gawk}/bin/awk '{printf "%s (%-10s %s %s %s %s)\n", $1, $4, $5, $6, $7, $8}' \
      )" \
      --width=600 --height=400
  '';

  # Repair and diagnostics
  repairScript = pkgs.writeShellScript "system-repair" ''
    set -euo pipefail

    repair_output=$(mktemp)

    {
      echo "=== NixOS Repair and Diagnostics ==="
      echo ""
      echo "Checking configuration syntax..."
      ${pkgs.nix}/bin/nix-instantiate /etc/nixos/configuration.nix > /dev/null && echo "✓ Configuration syntax OK" || echo "✗ Configuration syntax ERROR"

      echo ""
      echo "Checking store integrity..."
      ${pkgs.nix}/bin/nix-store --verify --repair 2>&1 | head -20

      echo ""
      echo "Available disk space:"
      ${pkgs.coreutils}/bin/df -h / | tail -1

      echo ""
      echo "Nix store size:"
      ${pkgs.coreutils}/bin/du -sh /nix/store

      echo ""
      echo "System uptime:"
      ${pkgs.uptime}/bin/uptime

      echo ""
      echo "Last 5 system journal errors:"
      ${pkgs.systemd}/bin/journalctl -xe -n 5 --no-pager 2>&1 | tail -10
    } | tee "$repair_output"

    ${pkgs.zenity}/bin/zenity --info --title="System Diagnostics" \
      --text="$(cat "$repair_output")" \
      --width=700 --height=500

    rm "$repair_output"
  '';

  # Create new user account (in-session version with GUI)
  createUserGuiScript = pkgs.writeShellScript "create-user-gui" ''
    set -euo pipefail

    username=$(${pkgs.zenity}/bin/zenity --entry --title="Create New User" \
      --text="Enter new username:" \
      --width=300)

    if [ -z "$username" ]; then
      exit 0
    fi

    if ${pkgs.coreutils}/bin/id "$username" &>/dev/null; then
      ${pkgs.zenity}/bin/zenity --error --title="User Exists" \
        --text="User '$username' already exists." \
        --width=300
      exit 1
    fi

    password=$(${pkgs.zenity}/bin/zenity --password --title="Create New User" \
      --text="Enter password for '$username':")

    if [ -z "$password" ]; then
      exit 0
    fi

    password_confirm=$(${pkgs.zenity}/bin/zenity --password --title="Create New User" \
      --text="Confirm password for '$username':")

    if [ "$password" != "$password_confirm" ]; then
      ${pkgs.zenity}/bin/zenity --error --title="Password Mismatch" \
        --text="Passwords do not match." \
        --width=300
      exit 1
    fi

    # Create user with sudo
    echo "$password" | sudo ${pkgs.shadow}/bin/useradd -m -G networkmanager,audio,video,input -s ${pkgs.bash}/bin/bash "$username"

    # Set password
    echo "$username:$password" | sudo ${pkgs.shadow}/bin/chpasswd

    ${pkgs.zenity}/bin/zenity --info --title="User Created" \
      --text="User '$username' has been created successfully.\n\nYou can now logout and login as the new user." \
      --width=350
  '';

in

{

##########################################################
#Maintenance Scripts - System utilities                 #
##########################################################

  environment.systemPackages = with pkgs; [
    libnotify
    (pkgs.runCommandLocal "maintenance-scripts" {} ''
      mkdir -p $out/bin
      ln -s ${updateScript} $out/bin/system-update
      ln -s ${updateShutdownScript} $out/bin/system-update-shutdown
      ln -s ${listGenerationsScript} $out/bin/list-generations
      ln -s ${repairScript} $out/bin/system-repair
      ln -s ${createUserGuiScript} $out/bin/create-user
    '')
  ];

##########################################################
#End of Maintenance Scripts                             #
##########################################################

}
