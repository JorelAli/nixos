let color = id: (import ./configutil.nix).getColor id false; in
''

set symbols_style numbers

# Set tty colors & font
if tty | grep tty > /dev/null
	setuptty
    echo -en "\e]PB657b83" # S_base00
    echo -en "\e]PA586e75" # S_base01
    echo -en "\e]P0073642" # S_base02
    echo -en "\e]P62aa198" # S_cyan
    echo -en "\e]P8002b36" # S_base03
    echo -en "\e]P2859900" # S_green
    echo -en "\e]P5d33682" # S_magenta
    echo -en "\e]P1dc322f" # S_red
    echo -en "\e]PC839496" # S_base0
    echo -en "\e]PE93a1a1" # S_base1
    echo -en "\e]P9cb4b16" # S_orange
    echo -en "\e]P7eee8d5" # S_base2
    echo -en "\e]P4268bd2" # S_blue
    echo -en "\e]P3b58900" # S_yellow
    echo -en "\e]PFfdf6e3" # S_base3
    echo -en "\e]PD6c71c4" # S_violet
    clear # against bg artifacts

	setfont /nix/store/gjnwk119q3wzp7y50s3bnzx2ms8dp06s-powerline-fonts-2018-11-11/share/fonts/psf/ter-powerline-v28b.psf.gz
end

# Set budspencer color scheme
set budspencer_colors ffffff ${color "bg"} ${color 5} ffffff ${color 3} cb4b16 ${color 1} d33682 ${color 4} ${color "bg"} ${color 4} ${color 2}
''
