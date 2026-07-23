{ config, pkgs, ... }:

{

#################
#Security Setup #
#################

# Enable Polkit for privilege escalation
security.polkit.enable = true;

# Enable Dbus for system communication
services.dbus.enable = true;

# SELinux-like mandatory access control would go here if available
# For now, we rely on container isolation and firewall rules

# AppArmor for additional process confinement
security.apparmor.enable = false;

# Restrict kernel module loading
boot.kernelParams = [
  "lockdown=confidentiality"
];

# Disable magic SysRq key
boot.kernel.sysctl."kernel.sysrq" = 0;

# Restrict kernel pointer exposure
boot.kernel.sysctl."kernel.kptr_restrict" = 2;

# Restrict dmesg access
boot.kernel.sysctl."kernel.dmesg_restrict" = 1;

# Hide kernel logs from unprivileged users
boot.kernel.sysctl."kernel.printk" = "3 3 3 3";

# Restrict access to kernel modules information
boot.kernel.sysctl."kernel.modules_disabled" = 1;

# Enable ASLR (Address Space Layout Randomization)
security.randomizedAddressSpace = true;

# Disable unprivileged user namespaces (for container isolation)
# boot.kernel.sysctl."user.max_user_namespaces" = 0;

# Require authentication for sudo
security.sudo.enable = true;
security.sudo.wheelNeedsPassword = true;

# Polkit rules for privilege escalation
security.polkit.extraConfig = ''
  polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.systemd1.manage-units" &&
        subject.isInGroup("users")) {
      return polkit.Result.YES;
    }
  });
'';

########################
#End of Security Setup #
########################

}
