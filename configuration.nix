# My glorious all powerful NixOS configuration file
# https://github.com/JorelAli/nixos

{ config, pkgs, ... }:

with builtins;
let

  ### Nix channels #############################################################
  # These are channels defined using the `sudo nix-channel --list` command.    #
  # They are as follows:                                                       #
  #   nixos https://nixos.org/channels/nixos-19.03                             #
  #   nixos-old https://nixos.org/channels/nixos-18.09                         #
  #   unstable https://nixos.org/channels/nixos-unstable                       #
  #   unstable-small https://nixos.org/channels/nixos-unstable-small           #
  ##############################################################################

  unstable   = import <unstable>       { config.allowUnfree = true; };
  unstablesm = import <unstable-small> { config.allowUnfree = true; };
  old        = import <nixos-old>      { config.allowUnfree = true; };

##### Optional installation ####################################################

  # Includes: Haskell, GHC, Stack, Atom IDE, Cabal, HIE (GHC v8.4.3)
  haskellSetup = false;

##### Nix expressions ##########################################################
  
  # Calculates the blur strength for compton windows with background blur 
  calcBlurStrength = (input: assert (bitAnd input 1) == 1; 
    foldl' 
      (x: y: x + y) 
      (toString(input) + "," + toString(input)) 
      (genList (x: ",1.000000") (input * input - 1))
    );

##### NixOS configuration starts here ##########################################

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

##### Containers ###############################################################

  containers.jshell = {
    autoStart = true;
    config = { config, pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        openjdk11
      ];
      services.mingetty.autologinUser = "root";
      environment.shellInit = ''
        clear
        jshell
      '';
    };
  };

  containers.test = {
    autoStart = false;
    privateNetwork = true;
    hostAddress = "192.168.101.10";
    localAddress = "192.168.101.11"; #ssh -X testusr@192.168.101.11
    
    config = { config, pkgs, ... }: { 
      environment.systemPackages = with pkgs; [
        hello
        gparted
        ark 
      ];
      
      users.users.testusr = {
        isNormalUser = true;
        home = "/home/testusr";
        description = "test";
        # mkpasswd -m sha-512 <NEW_PASSWORD>
        initialHashedPassword = "$6$0z67w00YMNumxeCY$GfFK.qW/cyV1aHfnRWWSwxByoX.VbikO7EvFjhWG8vj9LfU99wgcLT5wov8iwKfCsSTGXgmV8NDD3D6iBYATG.";
        extraGroups = [ "wheel" ];
        uid = 2000;
      };
      
      services.xserver = {
        enable = true;
        windowManager.i3.enable = true;
      };

      services.openssh = {
        enable = true;
        forwardX11 = true;
      };

      programs.ssh.setXAuthLocation = true;
    };
  };

##### Networking Settings ######################################################

  networking = {
    hostName = "NixOS";
    networkmanager.enable = true;       # Use nm-connection-editor

    firewall = {
      enable = true;                    # Enable firewall
      allowedTCPPorts = [ 25565 ];      # Minecraft
      allowedUDPPorts = [ 25565 ];      # Minecraft
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
    QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.qtCompatVersion}/plugins/platforms";
    #QT_QPA_PLATFORM_PLUGIN_PATH=$(nix-build '<nixpkgs>' -A qt5.qtbase)/lib/qt-5.10/plugins/platforms

    BAT_PAGER = "less -RF";
  };

