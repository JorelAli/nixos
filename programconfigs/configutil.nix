# A collection of helper functions

rec {

  # Gets the system colorscheme color, with or without
  # the hash symbol before the 6 character hex code.
  # Examples:
  #   getColor 0 true    ->> #8c9440
  #   getColor 0 false   ->> 8c9440
  #   getColor "fg" true ->> #c5c8c6
  getColor = colorID: withHash: 
    let colorScheme = import ./colorscheme.nix; in
    let color =
      if colorID == "bg" then 
        colorScheme.background
      else if colorID == "fg" then
        colorScheme.foreground
      else if colorID == "bgl" then
        colorScheme.background_light
      else if colorID == "ac" then
        colorScheme.accent
      else 
        builtins.elemAt colorScheme.color colorID; in
    if withHash then color else builtins.replaceStrings ["#"] [""] color; 

}
