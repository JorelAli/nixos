{ config, lib, pkgs, ...}:

with lib; with builtins;

let
  cfg = config.services.compton;

  calcBlurStrength = input:
    foldl' 
      (x: y: x + y) 
      (toString(input) + "," + toString(input)) 
      (genList (x: ",1.000000") (input * input - 1));

  blur-exclusions = optionalString (length cfg.blur-excludes != 0)
    (concatMapStringsSep ",\n" (ex: ''"${ex}"'') cfg.blur-excludes);

in
{
  options = {
    services.compton = {

      blur-background = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to enable blur backgrounds";
      };

      blur-strength = mkOption {
        default = 13;
        type = types.addCheck types.int (x: bitAnd x 1 == 1);
        description = "The strength of background blur";

      };

      blur-excludes = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [
          "name = 'Screenshot'"
          "class_g = 'Escrotum'"
        ];
        description = "Rules that control the blur, in the form a = b.";
      };

      paint-on-overlay = mkOption {
        default = true;
        type = types.bool;
        description = "Painting on X Composite overlay window instead of on root window"; 
      };
    };
  };

  config = mkIf cfg.blur-background {
    services.compton.extraOptions =  ''
      blur-background = true;
      blur-background-fixed = true;
      glx-no-stencil = true;
      unredir-if-possible = false;
      blur-kern = "${calcBlurStrength cfg.blur-strength}";
    '' + 
    optionalString cfg.paint-on-overlay ''
      paint-on-overlay = true;
    '' + ''
      blur-background-exclude = [
        ${blur-exclusions}
      ];
    '';
  };
}
