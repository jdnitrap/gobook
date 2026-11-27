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
  extraGroups = [ "wheel" ];
  shell = userCreateHelper;
};

# Allow creator account to run useradd without password prompt
security.sudo.extraRules = [
  {
    users = [ "creator" ];
    commands = [
      {
        command = "${pkgs.shadow}/bin/useradd";
        options = [ "NOPASSWD" ];
      }
    ];
  }
];

##############
#End of Users#
##############

}
