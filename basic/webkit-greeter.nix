{ config, pkgs, ... }:

let

  webGreeterPkg = pkgs.callPackage ./pkgs/web-greeter.nix { };

  createAccountTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "web-greeter-theme-create-account";
    version = "0.1.0";
    src = ./pkgs/create-account-theme;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };

  # web-greeter's own package output is an immutable store path, so the
  # only way to add our theme alongside its bundled ones is to layer a
  # symlink on top of a copy of the tree via symlinkJoin.
  webGreeterWithTheme = pkgs.symlinkJoin {
    name = "web-greeter-with-create-account-theme";
    paths = [ webGreeterPkg ];
    postBuild = ''
      mkdir -p $out/share/web-greeter/themes
      ln -s ${createAccountTheme} $out/share/web-greeter/themes/create-account
    '';
  };

in

{

##########################################################################
#EXPERIMENTAL: web-greeter with a custom "Create account" theme          #
#                                                                        #
#UNVERIFIED — see basic/pkgs/web-greeter.nix for why (no nixpkgs        #
#package exists for web-greeter; this builds it from source against a   #
#best-effort, untested dependency list). Do not expect this to build or #
#work without real debugging on an actual machine.                      #
#                                                                        #
#Pairs with basic/user-create-helper.nix, which runs the privileged     #
#backend the theme's "Create account" form talks to.                    #
##########################################################################

  environment.systemPackages = [ webGreeterWithTheme ];

  environment.etc."lightdm/web-greeter.yml".text = ''
    greeter:
      theme: create-account
      debug_mode: false
  '';

  # Disable whatever greeter the desktop-environment/cinnamon module
  # otherwise defaults to (gtk or slick), and point LightDM at
  # web-greeter's xgreeter session instead. "web-xgreeter" must match
  # the .desktop file name web-greeter's Makefile installs
  # (share/xgreeters/web-xgreeter.desktop).
  services.xserver.displayManager.lightdm.greeters.gtk.enable = false;
  services.xserver.displayManager.lightdm.greeters.slick.enable = false;
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    greeter-session=web-xgreeter
  '';

##########################################################################
#End of web-greeter / create-account theme                               #
##########################################################################

}
