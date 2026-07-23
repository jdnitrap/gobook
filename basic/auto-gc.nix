{ config, pkgs, ... }:

{

####################################
#Auto-delete Previous Generations  #
#(keeps the first and current gen) #
####################################

  systemd.services.gc-old-generations = {
    description = "Delete previous system generations, keeping the first and current";
    serviceConfig.Type = "oneshot";
    script = ''
      profile=/nix/var/nix/profiles/system

      generations=$(${pkgs.nix}/bin/nix-env -p "$profile" --list-generations | ${pkgs.gawk}/bin/awk '{print $1}')
      first=$(echo "$generations" | head -n1)
      current=$(${pkgs.coreutils}/bin/readlink "$profile" | ${pkgs.gnugrep}/bin/grep -oP '(?<=-)[0-9]+(?=-link)')

      to_delete=$(echo "$generations" | ${pkgs.gnugrep}/bin/grep -v -x -e "$first" -e "$current" || true)

      if [ -n "$to_delete" ]; then
        ${pkgs.nix}/bin/nix-env -p "$profile" --delete-generations $to_delete
      fi

      ${pkgs.nix}/bin/nix-collect-garbage
    '';
  };

  systemd.timers.gc-old-generations = {
    description = "Timer for deleting previous system generations";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

###########################################
#End of Auto-delete Previous Generations  #
###########################################

}