##### /etc/ Files ##############################################################
  
  /*environment.etc."vconsole.conf" = {
    text = ''
      KEYMAP=uk
      FONT=Lat2-Terminus16
    '';
  };*/

  environment.etc."systemd/journald.conf" = {
    text = "SystemMaxUse=50M";
  };

  # Remove screen tearing
  environment.etc."X11/xorg.conf.d/20-intel.conf" = {
    text = ''
      Section "Device"
        Identifier "Intel Graphics"
        Driver "intel"
        Option "TearFree" "true"
        Option "AccelMethod" "sna"
        Option "SwapbuffersWait" "false"
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

    qutebrowser                         # Lightweight minimal browser (v1.6.2)

    xsel
    wmctrl
    taskwarrior

    any-nix-shell
    idris
#    flutter.engine
    imlib2
#    flutter.flutter

    (import ./breezeAdaptaCursor.nix {inherit stdenv fetchFromGitHub;})

    ### KDE Applications #######################################################

    kdeApplications.kwalletmanager      # Manager for password manager
    kdeApplications.konsole             # Terminal
    kdeconnect                          # Connect linux with your phone
    ksshaskpass                         # Password manager
    libsForQt5.kwallet                  # Password manager

    ### Command line utilities #################################################

    bat                                 # cat command, but better
    cht-sh                              # Everything cheat sheet
    escrotum                            # Screenshot tool (what a name...)
    exa                                 # Better ls command
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
    rsync                               # Better cp command
    rtv                                 # Reddit in terminal
    ruby                                # Ruby (Programming language)
    screenfetch                         # Display info about themes to console
    sl                                  # For when you mistype 'ls'
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
    blueman                             # Bluetooth manager
    dolphin                             # File browser
    filelight                           # View disk usage
    gimp                                # Image editor
    google-chrome                       # Google Chrome browser (Has flash!)
    google-play-music-desktop-player    # Google Play Music for desktop
    gparted                             # Partition manager
    inkscape                            # Vector artwork
    libsForQt5.vlc                      # Video player (VLC)
    mpv                                 # Video player
    redshift                            # Screen temperature changer
    simplescreenrecorder                # ... A simple screen recorder (duh)
    typora                              # Visual markdown editor
    zathura                             # PDF viewer

    ### Backup Applications (You never know when you might need them...) #######

    abiword                             # Word processing
    deluge                              # Torrent client
    gitkraken                           # Advanced git management
    gnumeric                            # Spreadsheets
    pavucontrol                         # Pulse Audio controller
    sqlitebrowser                       # SQLite .db file browser

    ### System-wide theming ####################################################

    papirus-icon-theme                  # Papirus theme icons
    breeze-qt5                          # Breeze theme for qt5 (cursors!)
    numix-solarized-gtk-theme           # Numix solarized theme for GTK & Qt

    lxappearance-062                    # Program that manages themeing 
    clairvoyance                        # SDDM greeter theme

    ### Games ##################################################################

    _2048-in-terminal                   # 2048 game in terminal
    minecraft                           # Minecraft video game
    pacvim                              # Pacman, but with vim controls
    steam                               # Game distribution platform
    vitetris                            # Terminal based tetris game

    ### Programming (Java) #####################################################
    
    ant                                 # Java building tool
    eclipses.eclipse-java               # Eclipse Java IDE
    maven                               # Java dependency manager
    openjdk                             # Java Development Kit for Java 

    ### Programming (Other) ####################################################

    bundler                             # Bundle command for Ruby
    gcc                                 # C/C++ compiler
    gdb                                 # C code debugger
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

    ### GUI/Window Manager #####################################################

    # i3status-rust        coming soon: https://github.com/JorelAli/i3status-rust
    # i3status-rust                     # Better i3 status bar

    ### System tools ###########################################################

    brightnessctl                       # Brightness change for NixOS 19.03
    dunst                               # Notification manager
    libnotify                           # Notification library
    networkmanagerapplet                # GUI for networking
    ntfs3g                              # Access a USB drive
    universal-ctags                     # Tool for browsing source code quickly
    xorg.xbacklight                     # Enable screen backlight adjustments
    xorg.xcompmgr                       # Window compositing
    xorg.xev                            # Program to find xmodmap key-bindings
    xorg.xmodmap                        # Keyboard key remapping

    ### Nix related stuff ######################################################

    cachix                              # Compiled binary hosting for Nix
    nix-index                           # Locate packages
    nox                                 # Better nix searching
    patchelf                            # Patches binaries for Nix support

    ### Dictionaries ###########################################################

    hunspell                            # Dictionary for document programs
    hunspellDicts.en-gb-ise             # English (GB with '-ise' spellings)
    hunspellDicts.en-us                 # English (US)

  ] ++ ( if haskellSetup then [

    ### Programming (Haskell) ##################################################

    atom                                # Glorified text editor (for Haskell w/ HIE)

    cabal-install                       # CLI for Cabal + Hackage (for Haskell)
    ghc                                 # Haskell compiler
    stack                               # Haskell compiler + package manager
    zlib                                # Some zipping library for C?

    haskellPackages.hoogle              # Haskell documentation database
    haskellPackages.container           # Represents Haskell containers (e.g. Monoid)
    haskellPackages.zlib                # Compression library for Haskell

    all-hies.versions.ghc843            # Haskell IDE Engine for GHC v8.4.3

      ### How to get the best Haskell setup ##########################
      # Install the following system packages:                       #
      #   stack cabal-install ghc cachix atom zlib                   #
      #                                                              #
      # To install hie (Haskell IDE Engine):                         #
      #   1) "cachix use hie-nix"                                    #
      #   2) "nix-env -iA hies -f \                                  #
      #        https://github.com/domenkozar/hie-nix/tarball/master" #
      #                                                              #
      # Optional: Install Hasklig font (I use Fira Code Medium)      #
      #                                                              #
      # Install the following packages for atom                      #
      #   (using the built in package manager):                      #
      #   atom-ide-ui                                                #
      #   ide-haskell-hie                                            #
      #   language-haskell                                           #
      #                                                              #
      # In atom, Ctrl + , ide-haskell-hie package:                   #
      #   Settings -> Absolute path to hie executable                #
      #   => hie-wrapper                                             #
      #                                                              #
      # Optional: git clone hie-nix and run the ./update.sh file     #
      #                                                              #
      # In ~/.stack/config.yaml:                                     #
      #   nix:                                                       #
      #     enable: true                                             #
      #     packages: [zlib.dev, zlib.out]                           #
      ################################################################

  ] else [] );


