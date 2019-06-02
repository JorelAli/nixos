# My glorious all powerful NixOS configuration file
# https://github.com/JorelAli/nixos

{ config, pkgs, ... }:

let

  ### Nix channels #############################################################
  # These are channels defined using the `sudo nix-channel --list` command.    #
  # They are as follows:                                                       #
  #   nixos https://nixos.org/channels/nixos-19.03                             #
  #   nixos-old https://nixos.org/channels/nixos-18.09                         #
  #   unstable https://nixos.org/channels/nixos-unstable                       #
  ##############################################################################

  unstable   = import <unstable>       { config.allowUnfree = true; };
  unstablesm = import <unstable-small> { config.allowUnfree = true; };
  old        = import <nixos-old>      { config.allowUnfree = true; };

##### Other Nix expressions ####################################################

  all-hies = 
    import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};

  # Calculates the blur strength for compton windows with background blur 
  calcBlur = (input: 
    builtins.foldl' 
      (x: y: x + y) 
      (builtins.toString(input) + "," + builtins.toString(input)) 
      (builtins.genList (x: ",1.000000") (input * input - 1))
    );
in {

##### NixOS important settings #################################################

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
    ./vim.nix
  ];

##### Boot Settings ############################################################

  boot = {
    loader.systemd-boot.enable = true;        # Use systemd bootloader
    loader.efi.canTouchEfiVariables = true;   # Allow EFI variable modifications
    loader.grub.useOSProber = true;           # Search for other OSs

    extraTTYs = [ "tty8" "tty9" ];            # More terminals!
    extraModulePackages = [ 
      config.boot.kernelPackages.exfat-nofuse # exFAT format for USBs/HDDs
    ];
  };

##### Networking Settings ######################################################

  networking = {
    hostName = "NixOS";
    networkmanager.enable = true;       # Use nm-connection-editor

    firewall = {
      enable = true;                    # Enable firewall

      allowedTCPPorts = [ 25565 ];
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; } 
      ];

      allowedUDPPorts = [ 25565 ];
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; } 
      ];
    };
  };

##### Regional Settings ########################################################

  time.timeZone = "Europe/London";

##### Environment Variables ####################################################

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

    _JAVA_OPTIONS= "-Dawt.useSystemAAFontSettings=lcd";
    QT_XCB_GL_INTEGRATION = "xcb_egl";
  };

##### /etc/ Files ##############################################################

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

  # Remove screen tearing
  environment.etc."X11/xorg.conf.d/20-intel.conf" = {
    text = ''
      Section "Device"
 
        Identifier "Intel Graphics"
 
        Driver "intel"
 
        Option "TearFree" "true"
 
      EndSection
    '';
  };

