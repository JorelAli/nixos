{ pkgs }:
let
  chromium-extension = pkgs.writeTextFile {
    name = "manifest.json";
    text = import ./../programconfigs/chromiumconf.nix;
    destination = "/theme/manifest.json";
  };
in
pkgs.stdenv.mkDerivation {
  name = "chromiumWrapper";
  buildInputs = [ pkgs.makeWrapper ];
  phases = [ "buildPhase" ];
  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper "${pkgs.chromium}/bin/chromium" $out/bin/chromium --add-flags "--load-extension=${chromium-extension}/theme"
  '';
}
