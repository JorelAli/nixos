# My glorious all powerful NixOS configuration file
# https://github.com/JorelAli/nixos

{ config, pkgs, lib, ... }:

with builtins; let 

##### Important settings #######################################################

  haskellSetup = false;                 # Haskell, GHC, Stack, Atom ...
  unfreePermitted = true;               # Allow installing unfree packages

in let

  ### Nix channels #############################################################
  # These are channels defined using the `sudo nix-channel --list` command.    #
  # They are as follows:                                                       #
  #   nixos https://nixos.org/channels/nixos-19.03                             #
  #   unstable https://nixos.org/channels/nixos-unstable                       #
  ##############################################################################

  unstable   = import <unstable>       { config.allowUnfree = unfreePermitted; };

  reallyOld = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "083d0890f50c7bff87419b88465af6589faffa2e";
    sha256 = "13gldascq0wjifcpd8sh0rq0gx074x1n2ybx5mwq6hinjplgfi50";
  }) {};

  polybarPin = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "9543e3553719894e71591c5905889fc4ffaa5932";
    sha256 = "0x86w7lxhfdchnqfan6fqpj6j09mjz2sq1plmbwchnqfjg37akfa";
  }) {};

  gMusicPin = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "c1b3b6f8b22fe11b894c236bcfe6522c6a46dc5d";
   sha256 = "04i4iy26pa585bwy43487k27arigyrsdh6vv0khz5n58ixswgkfa";
  }) {};

  mdbookPin = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "a7e63f2eee45dbd92a2ddbc5dd579ee9c07b087e";
    sha256 = "0makb1kwxghdx3fqcqa2ixs4njs76j9jj90d80kxq5ls80assl0c";
  }) {};

  nix-2003 = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "1db42b7fe3878f3f5f7a4f2dc210772fd080e205";
    sha256 = "05k9y9ki6jhaqdhycnidnk5zrdzsdammbk5lsmsbz249hjhhgcgh";
  }) {};

  firacode52Pin = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "33a7767fa1951dfda001f0313ea12eb37b43eb8e";
    sha256 = "0r02k8l4f19gl3glinhijfqrr4yfzm1iv4q03ac5kdfj2qdvk8ml";
  }) {};
  
  #  https://github.com/NixOS/nixpkgs/archive/083d0890f50c7bff87419b88465af6589faffa2e.tar.gz

##### Nix expressions ##########################################################
  
  nixSnowflake = fetchurl { 
    url = https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg; 
    sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
  };

  color = id: (import ./programconfigs/configutil.nix).getColor id false;

##### NixOS configuration starts here ##########################################

