{ config, pkgs, ... }:

let
  # User creation helper
  userCreateHelper = import ./user-create-helper.nix { inherit pkgs; };

  # LightDM session for creating users
  createUserSession = pkgs.writeShellScriptBin "create-user-session" ''
    ${userCreateHelper}
  '';

in

{

################################
#Desktop and Display Environment#
################################

services.xserver = {
  enable = true;
  displayManager.lightdm.enable = true;
  desktopManager.cinnamon.enable = true;
};

# Add create-user script to system
environment.systemPackages = with pkgs; [
  createUserSession
];

# Install LightDM session file (.desktop) in the right place
environment.etc."xsessions/create-user.desktop".text = ''
  [Desktop Entry]
  Type=Application
  Name=Create User Account
  Comment=Create a new user account for this system
  Exec=${createUserSession}/bin/create-user-session
  Icon=system-users
  X-LightDM-Session=create-user
'';

#######################################
#End of Desktop and Display Environment#
#######################################

}
