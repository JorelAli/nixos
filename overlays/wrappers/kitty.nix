{ pkgs }:
let
  kitty-config = import ./../../programconfigs/kittyconf.nix;

  # https://github.com/kovidgoyal/kitty/issues/1519#issuecomment-479805831
  # Kitty can't use kittens if --config is used first!
in
pkgs.stdenv.mkDerivation {
  name = "kittyWrapper";
  buildInputs = [ pkgs.makeWrapper ];
  phases = [ "buildPhase" ];
  buildCommand = with builtins; ''
    mkdir -p $out/bin
    makeWrapper "${pkgs.kitty}/bin/kitty" $out/bin/kitty --add-flags "-c=${toFile "kitty.conf" kitty-config}"
    makeWrapper "${pkgs.kitty}/bin/kitty" $out/bin/kittyw --add-flags "-c=${toFile "kitty.conf" kitty-config}"
    # makeWrapper "${pkgs.kitty}/bin/kitty" $out/bin/kitty
  '';
}
