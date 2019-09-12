rec { 
  # To import into terminal.sexy, use the following command:
  #   builtins.toJSON (import ./colorscheme.nix)
  name = "";
  author = "Jorel Ali"; 
  background = "#360036";# default: 002b36 
  foreground = "#93a1a1";
  color = [ 
    # Background colors:
    background # Color 0 (black)
    "#dc322f" # Color 1 (red)
    "#859900" # Color 2 (green)
    "#b58900" # Color 3 (yellow) 
    "#268bd2" # Color 4 (blue)
    "#6c71c4" # Color 5 (magenta)
    "#2aa198" # Color 6 (cyan)
    foreground # Color 7 (white)

    # Foreground colors:
    "#657b83" # Color 8 (black)
    "#dc322f" # Color 9 (red)
    "#859900" # Color 10 (green)
    "#b58900" # Color 11 (yellow)
    "#268bd2" # Color 12 (blue)
    "#6c71c4" # Color 13 (magenta)
    "#2aa198" # Color 14 (cyan)
    "#fdf6e3" # Color 15 (white)
  ]; 
}
