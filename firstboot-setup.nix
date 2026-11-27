{ config, pkgs, ... }:

let
  # User creation helper
  userCreateHelper = import ./user-create-helper.nix { inherit pkgs; };

  # First-boot setup service script (based on proven jeos-firstboot model)
  firstbootSetup = pkgs.writeShellScript "gobook-firstboot" ''
    #!/${pkgs.bash}/bin/bash
    set -e

    clear
    echo ""
    echo "=================================================="
    echo "    Welcome to GoBook - First-Time Setup"
    echo "=================================================="
    echo ""
    echo "This system needs to create a user account."
    echo ""

    # Show menu
    echo "1. Create a user account"
    echo "2. Skip setup (continue as admin user)"
    echo ""
    read -p "Select an option (1-2): " choice

    case $choice in
      1)
        # Run user creation helper
        ${userCreateHelper}
        ;;
      2)
        echo "Skipping user creation."
        sleep 2
        ;;
      *)
        echo "Invalid option. Continuing..."
        sleep 2
        ;;
    esac
  '';

in

{

##########################################################
#First-Boot Setup Service (jeos-firstboot model)        #
##########################################################

# Flag file to trigger first-boot setup
systemd.tmpfiles.rules = [
  "d /var/lib/gobook 0755 root root -"
  "F /var/lib/gobook/first-boot-setup 0644 root root -"
];

# systemd service for first-boot user creation
# Based on proven jeos-firstboot pattern from openSUSE
systemd.services.gobook-firstboot = {
  description = "GoBook First-Boot Setup - Create User Account";

  # Use flag file to detect first boot
  unitConfig.ConditionPathExists = "/var/lib/gobook/first-boot-setup";

  # CRITICAL: Order relative to basic.target, NOT multi-user.target
  # This runs BEFORE display-manager.service even starts
  wantedBy = [ "basic.target" ];
  before = [ "multi-user.target" ];
  after = [ "local-fs.target" ];

  # Service configuration for interactive TTY usage
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "tty";
    Environment = "TERM=linux";
    User = "root";
  };

  # Run the setup script, then remove flag file to prevent re-running
  script = ''
    ${firstbootSetup}
    rm -f /var/lib/gobook/first-boot-setup
  '';
};

##########################################################
#End of First-Boot Setup Service                        #
##########################################################

}
