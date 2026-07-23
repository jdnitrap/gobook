{ config, pkgs, ... }:

{

#################
#System Packages#
#################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [
	# Development and build tools
	git
	curl
	wget
	nano
	vim
	build-essential
	pkg-config

	# Office and media
	brave
	firefox
	libreoffice
	thunderbird
	simple-scan

	# System utilities
	btop
	gnome-software
	htop
	unzip

	# Fonts
	liberation_ttf
	dejavu_fonts
	noto-fonts
	noto-fonts-cjk
	noto-fonts-emoji
	];

  fonts.packages = with pkgs; [
	liberation_ttf
	dejavu_fonts
	noto-fonts
	noto-fonts-cjk
	noto-fonts-emoji
	];
########################
#End of System Packages#
########################

}
