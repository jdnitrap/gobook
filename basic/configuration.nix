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
    [ # Include the results of the hardware scan.
	./hardware-configuration.nix
	./printer-scanner.nix
	./system-packages.nix
	./sound.nix
	./networking.nix
	./desktop-environment.nix
	./users.nix
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


##############
#System Setup#
##############

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

# Set your time zone.
  time.timeZone = "America/New_York";

# Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


#####################
#End of System Setup#
#####################

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

 

  
  

  


}
