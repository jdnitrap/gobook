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

############################
#End of Flatpak (per-user) #
############################

}
