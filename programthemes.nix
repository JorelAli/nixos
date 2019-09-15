{ config, pkgs, ... }:

{
  # Zathura configuration, handled using symlinks from dotfiles 
  # Symlink ~/.config/zathura/zathurarc -> /etc/configs/zathurarc
  environment.etc."configs/zathurarc" = {
    text = import ./programconfigs/zathuraconf.nix;
  };

  # Dunst configuration, handled using symlinks from dotfiles
  # Symlink ~/.config/dunst/dunstrc -> /etc/configs/dunstrc
  environment.etc."configs/dunstrc" = {
    text = import ./programconfigs/dunstconf.nix;
  };

  # Fish (budspencer theme) configuration, using symlinks from dotfiles
  # Symlink ~/.config/fish/budspencer_config.fish -> 
  #   /etc/configs/budspencer_config.fish
  environment.etc."configs/budspencer_config.fish" = {
    text = import ./programconfigs/budspencerconf.nix;
  };

  # Qutebrowser configuration, handled using symlinks from dotfiles
  # Symlink ~/.config/qutebrowser/customtheme.py -> 
  #   /etc/configs/customtheme.py
  environment.etc."configs/customtheme.py" = {
    text = import ./programconfigs/qutebrowserconf.nix;
  };

  environment.etc."configs/customtheme.conf" = {
    text = import ./programconfigs/qt5ctconf.nix;
  };

  environment.etc."configs/DolphinFix.qss" = {
    text = import ./programconfigs/dolphinqss.nix;
  };

  environment.etc."configs/gtkrc" = {
    text = import ./programconfigs/gtk2theme.nix;
  };

  environment.etc."configs/chromiumtheme/manifest.json" = {
    text = import ./programconfigs/chromiumconf.nix;
  };

  environment.etc."configs/nix_generated.rasi" = {
    text = import ./programconfigs/roficonf.nix;
  };
}
