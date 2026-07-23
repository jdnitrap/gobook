{ config, pkgs, ... }:

{

###################
#System Setup     #
###################

# Enable SSH for remote management
services.openssh = {
  enable = true;
  settings.PasswordAuthentication = true;
  settings.PermitRootLogin = "no";
};

# Limit SSH access
networking.firewall.allowedTCPPorts = [ 22 ];

####################
#End of System Setup#
####################

}
