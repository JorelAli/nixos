{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.wayfire;
in
{
  options = {
    services.wayfire = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable wayfire. An insane window manager
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      wayfire
      wf-config
      xwayland
      wf-recorder
      wl-clipboard
      waypipe
      wofi
      grim
      cage
      oguri
      kanshi
      dmenu
      wlay
      wldash
      wlroots
      waybar
    ];

    nixpkgs.overlays = [
      (import (builtins.fetchTarball "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz"))
    ];
  };
}
