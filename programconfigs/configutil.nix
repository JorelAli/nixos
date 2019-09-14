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

# Converts a hex string to RBG.
# Examples:
#   hexToDec "#ffffff" ->> [ 255 255 255 ]
  hexToDec = 
    let 
    twoDigitToDec = str:         let 
    digit1 = builtins.substring 0 1 str;
  digit2 = builtins.substring 1 2 str;
  in
    (charToDec digit1) * 16 + (charToDec digit2);
  charToDec = char: 
    if char == "a" || char == "A" then 10 else
      if char == "b" || char == "B" then 11 else
        if char == "c" || char == "C" then 12 else
          if char == "d" || char == "D" then 13 else
            if char == "e" || char == "E" then 14 else
              if char == "f" || char == "F" then 15 else
                builtins.fromJSON char;
  in
    str:
    let hexStr = 
    if builtins.substring 0 1 str == "#" then 
      builtins.substring 1 6 str else str;
  in 
    let 
    r = twoDigitToDec (builtins.substring 0 2 hexStr);
  g = twoDigitToDec (builtins.substring 2 2 hexStr);
  b = twoDigitToDec (builtins.substring 4 2 hexStr);
  in
    [r g b];

}
