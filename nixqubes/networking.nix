{ config, pkgs, ... }:

{

#####################################
#NixQubes Network Isolation & Setup #
#####################################

# Enable networking on host
networking.networkmanager.enable = false;
networking.useDHCP = false;
networking.interfaces.eth0.useDHCP = true;

# Host firewall configuration
networking.firewall.enable = true;
networking.firewall.allowedTCPPorts = [ 22 ];
networking.firewall.allowedUDPPorts = [];

# Routing: All containers get internet through net container
# Work, Dev, Untrusted containers ONLY access net container
# Net container has access to host network/WiFi

networking.firewall.extraCommands = ''
  # Allow all container traffic on veth interfaces
  ip46tables -A INPUT -i ve-+ -j ACCEPT
  ip46tables -A FORWARD -i ve-+ -j ACCEPT
  ip46tables -A FORWARD -o ve-+ -j ACCEPT

  # Restrict inter-container communication (Qubes-style isolation)
  # Containers can ONLY reach net container, not each other
  ip46tables -A FORWARD -i ve-work -o ve-dev -j DROP
  ip46tables -A FORWARD -i ve-dev -o ve-work -j DROP
  ip46tables -A FORWARD -i ve-work -o ve-untrusted -j DROP
  ip46tables -A FORWARD -i ve-untrusted -o ve-work -j DROP
  ip46tables -A FORWARD -i ve-dev -o ve-untrusted -j DROP
  ip46tables -A FORWARD -i ve-untrusted -o ve-dev -j DROP

  # Allow containers to reach net container for internet access
  ip46tables -A FORWARD -i ve-work -o ve-net -j ACCEPT
  ip46tables -A FORWARD -i ve-dev -o ve-net -j ACCEPT
  ip46tables -A FORWARD -i ve-untrusted -o ve-net -j ACCEPT
  ip46tables -A FORWARD -i ve-net -o ve-work -j ACCEPT
  ip46tables -A FORWARD -i ve-net -o ve-dev -j ACCEPT
  ip46tables -A FORWARD -i ve-net -o ve-untrusted -j ACCEPT
'';

networking.firewall.extraStopCommands = ''
  ip46tables -D INPUT -i ve-+ -j ACCEPT 2>/dev/null || true
  ip46tables -D FORWARD -i ve-+ -j ACCEPT 2>/dev/null || true
  ip46tables -D FORWARD -o ve-+ -j ACCEPT 2>/dev/null || true
'';

# DNS resolution for host
services.resolved.enable = true;

#########################################
#End NixQubes Network Isolation & Setup #
#########################################

}
