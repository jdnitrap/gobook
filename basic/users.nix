{ config, pkgs, ... }:

let
  userCreateHelper = pkgs.callPackage ./user-create-helper.nix {};
in
{

#######
#Users#
#######

# Allow imperative user management (users survive rebuilds)
users.mutableUsers = true;

# Creator account - login shell is the user creation script
users.users.creator = {
  isNormalUser = true;
  description = "Create New Users";
  extraGroups = [ "wheel" ];  # sudo access to modify system
  shell = userCreateHelper;
};

##############
#End of Users#
##############

}
