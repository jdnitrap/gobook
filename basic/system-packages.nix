{ config, pkgs, ... }:

{

#################
#System Packages#
#################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [

	git
	brave
	firefox
	libreoffice
thunderbird
simple-scan

	];
########################
#End of System Packages#
########################

}
