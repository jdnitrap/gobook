# Edit this configuration file to define what should be installed on
# your NixQubes system. NixQubes implements Qubes OS security principles
# on NixOS using containers and network isolation.

{ config, pkgs, ... }:

{

###################################################################
#                 Channel Version								  #
# When adding a new channel make sure your channel you are adding #
# matches with the channel version before upgrading system        #
###################IMPORTANT#######################################

system.stateVersion = "26.05";

########################
#End of Channel Version#
########################


##############
#Module Setup#
##############

imports =
    [
	./hardware-configuration.nix
	./system-packages.nix
	./networking.nix
	./security.nix
	./containers.nix
	./qubes-manager.nix
	./desktop-environment.nix
	./sound.nix
	./users.nix
	./system-setup.nix
	./auto-upgrade.nix
	./auto-gc.nix
	./keep-first-generation.nix
	./powerwash.nix
	./flatpak.nix
    ];

#####################
#End of Module Setup#
#####################

############
#Bootloader#
############

boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

###################
#End of BootLoader#
###################

##########################
#Experimental Features   #
##########################

nix.settings.experimental-features = [ "nix-command" "flakes" ];

###########################
#End Experimental Features#
###########################

############################
#Imperative User Management#
############################

# Allow users created imperatively to survive rebuilds
users.mutableUsers = true;

####################################
#End Imperative User Management    #
####################################

###############
#Localization #
###############

time.timeZone = "America/Chicago";

i18n.defaultLocale = "en_US.UTF-8";

i18n.supportedLocales = [
  "en_US.UTF-8/UTF-8"
];

#####################
#End Localization   #
#####################

##########
#Hostname#
##########

networking.hostname = "nixqubes";

################
#End Hostname  #
################

}
