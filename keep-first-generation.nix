{ config, pkgs, ... }:

{

##########################################
#Keeping the First Generation Permanently#
##########################################

  # Pins the very first system generation as its own gc-root, independent
  # of the profile symlink auto-gc.nix already protects. This means the
  # first generation's store paths survive even a manual
  # `nix-collect-garbage -d` or `nix-env --delete-generations`, not just
  # the weekly cleanup in auto-gc.nix.
  systemd.services.pin-first-generation = {
    description = "Pin the first system generation as a permanent gc-root";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -euo pipefail

      profile=/nix/var/nix/profiles/system
      gcroot=/nix/var/nix/gcroots/first-generation

      first=$(${pkgs.nix}/bin/nix-env -p "$profile" --list-generations \
        | ${pkgs.gawk}/bin/awk '{print $1}' | head -n1)

      first_link="$profile-$first-link"

      if [ ! -e "$gcroot" ] || [ "$(${pkgs.coreutils}/bin/readlink "$gcroot")" != "$first_link" ]; then
        ln -sfn "$first_link" "$gcroot"
      fi
    '';
  };

#################################################
#End of Keeping the First Generation Permanently#
#################################################

}
