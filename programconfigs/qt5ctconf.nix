let color = id: (import ./configutil.nix).getColor id true; in
''
[ColorScheme]
active_colors=#839496, ${color "bg"}, #979797, #5e5c5b, #204953, #4a4947, #839496, #839496, #839496, ${color "bgl"}, ${color "bgl"}, #cf0000, #204953, #839496, ${color 2}, #a70b06, #5c5b5a, #ffffff, #0a0a0a, #ffffff
disabled_colors=#808080, ${color "bgl"}, #979797, #5e5c5b, #204953, #4a4947, #808080, #808080, #808080, ${color "bg"}, ${color "bg"}, #839496, ${color "bg"}, #808080, ${color 2}, #a70b06, #5c5b5a, #ffffff, #0a0a0a, #ffffff
inactive_colors=#839496, ${color "bgl"}, #979797, #5e5c5b, #204953, #4a4947, #839496, #839496, #839496, ${color "bgl"}, ${color "bgl"}, #839496, #204953, #839496, ${color 2}, #a70b06, #5c5b5a, #ffffff, #0a0a0a, #ffffff
''
