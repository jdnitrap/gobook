# EXPERIMENTAL / UNVERIFIED — see basic/webkit-greeter.nix for context.
#
# Best-effort packaging of JezerM/web-greeter, pinned to the last Make-based
# release (3.5.3) because 4.0.0 switched its build to `uv sync`, which fetches
# Python packages from PyPI mid-build — incompatible with Nix's network-less
# sandboxed builds unless someone does the (separate, substantial) work of
# translating its uv.lock with a tool like uv2nix.
#
# This derivation has NOT been built or tested against a real nixpkgs
# checkout or a real machine. Things most likely to need fixing on first
# build attempt:
#   - Exact python3Packages / libsForQt5 attribute names below (guessed from
#     upstream's dependency table, not verified against current nixpkgs).
#   - Whether nixpkgs' pyqt5 is built with QtWebEngine bindings enabled;
#     if not, pyqt5-webengine may need to be packaged/overridden separately.
#   - Whether `make install` respects DESTDIR/PREFIX the way assumed here.

{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rsync
, gnumake
, nodePackages
, pkg-config
, wrapGAppsHook3
, python3
, python3Packages
, libsForQt5
, lightdm
, glib
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "web-greeter";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "JezerM";
    repo = "web-greeter";
    rev = version;
    fetchSubmodules = true;
    # NOTE: placeholder — replace with the real hash before building.
    # `nix-prefetch-github JezerM web-greeter --rev 3.5.3` (or
    # `nix run nixpkgs#nix-prefetch-github -- ...`) will produce it.
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    makeWrapper
    rsync
    gnumake
    nodePackages.typescript
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    python3
    python3Packages.pygobject3
    python3Packages.pyyaml
    python3Packages.pyinotify
    libsForQt5.pyqt5
    libsForQt5.qt5.qtwebengine
    lightdm
    glib
    gtk3
  ];

  # Upstream's Makefile install target does:
  #   cp -R "${INSTALL_ROOT}"/* "${DESTDIR}"
  # with THEMES_DIR/xgreeters paths derived from DESTDIR+PREFIX, so we point
  # both at $out with PREFIX=/ to land things directly under
  # $out/share/web-greeter, $out/share/xgreeters, $out/bin, etc.
  installFlags = [
    "PREFIX="
    "DESTDIR=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "HTML/CSS/JS themeable LightDM greeter (experimental Nix packaging, unverified)";
    homepage = "https://github.com/JezerM/web-greeter";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    broken = true; # flip to false once this has actually been built successfully
  };
}
