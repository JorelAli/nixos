let color = id: (import ./configutil.nix).getColor id true; in
''
[ColorScheme]
; Color usage: (dolphin)
; 01) Font color for directories (e.g. Home, or number of folders)
; 02) ?? (bg)
; 03) ?? 979797
; 04) ?? 5e5c5b
; 05) ?? 204953
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
active_colors=#ffffff, ${color "bg"}, #979797, #5e5c5b, #204953, #4a4947, #ffffff, #839496, #839496, ${color "bg"}, ${color "bg"}, #cf0000, ${color 5}, #ffffff, ${color 2}, #a70b06, ${color "bgl"}, #00ff00, #0a0a0a, #ffffff
disabled_colors=#808080, ${color "bgl"}, #979797, #5e5c5b, #204953, #4a4947, #808080, #808080, #808080, ${color "bg"}, ${color "bg"}, #839496, ${color "bg"}, #808080, ${color 2}, #a70b06, #5c5b5a, #ffffff, #0a0a0a, #ffffff
inactive_colors=#839496, ${color "bgl"}, #979797, #5e5c5b, #204953, #4a4947, #839496, #839496, #839496, ${color "bgl"}, ${color "bgl"}, #839496, #204953, #839496, ${color 2}, #a70b06, #5c5b5a, #ffffff, #0a0a0a, #ffffff
''