in with lib; {

##### NixOS important settings #################################################

  imports = [
    ./hardware-configuration.nix        # Import hardware configuration
    ./cachix.nix                        # Import cached nixpkg locations
    ./extrapackages/vim.nix             # Import neovim setup
    ./programthemes.nix
    ./glib-networking.nix
  ] ++ [
    ./modules/dunst.nix
#    ./modules/emojione.nix
    ./modules/xcompmgr.nix
#    ./modules/wayfire.nix
  ];

## Docker

  virtualisation = {
    docker.enable = true;
  };

##### Boot Settings ############################################################

  boot = {
    loader.systemd-boot.enable = true;        # Use systemd bootloader
    loader.efi.canTouchEfiVariables = true;   # Allow EFI variable modifications
    loader.grub.useOSProber = true;           # Search for other OSs

    extraModulePackages = [ 
      #config.boot.kernelPackages.exfat-nofuse # exFAT format for USBs/HDDs
    ];
  };

##### Console Settings #########################################################

  console = {
    #extraTTYs = [ "tty8" "tty9" "tty10" ];            # More ttys!
    font = with pkgs;            # Set default TTY font as powerline
      "${powerline-fonts}/share/consolefonts/ter-powerline-v28b.psf.gz";
    keyMap = "uk";               # TTY keyboard layout = UK layout
    colors = [                   # The 16 terminal colors 
      "${color 0}" "${color 1}" "${color 2}" "${color 3}" 
      "${color 4}" "${color 5}" "${color 6}" "${color 7}" 
      "${color 8}" "${color 9}" "${color 10}" "${color 11}" 
      "${color 12}" "${color 13}" "${color 14}" "${color 15}"
    ];
    earlySetup = true;
  };

##### Containers ###############################################################

##### Networking Settings ######################################################

  networking = {
    hostName = "NixOS";                 # Set computer's hostname
    networkmanager.enable = true;       # Use nm-connection-editor
    networkmanager.packages = with pkgs; [ gnome3.networkmanager-openvpn ];

    firewall = {
      enable = true;                    # Enable firewall
      allowedTCPPorts = [ 
        80
        9925
        25565                           # Minecraft
        #22070                           # Syncthing relay
        #22067                           # Syncthing relay
      ];
      allowedUDPPorts = [ 25565 ];      # Minecraft
    };
  };

##### Regional Settings ########################################################

  time.timeZone = "Europe/London";

##### Environment Variables ####################################################

  environment.variables = {
    #XCURSOR_PATH = [
    #  "${config.system.path}/share/icons"
    #  "$HOME/.icons"
    #  "$HOME/.nix-profile/share/icons"
    #];

    GTK_DATA_PREFIX = [
      "${config.system.path}"
    ];

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";

#    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd"; # Java font antialiasing
    QT_XCB_GL_INTEGRATION = "xcb_egl";
    QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.qtCompatVersion}/plugins/platforms";

    ANDROID_HOME = "$HOME/Android/Sdk"; # Set the home of the android SDK
    
    BAT_PAGER = "less -RF";             # Use less -RF as the pager for bat
    PAGER = "less -RF";                 # Use less -RF as the pager for git

    JAVA_HOME = "${unstable.jdk16_headless}";

    DCS = (import ./secrets.nix).DCS;

    TERMINAL = "kitty";
    /*KITTY_CONFIG_DIRECTORY = 
      let 
        kitty-config = import ./programconfigs/kittyconf.nix;
        kittyConfigPath = toFile "kitty.conf" kitty-config;
      in "${dirOf kittyConfigPath}";*/
  };

