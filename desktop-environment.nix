{ config, pkgs, ... }:

{

################################
#Decktop and Display Enviroment#
################################

services.xserver = {
  enable = true;
  displayManager.lightdm.enable = true;
  desktopManager.cinnamon.enable = true;
	};

#######################################
#End of Desktop and Display Enviroment#
#######################################

}
