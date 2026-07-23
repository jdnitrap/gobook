{ pkgs }:

pkgs.writeShellScript "user-create-helper" ''
  #!/${pkgs.bash}/bin/bash

  set -e

  DEFAULT_GROUPS="networkmanager,audio,video,input"

  create_user_menu() {
    clear
    echo "========================================"
    echo "  NixOS User Creation Utility"
    echo "========================================"
    echo ""
    echo "1. Create a new user"
    echo "2. Exit"
    echo ""
    read -p "Select an option (1-2): " choice

    case $choice in
      1)
        create_new_user
        ;;
      2)
        echo "Exiting user creation utility..."
        exit 0
        ;;
      *)
        echo "Invalid option. Please try again."
        sleep 2
        create_user_menu
        ;;
    esac
  }

  create_new_user() {
    clear
    echo "========================================"
    echo "  Create New User"
    echo "========================================"
    echo ""

    read -p "Enter username: " username

    if [ -z "$username" ]; then
      echo "Error: Username cannot be empty."
      sleep 2
      create_new_user
      return
    fi

    if id "$username" &>/dev/null; then
      echo "Error: User '$username' already exists."
      sleep 2
      create_new_user
      return
    fi

    echo ""
    echo "Creating user '$username'..."
    echo "Assigned groups: $DEFAULT_GROUPS"
    echo ""

    if sudo useradd -m -G $DEFAULT_GROUPS -s /bin/bash "$username"; then
      echo "Successfully created user '$username'!"
      sleep 2
      create_user_menu
    else
      echo "Error creating user '$username'. Please check the error above."
      sleep 2
      create_user_menu
    fi
  }

  create_user_menu
''
