{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.dunst;
in
{
  options = {
    services.dunst = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable dunst. A notification service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services."dunst" = {
        enable = true;
        description = "A notification system";
        wantedBy = [ "default.target" ];
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = 2;
        serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
        path = [ pkgs.mpv ];
    };
  };
}
