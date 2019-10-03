let color = id: (import ./configutil.nix).getColor id true; in
''
[ColorScheme]
; Color usage: (dolphin)
; 01) Font color for directories (e.g. Home, or number of folders)
; 02) Title bars (i.e. File, Edit ...), buttons, tabs, scroll bars (bg)
; 03) pixel-width borders around tabs, color of the "handle" for scrollbars & other toolbars 979797
; 04) ?? 5e5c5b
; 05) ?? 204953 (maybe: color of a heirarchy tree + "stuff that shouldn't be seen"?)
; 06) ?? 4a4947
; 07) File name color; address bar color 
; 08) ?? 839496
; 09) ?? 839496
; 10) Background color for the directory icon in address bar
; 11) Side/bottom bar color
; 12) ?? cf0000
; 13) Currently selected item (icons) 204953
; 14) Currently selected item (text) 839496
; 15) ?? color 2
; 16) ?? a70b06
; 17) alternate color (for say, a list view, alternate background color) 5c5b5a
; 18) ?? white
; 19)
; 20)
active_colors=${color 15}, ${color "bgl"}, ${color "ac"}, #5e5c5b, #204953, #4a4947, ${color 15}, #839496, #839496, ${color "bg"}, ${color "bg"}, #cf0000, ${color 5}, ${color 15}, ${color 2}, #a70b06, ${color "bgl"}, #00ff00, #0a0a0a, ${color 15}
disabled_colors=#808080, ${color "bgl"}, #979797, #5e5c5b, #204953, #4a4947, #808080, #808080, #808080, ${color "bg"}, ${color "bg"}, #839496, ${color "bg"}, #808080, ${color 2}, #a70b06, #5c5b5a, ${color 15}, #0a0a0a, ${color 15}
inactive_colors=#839496, ${color "bgl"}, #979797, #5e5c5b, #204953, #4a4947, #839496, #839496, #839496, ${color "bgl"}, ${color "bgl"}, #839496, #204953, #839496, ${color 2}, #a70b06, #5c5b5a, ${color 15}, #0a0a0a, ${color 15}
''