##### Programs #################################################################

  programs = {
    adb.enable = true;                  # Enables the Android Debug Bridge
    bash.enableCompletion = true;       # Enable completion in bash shell

    ### My Fish setup ###################################
    # Color scheme:                                     #
    #   curl -L https://get.oh-my.fish | fish           #
    #   omf install budspencer                          #
    # Highlight Colors:                                 #
    #   set fish_color_search_match --background=d33682 #
    # Remove greeting:                                  #
    #   set fish_greeting                               ##########################################################
    # Solarized budspencer powerline colors:                                                                     #
    #  set budspencer_colors ffffff 073642 6c71c4 ffffff b58900 cb4b16 dc322f d33682 268bd2 073642 268bd2 00ff00 #
    #                                                                                                            #
    ##############################################################################################################

    fish.enable = true;                 # Fish shell (Better bash)
    fish.shellAliases = {               
      arc = "ark";
      config = "sudo vim /etc/nixos/configuration.nix";
      cp = "rsync -ahv --progress";
      dirsize = "du -sh";
      dolphin = "dolphin -stylesheet ~/.config/qt5ct/qss/DolphinFix.qss";
      evalnix = "nix-instantiate --eval";
      fonts = "fc-list : family | cut -f1 -d\",\" | sort";
      gparted = "sudo fish -c gparted";
      history = "history | bat";
      ls = "exa";
      mocp = "mocp --theme solarized";
      neofetchnix = "neofetch --ascii_colors 68 110";
      nix-repl = "nix repl";
      prettify = "python -m json.tool"; # Prettify json!
      rebuild = "sudo nixos-rebuild switch";
      rebuilt = "sudo nixos-rebuild switch";
      vimf = "vim (fzf)";
      batf = "bat (fzf)";
    };

    less.enable = true;                 # Enables config for the `less` command
    less.commands = { h = "quit"; };    # Rebind the `h` key to quit 
    qt5ct.enable = true;                # Enable qt5ct (fixes Qt applications) 
    ssh.askPassword = "${pkgs.ksshaskpass}/bin/ksshaskpass";
    ssh.setXAuthLocation = true;
    ssh.forwardX11 = true;

  };

