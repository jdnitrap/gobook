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

  # Registers Flathub once, system-wide, so it's already there for every
  # user's `flatpak install --user ...` -- nobody has to run
  # `flatpak remote-add` themselves.
  systemd.services.flatpak-add-flathub = {
    description = "Ensure the Flathub remote is registered for Flatpak";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

############################
#End of Flatpak (per-user) #
############################

}
