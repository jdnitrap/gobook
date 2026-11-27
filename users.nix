{ config, pkgs, ... }:

{

#######
#Users#
#######

# Allow imperative user management (users survive rebuilds)
users.mutableUsers = true;

##############
#End of Users#
##############

}
