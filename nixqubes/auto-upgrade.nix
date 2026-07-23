{ config, pkgs, ... }:

{

##################
#Auto Upgrade    #
##################

system.autoUpgrade = {
  enable = false;
  allowReboot = false;
};

####################
#End Auto Upgrade  #
####################

}
