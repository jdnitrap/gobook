{ config, pkgs, ... }:

{

##########################################################################
#EXPERIMENTAL: localhost helper so the login-screen theme can create a   #
#user account (conventional useradd/chpasswd, not a declarative NixOS    #
#user). Paired with basic/webkit-greeter.nix, which wires web-greeter's  #
#custom theme to POST here. See basic/pkgs/create-account-helper.py for  #
#the actual logic and its security notes.                                #
##########################################################################

  systemd.services.create-account-helper = {
    description = "Localhost helper allowing the login screen to create user accounts";
    after = [ "display-manager.service" ];
    partOf = [ "display-manager.service" ];
    wantedBy = [ "display-manager.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python3 ${./pkgs/create-account-helper.py}";
      Restart = "on-failure";
      # Needs real root for useradd/chpasswd -- not sandboxed via DynamicUser.
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ "/etc" "/home" "/var/log" ];
      PrivateTmp = true;
    };
  };

##########################################################################
#End of create-account helper                                            #
##########################################################################

}
