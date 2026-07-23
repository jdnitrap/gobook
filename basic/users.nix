{ config, pkgs, ... }:

{

#######
#Users#
#######


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "input" "audio" "lp" "scanner" "video"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  users.users.user1 = {
    isNormalUser = true;
    description = "user1";
    extraGroups = [ "networkmanager" "scanner" "lp" "input" "audio" "video"];
    packages = with pkgs; [

    ];
  };


##############
#End of Users#
##############

}
