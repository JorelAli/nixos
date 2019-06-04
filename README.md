# nixos
My NixOS configuration

## Configuration at a glance (what it gives you):
  - i3 window manager, with KDE programs installed
  - Vim-based interfaces:
    - Vim
    - Qutebrowser (vim shortcuts web browser)
    - RTV (reddit browser)
    - Ranger (file browser)
  - Programming environments:
    - Haskell (With Atom + HIE)
    - Java (With Eclipse) 
    - Rust (With Vim)
    - Python
  - Fancy sddm lockscreen (courtesy of [eayus](https://github.com/eayus/sddm-theme-clairvoyance))
  - Everyday programs
    - Web browsing (Choose your weapon: Chrome, Firefox, Qutebrowser, Elinks)
    - Document writing (Typora, Libreoffice)
    - Image editing (Gimp, Inkscape)
  - Decent command line commands
    - htop (a better `top` command)
    - neofetch (a better `screenfetch` command)
    - fish (a better `bash` shell)

## Things fixed with this configuration (compared to other Nix builds)
  - Typora works properly (can open files etc.)
  - GTK 3 and GTK 2 work as intended (Themes can be easily applied using `lxappearance`)
  - Qt themeing just works (Themes applied using `qt5ct`)
  - Eclipse isn't busted (Icons work normally due to GTK fixes)

## Planned features:
  - [ ] HIE setup is all part of the configuration (don't have to manually run the command to install and setup HIE
  - [ ] i3status-rust is all part of the configuration
  - [x] Steam
  - [ ] ~~Derivation for new Minecraft launcher~~
  - [ ] Enable qutebrowser pdf viewer
