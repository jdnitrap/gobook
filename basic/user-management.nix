{ config, pkgs, ... }:

{

########################################
#User Management (add users via the DM)#
########################################

  # Keep imperatively-created accounts (e.g. via `useradd`, or the
  # "Users" panel in Cinnamon's Settings, reachable from the display
  # manager session) intact across rebuilds, instead of NixOS wiping
  # out anything not declared in users.nix.
  users.mutableUsers = true;

  # Cinnamon's desktop manager already enables accounts-daemon and
  # ships cinnamon-control-center, which provides the graphical
  # "Users" panel (the "+" button) backed by AccountsService/useradd
  # rather than declarative NixOS user config. Declared here again
  # for clarity in case the desktop environment module changes.
  services.accounts-daemon.enable = true;

###############################################
#End of User Management (add users via the DM)#
###############################################

}
