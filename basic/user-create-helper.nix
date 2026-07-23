{ pkgs }:

pkgs.writeShellScript "user-create-helper" ''
  #!/${pkgs.bash}/bin/bash

  DEFAULT_GROUPS="networkmanager audio video input"
  BASH_PATH="${pkgs.bash}/bin/bash"
  USERADD_PATH="${pkgs.shadow}/bin/useradd"
  ID_PATH="${pkgs.coreutils}/bin/id"
  GETENT_PATH="${pkgs.libc}/bin/getent"

  validate_groups() {
    local valid_groups=""
    local missing_groups=""

    for group in $DEFAULT_GROUPS; do
      if $GETENT_PATH group "$group" &>/dev/null; then
        if [ -z "$valid_groups" ]; then
          valid_groups="$group"
        else
          valid_groups="$valid_groups,$group"
        fi
      else
        missing_groups="$missing_groups $group"
      fi
    done

    if [ -n "$missing_groups" ]; then
      echo "Warning: These groups don't exist on the system:$missing_groups"
      echo "They will be skipped during user creation."
      sleep 2
    fi

    echo "$valid_groups"
  }

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

    if $ID_PATH "$username" &>/dev/null; then
      echo "Error: User '$username' already exists."
      sleep 2
      create_new_user
      return
    fi

    local valid_groups=$(validate_groups)

    echo ""
    echo "Creating user '$username'..."
    echo "Assigned groups: $valid_groups"
    echo ""

    if [ -z "$valid_groups" ]; then
      if sudo $USERADD_PATH -m -s "$BASH_PATH" "$username"; then
        echo "Successfully created user '$username'!"
        sleep 2
        create_user_menu
      else
        echo "Error creating user '$username'. Please check the error above."
        sleep 2
        create_user_menu
      fi
    else
      if sudo $USERADD_PATH -m -G "$valid_groups" -s "$BASH_PATH" "$username"; then
        echo "Successfully created user '$username'!"
        sleep 2
        create_user_menu
      else
        echo "Error creating user '$username'. Please check the error above."
        sleep 2
        create_user_menu
      fi
    fi
  }

  create_user_menu
''