##### Fonts ####################################################################

  fonts = {
    fonts = with pkgs; [
      emojione                          # Emoji font
      font-awesome_4                    # Fancy icons font
      ipafont                           # Japanese font
      siji                              # Iconic bitmap font
      symbola                           # Braille support for gotop command

      ### Programming ligatures ################################################
      # *This means that -> will look like an actual arrow and >= and <=       #
      # actually look like less than or equal and greater than or equal        #
      # symbols, as opposed to what they look like on a computer               #
      ##########################################################################
      
      fira-code-symbols                 # Fancy font with programming ligatures
      fira-code                         # Fancy font with programming ligatures
      powerline-fonts                   # Fonts for powerlines (Used in my tty)
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
    consoleFont = with pkgs; "${powerline-fonts}/share/fonts/psf/ter-powerline-v28b.psf.gz";
    consoleKeyMap = "uk";
    consoleColors = [ "002b36" "dc322f" "859900" "b58900" "268bd2" "d33682" "2aa198" "eee8d5" "002b36" "cb4b16" "586e75" "657b83" "839496" "6c71c4" "93a1a1" "fdf6e3" ];
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
        paint-on-overlay = true; 
        glx-no-stencil = true;
        unredir-if-possible = true;
        blur-background-exclude = [ "class_g = 'escrotum'" ];
        blur-background = true;
        blur-background-fixed = true;
        blur-kern = "${calcBlurStrength 13}";
        '';
    };

    logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "suspend";
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

    openssh = {
      enable = true;
      forwardX11 = true;
    };



    ### X ######################################################################

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
    postStart = "pkill dunst";
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
    description = "Connect phone with linux";
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
    # Sets vm password to "test". Use `nixos-rebuild build-vm` and `./result/bin/run-*-vm`
    # mkpasswd -m sha-512 <NEW_PASSWORD>
    # initialHashedPassword = "$6$0z67w00YMNumxeCY$GfFK.qW/cyV1aHfnRWWSwxByoX.VbikO7EvFjhWG8vj9LfU99wgcLT5wov8iwKfCsSTGXgmV8NDD3D6iBYATG.";
    extraGroups = [ 
      "audio"                           # Access sound hardware
      "disk"                            # Access /dev/sda /dev/sdb etc.
      "kvm"                             # Access virtual machines
      "networkmanager"                  # Access network manager
      "storage"                         # Access storage devices 
      "video"                           # 2D/3D hardware acceleration & camera
      "wheel"                           # Access sudo command
    ];
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

    # This lets you override package derivations for the entire list of 
    # packages for this configuration.nix file. For example, below, I redefine
    # the derivation of the Typora application to have a different install
    # script. This is then used in the Typora package in the system packages
    # above.
    packageOverrides = pkgs: with pkgs; {

      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };

      ### Typora Markdown Editor #################################################
      # Typora - another markdown editor with fancy features (such as exporting  # 
      # to PDF). This overrides the build script for typora, in particular:      #
      #   --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \                   #
      # Which fixes a bug where GTK+ doesn't interact with Typora properly.      #
      ############################################################################

      typora = typora.overrideAttrs (oldAttrs: {
        postFixup = (builtins.substring 0 (builtins.stringLength oldAttrs.postFixup - 1)) 
          oldAttrs.postFixup + 
          " \\\n --prefix XDG_DATA_DIRS : \"$GSETTINGS_SCHEMAS_PATH\"\n";
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

      ### HIEs #################
      # The Haskell IDE Engine #
      ##########################

      all-hies = import (
        fetchTarball "https://github.com/infinisil/all-hies/tarball/master"
      ) {};

      flutter = import ./flutter.nix {};

      ### Clairvoyance SDDM Theme #######################################
      # Custom nix derivation for the Clairvoyance SDDM theme by eayus: #
      #   https://github.com/eayus/sddm-theme-clairvoyance              #
      ###################################################################

      clairvoyance = (import ./clairvoyance.nix {
        autoFocusPassword = true;
        backgroundURL = "https://images7.alphacoders.com/700/700047.jpg";
        inherit stdenv fetchFromGitHub;
      });

    };
  };

##### NixOS System Version (Do not touch) ######################################

  system.stateVersion = "18.09";

################################################################################
}
