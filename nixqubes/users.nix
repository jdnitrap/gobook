{ config, pkgs, ... }:

{

#######
#Users#
#######

users.mutableUsers = true;

users.users.nixqubes = {
  isNormalUser = true;
  description = "NixQubes Administrator";
  extraGroups = [ "wheel" "systemd-journal" ];
  shell = "${pkgs.bash}/bin/bash";
};

security.sudo.extraRules = [
  {
    users = [ "nixqubes" ];
    commands = [
      {
        command = "${pkgs.systemd}/bin/systemctl";
        options = [ "NOPASSWD" ];
      }
      {
        command = "${pkgs.systemd}/bin/machinectl";
        options = [ "NOPASSWD" ];
      }
    ];
  }
];

##############
#End of Users#
##############

}