##### System Packages ##########################################################

  environment.systemPackages = with pkgs; [

    ### Qutebrowser ############################################################
    # There's this annoying bug with NixOS where NixOS has issues with         #
    # conflicting versions of Qt. This causes applications that use Qt to fail #
    # to run with the following error message:                                 #
    #   Cannot mix incompatible Qt library (ver.) with this library (ver.)     #
    #                                                                          #
    # The only way I managed to fix this error was to reinstall NixOS. To make #
    # sure I never make the same mistake first, Qutebrowser comes first.       #
    #                                                                          #
    # See:                                                                     #
    #   https://github.com/NixOS/nixpkgs/issues/30551                          #
    #   https://github.com/NixOS/nixpkgs/issues/37864                          #
    ############################################################################

    unstable.qutebrowser                # Lightweight minimal browser (v1.6.2)

    ### KDE Applications #######################################################

    kdeApplications.kwalletmanager      # Manager for password manager
    kdeApplications.konsole             # Terminal
    kdeconnect                          # Connect linux with your phone
    kdeFrameworks.kinit
    ksshaskpass                         # Password manager
    libsForQt5.kwallet                  # Password manager

    ### Command line utilities #################################################

    bat                                 # cat command, but better
    bundler                             # Ruby bundle thing
    escrotum                            # Screenshot tool (what a name...)
    feh                                 # Image viewer
    fzf                                 # Find files easily
    git                                 # Version control
    git-lfs                             # Support for large files for git
    gnirehtet                           # Reverse tethering (PC -> Mobile)
    gnumake                             # 'make' command to build executables
    gotop                               # Shows processes, CPU usage etc.
    htop                                # A better 'top' command
    lynx                                # Terminal web browser
    mdbook                              # A markdown to web "book" generator
    moc                                 # Music player in a terminal
    neofetch                            # screenfetch, but better
    p7zip                               # 7z zip manager
    pdfgrep                             # Grep, but for PDF files
    ranger                              # Terminal file manager
    ripgrep                             # Better grep (use rg command)
    rofi                                # Window switcher & App launcher
    rtv                                 # Reddit in terminal
    ruby                                # Ruby (Programming language)
    screenfetch                         # Display info about themes to console
    speedtest-cli                       # Speed test in terminal
    tree                                # Print file tree in terminal
    unixtools.xxd                       # Some hex viewer
    unzip                               # Command to unzip files
    urlview                             # View URLs in a document (for rtv)
    wget                                # Download web files
    youtube-dl                          # YouTube downloader
    zip                                 # Command to zip files

    ### Applications ###########################################################

    arandr                              # Multiple display manager
    ark                                 # Archive manager
    atom                                # Glorified text editor
    blueman                             # Bluetooth manager
    chromium                            # Opensource Chrome browser
    dolphin                             # File browser
    kdeApplications.dolphin-plugins     # Plugin support for dolphin
    firefox                             # Web browser
    deluge                              # Torrent client
    gimp                                # Image editor
    gitkraken                           # Version control management software
    google-play-music-desktop-player    # Google Play Music for desktop
    gparted                             # Partition manager
    graphviz                            # Diagram generation software
    inkscape                            # Vector artwork
    libreoffice-fresh                   # Documents/Spreadsheets/Presentations
    libsForQt5.vlc                      # Video player (VLC)
    mpv                                 # Video player
    pavucontrol                         # Pulse Audio controller
    pidgin-with-plugins                 # IM program           
    redshift                            # Screen temperature changer
    shutter                             # Screenshot tool
    skype                               # Messaging & Video calling platform
    sqlitebrowser                       # SQLite .db file browser
    typora                              # Visual markdown editor
    zathura                             # PDF viewer

    ### System-wide theming ####################################################

    papirus-icon-theme                  # Papirus theme icons
    breeze-qt5                          # Breeze theme for qt5 (cursors!) <<- ----------------------- Fix this! 
    numix-solarized-gtk-theme           # Numix solarized theme for GTK & Qt
    
    lxappearance-062                    # Program that manages themeing 

    ### Clairvoyance SDDM Theme #######################################
    # Custom nix derivation for the Clairvoyance SDDM theme by eayus: #
    #   https://github.com/eayus/sddm-theme-clairvoyance              #
    ###################################################################

    ((import ./clairvoyance.nix).overrideAttrs (oldAttrs: rec {
      autoFocusPassword = "true";
      backgroundURL = "https://images7.alphacoders.com/700/700047.jpg";
      installPhase = oldAttrs.installPhase + "cp ${builtins.fetchurl backgroundURL} $out/share/sddm/themes/clairvoyance/$background";
      background = "Assets/Background.jpg";
    }))

    ### Games ##################################################################

    _2048-in-terminal                   # 2048 game in terminal
    minecraft                           # Minecraft video game
    pacvim                              # Pacman, but with vim controls
    steam                               # Game distribution platform
    vitetris                            # Terminal based tetris game

    ### Other random stuff #####################################################

    cool-retro-term                     # A retro looking terminal
    elinks                              # Useless terminal based browser
    gnash                               # Flash player
    sl                                  # Display a steam locomotive in terminal

    ### Programming (Java) #####################################################
    
    ant                                 # Java building tool
    eclipses.eclipse-java               # Eclipse Java IDE (my favourite IDE)
    maven                               # Java dependency manager
    openjdk11                           # Java Development Kit for Java 11

    ### Programming (Other) ####################################################

    bundler                             # Bundle command for Ruby
    gcc                                 # C/C++ compiler
    gdb                                 # C code debugger
    jekyll                              # Static site generator
    python                              # Python 2.7.15
    python27Packages.debian             # Python 2.7 'debian' package
    python3                             # Python 3.6.8
    valgrind                            # C/C++ memory debugging tool

    ### Programming (Node.JS) ##################################################

    ###############################################################
    # To lookup packages for nix, use the following code:         #
    #   nix-env -qaPA 'nixos.nodePackages' | grep -i <npm module> #
    ###############################################################

    nodejs                              # Node.JS
    nodePackages.vue-cli                # Vue.JS package

    ### Programming (Rust) #####################################################

    ncurses                             # Library to create Text User Interfaces
    rustup                              # Rust toolchain manager

    ### Programming (Haskell) ##################################################

    cabal-install                       # CLI for Cabal + Hackage (for Haskell)
    ghc                                 # Haskell compiler
    stack                               # Haskell compiler + package manager
    zlib                                # Some zipping library for C?

    haskellPackages.hoogle              # Haskell documentation database
    haskellPackages.container           # Represents Haskell containers (e.g. Monoid)
    haskellPackages.zlib                # Compression library for Haskell

    all-hies.versions.ghc843            # Haskell IDE Engine for GHC v8.4.3

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

    brightnessctl                       # Brightness change for NixOS 19.03
    dunst                               # Notification manager
    libnotify                           # Notification library
    networkmanagerapplet                # GUI for networking
    ntfs3g                              # Access a USB drive

      #########################################################################
      # If a USB pen is mounted and you can't access it, use                  #
      # `chown <username> <usb mount point>` (or wherever the mount point is) #
      # If the USB is not mounted, use `udisksctl mount -b /dev/<usb>`        #
      #########################################################################

    universal-ctags                     # Tool for browsing source code quickly
    xorg.xbacklight                     # Enable screen backlight adjustments
    xorg.xcompmgr                       # Window compositing
    xorg.xev                            # Program to find xmodmap key-bindings
    xorg.xmodmap                        # Keyboard key remapping

    ### Nix related stuff ######################################################

    cachix                              # Compiled binary hosting for Nix
#    unstable.nixbox                     # Nix operations "in a box"
    nix-index                           # Locate packages
    nox                                 # Better nix searching
    patchelf                            # Patches binaries for Nix support

    (import (fetchGit "https://github.com/haslersn/fish-nix-shell"))

    ### Dictionaries ###########################################################

    hunspell                            # Dictionary for document programs
    hunspellDicts.en-gb-ise             # English (GB with '-ise' spellings)
    hunspellDicts.en-us                 # English (US)

  ];


