# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

###################################################################
#                 Channel Version								  #
# When adding a new channel make sure your channel you are adding #
# machtes with the channel version before upgrading system        # 
###################IMPORTANT#######################################  

system.stateVersion = "26.05"; 

########################
#End of Channel Version#
########################


##############  
#Module Setup#
##############

imports =
    [ # Not tracked in git -- it's machine-specific (disk UUIDs, etc).
      # Generate your own with `nixos-generate-config` and place it right
      # here as basic/hardware-configuration.nix; no need to touch this
      # file itself.
	./hardware-configuration.nix
	./printer-scanner.nix
	./system-packages.nix
	./sound.nix
	./networking.nix
	./desktop-environment.nix
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

networking.hostname = "nixos-system";

################
#End Hostname  #
################


###################
#Security & Polkit#
###################

# Enable polkit for privilege escalation in desktop environment
security.polkit.enable = true;

# Enable dbus for system communication
services.dbus.enable = true;

#############################
#End Security & Polkit      #
############################


###########
#Bluetooth#
###########

hardware.bluetooth.enable = true;
hardware.bluetooth.powerOnBoot = true;

#################
#End Bluetooth  #
#################

}
