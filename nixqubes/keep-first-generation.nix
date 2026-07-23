{ config, pkgs, ... }:

{

#########################
#Keep First Generation  #
#########################

boot.loader.systemd-boot.configurationLimit = 10;

############################
#End Keep First Generation #
############################

}