##### Programs #################################################################

  programs = {

    ssh.askPassword = "${pkgs.ksshaskpass}/bin/ksshaskpass";
    adb.enable = true;                  # Enables the Android Debug Bridge

    bash.enableCompletion = true;       # Enable completion in bash shell

    ### My Fish setup ###################################
    # Color scheme:                                     #
    #   curl -L https://get.oh-my.fish | fish           #
    #   omf install agnoster                            #
    # Highlight Colors:                                 #
    #   set fish_color_search_match --background=d33682 #
    # Remove greeting:                                  #
    #   set fish_greeting                               #
    #####################################################

    fish.enable = true;                 # Holdup... why is this here?
    fish.shellAliases = {               # Extra fish commands
      neofetchnix = "neofetch --ascii_colors 68 110";
      fonts = "fc-list : family | cut -f1 -d\",\" | sort";
      prettify = "python -m json.tool"; # Prettify json!
      dotp = "dot -Tpdf -o $1.pdf";
      doti = "dot -Tpng -o $1.png";
      dolphin = "dolphin -stylesheet ~/.config/qt5ct/qss/DolphinFix.qss";
      "@executable" = "chmod a+x";      # Make a file executable
    };
    fish.promptInit = ''
      fish-nix-shell --info-right | source
    '';
    bash.shellAliases = {
      dolphin = "dolphin -stylesheet ~/.config/qt5ct/qss/DolphinFix.qss";
    };

    less.enable = true;                 # Enables config for the `less` command
    less.commands = { h = "quit"; };    # Rebind the `h` key to quit 

    qt5ct.enable = true;                # Enable qt5ct (fixes Qt applications) 

  };

