{ pkgs }:
let
  kitty-config = import ./../../programconfigs/kittyconf.nix;
in
pkgs.stdenv.mkDerivation {
  name = "kittyWrapper";
  buildInputs = [ pkgs.makeWrapper ];
  phases = [ "buildPhase" ];
  buildCommand = with builtins; ''
    mkdir -p $out/bin
    makeWrapper "${pkgs.kitty}/bin/kitty" $out/bin/kitty --add-flags "-c=${toFile "kitty.conf" kitty-config}"
  '';
}
