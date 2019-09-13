let color = id: (import ./configutil.nix).getColor id true; in
''
DolphinViewContainer > DolphinView > QAbstractScrollArea {
    background-color: ${color "bgl"};
}
''
