{ config, pkgs, ... }:

let

  wizard = pkgs.writeShellScript "account-setup-wizard-launcher" ''
    exec ${pkgs.python3}/bin/python3 ${./pkgs/account-setup-wizard.py}
  '';

in

{

##########################################################
#Add Account: dedicated account to create new user accounts
##########################################################

  users.groups.account-setup = { };

  # Locked password: the only way in is the PAM bypass below, scoped to
  # LightDM's graphical login specifically. `su`, ssh, console login, etc.
  # all still go through the normal (failing) password check.
  users.users.addaccount = {
    isNormalUser = true;
    description = "Add Account";
    hashedPassword = "!";
    extraGroups = [ "account-setup" ];
  };

  # A no-password bypass for exactly this one username, inserted ahead of
  # the normal auth chain in the shared "lightdm" PAM service (used for
  # every graphical login). Any other username still falls through to the
  # regular password check untouched.
  security.pam.services.lightdm.rules.auth.addaccount-bypass = {
    order = 100;
    control = "[success=done default=ignore]";
    modulePath = "${config.security.pam.package}/lib/security/pam_succeed_if.so";
    settings.audit = true;
    settings.quiet_success = true;
    args = [ "user" "=" "addaccount" ];
  };

  # A minimal session -- not the full Cinnamon desktop -- that runs only
  # the setup wizard. When the wizard exits (finished or cancelled), the
  # session ends and LightDM returns to the greeter, i.e. "logged out".
  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "account-setup";
      start = ''
        ${wizard} &
        waitPID=$!
      '';
    }
  ];

  # Pre-select the "account-setup" session for the addaccount tile, so
  # nobody has to manually pick it from the greeter's session dropdown.
  # Both files below are for the two mechanisms LightDM/greeters may read
  # the last-used session from (AccountsService, and the older .dmrc).
  system.activationScripts.addaccount-default-session = ''
    mkdir -p /home/addaccount
    cat > /home/addaccount/.dmrc <<'EOF'
    [Desktop]
    Session=account-setup
    EOF
    chown addaccount /home/addaccount/.dmrc

    mkdir -p /var/lib/AccountsService/users
    cat > /var/lib/AccountsService/users/addaccount <<'EOF'
    [User]
    Session=account-setup
    SystemAccount=false
    EOF
  '';

  # Root-privileged backend the wizard talks to over a Unix socket to
  # actually run useradd/chpasswd. See basic/pkgs/account-setup-helper.py
  # for the request validation and peer-credential check.
  systemd.services.account-setup-helper = {
    description = "Privileged helper for the Add Account setup wizard";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python3 ${./pkgs/account-setup-helper.py}";
      Restart = "on-failure";
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ "/etc" "/home" "/var/log" "/run" ];
    };
  };

  environment.systemPackages = [ pkgs.zenity ];

#################################################################
#End of Add Account                                             #
#################################################################

}
