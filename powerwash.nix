{ config, pkgs, ... }:

let

  # EXPERIMENTAL / UNVERIFIED -- never built or run on a real machine.
  # Rolls the system back to its first generation (relies on
  # keep-first-generation.nix having pinned it as a permanent gc-root)
  # and wipes the contents of every /home/* directory, then reboots.
  # Does not touch /root, and does not reset passwords -- users.nix sets
  # no declarative password to revert to.
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

  # Runs as the logged-in user (via the hotkey), shows a confirmation
  # dialog, and only then escalates to root via pkexec/polkit -- which
  # itself prompts for admin authentication -- to run the actual wipe.
  powerwashConfirm = pkgs.writeShellScript "powerwash-confirm" ''
    set -euo pipefail

    if ${pkgs.zenity}/bin/zenity --question --title="Powerwash" \
      --text="This erases ALL user data and rolls the system back to its first generation -- like a factory reset. This cannot be undone.\n\nContinue?" \
      --width=420
    then
      exec ${pkgs.polkit}/bin/pkexec ${powerwashScript}
    fi
  '';

  xbindkeysConfig = pkgs.writeText "xbindkeysrc.powerwash" ''
    "${powerwashConfirm}"
        Control + Escape + space
  '';

in

{

##########################################################
#Powerwash: reset to first generation (Ctrl+Esc+Space)   #
##########################################################

  environment.systemPackages = with pkgs; [
    xbindkeys
    zenity
  ];

  # Desktop-agnostic hotkey grab, started for every X session regardless
  # of which window manager/app has focus.
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xbindkeys}/bin/xbindkeys -f ${xbindkeysConfig}
  '';

  security.polkit.enable = true;

#################################################################
#End of Powerwash: reset to first generation (Ctrl+Esc+Space)   #
#################################################################

}
