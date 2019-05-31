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

  ### Custom Vim plugins #######################################################

  # Java Complete 2, with pre-built packages (todo: extract into Nix expression
  # for a more "pure" installation of Java Complete 2)
  customPlugins.vim-javacomplete2 = pkgs.vimUtils.buildVimPlugin {
    name = "vim-javacomplete2";
    src = pkgs.fetchFromGitHub {
      owner = "JorelAli";
      repo = "vim-javacomplete2";
      rev = "cc140af15dc850372655a45cca5b5d07e0d14344";
      sha256 = "1kzx80hz9n2bawrx9lgsfqmjkljbgc1lpl8abnhfzkyy9ax9svk3";
    };
  };

  customPlugins.vim-devdocs = pkgs.vimUtils.buildVimPlugin {
    name = "vim-devdocs";
    src = pkgs.fetchFromGitHub {
      owner = "rhysd";
      repo = "devdocs.vim";
      rev = "1c91c619874f11f2062f80e6ca4b49456f21ae91";
      sha256 = "1nxww2mjabl2g2wchxc4h3a58j64acls24zb5jmfi71b8sai8a9b";
    };
  };

  all-hies = import 
    (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};

in {

  ### NixOS important settings #################################################

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
  ];

  ### Boot Settings ############################################################

  # Enable exFAT format for USB/External HDD
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Search for other operating systems
  boot.loader.grub.useOSProber = true;

  boot.extraTTYs = [ "tty8" "tty9" "tty10" ];

  ### Networking Settings ######################################################

  networking = {

    hostName = "NixOS";
    networkmanager.enable = true; # Use nm-connection-editor

    firewall = {
      enable = true;

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
    EDITOR = "nvim";
    _JAVA_OPTIONS= "-Dawt.useSystemAAFontSettings=lcd";
    QT_XCB_GL_INTEGRATION = "xcb_egl";

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

  environment.etc."X11/xorg.conf.d/20-intel.conf" = {
    text = ''
      Section "Device"
 
        Identifier "Intel Graphics"
 
        Driver "intel"
 
        Option "TearFree" "true"
 
      EndSection
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

    unstable.qutebrowser                # Lightweight minimal browser (v1.6.2)

    ### KDE Applications #######################################################

    kdeApplications.kwalletmanager      # Manager for password manager
    kdeApplications.konsole             # Terminal
    kdeconnect                          # Connect linux with your phone
    kinit
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
    kdeApplications.dolphin-plugins
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
    mpv
    pavucontrol                         # Pulse Audio controller
    pidgin-with-plugins                 # IM program           
    redshift                            # Screen temperature changer
    shutter                             # Screenshot tool
    skype                               # Messaging & Video calling platform
    sqlitebrowser                       # SQLite .db file browser
    zathura                             # PDF viewer

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

    (vscode-with-extensions.override {
       # When the extension is already available in the default extensions set.
        vscodeExtensions = with vscode-extensions; [
         # bbenoist.Nix
        ]
        # Concise version from the vscode market place when not available in the default set.
        ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
#            name = "code-runner";
#            publisher = "formulahendry";
#            version = "0.6.33";
#            sha256 = "166ia73vrcl5c9hm4q1a73qdn56m0jc7flfsk5p5q41na9f10lb0";
            name = "vsliveshare";
            publisher = "ms-vsliveshare";
            version = "1.0.91";
            sha256 = "1ndii2x46kkmcdxb3xdbkxrxdj0a1i9qnga12vilpw4bvpz31b1z";
            #https://ms-vsliveshare.gallery.vsassets.io/_apis/public/gallery/publisher/MS-vsliveshare/extension/vsliveshare/0.3.423/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage
          }
        ];
    })

#    vscode                              # Code editor (think notepad++ or atom)

    ### System-wide theming ####################################################

    breeze-icons                        # Breeze theme icons
    gnome3.adwaita-icon-theme           # Adwaita theme icons
    hicolor_icon_theme                  # Hicolor theme icons
    paper-icon-theme 
    papirus-icon-theme
    maia-icon-theme

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
    breeze-qt5                          # Breeze theme for qt5 (cursors!)
    numix-solarized-gtk-theme

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
    
    ant                                 # Java building thingy
    eclipses.eclipse-java               # Eclipse Java IDE (my favourite IDE)
    jetbrains.idea-community            # IntelliJ IDEA Java IDE (eh)
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
    valgrind                            # Executable debugging tool
    unstable.swift                      # Swift programming language

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

    all-hies.versions.ghc843

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
    #udisks                              # Storage device daemon
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
    patchelf

    (import (fetchGit "https://github.com/haslersn/fish-nix-shell"))

    ### Dictionaries ###########################################################

    hunspell                            # Dictionary for GhostWriter
    hunspellDicts.en-gb-ise             # English (GB with '-ise' spellings)
    hunspellDicts.en-us                 # English (US)

    ### NeoVim #################################################################

    ( with pkgs;
      neovim.override {
          vimAlias = true;              # Lets you use 'vim' as alias for 'nvim'
          configure = {
            customRC = ''
                " Generic vim configuration here  
                syntax enable
                set tabstop=4
                set shiftwidth=4
                set background=dark
                colorscheme solarized
                set number relativenumber
                set mouse=a
                let g:airline_powerline_fonts = 1
                set backspace=indent,eol,start

                " Enable TagBar support for rust files
                autocmd VimEnter *.rs TagbarOpen

                " Configured color pairs for rainbow parentheses
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

                " Let Alloy Analyser java Java syntax highlighting
                au BufReadPost *.als set syntax=java
                au BufReadPost *.vue set syntax=html

                " Show tabs as lines
                set listchars=tab:\¦\ 
                set list

                " Enable file specific dev docs
                let g:devdocs_filetype_map = {
                  \ 'java': 'java',
                  \ 'javacc': 'java',
                  \ 'haskell': 'haskell',
                  \ 'rust': 'rust',
                  \  }

                nmap K <Plug>(devdocs-under-cursor)

                " Syntastic configuration
                set statusline+=%#warningmsg#
                set statusline+=%{SyntasticStatuslineFlag()}
                set statusline+=%*

                let g:syntastic_always_populate_loc_list = 1
                let g:syntastic_auto_loc_list = 1
                let g:syntastic_check_on_open = 1
                let g:syntastic_check_on_wq = 0

                " Some Java Complete 2 setup (might be unnecessary)
                let g:JavaComplete_JavaviLogDirectory = $HOME . '/javavilogs'
                let g:JavaComplete_Home = $HOME . '/.vim/bundle/vim-javacomplete2'
                let $CLASSPATH .= '.:' . $HOME . '/.vim/bundle/vim-javacomplete2/lib/javavi/target/classes'

                nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
                imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
                nmap <F5> <Plug>(JavaComplete-Imports-Add)
                imap <F5> <Plug>(JavaComplete-Imports-Add)
                nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
                imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
                nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
                imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

                inoremap <C-@> <c-x><c-o>

                autocmd FileType java setlocal omnifunc=javacomplete#Complete
                autocmd FileType javacc setlocal omnifunc=javacomplete#Complete

                " Enable quality autocompletion
                let g:deoplete#enable_at_startup = 1 

                " Rust stuff
                let g:deoplete#sources#rust#racer_binary = $HOME . '/.cargo/bin/racer'
                let g:deoplete#sources#rust#rust_source_path = $HOME . '/github/rust/src'
                let g:syntastic_rust_checkers = ['cargo']

                " Markdown
                let g:markdown_enable_mappings = 0
                let g:vim_markdown_folding_disabled = 1

                let g:kronos_database = $HOME . '.kronos.database'

              '';

              ### Vim packages #################################################

              packages.myVimPackage = with pkgs.vimPlugins // customPlugins; {
                
                start = [ 
                  deoplete-nvim         # Dark powered autocompletion
                  deoplete-rust         # Autocompletion for rust

                  gitgutter             # Shows git changes in sidebar
                  rainbow_parentheses   # Pairs parentheses with colors
                  solarized             # Solarized theme (of course)
                  supertab              # Tab key does suggestions
                  Syntastic             # Syntax checking for languages
                  tagbar                # Shows declared file methods etc.

                  vim-airline           # Fancy bottom bar for vim
                  vim-airline-themes    # Theme support for bottom bar 
                  vim-commentary        # Easy comment using 'gcc' key shortcut
                  vim-devdocs           # Easy file documentation using ':DevDocs'
                  #vim-javacomplete2    # Java IDE features (autocomplete)
                  vim-markdown          # Markdown syntax highlighting
                  vim-nix               # Nix language syntax
                  vim-toml              # Toml language syntax

                  ctrlp                 # Easy file opener using Ctrl+P

                ];    
              };
          };
        }
      )
  ];


  ### Programs #################################################################

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

  ### Fonts ####################################################################

  fonts = {
    fonts = with pkgs; [

      emojione                          # Emoji font
      fira-code-symbols                 # Fancy font with programming ligatures
      fira-code                         # Fancy font with programming ligatures
      font-awesome_4                    # Fancy icons font
      siji                              # Iconic bitmap font
      symbola

      ### Programming ligatures ################################################
      # *This means that -> will look like an actual arrow and >= and <=       #
      # actually look like less than or equal and greater than or equal        #
      # symbols, as opposed to what they look like on a computer               #
      ##########################################################################
  
      ### Japanese Fonts #######################################################
      ipafont
      kochi-substitute
      migmix

      xorg.libXfont
      xorg.fontutil
      xorg.libXfont2
      xorg.fontalias
      xorg.fontbh100dpi
      xorg.fontbh75dpi
      xorg.fontbhttf
      xorg.fontbhtype1
    ];

    fontconfig = {
      ultimate.enable = true;
      defaultFonts = {
        monospace = [ "Fira Code Medium" "Symbola" "IPAGothic" ];
#        sansSerif = [ "DejaVu Sans" "IPAPGothic" ];
#        serif = [ "DejaVu Serif" "IPAPMincho" ];
      };
    };

  };

  ### i18n (Internationalization and Localization) #############################

  i18n = {
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
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
       vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

  # Use fingerprint recognition on the login screen to log in. To add a 
  # fingerprint, use the 'fprintd-enroll' command in the terminal, and scan
  # your fingerprint a few times. I disabled this because this can be a bit
  # unreliable sometimes.

  # security.pam.services.login.fprintAuth = true;

  security.sudo.wheelNeedsPassword = false;  # Use 'sudo' without a password
  security.chromiumSuidSandbox.enable = true;

  ### Services #################################################################

  services = {


    teamviewer.enable = true;

    nixosManual.ttyNumber = 8;
    rogue.enable = true;
    rogue.tty = "tty9";

    # Adds support for scrolling to change the brightness for i3status-rs
    udev.extraRules = ''  
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    compton = {
      enable = true;                    # Application transparency
      opacityRules = [ "95:class_g = 'konsole'" "85: class_g = 'dolphin'" ];
      vSync = "opengl-swc";
      backend = "glx";
      fade = true;
      fadeDelta = 2;
      inactiveOpacity = "0.85";
      extraOptions = ''
        unredir-if-possible = true;
        blur-background = true;
        blur-background-fixed = true;
        blur-kern = "11,11,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,1.000000";
        '';
    };

    gnome3.gnome-disks.enable = true;   # Something something USBs
    udisks2.enable = true;              # Something something USBs

    #fprintd.enable = true;             # Fingerprint reader (Disabled -> unreliable)

    printing.enable = true;             # Printing (You know, to a printer...)
    upower.enable = true;               # Battery info

    xserver = {gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      enable = true;                    # GUI for the entire computer
      layout = "gb";                    # Use the GB English keyboard layout

      exportConfiguration = true;

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
  #    desktopManager.plasma5.enable = true;

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

  systemd.user.services."kdeconnect" = {
    enable = true;
    description = "eh";
    wantedBy = [ "graphical-session.target" "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.kdeconnect}/lib/libexec/kdeconnectd";
  };

  ### User Accounts ############################################################

  users.users.jorel = {
    isNormalUser = true;
    home = "/home/jorel";
    description = " ";                  # The ultimate sddm aesthetics
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

  ### NixPkgs Configuration ####################################################

  nixpkgs.config = {
    allowUnfree = true;                 # Allow unfree/proprietary packages
    flashplayer = { debug = true; };    # Flashplayer debug mode has new dl URL

    packageOverrides = pkgs: with pkgs; {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      pidgin-with-plugins = pkgs.pidgin-with-plugins.override {
        ## Add whatever plugins are desired (see nixos.org package listing).
        plugins = [ purple-facebook purple-discord purple-matrix ];
      };
    };

  };

  ### NixOS System Version (Do not touch. Ever.) ###############################

  system.stateVersion = "18.09";

}
