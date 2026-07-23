{ config, pkgs, ... }:

{

################################
#NixQubes Container Definition #
################################

# Enable container support
virtualisation.containers.enable = true;

# AppQube - Work (isolated work environment)
# Routes internet through net container only
containers.work = {
  autoStart = false;
  privateNetwork = true;
  hostAddress = "10.233.0.1";
  localAddress = "10.233.0.2";

  config = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      firefox
      libreoffice
      git
      curl
      wget
    ];

    # Get DNS from net container
    networking.nameservers = [ "10.233.2.2" ];

    # Route all traffic through net container gateway
    networking.defaultGateway = "10.233.0.1";
    networking.interfaces.eth0 = {
      ipv4.addresses = [{
        address = "10.233.0.2";
        prefixLength = 24;
      }];
      ipv4.routes = [{
        address = "10.233.0.0";
        prefixLength = 24;
        via = "10.233.0.1";
      }];
    };

    services.openssh.enable = false;
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [];
    networking.firewall.allowedUDPPorts = [];
  };
};

# AppQube - Development (isolated development environment)
# Routes internet through net container only
containers.dev = {
  autoStart = false;
  privateNetwork = true;
  hostAddress = "10.233.1.1";
  localAddress = "10.233.1.2";

  config = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
      vim
      nano
      build-essential
      pkg-config
      rustc
      cargo
      nodejs
      python3
    ];

    # Get DNS from net container
    networking.nameservers = [ "10.233.2.2" ];

    # Route all traffic through net container gateway
    networking.defaultGateway = "10.233.1.1";
    networking.interfaces.eth0 = {
      ipv4.addresses = [{
        address = "10.233.1.2";
        prefixLength = 24;
      }];
      ipv4.routes = [{
        address = "10.233.1.0";
        prefixLength = 24;
        via = "10.233.1.1";
      }];
    };

    services.openssh.enable = false;
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [];
    networking.firewall.allowedUDPPorts = [];
  };
};

# NetQube - Network services (handles ALL networking, like Qubes NetVM)
containers.net = {
  autoStart = true;
  privateNetwork = false;

  config = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      curl
      wget
      bind
      dnsmasq
      networkmanager
      networkmanager-openvpn
      cockpit
      cockpit-networkmanager
    ];

    # Enable NetworkManager for WiFi/network management
    networking.networkmanager.enable = true;

    # Enable Cockpit for web-based network management
    services.cockpit = {
      enable = true;
      port = 9090;
    };

    # Enable DNS/DHCP services for other containers
    services.dnsmasq = {
      enable = true;
      settings.interface = "veth*";
      settings.dhcp_range = "10.233.0.10,10.233.3.254,24h";
    };

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 53 9090 ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    services.openssh.enable = false;
  };
};

# AppQube - Untrusted (ephemeral container for untrusted applications)
# Routes internet through net container only
containers.untrusted = {
  autoStart = false;
  privateNetwork = true;
  hostAddress = "10.233.3.1";
  localAddress = "10.233.3.2";
  ephemeral = true;

  config = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      firefox
      curl
    ];

    # Get DNS from net container
    networking.nameservers = [ "10.233.2.2" ];

    # Route all traffic through net container gateway
    networking.defaultGateway = "10.233.3.1";
    networking.interfaces.eth0 = {
      ipv4.addresses = [{
        address = "10.233.3.2";
        prefixLength = 24;
      }];
      ipv4.routes = [{
        address = "10.233.3.0";
        prefixLength = 24;
        via = "10.233.3.1";
      }];
    };

    services.openssh.enable = false;
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [];
    networking.firewall.allowedUDPPorts = [];
  };
};

######################################
#End NixQubes Container Definition   #
######################################

}
