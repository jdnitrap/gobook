{ config, pkgs, ... }:

{

################################
#NixQubes Container Definition #
################################

# Enable container support
virtualisation.containers.enable = true;

# AppQube - Work (isolated work environment)
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

    services.openssh.enable = false;
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [];
    networking.firewall.allowedUDPPorts = [];
  };
};

# AppQube - Development (isolated development environment)
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

    services.openssh.enable = false;
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [];
    networking.firewall.allowedUDPPorts = [];
  };
};

# NetQube - Network services (isolated network container)
containers.net = {
  autoStart = true;
  privateNetwork = true;
  hostAddress = "10.233.2.1";
  localAddress = "10.233.2.2";

  config = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      curl
      wget
      bind
      dnsmasq
    ];

    services.openssh.enable = false;
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 53 ];
    networking.firewall.allowedUDPPorts = [ 53 ];
  };
};

# AppQube - Untrusted (for testing untrusted applications)
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
