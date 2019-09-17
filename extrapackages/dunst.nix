{ pkgs }:
let
  dunst-config = import ./../programconfigs/dunstconf.nix;
  dunst-config-file = builtins.toFile "dunstrc" dunst-config;
in
pkgs.stdenv.mkDerivation {
  name = "dunstWrapper";
  buildInputs = [ pkgs.makeWrapper ];
  phases = [ "buildPhase" ];
  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper "${pkgs.dunst}/bin/dunst" $out/bin/dunst --add-flags "-config ${dunst-config-file}"
  '';
}
