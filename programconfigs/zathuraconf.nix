let color = id: (import ./configutil.nix).getColor id true; in
''
# zathurarc-dark
set notification-error-bg       "#586e75" # base01  # seem not work
set notification-error-fg       "${color 1}" # red
set notification-warning-bg     "#586e75" # base01
set notification-warning-fg     "${color 1}" # red
set notification-bg             "#586e75" # base01
set notification-fg             "${color 3}" # yellow

set completion-group-bg         "${color "bg"}" # base03
set completion-group-fg         "#839496" # base0
set completion-bg               "${color "bg"}" # base02
set completion-fg               "${color "fg"}" # base1
set completion-highlight-bg     "#586e75" # base01
set completion-highlight-fg     "#eee8d5" # base2

# Define the color in index mode
set index-bg                   "${color "bg"}" # base02
set index-fg                   "${color "fg"}" # base1
set index-active-bg             "#586e75" # base01
set index-active-fg             "#eee8d5" # base2

set inputbar-bg                 "#586e75" # base01
set inputbar-fg                 "#eee8d5" # base2

set statusbar-bg                "${color "bg"}" # base02
set statusbar-fg                "${color "fg"}" # base1

set highlight-color             "#657b83" # base00  # hightlight match when search keyword(vim's /)
set highlight-active-color      "${color 4}" # blue

set default-bg                  "${color "bg"}" # base02
set default-fg                  "${color "fg"}" # base1
# set render-loading              true
# set render-loading-fg           "${color "bg"}" # base02
# set render-loading-bg           "${color "bg"}" # base02

# Recolor book content's color
set recolor                     true
set recolor-lightcolor          "${color "bg"}" # base02
set recolor-darkcolor           "#93a1a1" # base1
# set recolor-keephue             true      # keep original color

set selection-clipboard clipboard
''