##### Fonts ####################################################################

  fonts = {
    fonts = with pkgs; [
      emojione                          # Emoji font
      font-awesome_4                    # Fancy icons font
      ipafont                           # Japanese font
      kochi-substitute                  # Japanese font
      migmix                            # Japanese font
      siji                              # Iconic bitmap font
      symbola                           # Braille support for gotop command

      ### Programming ligatures ################################################
      # *This means that -> will look like an actual arrow and >= and <=       #
      # actually look like less than or equal and greater than or equal        #
      # symbols, as opposed to what they look like on a computer               #
      ##########################################################################
      
      fira-code-symbols                 # Fancy font with programming ligatures
      fira-code                         # Fancy font with programming ligatures
  
#      nerdfonts <<- Coming soon!!
    ];

    fontconfig.defaultFonts = {
      monospace = [ "Fira Code Medium" "Symbola" "IPAGothic" ];
#     sansSerif = [ "DejaVu Sans" "IPAPGothic" ];
#     serif = [ "DejaVu Serif" "IPAPMincho" ];
    };

  };

##### i18n (Internationalization and Localization) #############################

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    inputMethod.enabled = "fcitx";
    inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
  };

##### Hardware Settings ########################################################

  sound.enable = true;                  # Enable sound
  sound.mediaKeys.enable = true;        # Enable sound keys (play/pause)

  hardware = {
    pulseaudio = {
      enable = true;                    # Enable pulseaudio sound manager
      package = pkgs.pulseaudioFull;    # Use full version (bluetooth support)
      support32Bit = true;             
    };

    bluetooth.enable = true;            # Enable bluetooth 
    bluetooth.powerOnBoot = true;       # Let bluetooth enable on startup

    opengl = {
      enable = true;                    # Enable OpenGL
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

##### Security Settings ########################################################

  security.sudo.wheelNeedsPassword = false;  # Use 'sudo' without a password
  security.chromiumSuidSandbox.enable = true;

##### Services #################################################################

  services = {
  
    ### Compton ###########################################
    # Compositing effects for windows (Blur backgrounds!) #
    #######################################################
    compton = {
      enable = true;                    # Application transparency
      opacityRules = [ 
        "95: class_g = 'konsole'"       # Always blur for konsole
        "85: class_g = 'dolphin'"       # Always blur for dolphin
      ];
      vSync = "opengl-swc";             # Remove screen tearing
      backend = "glx";
      inactiveOpacity = "0.85";         # Make programs blur on unfocus
      extraOptions = ''
        unredir-if-possible = true;
        blur-background-exclude = "(class_g = 'escrotum')";
        blur-background = true;
        blur-background-fixed = true;
        blur-kern = "${calcBlur 11}";
        '';
    };
    
    gnome3.gnome-disks.enable = true;   # Something something USBs
    nixosManual.showManual = true;      # Enable the NixOS manual in tty 8
    printing.enable = true;             # Printing (You know, to a printer...)
    rogue.enable = true;                # Enable the rogue game in tty 9 
    teamviewer.enable = true;           # Enable teamviewer
    udisks2.enable = true;              # Something something USBs
    upower.enable = true;               # Battery info

    # Adds support for scrolling to change the brightness for i3status-rs
    udev.extraRules = ''  
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    ### X Server ###############################################################

    xserver = {
      enable = true;                    # GUI for the entire computer
      exportConfiguration = true;       # symlink the config to /etc/X11/xorg.conf
      gdk-pixbuf.modulePackages = [ 
        pkgs.librsvg 
      ];
      layout = "gb";                    # Use the GB English keyboard layout
      libinput.enable = true;           # Touchpad support

      synaptics = {
        twoFingerScroll = true;         # Two finger scroll for touchpad
        horizTwoFingerScroll = true;    # Two finger horizontal scrolling
      };

      ### Display Manager ####################
      # Think of it as a lock screen, except #
      # it only shows when the computer is   # 
      # turned on for the first time         #
      ########################################

      displayManager = {
        sessionCommands = ''xmodmap .Xmodmap'';
        sddm.enable = true;             # Login screen manager
        sddm.theme = "clairvoyance";    # Clairvoyance theme for sddm
        sddm.extraConfig = ''
          [General]
          InputMethod=
        '';
      };

      ### Window Manager ##########################################
      # Displays windows (applications). I'm using i3, the tiling #
      # manager which uses keyboard shortcuts instead of dragging #
      # windows with a mouse to move them around and change size  #
      #############################################################
      
      windowManager.i3 = {
        enable = true;                  # Enable i3 tiling manager
        package = pkgs.i3-gaps;         # Use i3-gaps (lets you have gaps (duh))

        # Command to copy wallpapers from ~/Wallpapers to .background-image on
        # each restart of i3. Turns out, I actually like a certain wallpaper 
        # more than all of the others, so I decided to just keep it as that 
        # instead. https://wall.alphacoders.com/big.php?i=710132

        # extraSessionCommands = ''
        #   cp $(ls -d $HOME/Wallpapers/* | shuf -n 1) $HOME/.background-image
        # '';
      };
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
    description = "Transparency compositing service";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSrc = 2;
    serviceConfig.ExecStart = "${pkgs.xcompmgr}/bin/xcompmgr";
  };

  systemd.user.services."kdeconnect" = {
    enable = true;
    description = "Connext phone with linux";
    wantedBy = [ "graphical-session.target" "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.kdeconnect}/lib/libexec/kdeconnectd";
  };

##### User Accounts ############################################################

  users.users.jorel = {
    isNormalUser = true;
    home = "/home/jorel";
    description = " ";                  # The ultimate sddm aesthetics
    extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" ];
    uid = 1000;
    shell = pkgs.fish;                  # Use fish as the default shell
  };

##### Nix Configuration (Honestly, I have no idea what this is) ################

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];
    trustedUsers = [ "root" "jorel" ];
    maxJobs = 4;
    autoOptimiseStore = true;

    #####################################################################
    # This setting, when enabled to true, allows writing access to the  #
    # /nix/store/ directories. This isn't a good thing on NixOS, since  #
    # new derivations can override these folders (or be deleted with    #
    # nix's garbage collector) whenever the system does so. This should #
    # only be toggled for development testing purposes ONLY.            #
    #####################################################################
    
    readOnlyStore = false;            # Allows writing access to /nix/store
  };

##### NixPkgs Configuration ####################################################

  nixpkgs.config = {
    allowUnfree = true;                 # Allow unfree/proprietary packages
    flashplayer = { debug = true; };    # Flashplayer debug mode has new dl URL

    # This lets you override package derivations for the entire list of 
    # packages for this configuration.nix file. For example, below, I redefine
    # the derivation of the Typora application to have a different install
    # script. This is then used in the Typora package in the system packages
    # above.
    packageOverrides = pkgs: with pkgs; {

      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };

      pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
        ## Add whatever plugins are desired (see nixos.org package listing).
        plugins = [ purple-facebook purple-discord purple-matrix ];
      };

      ### Typora Markdown Editor #################################################
      # Typora - another markdown editor with fancy features (such as exporting  # 
      # to PDF). This overrides the build script for typora, in particular:      #
      #   --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \                   #
      # Which fixes a bug where GTK+ doesn't interact with Typora properly.      #
      ############################################################################

      typora = typora.overrideAttrs (oldAttrs: {
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
      });

      ### LXAppearance - GTK Themer  ########################
      # Version 0.6.2 has support for BOTH GTK2 and GTK3.   #
      # The latest version on NixOS' stable channel doesn't #
      # support both GTK2 and GTK3, it only supports GTK3.  #
      #######################################################
  
      lxappearance-062 = lxappearance.overrideAttrs(old: rec {
          name = "lxappearance-0.6.2";
          src = fetchurl {
            url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
            sha256 = "07r0xbi6504zjnbpan7zrn7gi4j0kbsqqfpj8v2x94gr05p16qj4";
          };
      });
    };
  };

##### NixOS System Version (Do not touch) ######################################

  system.stateVersion = "18.09";

################################################################################
}
