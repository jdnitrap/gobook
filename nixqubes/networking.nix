{ config, pkgs, ... }:

{

#####################################
#NixQubes Network Isolation & Setup #
#####################################

# Enable networking
networking.useDHCP = false;
networking.interfaces.eth0.useDHCP = true;

# Enable NAT for containers to reach host network
networking.nat.enable = true;
networking.nat.internalInterfaces = [ "ve-+" ];
networking.nat.externalInterface = "eth0";

# Container networking setup
networking.networkmanager.enable = true;

# Host firewall configuration
networking.firewall.enable = true;
networking.firewall.allowedTCPPorts = [];
networking.firewall.allowedUDPPorts = [];

# Allow container-to-container communication on specific interfaces
networking.firewall.extraCommands = ''
  # Allow communication between containers and management qube
  ip46tables -A INPUT -i ve-+ -j ACCEPT
  ip46tables -A FORWARD -i ve-+ -j ACCEPT
  ip46tables -A FORWARD -o ve-+ -j ACCEPT

  # Restrict inter-container communication (isolate by default)
  # Containers can reach the host (for NixQubes services)
  # but not each other unless explicitly allowed
  ip46tables -A FORWARD -i ve-work -o ve-dev -j DROP
  ip46tables -A FORWARD -i ve-dev -o ve-work -j DROP
  ip46tables -A FORWARD -i ve-untrusted -o ve-+ -j DROP
  ip46tables -A FORWARD -i ve-+ -o ve-untrusted -j DROP
'';

networking.firewall.extraStopCommands = ''
  ip46tables -D INPUT -i ve-+ -j ACCEPT 2>/dev/null || true
  ip46tables -D FORWARD -i ve-+ -j ACCEPT 2>/dev/null || true
  ip46tables -D FORWARD -o ve-+ -j ACCEPT 2>/dev/null || true
'';

# DNS resolution for containers
services.resolved.enable = true;

#########################################
#End NixQubes Network Isolation & Setup #
#########################################

}