##### /etc/ Files ##############################################################
  
  # Sets a max size of 50MB for systemd journal logs
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
        Option "SwapbuffersWait" "true"
      EndSection
    '';
  };

  environment.etc."qutebrowserhomepage.html" = {
    text = ''
      <!DOCTYPE html>
      <html>
        <head>
          <style>
            h1 {
              left: 0;
              line-height: 200px;
              margin-top: -100px;
              position: absolute;
              text-align: center;
              top: 50%;
              width: 100%;
              font-family: Fira Code Medium;
              color: #${color "fg"};
            }
          </style>
        </head>
        <body style="background: #${color "bg"};">
          <h1>->> You're in a browser <<-</h1>
        </body>
      </html>
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

    unstable.qutebrowser                # Lightweight minimal browser (v1.7.0)

    ### FHS user environment ###################################################
    # A very glorious sandbox that uses the Linux FHS-compatible sandbox. As   #
    # described by the Nixpkgs manual:                                         #
    #   This allows one to run software which is hard or unfeasible to patch   #
    #   for NixOS -- 3rd-party source trees with FHS assumptions, games        #
    #   distributed as tarballs, software with integrity checking and/or       #
    #   external self-updated binaries. It uses Linux namespaces feature to    # 
    #   create temporary lightweight environments which are destroyed after    #
    #   all child processes exit, without root user rights requirement.        #
    ############################################################################

    (buildFHSUserEnv {
      name = "fhs";
      runScript =  let
        gsettings_schemas = 
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
          + ":"
          + "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}";
        in "bash --rcfile <(echo 'export XDG_DATA_DIRS=${gsettings_schemas}')";
      targetPkgs = pkgs: with pkgs; [
        alsaLib atk cairo cups dbus expat file fontconfig freetype gdb git glib 
        gnome3.gdk_pixbuf gnome3.gtk libnotify libxml2 libxslt
        netcat nspr nss  strace udev watch wget which xorg.libX11
        xorg.libXScrnSaver xorg.libXcomposite xorg.libXcursor xorg.libXdamage
        xorg.libXext xorg.libXfixes xorg.libXi xorg.libXrandr xorg.libXrender
        xorg.libXtst xorg.libxcb xorg.xcbutilkeysyms zlib zsh
        curlFull openjdk libglvnd valgrind gnome2.pango gnome2.GConf gtk2-x11
        xdg_utils flite fuse ncurses5 clang_8 llvm_8 libgit2
        x2goclient glibc gnulib gnome3.nautilus gnome3.gsettings_desktop_schemas
        gnome3.dconf gtk3
      ]; })

    ### KDE Applications #######################################################
    # Despite the fact that I don't (really) use a desktop environment, I do   #
    # like KDE's password management system, kwallet, to manage various        #
    # passwords, for things such as pushing to git.                            #
    ############################################################################

    #nix-2003.kdeApplications.kwalletmanager
    #kdeApplications.kwalletmanager      # Manager for password manager
    libsForQt5.kwalletmanager
    ksshaskpass                         # Password manager
    libsForQt5.kwallet                  # Password manager

    ### Command line utilities #################################################
    # A very exhaustive list of command-line commands                          #
    ############################################################################

    docker-compose

    bat                                 # cat command, but better
    cht-sh                              # Everything cheat sheet
    escrotum                            # Screenshot tool (what a name...)
    exa                                 # Better ls command
    feh                                 # Image viewer
    ffmpeg-full                         # Used to record the screen
    file                                # View information about a file
    fzf                                 # Find files easily
    git                                 # Version control
    git-lfs                             # Support for large files for git
    gnirehtet                           # Reverse tethering (PC -> Mobile)
    gnumake                             # 'make' command to build executables
    gotop                               # Shows processes, CPU usage etc.
    htop                                # A better 'top' command
    iw                                  # Wireless device info
    jq                                  # Command-line JSON processor
    unstable.mdbook                              # A markdown to web "book" generator
    moc                                 # Music player in a terminal
    neofetch                            # screenfetch, but better
    neovim-remote                       # Remotely control neovim
    p7zip                               # 7z zip manager
    pdfgrep                             # Grep, but for PDF files
    playerctl                           # Control media player (e.g. play/pause)
    pup                                 # Streaming HTML processor/selector
    ranger                              # Terminal file manager
    ripgrep                             # Better grep (use rg command)
    #rofi                                # Window switcher & App launcher
    #rofi-emoji
    (rofi.override {plugins=[rofi-file-browser rofi-emoji rofi-calc];})

    rsync                               # Better cp command
    rtv                                 # Reddit in terminal
    ruby                                # Ruby (Programming language)
    screenfetch                         # Display info about themes to console
    sl                                  # For when you mistype 'ls'
    speedtest-cli                       # Speed test in terminal
    taskwarrior                         # Task management in the terminal
    tree                                # Print file tree in terminal
    unixtools.xxd                       # Some hex viewer
    unzip                               # Command to unzip files
    urlview                             # View URLs in a document (for rtv)
    wget                                # Download web files
    xclip
    yaml2json
    youtube-dl                          # YouTube downloader
    zip                                 # Command to zip files

    ### Applications ###########################################################

    arandr                              # Multiple display manager
    ark                                 # Archive manager
    blueman                             # Bluetooth manager
    brave                               # Chromium based browser
    code                                # VSCode with extensions
    filelight                           # View disk usage
    gimp                                # Image editor
    gnome3.nautilus                     # File browser
    gnome3.sushi
    gMusicPin.google-play-music-desktop-player    # Google Play Music for desktop
    inkscape                            # Vector artwork
    #kitty                               # Terminal
    unstable.kitty
    #libsForQt5.vlc                      # Video player (VLC)
    pinta                               # Paint.NET for Linux
    vlc
    mpv                                 # Video player
    peek                                # Easy gif creator
    simplescreenrecorder                # ... A simple screen recorder (duh)
    #syncthing                           # File syncing program across devices
    typora
    thunderbird
    x2goclient                          # An x2go client (Similar to VNC)
    zathura                             # PDF viewer

    ### Backup Applications (You never know when you might need them...) #######

    abiword                             # Word processing
    deluge                              # Torrent client
    gparted                             # Partition manager
    libreoffice                         # More word processing
    pavucontrol                         # Pulse Audio controller
    sqlitebrowser                       # SQLite .db file browser

    ### System-wide theming ####################################################

    breeze-qt5                          # Breeze theme for qt5 (cursors!)
    clairvoyance                        # SDDM greeter theme
    gnome3.adwaita-icon-theme           # Adwaita icon theme
    lxappearance-062                    # Program that manages themeing 
    papirus-icon-theme                  # Papirus theme icons
    wmctrl                              # Budspencer requirement for fish shell
    xsel                                # Budspencer requirement for fish shell

    ### Games ##################################################################

    _2048-in-terminal                   # 2048 game in terminal
    mahjong                             # Mahjong game
    minecraft-launcher                  # Minecraft (actually updated)
    pacvim                              # Pacman, but with vim controls
    vitetris                            # Terminal based tetris game

    ### Programming (Java) #####################################################
    
    unstable.eclipses.eclipse-java               # Eclipse Java IDE
#    (with eclipses; buildEclipse {
#    name = "eclipse-java-oxygen";
#    description = "Eclipse IDE for Java Developers";
#    src =
#      fetchurl {
#        url = "http://mirror.tspu.ru/eclipse/technology/epp/downloads/release/oxygen/3a/eclipse-java-oxygen-3a-linux-gtk-x86_64.tar.gz";
#        sha512 = "0hmm2c0nv2lk406x4a3yd5rpzswm89l9zdd1rjz7cwg5byvdnbq7lawvbc45fgxx7bkzq2nq0hlrifqmwmh6if0dxhdjrv6ansfscv3";
#      };
#  })
    unstable.maven                               # Java dependency manager
    gradle                              # Java dependency manager
    unstable.jdk16_headless                             # Java Development Kit for Java 

    ### Programming (Other) ####################################################

    bundler                             # Bundle command for Ruby
    ccls                                # C/C++ language server protocol
    gcc                                 # C/C++ compiler
    gdb                                 # C code debugger
    llvm_8                              # LLVM 
    python                              # Python 2.7.15
    python27Packages.debian             # Python 2.7 'debian' package
    python3                             # Python 3.6.8
    python37Packages.pylint             # Python linter
    sqlite
    valgrind                            # C/C++ memory debugging tool

    # Other
    gvfs # trash support for VSCode?

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
    cargo                               # Rust package manager
    rustc                               # Rust compiler
    pkgconfig                           # Compiler helper tool

    ### Programming (Elm) ######################################################

    unstable.elmPackages.elm            # Elm programming language
    unstable.elmPackages.elm-live       # An alternative to the Elm reactor
    unstable.elmPackages.elm-test
    unstable.elmPackages.elm-format
    unstable.elmPackages.elm-analyse
    unstable.elmPackages.elm-language-server
    webkitgtk                           # Library to display native web views
    
    ### System tools ###########################################################

#    polybarPin.polybar
    polybar
    alsaUtils
    brightnessctl                       # Brightness change for NixOS 19.03
#    clipmenu
    dunst                               # Notification manager
    libnotify                           # Notification library
    imlib2                              # Image manipulation library (for feh)
    networkmanagerapplet                # GUI for networking
    ntfs3g                              # Access a USB drive
    system-config-printer               # Add/manage printers
    universal-ctags                     # Tool for browsing source code quickly
    xorg.xbacklight                     # Enable screen backlight adjustments
    xorg.xcompmgr                       # Window compositing
    xorg.xev                            # Program to find xmodmap key-bindings
    xorg.xmodmap                        # Keyboard key remapping
    xdotool                             # Used to get current window ID
    
    ### Nix related stuff ######################################################

    cachix                              # Compiled binary hosting for Nix
    direnv                              # Manage directory environments
    nix-index                           # Locate packages
    nox                                 # Better nix searching
    patchelf                            # Patches binaries for Nix support

    ### Dictionaries ###########################################################

    hunspell                            # Dictionary for document programs
    hunspellDicts.en-gb-ise             # English (GB with '-ise' spellings)
    hunspellDicts.en-us                 # English (US)

    ### LaTeX ##################################################################

    texlive.combined.scheme-full        # TeX + TeX packages
    texstudio                           # Solely as a backup. I use vim.
    python37Packages.pygments

    ### Other complete nonsense ################################################

      /*#wayfire
      wf-config
      xwayland
      #wf-recorder
      #wl-clipboard
      #waypipe
      wofi
      grim
      #cage
      oguri
      #kanshi
      dmenu
      #wlay
      #wldash
      wlroots
      #waybar*/
      dmenu

    ### Custom Bash Scripts ####################################################

    (writeShellScriptBin "nixdoc" "${ripgrep}/bin/rg $1 /etc/nixos/NixDoc.md")
    (writeShellScriptBin "default" "${perl530Packages.FileMimeInfo}/bin/mimeopen -d $1")
    (writeShellScriptBin "setuptty" ''
      echo -en "\e]PB657b83" # S_base00
      echo -en "\e]PA586e75" # S_base01
      echo -en "\e]P0073642" # S_base02
    '')
    (writeShellScriptBin "autofish" "${xdotool}/bin/xdotool mousedown 3")
    (writeShellScriptBin "caln" "${libnotify}/bin/notify-send \"$(cal)\"")

    (writeShellScriptBin "ding" "${mpv}/bin/mpv /home/jorel/.config/dunst/notifsound.mp3")
    (writeShellScriptBin "ding2" "${mpv}/bin/mpv ${builtins.fetchurl "https://github.com/JorelAli/dotfiles/blob/master/.config/dunst/notifsound.mp3?raw=true"}")

    (writeShellScriptBin "lock" "${feh}/bin/feh ~/.background-image --full-screen & ${i3lock-color}/bin/i3lock-color --ringcolor=${color 15}ff i3lock-color -c ${color "bg"} --ringcolor=${color "bgl"}ff --indicator -k --timecolor=${color 15}ff --datecolor=${color 15}ff --insidecolor=00000000 --insidevercolor=00000000 --insidewrongcolor=00000000 --ringvercolor=${color 4}ff --ringwrongcolor=${color 1}ff --linecolor=00000000 --keyhlcolor=${color 2}ff --separatorcolor=00000000 --wrongtext=\"\" --veriftext=\"\" --timestr=\"%I:%M:%S %p\" --radius=120 --ring-width=6 -n; pkill feh; postlock")

    (writeShellScriptBin "postlock" ''
      nmcli connection up NordVPN
    '')

    (writeShellScriptBin "fork" "kittyw --detach fish -c \"cd $(pwd) && fish\"")

    (writeShellScriptBin "ws" ''
      function gen_workspaces() {
        i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
      }
      WORKSPACE=$( (gen_workspaces) | rofi -dmenu -p "Move to workspace:")
      if [ -n "''${WORKSPACE}" ]
      then
        i3-msg move container to workspace "''${WORKSPACE}"
      fi
    '')

    (writeShellScriptBin "jshell" "${pkgs.openjdk11}/bin/jshell")
    (writeShellScriptBin "emoji" "rofi -modi emoji -show emoji; sleep 0.01; xdotool type $(xclip -o -selection clipboard)")

  ] ++ optionals unfreePermitted [
    
    steam                               # Game distribution platform
    unrar                               # Command to unzip .rar files

  ] ++ optionals haskellSetup [

    ### Programming (Haskell) ##################################################

    atom                                # Glorified text editor (for Haskell w/ HIE)

    cabal-install                       # CLI for Cabal + Hackage (for Haskell)
    ghc                                 # Haskell compiler
    stack                               # Haskell compiler + package manager
    zlib                                # Some zipping library for C?

    haskellPackages.hoogle              # Haskell documentation database
    haskellPackages.container           # Represents Haskell containers (e.g. Monoid)
    haskellPackages.zlib                # Compression library for Haskell

    #all-hies.versions.ghc843            # Haskell IDE Engine for GHC v8.4.3

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

  ];


##### Programs #################################################################

  programs = {
    adb.enable = true;                  # Enables the Android Debug Bridge
    bash.enableCompletion = true;       # Enable completion in bash shell
    dconf.enable = true;                # Gnome configuration tool
    gnome-disks.enable = true;

    ### My Fish setup ###################################
    # Color scheme:                                     #
    #   curl -L https://get.oh-my.fish | fish           #
    #   omf install budspencer                          #
    # Highlight Colors:                                 #
    #   set fish_color_search_match --background=d33682 #
    # Remove greeting:                                  #
    #   set fish_greeting                               #
    #####################################################

    fish.enable = true;                 # Fish shell (Better bash)
    fish.shellInit = "direnv hook fish | source";

    fish.shellAliases = {               
      arc = "ark";
      batf = "bat (fzf)";
      code = "codium";
      config = "sudo vim /etc/nixos/configuration.nix";
      cp = "rsync -ahv --progress";
      dirsize = "du -sh";
      evalnix = "nix-instantiate --eval";
      fonts = "fc-list : family | cut -f1 -d\",\" | sort";
      gparted = "sudo fish -c gparted";
      hash = "nix-hash --type sha256 --flat --base32";
      history = "history | bat";
      icat = "kitty +kitten icat";
#      kitty = "kittyw";
      ls = "exa";
      mocp = "mocp --theme solarized";
      neofetchnix = "neofetch --ascii_colors 68 110 --kitty ${nixSnowflake}";
      nix-repl = "nix repl";
      prettify = "python -m json.tool"; # Prettify json!
      rebuild = "sudo nixos-rebuild switch";
      rebuilt = "sudo nixos-rebuild switch";
      vimf = "vim (fzf)";
      "@abort" = ''git add .; git commit -m "@abort commit"; git push; sudo shutdown now'';
    };

    less.enable = true;                 # Enables config for the `less` command
    less.commands = { h = "quit"; };    # Rebind the `h` key to quit 
    less.envVariables = { LESS = "-RF"; }; # Use less -RF

    qt5ct.enable = true;                # Enable qt5ct (fixes Qt applications) 

    ssh.askPassword = "${pkgs.ksshaskpass}/bin/ksshaskpass"; # use kwallet
    ssh.setXAuthLocation = true;        # Authenticated X ssh connections
    ssh.forwardX11 = true;              # Allow X server forwarding over ssh

  };

##### Fonts ####################################################################

  fonts = {
    fonts = with pkgs; [

      migmix
      #noto-fonts-emoji
      joypixels
      font-awesome_4                    # Fancy icons font
      ipafont                           # Japanese font
      siji                              # Iconic bitmap font
      symbola                           # Braille support for gotop command

      kochi-substitute

      ### Programming ligatures ################################################
      # *This means that -> will look like an actual arrow and >= and <=       #
      # actually look like less than or equal and greater than or equal        #
      # symbols, as opposed to what they look like on a computer               #
      ##########################################################################
      
      fira-code-symbols                 # Fancy font with programming ligatures
      firacode52Pin.fira-code                         # Fancy font with programming ligatures
      powerline-fonts                   # Fonts for powerlines (Used in my tty)
    ];

    fontconfig.defaultFonts.monospace = [
      "Fira Code Medium"                # Set default font as Fira Code Medium
      "Symbola"                         # Use Symbola as fallback font
      "IPAGothic"                       # Use IPAGothic as fallback font
    ];
    fontconfig.defaultFonts.emoji = [
      #"Noto Color Emoji"
      "JoyPixels"
    ];
  };

##### i18n (Internationalization and Localization) #############################

  i18n = {
    defaultLocale = "en_GB.UTF-8";      # Set default TTY locale as English
    inputMethod.enabled = "fcitx";
    inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
   };

##### Hardware Settings ########################################################

  sound.enable = true;                  # Enable sound
  sound.mediaKeys.enable = true;        # Enable sound keys (play/pause)

  powerManagement.resumeCommands = ''
    xmodmap /home/jorel/.Xmodmap
    nmcli connection up NordVPN
  '';
  powerManagement.powerUpCommands = ''
    xmodmap /home/jorel/.Xmodmap
    nmcli connection up NordVPN
  '';

  hardware = {
    pulseaudio = {
      enable = true;                    # Enable pulseaudio sound manager
      package = pkgs.pulseaudioFull;    # Use full version (bluetooth support)
      support32Bit = true;              # Sound support for Steam
    };

    bluetooth.enable = true;            # Enable bluetooth 
    bluetooth.powerOnBoot = true;       # Let bluetooth enable on startup

    opengl = {
      enable = true;                    # Enable OpenGL
      driSupport32Bit = true;           # Video support for Steam
      extraPackages = with pkgs; [
        vaapiIntel                      # Intel drivers
        vaapiVdpau                      # Intel Drivers
        libvdpau-va-gl                  # Intel Drivers
        intel-media-driver              # Intel Drivers
      ];
    };

    steam-hardware.enable = true;
  };

##### Security Settings ########################################################

  security.sudo.wheelNeedsPassword = false;  # Use 'sudo' without a password

#### Docker setup

  /*docker-containers = {
    whoogle-search = {
      image = "benbusby/whoogle-search:latest";
      ports = [ "5000:5000" ];
    };
  };*/


##### Other ####
  documentation.nixos.enable = false;

##### Services #################################################################
  
  services = {

    mattermost = {
      enable = false;
      siteUrl = "localhost";
    };

    clipmenu.enable = true;

    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        font-size=18
      '';
    };

    dunst.enable = true;                # Notification service
    devmon.enable = true;               # Auto mount USBs
    searx.enable = false;
#    searx.configFile = builtins.toFile "settings.yml" (import ./programconfigs/searx.nix).asYaml;
    syncthing = {
      enable = false;
      openDefaultPorts = true;
      relay.enable = true;
      user = "jorel";
    };
    #lorri.enable = true;
    xcompmgr.enable = false;

    ### Compton/picom ###########################################
    # Compositing effects for windows (Blur backgrounds!) #
    #######################################################
    picom = {
      enable = true;                    # Application transparency
      shadow = true;
      fade = true;
      fadeDelta = 2;
      vSync = true;                     # Remove screen tearing
      backend = "glx"; 
      inactiveOpacity = 0.8;         # Make programs blur on unfocus
      opacityRules = [ 
        "100: class_g = 'kitty' && !focused"
        "100: class_g = 'kitty' && focused"
        "100: class_g = 'Eclipse'"
        "100: class_g = 'Peek'"
      ];
      settings = {
        blur-background = true;
        blur-background-fixed = true;
        glx-no-comptonstencil = true;
        #paint-on-overlay = true;
        unredir-if-possible = false;
        #blur-kern = "3x3box";
        #blur-method = "kawase";
        blur-strength = 10;
        focus-exclude = [ 
          "class_g = 'Eclipse'"
        ];
        blur-background-exclude = [
          "name = 'Screenshot'"
          "class_g = 'Escrotum'"
          "class_g = 'Peek'"
        ];
      };
    };

    logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      extraConfig = ''
        HandlePowerKey=suspend
        IdleAction=ignore
      '';
    };
    
