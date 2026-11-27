{ config, pkgs, ... }:

{

#######################################
#User Management                      #
#######################################

# Allow imperative user management (users survive rebuilds)
# Users created with `create-user` hotkey (Ctrl+Alt+N) persist across rebuilds
users.mutableUsers = true;

# Default admin user for first-time setup
users.users.admin = {
  isNormalUser = true;
  home = "/home/admin";
  createHome = true;
  shell = "${pkgs.bash}/bin/bash";
  initialPassword = "a";

  # Add to wheel group for sudo access
  extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
};

# Enable sudo without password for wheel group (optional)
# security.sudo.wheelNeedsPassword = false;

###############################################
#End User Management                         #
###############################################

}
