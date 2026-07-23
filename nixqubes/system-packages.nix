{ config, pkgs, ... }:

{

#################
#System Packages#
#################

nixpkgs.config.allowUnfree = true;

environment.systemPackages = with pkgs; [
	# Essential tools
	git
	curl
	wget
	nano
	vim

	# Container and virtualization tools
	systemd
	machinectl
	bubblewrap

	# Development
	build-essential
	pkg-config

	# Desktop and utilities
	htop
	unzip
	];

########################
#End of System Packages#
########################

}