#    nixosManual.showManual = false;     # Disable the NixOS manual in tty 8
    printing.enable = true;             # Printing (You know, to a printer...)
    #rogue.enable = true;                # Enable the rogue game in tty 9 
    
    upower.enable = true;               # Battery info

    # Adds support for scrolling to change the brightness for i3status-rs
    udev.extraRules = ''  
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    openssh = {
      enable = true;                    # Enable ssh
      forwardX11 = true;                # Enable forwarding X session over ssh
      allowSFTP = true;
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
        sessionCommands = ''
          xmodmap .Xmodmap
          xmodmap -e "keycode 110 = Prior"
          xmodmap -e "keycode 115 = Next"
          xmodmap -e "keycode 112 = Home"
          xmodmap -e "keycode 117 = End"
        '';
        sddm.enable = true;             # Login screen manager
        sddm.theme = "clairvoyance";    # Clairvoyance theme for sddm
        #sddm.settings = ''
        #  [General]
        #  InputMethod=
        #'';
      };

      ### Window Manager ##########################################
      # Displays windows (applications). I'm using i3, the tiling #
      # manager which uses keyboard shortcuts instead of dragging #
      # windows with a mouse to move them around and change size  #
      #############################################################
      
      windowManager.i3 = {
        enable = true;                  # Enable i3 tiling manager
        package = pkgs.i3-gaps;         # Use i3-gaps (lets you have gaps (duh))
        extraPackages = with pkgs; [ i3lock-color ];
        configFile = import ./programconfigs/i3config.nix;
      };
      
    };
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
      "docker"
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
    # This setting, when set to false, allows writing access to the     #
    # /nix/store/ directories. This isn't a good thing on NixOS, since  #
    # new derivations can override these folders (or be deleted with    #
    # nix's garbage collector) whenever the system does so. This should #
    # only be toggled for development testing purposes ONLY.            #
    #####################################################################
    
    readOnlyStore = true;            # Allows writing access to /nix/store
  };

