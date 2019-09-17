{ pkgs }:
let
  dunst-config = import ./dunstconf.nix;
  dunst-config-file = builtins.toFile "dunstrc" dunst-config;
  dunst = pkgs.dunst.override {dunstify = true;};
in
pkgs.stdenv.mkDerivation {
  name = "dunstWrapper";
  buildInputs = [ pkgs.makeWrapper ];
  phases = [ "buildPhase" ];
  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper "${dunst}/bin/dunst" $out/bin/dunst --add-flags "-config ${dunst-config-file}"
  '';
}
