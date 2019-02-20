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

  # I'm pretty sure none of this works
  boot.loader.grub.splashImage = ./grub_bg.png;
  boot.loader.grub.fontSize = 16;
  boot.loader.grub.backgroundColor = "#00B79C";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Use wireless networking via wpa_supplicant. This is NOT required because
  # I'm using networking.networkmanager above, which does this for us.
  # networking.wireless.enable = true; 

  # Set your time zone.
  time.timeZone = "Europe/London";
 
  environment.variables = {
    # MY_ENV_VAR = "\${HOME}/my/dir";
  };
 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    ### Command line utilities ###
    baobab					    # Disk usage viewer (with GUI)
    fish 					    # Friendly Interface SHell (better than bash)
    git 					    # Version control
    gnumake3				    # Make command to build executables
    p7zip					    # 7z zip manager
    ranger					    # Terminal file manager
    rofi					    # Window switcher & App launcher
    screenfetch				    # Display info about themes to console
    speedtest-cli			    # Speed test in terminal
    telnet 					    # Telnet client
    tree 					    # Print file tree in terminal
    wget					    # Download web files
    youtube-dl 				    # YouTube downloader

    ### Applications ###
    atom 					    # Glorified text editor
    chromium				    # Browser (opensource chrome)
    deluge 					    # Torrent client
    ghostwriter 			    # Markdown editor
    gimp					    # Image editor
    gparted 				    # Partition manager
    inkscape 				    # Vector artwork
    libreoffice-fresh		    # Documents/Spreadsheets/Presentations
    libsForQt5.vlc 			    # Video player
    qutebrowser				    # Super minimal browser
    redshift				    # Screen temperature changer
    shutter					    # Screenshot tool
    vscode					    # Code editor

    ### Games ###
    minecraft				    # Minecraft video game
    pacvim					    # Game that teaches you vim
    zeroad					    # 0ad video game - like Age of Empires

    ### Other random stuff ###
    cool-retro-term 		    # A retro looking terminal for show
   
    ### Programming (Java) ###
    eclipses.eclipse-platform	# Java IDE
    openjdk10 					# Java Development Kit for Java 10
    maven 					    # Java dependency manager

    ### Programming (Other) ###
    gcc 					    # C/C++ compiler
    python					    # Python 2.7.15
    python3					    # Python 3.6.8

    ### System tools ###
    feh						    # Image viewer (+background image)
    gnome3.nautilus				# File browser
    i3status-rust				# Better i3 status bar
    # Installing i3status-rust is a pain on NixOS. The current package which is
    # on the nixpkgs is outdated and doesn't have the major features that I want
    # Instead, I built it manually by git cloning the repository, and running the
    # following command:
    # sudo nix-shell -p cargo dbus pkgconfig libpulseaudio pulseaudio --pure --run 'cargo build --release'

    networkmanagerapplet  		# GUI for networking
    ntfs3g			      		# Access a USB drive
    upower				    	# Read bettery info
    xorg.xmodmap				# Keyboard key remapping
    xorg.xev 					# Program to find xmodmap key-bindings
    xorg.xbacklight				# Enable screen backlight adjustments

    ### Unused stuff ###
    libpulseaudio				# Library for sound
    pulseaudio					# Sound (e.g. detect the volume of the laptop)
    polybar					    # Status bar
    
    ### Nix related stuff ###
    cachix 					    # Nix binary hosting for easy installation

    ### Haskell packages + Haskell stuff ###
    cabal-install				# CLI for Cabal + Hackage (for Haskell)
    ghc						    # Haskell compiler
    stack					    # Haskell compiler + package manager

    haskellPackages.hoogle		# Haskell documentation database
    haskellPackages.container	# Represents Haskell containers (e.g. Monoid)
    haskellPackages.zlib		# Compression library for Haskell
 
    ### Dictionaries ###
    hunspell					# Dictionary for GhostWriter
    hunspellDicts.en-gb-ise		# English (GB with '-ise' spellings)
    hunspellDicts.en-us			# English (US)

    ### How to get the best Haskell setup ###############################################
    # Install the following system packages: stack cabal-install ghc cachix atom	#
    # To install hie (Haskell IDE Engine): 						#
    #   1) "cachix use hie-nix"							 	#
    #   2) "nix-env -iA hies -f https://github.com/domenkozar/hie-nix/tarball/master" 	#
    # Optional: Install Hasklig (I use Fira Code Medium)				#
    # Install the following packages for atom (using the built in package manager):	#
    #   atom-ide-ui									#
    #   ide-haskell-hie									#
    #   language-haskell								#
    # In atom, Ctrl + , ide-haskell-hie package:					#
    #   Settings -> Absolute path to hie executable					#
    #   => hie-wrapper									#
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
                # autocmd vimenter * NERDTree
                set number
                set mouse=a
                let g:airline_powerline_fonts = 1
                
            '';
            vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;

            # List of vim plugins, installed via VAM
 	        vimrcConfig.vam.pluginDictionaries = [
                { names = [
        	           	"Syntastic"
	                	"ctrlp"
                        "vim-airline"
                        "vim-airline-themes"
                        "nerdtree"
                        "youcompleteme"
                        "solarized"
                        "rainbow_parentheses"
                        "vim-nix"
                        "vim-toml"
                        "vim-indent-guides"
                        "gitgutter"
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
    fira-code-symbols 			# Fancy font with programming ligatures*
    fira-code					# Fancy font with programming ligatures*
    font-awesome_4				# Fancy icons font

    # *This means that -> will look like an actual arrow and
    # >= and <= actually look like less than or equal and greater 
    # than or equal symbols, as opposed to what they look like on
    # a computer
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

  # Use fingerprint recognition on the login screen to log
  # in. To add a fingerprint, use the 'fprintd-enroll' command
  # in the terminal, and scan your fingerprint a few times. I
  # disabled this because this can be a bit unreliable sometimes.
  # security.pam.services.login.fprintAuth = true;

  security.sudo.wheelNeedsPassword = false;	# Use 'sudo' without needing password

  services = {
    gnome3.gnome-disks.enable = true;		# Something something USBs
    udisks2.enable = true;			# Something something USBs
    #fprintd.enable = true;			# Fingerprint reader (Disabled -> unreliable)
    printing.enable = true;			# Printing (You know, to a printer...)
    xserver = {
      enable = true;				# GUI for the entire computer
      layout = "gb";				# Use the GB English keyboard layout
      libinput.enable = true;			# Touchpad support
      synaptics.twoFingerScroll = true;		# Two finger scroll for touchpad

      displayManager = {
        sddm.enable = true;			# Login screen manager
        sddm.theme = "clairvoyance";		# Ellis' clairvoyance theme for sddm
       sessionCommands = ''
			xmodmap .Xmodmap
			feh --bg-fill ~/Documents/Background.jpg
			'';	
# Remap keys on start
      };

      # Tiling manager to manage windows using keyboard 
      # shortcuts instead of dragging and dropping
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

