{ config, pkgs, ... }:

let
  # User creation script for display manager session
  userCreateSession = pkgs.writeShellScript "user-create-session" ''
    exec ${pkgs.bash} ${pkgs.writeShellScript "create-user-wrapper" ''
      trap 'exit 0' EXIT
      ${(import ./user-create-helper.nix { inherit pkgs; })}
    ''}
  '';

  # LightDM session for user creation
  createUserSessionFile = pkgs.writeText "create-user.desktop" ''
    [Desktop Entry]
    Type=Application
    Name=Create User Account
    Comment=Create a new user account
    Exec=${userCreateSession}
    Icon=system-users
    X-LightDM-Session=create-user
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

# Add user creation session to LightDM
environment.systemPackages = with pkgs; [
  (pkgs.runCommandLocal "lightdm-create-user-session" {} ''
    mkdir -p $out/share/xsessions
    cp ${createUserSessionFile} $out/share/xsessions/create-user.desktop
  '')
];

#######################################
#End of Desktop and Display Environment#
#######################################

}
