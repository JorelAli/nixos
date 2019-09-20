{ config, pkgs, lib, ... }: 

let 
  
  nixos-gsettings-desktop-schemas = let
    defaultPackages = with pkgs; [ gsettings-desktop-schemas gnome3.gnome-shell ];
  in with lib;
  pkgs.runCommand "nixos-gsettings-desktop-schemas" { preferLocalBuild = true; }
    ''
     mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
     ${concatMapStrings
        (pkg: "cp -rf ${pkg}/share/gsettings-schemas/*/glib-2.0/schemas/*.xml $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas\n")
        (defaultPackages)}
     chmod -R a+w $out/share/gsettings-schemas/nixos-gsettings-overrides
     cat - > $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/nixos-defaults.gschema.override <<- EOF
       [org.gnome.desktop.background]
       picture-uri='file://${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/artwork/gnome/nix-wallpaper-simple-dark-gray.png'
       [org.gnome.desktop.screensaver]
       picture-uri='file://${pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom}/share/artwork/gnome/nix-wallpaper-simple-dark-gray_bottom.png'
       [org.gnome.shell]
       favorite-apps=[ 'org.gnome.Epiphany.desktop', 'org.gnome.Geary.desktop', 'org.gnome.Music.desktop', 'org.gnome.Photos.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop' ]
     EOF
     ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
    '';
in {

  environment.variables = {
    NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
    GIO_EXTRA_MODULES = [ "${pkgs.gnome3.glib-networking.out}/lib/gio/modules" ];
  };

  systemd.packages = [ pkgs.glib-networking ];
  services.dbus.packages = [ pkgs.glib-networking ];

}
