{ config, pkgs, ... }:

{

######################
#Powerwash (Cleanup) #
######################

boot.tmp.cleanOnBoot = true;

boot.loader.systemd-boot.configurationLimit = 5;

############################
#End Powerwash (Cleanup)   #
############################

}
