# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable exFAT format for USB/External HDD
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Use wireless networking via wpa_supplicant. This is NOT required because
  # I'm using networking.networkmanager above, which does this for us.
  # networking.wireless.enable = true;
  #
  # If doom and gloom, use nm-connection-editor command

  # Set your time zone.
  time.timeZone = "Europe/London";

  environment.variables = {
    # MY_ENV_VAR = "\${HOME}/my/dir";
   # SWT_GTK3=0 = "eclipse";
   SWT_GTK3 = "0";
   QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # Definitely. This. First.
    qutebrowser

    ### Command line utilities ###
    fish 					    # Friendly Interface SHell (better than bash)

    ## My Fish setup ####################################
    # Color scheme:                                     #
    #   curl -L https://get.oh-my.fish | fish           #
    #   omf install agnoster                            #
    # Highlight Colors:                                 #
    #   set fish_color_search_match --background=d33682 #
    #####################################################

    git 					    # Version control
    gnumake3				    # Make command to build executables
    p7zip					    # 7z zip manager
    ranger					    # Terminal file manager
    rofi					    # Window switcher & App launcher
    ruby                        # Ruby (Programming language)
    screenfetch				    # Display info about themes to console
    speedtest-cli			    # Speed test in terminal
    sqlitebrowser
    telnet 					    # Telnet client
    tree 					    # Print file tree in terminal
    wget					    # Download web files
    youtube-dl 				    # YouTube downloader

    universal-ctags

    ### Applications ###
    atom 					    # Glorified text editor
    chromium				    # Browser (opensource chrome)
    deluge 					    # Torrent client
    ghostwriter 			    # Markdown editor
    gimp					    # Image editor
    gitkraken                   # Version control management software
    gparted 				    # Partition manager
    inkscape 				    # Vector artwork
    libreoffice-fresh		    # Documents/Spreadsheets/Presentations
    libsForQt5.vlc 			    # Video player
    pcmanfm                     # A file manager
    qutebrowser				    # Super minimal browser
    redshift				    # Screen temperature changer
    shutter					    # Screenshot tool
    vscode					    # Code editor
    
    qt5ct
    breeze-icons

    ### Games ###
    minecraft				    # Minecraft video game
    pacvim					    # Game that teaches you vim
    #steam
    #steam-run
    #steamcontroller
    zeroad					    # 0ad video game - like Age of Empires

    ### Other random stuff ###
    cool-retro-term 		    # A retro looking terminal for show
    elinks                      # Useless terminal based browser
    sl                          # Steam Locomotive

    ### Programming (Java) ###
    ant                         # Java building thingy
    eclipses.eclipse-sdk
    openjdk10 					# Java Development Kit for Java 10
    maven 					    # Java dependency manager

    ### Programming (Other) ###
    gcc 					    # C/C++ compiler
    python					    # Python 2.7.15
    python3					    # Python 3.6.8

    ### GUI/Window Manager ###
    i3status-rust				# Better i3 status bar
    # Installing i3status-rust is a pain on NixOS. The current package which is
    # on the nixpkgs is outdated and doesn't have the major features that I want
    # Instead, I built it manually by git cloning the repository, and running the
    # following command:
    # sudo nix-shell -p cargo dbus pkgconfig libpulseaudio pulseaudio --pure --run 'cargo build --release'

    ### System tools ###
    networkmanagerapplet  		# GUI for networking
    ntfs3g			      		# Access a USB drive
    upower				    	# Read bettery info
    xarchiver                   # File archiver
    xorg.xmodmap				# Keyboard key remapping
    xorg.xev 					# Program to find xmodmap key-bindings
    xorg.xbacklight				# Enable screen backlight adjustments

    ### Unused stuff ###
    # baobab					    # Disk usage viewer (with GUI)
    # libpulseaudio				    # Library for sound
    # pulseaudio					# Sound (e.g. detect the volume of the laptop)
    polybar					    # Status bar

    ### Nix related stuff ###
    cachix 					    # Nix binary hosting for easy installation

    ### Haskell packages + Haskell stuff ###
    cabal-install				# CLI for Cabal + Hackage (for Haskell)
    ghc						    # Haskell compiler
    stack					    # Haskell compiler + package manager
    zlib

    haskellPackages.hoogle		# Haskell documentation database
    haskellPackages.container	# Represents Haskell containers (e.g. Monoid)
    haskellPackages.zlib		# Compression library for Haskell

    ### Dictionaries ###
    hunspell					# Dictionary for GhostWriter
    hunspellDicts.en-gb-ise		# English (GB with '-ise' spellings)
    hunspellDicts.en-us			# English (US)

    ### How to get the best Haskell setup ###############################################
    # Install the following system packages: stack cabal-install ghc cachix atom zlib   #
    #                                                                                   #
    # To install hie (Haskell IDE Engine):                                              #
    #   1) "cachix use hie-nix"                                                         #
    #   2) "nix-env -iA hies -f https://github.com/domenkozar/hie-nix/tarball/master"   #
    #                                                                                   #
    # Optional: Install Hasklig (I use Fira Code Medium)                                #
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
    #     packages: [zlib.dev, zlib.out]                                                
    #####################################################################################

    # Vim installation for NixOS
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
                autocmd vimenter * NERDTree
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
            '';
            vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;

            # List of vim plugins, installed via VAM
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

  # 'day' and 'night' aliases for redshift
  programs.fish.enable = true;
  programs.fish.shellAliases = {
      day = "redshift -x";
      night = "redshift -O 4500K";
  };

  fonts.fonts = with pkgs; [
    # *This means that -> will look like an actual arrow and
    # >= and <= actually look like less than or equal and greater
    # than or equal symbols, as opposed to what they look like on
    # a computer

    fira-code-symbols 			# Fancy font with programming ligatures*
    fira-code					# Fancy font with programming ligatures*
    font-awesome_4				# Fancy icons font

  ];

  # Set default monospace font to the fancy ligatures font. Good for terminals
  fonts.fontconfig.defaultFonts.monospace = [ "Fira Code Medium" ];

  # List services that you want to enable:

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Support for 32 bit stuff (for Steam)
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Use fingerprint recognition on the login screen to log
  # in. To add a fingerprint, use the 'fprintd-enroll' command
  # in the terminal, and scan your fingerprint a few times. I
  # disabled this because this can be a bit unreliable sometimes.
  # security.pam.services.login.fprintAuth = true;

  security.sudo.wheelNeedsPassword = false;	# Use 'sudo' without needing password

  services = {

    compton = {
        enable = true;
        inactiveOpacity = "0.9";
        opacityRules = [ "95:class_g = 'konsole'" ];
    };

    gnome3.gnome-disks.enable = true;		# Something something USBs
    udisks2.enable = true;			        # Something something USBs

    #fprintd.enable = true;			        # Fingerprint reader (Disabled -> unreliable)

    printing.enable = true;			        # Printing (You know, to a printer...)

    xserver = {
      enable = true;				        # GUI for the entire computer
      layout = "gb";				        # Use the GB English keyboard layout

      libinput.enable = true;			    # Touchpad support
      synaptics.twoFingerScroll = true;		# Two finger scroll for touchpad

      displayManager = {
        sddm.enable = true;			        # Login screen manager
        sddm.theme = "clairvoyance";		# Ellis' clairvoyance theme for sddm
        sddm.extraConfig = ''
          [General]
          InputMethod=
          '';

        # Remap keys on start
        sessionCommands = ''
			xmodmap .Xmodmap
			'';
      };

      # Tiling manager to manage windows using keyboard
      # shortcuts instead of dragging and dropping
      windowManager.i3.package = pkgs.i3-gaps;
      windowManager.i3.enable = true;

      # Despite the fact that I don't actually use this desktop manager
      # I keep it installed because it includes the lovely things that
      # I like about KDE, such as Konsole
      desktopManager.plasma5.enable = true;

    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jorel = {
    isNormalUser = true;
    home = "/home/jorel";
    description = "C'Taz'M'Kazm";
    extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" ];
    uid = 1000;
    shell = pkgs.fish;				# Use fish as the default shell
  };


  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];
    trustedUsers = [ "root" "jorel" ];

    # USE WITH CAUTION
    readOnlyStore = false;			# Allows writing access to /nix/store
  };

  nixpkgs.config = {
    allowUnfree = true;				# Allow unfree/proprietary packages
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09";

}
