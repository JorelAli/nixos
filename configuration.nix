# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  # I'm pretty sure none of this works
  boot.loader.grub.splashImage = ./grub_bg.png;
  boot.loader.grub.fontSize = 16;
  boot.loader.grub.backgroundColor = "#00B79C";

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    ### Command line utilities ###
    baobab				# Disk usage viewer
    elinks				# Terminal web browser
    fish 				# Friendly Interface SHell (better than bash)
    git 				# Version control
    gnumake3				# Make command
   #jekyll				# Static site generator (for blog)
    p7zip				# 7z zip manager
    ruby				# Ruby programming language.
    screenfetch				# Display info about themes to console
    telnet 				# Telnet client
    tree 				# Print file tree
    unzip 				# ?
    vim 				# Text editor
    wget				# Download web files
    youtube-dl 				# YouTube downloader
    zip  				# ?

    ### Applications ###
    atom 				# Glorified text editor
    chromium				# Browser
    deluge 				# Torrent client
    ghostwriter 			# Markdown editor
    gparted 				# Partition manager
    inkscape 				# Vector artwork
    libsForQt5.vlc 			# Video player
    redshift				# Screen temperature changer
    shutter				# Screenshot tool

    ### Other random stuff ###
    cool-retro-term 			# A retro looking terminal for bants

    ### Programming (Java) ###
    eclipses.eclipse-platform		# Java IDE
    openjdk10 				# Java Development Kit 10
    maven 				# Java dependency manager

    ### Programming (Other) ###
    cabal-install			# CLI for Cabal + Hackage (Haskell)
    gcc 				# C/C++ compiler
    ghc					# Haskell compiler
    python3				# Python 3
    stack 				# Haskell compiler + package manager

    ### System tools ###
    plasma5.sddm-kcm			# KDE Config Module for SDDM
    networkmanagerapplet  		# GUI for networking
    xorg.xmodmap xorg.xev 		# Keyboard key remapping

    ### Nix related stuff ###
    cachix 				# Nix binary hosting

    ### Dictionaries ###
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science

    ### How to get the best Haskell setup ###############################################
    # Install the following Haskell packages: stack cabal-install ghc			#
    # To install hie (Haskell IDE Engine): 						#
    #   1) "cachix use hie-nix"							 	#
    #   2) "nix-env -iA hies -f https://github.com/domenkozar/hie-nix/tarball/master" 	#
    # Optional: Install Hasklig (I use Fira Code Medium)				#
    # Install atom									#
    # Install the following packages for atom:						#
    #   atom-ide-ui									#
    #   ide-haskell-hie									#
    #   language-haskell								#
    # In atom, Ctrl + , ide-haskell-hie package:					#
    #   Settings -> Absolute path to hie executable					#
    #   => hie-wrapper									#
    #####################################################################################

  ];

  # I like setting the redshift manually
  environment.shellAliases = {
    day = "redshift -x";
    night = "redshift -O 4500K";
  };

  programs.fish.enable = true;
  programs.fish.shellAliases = {
    day = "redshift -x";
    night = "redshift -O 4500K";
  };

  fonts.fonts = with pkgs; [
    fira-code-symbols
    fira-code
  ];

  fonts.fontconfig.defaultFonts.monospace = [ "Fira Code Medium" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # fprintd-enroll
  security.pam.services.login.fprintAuth = true;

  services = {
    fprintd.enable = true;			# Fingerprint reader 
    printing.enable = true;			# Printing (duh)
    xserver = {
      enable = true;				# GUI
      layout = "gb";				# Use the GB English keyboard layout
      libinput.enable = true;			# Touchpad support
      synaptics.twoFingerScroll = true;		# Two finger scroll for touchpad
      displayManager = {
        #sddm.enable = true;	
        slim = {				# Login screen
          enable = true;
          defaultUser = "jorel";
          theme = pkgs.fetchurl {
            url = "https://github.com/edwtjo/nixos-black-theme/archive/v1.0.tar.gz";
            sha256 = "13bm7k3p6k7yq47nba08bn48cfv536k4ipnwwp1q1l2ydlp85r9d";
          };
        };		
        sessionCommands = "xmodmap .Xmodmap";	# Remap keys on start
      };
      desktopManager.plasma5.enable = true;	# Fancy desktop manager
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jorel = {
    isNormalUser = true;
    home = "/home/jorel";
    description = "C'Taz'M'Kazm";
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
    shell = pkgs.fish;
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
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
