{ config, pkgs, ... }:

let
  # User creation helper - interactive menu for creating new accounts
  userCreateHelper = import ./user-create-helper.nix { inherit pkgs; };

  # Wrapper script that presents menu on login
  creatorLoginScript = pkgs.writeShellScript "creator-login-menu" ''
    clear
    echo "=================================================="
    echo "  GoBook - Account Setup"
    echo "=================================================="
    echo ""
    echo "Welcome! This system is ready for first-time setup."
    echo ""
    echo "1. Create a new user account"
    echo "2. Continue to desktop"
    echo ""
    read -p "Select an option (1-2): " choice

    case $choice in
      1)
        exec ${userCreateHelper}
        ;;
      2)
        exit 0
        ;;
      *)
        echo "Invalid option. Continuing to desktop..."
        sleep 1
        exit 0
        ;;
    esac
  '';

in

{

#######################################
#User Management - Creator Account    #
#######################################

# Allow imperative user management (users survive rebuilds)
users.mutableUsers = true;

# Creator account - used for first-time setup and account creation
users.users.creator = {
  isSystemUser = false;
  group = "creator";
  home = "/root";
  createHome = false;
  shell = "${pkgs.bash}/bin/bash";

  # Show user creation menu on login
  loginShellInit = ''
    # Only show menu on interactive login shells
    if [ -z "$GOBOOK_CREATOR_MENU_SHOWN" ]; then
      export GOBOOK_CREATOR_MENU_SHOWN=1
      exec ${creatorLoginScript}
    fi
  '';
};

users.groups.creator = {};

###############################################
#End User Management - Creator Account       #
###############################################

}
