{ config, pkgs, ... }:

{

#######################################
#User Management                      #
#######################################

# Allow imperative user management (users survive rebuilds)
# Users created with `create-user` hotkey (Ctrl+Alt+N) persist across rebuilds
users.mutableUsers = true;

###############################################
#End User Management                         #
###############################################

}
