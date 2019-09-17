{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.xcompmgr;
in
{
  options = {
    services.xcompmgr = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable xcompmgr, a compositing service
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services."xcompmgr" = {
        enable = true;
        description = "Transparency compositing service";
        wantedBy = [ "default.target" ];
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = 2;
        serviceConfig.ExecStart = "${pkgs.xcompmgr}/bin/xcompmgr";
    };
  };
}
