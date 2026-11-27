{ config, pkgs, ... }:

{

################################
#Desktop and Display Environment#
################################

services.xserver = {
  enable = true;
  displayManager.lightdm.enable = true;
  desktopManager.cinnamon.enable = true;
};

#######################################
#End of Desktop and Display Environment#
#######################################

}