##### NixPkgs Configuration ####################################################

  nixpkgs.overlays = [
    (import ./overlays/programs.nix)
    (import ./overlays/wrappers)
    (import (builtins.fetchTarball {
      url = "https://github.com/colemickens/nixpkgs-wayland/archive/0ca16b137e0251c873af68d89c26078848ca8cc5.tar.gz";
      sha256 = "00q9g6ab4rnf5w9jxsfj31s4jx0z84qmkivgnhbh1ilgmgv0fdwy";
    }))
  ];

  nixpkgs.config = {

    allowUnfree = unfreePermitted;    # Allow unfree/proprietary packages
    joypixels.acceptLicense = true;

    # This lets you override package derivations for the entire list of 
    # packages for this configuration.nix file. For example, below, I redefine
    # the derivation of the Typora application to have a different install
    # script. This is then used in the Typora package in the system packages
    # above.
    packageOverrides = pkgs: with pkgs; {

      jshEnv = buildEnv {
        name = "jsh";
        paths = [ pkgs.openjdk11 ];
      };

      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };

      polybar = polybar.override {
        i3GapsSupport = true;
      };

      ### HIEs #################
      # The Haskell IDE Engine #
      ##########################

      all-hies = import (
        fetchTarball "https://github.com/infinisil/all-hies/tarball/master"
      ) {};

    };
  };

##### NixOS System Version (Do not touch) ######################################

  system.stateVersion = "18.09";

################################################################################
}
