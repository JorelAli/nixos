# My glorious all powerful NixOS configuration file
# https://github.com/JorelAli/nixos

{ config, pkgs, ... }:

let

  ### Nix channels #############################################################
  # These are channels defined using the `sudo nix-channel --list` command.    #
  # They are as follows:                                                       #
  #   nixos https://nixos.org/channels/nixos-18.09                             #
  #   unstable https://nixos.org/channels/nixos-unstable                       #
  ##############################################################################

  unstable = import <unstable> { 
    config = {
      allowUnfree = true;
    }; 
  };
in {

  ### NixOS important settings #################################################

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  ### Boot Settings ############################################################

  # Enable exFAT format for USB/External HDD
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Search for other operating systems
  boot.loader.grub.useOSProber = true;

  ### Networking Settings ######################################################

  networking.hostName = "NixOS";
  networking.networkmanager.enable = true;

  # If stuck, use the 'nm-connection-editor' command

  ### Regional Settings ########################################################

  time.timeZone = "Europe/London";

  ### Environment Variables ####################################################

  environment.variables = {

    XCURSOR_PATH = [
      "${config.system.path}/share/icons"
      "$HOME/.icons"
      "$HOME/.nix-profile/share/icons"
    ];

    GTK_DATA_PREFIX = [
      "${config.system.path}"
    ];

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    EDITOR = "vim";
    _JAVA_OPTIONS= "-Dawt.useSystemAAFontSettings=lcd";

  };

  ### /etc/ Files ##############################################################

  # Settings file for GTK 3
  environment.etc."xdg/gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-icon-theme-name=breeze
      gtk-theme-name=Breeze-gtk
    '';
  };

  # Settings file for GTK 2
  environment.etc."xdg/gtk-2.0/gtkrc" = {
    text = ''
      gtk-icon-theme-name = "breeze"
      gtk-theme-name = "Breeze-gtk"
    '';
  };

  ### System Packages ##########################################################

  environment.systemPackages = with pkgs; [

    ### Qutebrowser ############################################################
    # Definitely. This. First. By placing qutebrowser first, I feel like the   #
    # right version of Qt is installed first, before other Qt applications.    #
    # This may be entirely false, but I've had to reinstall the operating      #
    # system after I screwed up nix channels and installed two separate        #
    # versions of Qt. In order to not make that mistake again:                 #
    #   Qutebrowser First.                                                     #
    ############################################################################

    unstable.qutebrowser                # Lightweight minimal browser (v1.6.1)

    ### Command line utilities #################################################

    escrotum                            # Screenshot tool (what a name...)
    feh                                 # Image viewer
    fish                                # Friendly Interface SHell

    ### My Fish setup ###################################
    # Color scheme:                                     #
    #   curl -L https://get.oh-my.fish | fish           #
    #   omf install agnoster                            #
    # Highlight Colors:                                 #
    #   set fish_color_search_match --background=d33682 #
    #####################################################

    git                                 # Version control
    gnirehtet                           # Reverse tethering (PC -> Mobile)
    gnumake                             # 'make' command to build executables
    htop                                # A better 'top' command
    lynx                                # Terminal web browser
    mdbook                              # A markdown to web "book" generator
    moc                                 # Music player in a terminal
    neofetch                            # screenfetch, but better
    p7zip                               # 7z zip manager
    ranger                              # Terminal file manager
    rofi                                # Window switcher & App launcher
    rtv                                 # Reddit in terminal
    ruby                                # Ruby (Programming language)
    screenfetch                         # Display info about themes to console
    speedtest-cli                       # Speed test in terminal
    tree                                # Print file tree in terminal
    unzip                               # Command to unzip files
    wget                                # Download web files
    youtube-dl                          # YouTube downloader
    zip                                 # Command to zip files

    ### Applications ###########################################################

    arandr                              # Multiple display manager
    ark                                 # Archive manager
    atom                                # Glorified text editor
    blueman                             # Bluetooth manager
    chromium                            # Opensource Chrome browser
    firefox                             # Web browser
    deluge                              # Torrent client
    ghostwriter                         # Markdown editor
    gimp                                # Image editor
    gitkraken                           # Version control management software
    google-play-music-desktop-player    # Google Play Music for desktop
    gparted                             # Partition manager
    graphviz                            # Diagram generation software
    inkscape                            # Vector artwork
    libreoffice-fresh                   # Documents/Spreadsheets/Presentations
    libsForQt5.vlc                      # Video player (VLC)
    pavucontrol                         # Pulse Audio controller
    redshift                            # Screen temperature changer
    shutter                             # Screenshot tool
    sqlitebrowser                       # SQLite .db file browser
    unstable.zathura                    # PDF viewer

    ### Typora Markdown Editor #################################################
    # Typora - another markdown editor with fancy features (such as exporting  # 
    # to PDF). This overrides the build script for typora, in particular:      #
    #   --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \                   #
    # Which fixes a bug where GTK+ doesn't interact with Typora properly.      #
    ############################################################################

    (pkgs.typora.overrideAttrs (oldAttrs: {
      installPhase = ''
        mkdir -p $out/bin $out/share/typora
        {
          cd usr
          mv share/typora/resources/app/* $out/share/typora
          mv share/applications $out/share
          mv share/icons $out/share
          mv share/doc $out/share
        }
        makeWrapper ${electron_3}/bin/electron $out/bin/typora \
          --add-flags $out/share/typora \
          "''${gappsWrapperArgs[@]}" \
          --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
          --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}"
        '';
    }))

    vscode                              # Code editor (think notepad++ or atom)

    ### System-wide theming ####################################################

    breeze-icons                        # Breeze theme icons
    gnome3.adwaita-icon-theme           # Adwaita theme icons
    hicolor_icon_theme                  # Hicolor theme icons

    ### LXAppearance - GTK Themer  ########################
    # Version 0.6.2 has support for BOTH GTK2 and GTK3.   #
    # The latest version on NixOS' stable channel doesn't #
    # support both GTK2 and GTK3, it only supports GTK3.  #
    #######################################################

    (lxappearance.overrideAttrs(old: rec {
        name = "lxappearance-0.6.2";
        src = fetchurl {
          url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
          sha256 = "07r0xbi6504zjnbpan7zrn7gi4j0kbsqqfpj8v2x94gr05p16qj4";
        };
    }))

    arc-theme                           # Arc theme for GTK+
    adapta-gtk-theme                    # Adapta theme for GTK

    ### Clairvoyance SDDM Theme #######################################
    # Custom nix derivation for the Clairvoyance SDDM theme by eayus: #
    #   https://github.com/eayus/sddm-theme-clairvoyance              #
    ###################################################################

    ((import ./clairvoyance.nix).overrideAttrs (oldAttrs: {
      autoFocusPassword = "true";
    }))

    ### Games ##################################################################

    _2048-in-terminal                   # 2048 game in terminal
    minecraft                           # Minecraft video game

    ### Minecraft Launcher #####################################################
    # Minecraft's launcher has updated. The minecraft derivation in nixpkgs    #
    # doesn't use the new launcher. By unpacking it from the .deb file which   #
    # can be downloaded here:                                                  #
    #   https://launcher.mojang.com/download/Minecraft.deb                     #
    # it should be possible to package it into something that Nix can use by   #
    # following the documentation for packaging binaries from here:            #
    #   https://nixos.wiki/wiki/Packaging/Binaries                             #
    ############################################################################
    
    pacvim                              # Pacman, but with vim controls
    unstable.steam                      # Game distribution platform
    #steam-run
    #steamcontroller
    #zeroad                             # 0ad video game - like Age of Empires

    ### Other random stuff #####################################################

    cool-retro-term                     # A retro looking terminal
    elinks                              # Useless terminal based browser

    ### Flash Player for Firefox ##################
    # NPAPI flash player for the Firefox browser. #
    # The nixpkgs version's links are dead.       #
    ###############################################

    ((pkgs.flashplayer).overrideAttrs (oldAttrs: {
      src = fetchurl {
        url = "https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_npapi_linux_debug.x86_64.tar.gz";
        sha256 = "0h16vdar4p8zj6w57ihll71xjr9sy7hdiq4qwvvqndah5c4ym8xl";
      };
    }))

    gnash                               # Flash player
    sl                                  # Display a steam locomotive in terminal

    ### Programming (Java) #####################################################
    
    ant                                 # Java building thingy
    jetbrains.idea-community            # IntelliJ IDEA Java IDE
    maven                               # Java dependency manager
    openjdk11                           # Java Development Kit for Java 11

    ### Programming (Other) ####################################################

    gcc                                 # C/C++ compiler
    nodejs                              # Node.js
    python                              # Python 2.7.15
    python27Packages.debian             # Python 2.7 'debian' package
    python3                             # Python 3.6.8

    ### Programming (Rust) #####################################################

    cargo                               # Rust package manager
    ncurses                             # Library to create Text User Interfaces
    unstable.rustc                      # Rust compiler (v 1.32.0)
    rustup                              # Rust toolchain manager

    ### Programming (Haskell) ##################################################

    cabal-install                       # CLI for Cabal + Hackage (for Haskell)
    ghc                                 # Haskell compiler
    stack                               # Haskell compiler + package manager
    zlib                                # Some zipping library for C?

    haskellPackages.hoogle              # Haskell documentation database
    haskellPackages.container           # Represents Haskell containers (e.g. Monoid)
    haskellPackages.zlib                # Compression library for Haskell

    ### How to get the best Haskell setup ###############################################
    # Install the following system packages: stack cabal-install ghc cachix atom zlib   #
    #                                                                                   #
    # To install hie (Haskell IDE Engine):                                              #
    #   1) "cachix use hie-nix"                                                         #
    #   2) "nix-env -iA hies -f https://github.com/domenkozar/hie-nix/tarball/master"   #
    #                                                                                   #
    # Optional: Install Hasklig font (I use Fira Code Medium)                           #
    #                                                                                   #
    # Install the following packages for atom (using the built in package manager):     #
    #   atom-ide-ui                                                                     #
    #   ide-haskell-hie                                                                 #
    #   language-haskell                                                                #
    #                                                                                   #
    # In atom, Ctrl + , ide-haskell-hie package:                                        #
    #   Settings -> Absolute path to hie executable                                     #
    #   => hie-wrapper                                                                  #
    #                                                                                   #
    # Optional: git clone hie-nix and run the ./update.sh file                          #
    #                                                                                   #
    # In ~/.stack/config.yaml:                                                          #
    #   nix:                                                                            #
    #     enable: true                                                                  #
    #     packages: [zlib.dev, zlib.out]                                                #
    #####################################################################################

    ### GUI/Window Manager #####################################################

    # i3status-rust        coming soon: https://github.com/JorelAli/i3status-rust
    # i3status-rust                     # Better i3 status bar

    ### System tools ###########################################################

    dunst                               # Notification manager
    libnotify                           # Notification library
    networkmanagerapplet                # GUI for networking
    ntfs3g                              # Access a USB drive
    udisks                              # Storage device daemon
    universal-ctags                     # Tool for browsing source code quickly
    xorg.xbacklight                     # Enable screen backlight adjustments
    xorg.xcompmgr                       # Window compositing
    xorg.xev                            # Program to find xmodmap key-bindings
    xorg.xmodmap                        # Keyboard key remapping

    ### Nix related stuff ######################################################

    cachix                              # Compiled binary hosting for Nix

    ### Dictionaries ###########################################################

    hunspell                            # Dictionary for GhostWriter
    hunspellDicts.en-gb-ise             # English (GB with '-ise' spellings)
    hunspellDicts.en-us                 # English (US)

    ### Vim (with my chosen packages of choice) ################################

    (
        with import <nixpkgs> {};

        vim_configurable.customize {
            # Specifies the vim binary name.
            # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
            # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
            name = "vim";

            # List of stuff that would go in ~/.vimrc

            vimrcConfig.customRC = ''
                syntax enable
                set tabstop=4
                set background=dark
                colorscheme solarized
                set number
                set mouse=a
                let g:airline_powerline_fonts = 1
                let g:NERDTreeWinSize=20
                autocmd VimEnter *.rs TagbarOpen
                set backspace=indent,eol,start

                let g:rbpt_colorpairs = [
                    \ ['brown',       'RoyalBlue3'],
                    \ ['Darkblue',    'SeaGreen3'],
                    \ ['darkgray',    'DarkOrchid3'],
                    \ ['darkgreen',   'firebrick3'],
                    \ ['darkcyan',    'RoyalBlue3'],
                    \ ['darkred',     'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['brown',       'firebrick3'],
                    \ ['gray',        'RoyalBlue3'],
                    \ ['black',       'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['Darkblue',    'firebrick3'],
                    \ ['darkgreen',   'RoyalBlue3'],
                    \ ['darkcyan',    'SeaGreen3'],
                    \ ['darkred',     'DarkOrchid3'],
                    \ ['red',         'firebrick3'],
                    \ ]

                let g:rbpt_max = 16
                let g:rbpt_loadcmd_toggle = 0

                au VimEnter * RainbowParenthesesToggle
                au Syntax * RainbowParenthesesLoadRound
                au Syntax * RainbowParenthesesLoadSquare
                au Syntax * RainbowParenthesesLoadBraces

                au BufReadPost *.als set syntax=java
            '';

            ### Vim plugins (installed via VAM) ################################

            vimrcConfig.vam.knownPlugins = pkgs.vimPlugins; 
            vimrcConfig.vam.pluginDictionaries = [
                { names = [
                        "Syntastic"               # Fancy syntax errors + status
                        "ctrlp"                   # Fuzzy finder
                        "vim-airline"             # Fancy status bar
                        "vim-airline-themes"      # Fancy status bar themes
                        "nerdtree"                # File tree on the side of vim
                        "youcompleteme"           # Code completer
                        #TODO: This needs to be enabled using install.py!!

                        "solarized"               # Solarized theme
                        "rainbow_parentheses"     # Rainbow brackets for easy brackets
                        "vim-nix"                 # Syntax etc. for .nix files
                        "vim-toml"                # Syntax etc. for .toml files
                        "gitgutter"               # Shows git changes in sidebar
                        "tagbar"                  # Class outline viewer
                        "easymotion"
                ]; }
            ];
        }
    )


  ];

  ### Programs #################################################################

  programs = {

    adb.enable = true;                  # Enables the Android Debug Bridge

    bash.enableCompletion = true;       # Enable completion in bash shell

    fish.enable = true;                 # Holdup... why is this here?
    fish.shellAliases = {               # Extra fish commands
      neofetchnix = "neofetch --ascii_colors 68 110";
      fonts = "fc-list : family | cut -f1 -d\",\" | sort";
      prettify = "python -m json.tool"; # Prettify json!
      dotp = "dot -Tpdf -o $1.pdf";
      doti = "dot -Tpng -o $1.png";
    };

    less.enable = true;                 # Enables config for the `less` command
    less.commands = { h = "quit"; };    # Rebind the `h` key to quit 

    qt5ct.enable = true;                # Enable qt5ct (fixes Qt applications) 

  };

  ### Fonts ####################################################################

  fonts.fonts = with pkgs; [

    emojione                            # Emoji font
    fira-code-symbols                   # Fancy font with programming ligatures
    fira-code                           # Fancy font with programming ligatures
    font-awesome_4                      # Fancy icons font
    migmix                              # Font with Japanese support
    siji                                # Iconic bitmap font

    ### Programming ligatures ##################################################
    # *This means that -> will look like an actual arrow and >= and <=         #
    # actually look like less than or equal and greater than or equal symbols, #
    # as opposed to what they look like on a computer                          #
    ############################################################################

    ### Japanese Fonts #########################
    ipafont
    kochi-substitute

  ];

  fonts.fontconfig.ultimate.enable = true;

  # Set default monospace font to Fira Code
  fonts.fontconfig.defaultFonts.monospace = [ "Fira Code Medium" "IPAGothic" ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "DejaVu Sans" "IPAPGothic" ];
  fonts.fontconfig.defaultFonts.serif = [ "DejaVu Serif" "IPAPMincho" ];

  ### i18n (Internationalization and Localization) #############################

  i18n = {
#    consoleKeyMap = "gb";
    defaultLocale = "en_GB.UTF-8";
    inputMethod.enabled = "fcitx";
    inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
  };

  ### Hardware Settings ########################################################

  sound.enable = true;                  # Enable sound
  sound.mediaKeys.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };
    bluetooth.enable = true;            # Enable bluetooth 
    bluetooth.powerOnBoot = true;       # Let bluetooth enable on startup
    opengl.driSupport32Bit = true;      # Allow 32 bit support for OpenGL
  };

  # Use fingerprint recognition on the login screen to log in. To add a 
  # fingerprint, use the 'fprintd-enroll' command in the terminal, and scan
  # your fingerprint a few times. I disabled this because this can be a bit
  # unreliable sometimes.

  # security.pam.services.login.fprintAuth = true;

  security.sudo.wheelNeedsPassword = false;  # Use 'sudo' without a password

  ### Services #################################################################

  services = {

    # Adds support for scrolling to change the brightness for i3status-rs
    udev.extraRules = ''  
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    compton = {
      enable = true;                    # Application transparency
      opacityRules = [ "95:class_g = 'konsole'" ];
      # inactiveOpacity = "0.99";
    };

    gnome3.gnome-disks.enable = true;   # Something something USBs
    udisks2.enable = true;              # Something something USBs

    #fprintd.enable = true;             # Fingerprint reader (Disabled -> unreliable)

    printing.enable = true;             # Printing (You know, to a printer...)
    upower.enable = true;               # Battery info

    xserver = {
      enable = true;                    # GUI for the entire computer
      layout = "gb";                    # Use the GB English keyboard layout

      libinput.enable = true;           # Touchpad support
      synaptics = {
        twoFingerScroll = true;         # Two finger scroll for touchpad
        horizTwoFingerScroll = true;    # Two finger horizontal scrolling
      };

      displayManager = {
        sddm.enable = true;             # Login screen manager
        sddm.theme = "clairvoyance";    # Ellis' clairvoyance theme for sddm
        sddm.extraConfig = ''
          [General]
          InputMethod=
          '';

        # Remap keys on start
        sessionCommands = ''
          xmodmap .Xmodmap
        '';
      };

      # Tiling manager to manage windows using keyboard shortcuts instead of 
      # dragging and dropping windows with a mouse
      windowManager.i3 = {
        enable = true;                  # Enable i3 tiling manager
        package = pkgs.i3-gaps;         # Use i3-gaps (lets you have gaps (duh))

        # Command to copy wallpapers from ~/Wallpapers to .background-image on
        # each restart of i3. Turns out, I actually like a certain wallpaper 
        # more than all of the others, so I decided to just keep it as that 
        # instead. https://wall.alphacoders.com/big.php?i=710132

#        extraSessionCommands = ''
#          cp $(ls -d $HOME/Wallpapers/* | shuf -n 1) $HOME/.background-image
#        '';
      };

      # Despite the fact that I don't actually use this desktop manager
      # I keep it installed because it includes the lovely things that
      # I like about KDE, such as Konsole, Dolphin and Kwallet
      desktopManager.plasma5.enable = true;

    };
  };

  ### Systemd Services #########################################################

  systemd.user.services."dunst" = {
    enable = true;
    description = "Notification system daemon";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
  };

  systemd.user.services."xcompmgr" = {
    enable = true;
    description = "Transparency compositing";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSrc = 2;
    serviceConfig.ExecStart = "${pkgs.xcompmgr}/bin/xcompmgr";
  };

  ### User Accounts ############################################################

  users.users.jorel = {
    isNormalUser = true;
    home = "/home/jorel";
    description = "C'Taz'M'Kazm";
    extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" ];
    uid = 1000;
    shell = pkgs.fish;                  # Use fish as the default shell
  };

  ### Nix Configuration (Honestly, I have no idea what this is) ################

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];
    trustedUsers = [ "root" "jorel" ];

    # Literally do NOT enable this setting, it's impure.
    # readOnlyStore = false;            # Allows writing access to /nix/store
  };

  ### NixPkgs Configuration ####################################################

  nixpkgs.config = {
    allowUnfree = true;                 # Allow unfree/proprietary packages
    flashplayer = { debug = true; };    # Flashplayer debug mode has new dl URL
  };

  ### NixOS System Version (Do not touch) ######################################

  system.stateVersion = "18.09";

}
