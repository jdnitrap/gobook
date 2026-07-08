{ config, pkgs, ... }:

{

#####################
#Flatpak (per-user) #
#####################

  services.flatpak.enable = true;

  # Needed for flatpak apps to integrate properly with the desktop
  # (file chooser, etc.) under Cinnamon.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # GNOME Software as the install-from-here GUI. Not part of Cinnamon by
  # default, so it has to be added explicitly.
  # NOTE: depending on the nixpkgs channel this may need to be
  # pkgs.gnome.gnome-software instead of the top-level attribute.
  environment.systemPackages = [
    pkgs.gnome-software
  ];

  # Registers Flathub as a --user remote for every real account (not
  # system-wide), so:
  #   - nobody has to open a terminal and run `flatpak remote-add`
  #   - GNOME Software only ever sees a user-scope remote, so it installs
  #     into that user's own ~/.local/share/flatpak, never system-wide,
  #     and never needs a polkit/admin password prompt to do it.
  systemd.services.flatpak-add-flathub-per-user = {
    description = "Ensure the Flathub remote is registered per-user for Flatpak";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for user in $(${pkgs.getent}/bin/getent passwd | ${pkgs.gawk}/bin/awk -F: '$3 >= 1000 && $3 < 65534 {print $1}'); do
        ${pkgs.util-linux}/bin/runuser -u "$user" -- \
          ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      done
    '';
  };

############################
#End of Flatpak (per-user) #
############################

}
