{ config, pkgs, ... }:

{

###################
#Garbage Collection#
###################

nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};

########################
#End Garbage Collection#
########################

}
