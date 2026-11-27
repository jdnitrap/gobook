{ config, pkgs, ... }:

{

###############
#Auto Upgrade #
###############

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "04:00";
    randomizedDelaySec = "45min";
  };

######################
#End of Auto Upgrade #
######################

}
