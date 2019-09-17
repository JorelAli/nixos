self: super: {
  chromium = super.callPackage ./chromium.nix { pkgs = super; };
  dunst = super.callPackage ./dunst.nix { pkgs = super; };
}
