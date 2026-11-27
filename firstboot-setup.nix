{ config, pkgs, ... }:

let
  # User creation helper
  userCreateHelper = import ./user-create-helper.nix { inherit pkgs; };

  # First-boot setup service script
  firstbootSetup = pkgs.writeShellScript "gobook-firstboot-setup" ''
    #!/${pkgs.bash}/bin/bash

    MARKER_FILE="/etc/gobook-firstboot-complete"

    # Exit if setup already completed
    if [ -f "$MARKER_FILE" ]; then
      exit 0
    fi

    # Clear screen and show welcome
    clear
    echo ""
    echo "=================================================="
    echo "    Welcome to GoBook - First-Time Setup"
    echo "=================================================="
    echo ""
    echo "This system needs initial configuration."
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
        sleep 1
        ;;
      *)
        echo "Invalid option. Continuing..."
        sleep 1
        ;;
    esac

    # Mark setup as complete
    touch "$MARKER_FILE"
  '';

in

{

##########################################################
#First-Boot Setup Service                               #
##########################################################

# systemd service for first-boot user creation
systemd.services.gobook-firstboot-setup = {
  description = "GoBook First-Boot Setup - Create User Account";

  # Run on first boot only (before display manager)
  before = [ "display-manager.service" ];
  wants = [ "display-manager.service" ];

  # Timing
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "tty";
    # Keep TTY open for input
    TTYPath = "/dev/tty1";
  };

  # Run the setup script
  script = ''
    ${firstbootSetup}
  '';

  # This is a user-facing service, so it needs
  wantedBy = [ "multi-user.target" ];
};

##########################################################
#End of First-Boot Setup Service                        #
##########################################################

}
