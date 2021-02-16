with builtins;

let
  
  i3statusRustConfig = 
  let color = id: (import ./configutil.nix).getColor id true; in
  ''
  [theme]
  name = "solarized-dark"

  [theme.overrides]
  idle_bg = "${color "bg"}"
  idle_fg = "${color "fg"}"
  info_bg = "${color 4}"
  info_fg = "${color "bg"}"
  good_bg = "${color 2}"
  good_fg = "${color "bg"}"
  warning_bg = "${color 3}"
  warning_fg = "${color "bg"}"
  critical_bg = "${color 1}"
  critical_fg = "${color "bg"}"
  alternating_tint_bg = "#22222225"
  alternating_tint_fg = "#000000"

  [icons]
  name = "awesome"

  #[[block]]
  #block = "focused_window"
  #max_width = 21

  [[block]]
  block = "cpu"
  interval = 1

  [[block]]
  block = "memory"
  clickable = true 
  format_mem = "{Mum}/{MTm}MB ({Mupi}%)"
  format_swap = "{SUm}MB/{STm}MB ({SUp}%)"
  interval = 2

  [[block]]
  block = "docker"
  interval = 2
  format = "{running}/{total}"

  [[block]]
  block = "net"
  device = "wlp3s0"
  signal_strength = true
  ip = false
  speed_up = false 
  speed_down = false
  bitrate = false

  [[block]]
  block = "net"
  device = "tun0"
  ip = false
  speed_up = false
  speed_down = false
  bitrate = false

  [[block]]
  block = "custom"
  command = "curl icanhazip.com"

  #[[block]]
  #block = "net"
  #device = "enp0s20f0u4"
  #ip = true
  #speed_up = false
  #speed_down = false
  #bitrate = false

  #[[block]]
  #block = "splitstatus"

  [[block]]
  block = "custom"
  #command = "i3-msg -t get_tree | grep -o \"scratchpad_state\":\"fresh\" | wc --lines"
  command = "i3-msg -t get_tree | grep -o fresh | wc -l"
  interval = 1

  [[block]]
  block = "sound"
  step_width = 1
  show_volume_when_muted = true

  [[block]]
  block = "bluetooth"
  mac = "E8:AB:FA:24:9F:09"

  [[block]]
  block = "battery"
  driver = "upower"
  #upower = true
  device = "BAT1"
  show = "both"

  [[block]]
  block = "backlight"
  step_width = 1

  #[[block]]
  #block = "nightlight"
  #color_temperature = 4500

  [[block]]
  block = "music"
  buttons = ["prev", "play", "next"]
  # player = "google-play-music-desktop-player"
  # on_collapsed_click = "google-play-music-desktop-player"

  [[block]]
  block = "time"
  interval = 1
  format = "%a %e %b %r"
  on_click = "caln"
  '';

in let

  config = 
  let color = id: (import ./configutil.nix).getColor id true; in
  ''
set $mod Mod4
set $terminal kitty

font pango:Fira Code Medium 12

# Fix any keybindings whenever i3 starts
exec_always xmodmap ~/.Xmodmap
exec_always nmcli connection up NordVPN
#exec_always --no-startup-id dunst

# Use i3Gaps!
for_window [class="^.*"] border pixel 0
for_window [title="^feh.*$"] floating enable
gaps inner 20                           # Default gap size is 20 
default_border none                     # No borders!

#default_border pixel 1

# Apparently this can do colors as well!
# class                 border  backgr. text    indicator child_border
#client.focused          #ff0000 #00ff00 #ffffff ${color "fg"}   ${color "ac"}
#client.focused_inactive #ff0000 #00ff00 #ffffff ${color "fg"}   ${color "ac"}
#client.unfocused        #ff0000 #00ff00 #888888 ${color "fg"}   ${color "bg"}
#client.urgent           #ff0000 #00ff00 #ffffff ${color "fg"}   ${color "ac"}

#client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c
#client.background       #ffffff

# Pulse Audio controls
#bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% #increase sound volume
#bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% #decrease sound volume
#bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # mute sound

bindsym XF86AudioRaiseVolume exec amixer set Master 5%+
bindsym XF86AudioLowerVolume exec amixer set Master 5%-
bindsym XF86AudioMute exec amixer set Master toggle

bindsym XF86MonBrightnessUp exec brightnessctl s +5% # xbacklight -inc 5 # increase screen brightness
bindsym XF86MonBrightnessDown exec brightnessctl s 5%- # xbacklight -dec 5 # decrease screen brightness

# Media player controls
bindsym XF86AudioPlay exec playerctl play
bindsym XF86AudioPause exec playerctl pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous

floating_modifier $mod

# Simulated media player controls
bindsym $mod+j exec playerctl previous
bindsym $mod+k exec playerctl play-pause
bindsym $mod+l exec playerctl next

# Lock screen!
#bindsym $mod+l exec lock

# App launchers
bindsym $mod+space exec $terminal 
bindsym $mod+q exec qutebrowser
bindsym $mod+Shift+q exec brave 
bindsym $mod+Shift+n exec brave --incognito
#bindsym $mod+j exec $terminal -e jshell 
#~/init.java
#bindsym $mod+k exec $terminal 
bindsym $mod+n exec $terminal -e nix repl '<nixpkgs>'
bindsym $mod+e exec nautilus
# dolphin 
#-stylesheet ~/.config/qt5ct/qss/DolphinFix.qss 
bindsym $mod+m exec google-play-music-desktop-player

bindsym $mod+Shift+t exec notify-send "$(date -u +%I:%M:%S)"

bindsym Print exec escrotum '~/Pictures/screenshots/%Y-%m-%d-%H%M%S-screenshot.png' -e 'notify-send "Screenshot" "Saved at $f"'
bindsym Shift+Print exec escrotum -sC
bindsym $mod+Shift+s exec import png:- | xclip -selection clipboard -t image/png

bindsym $mod+Shift+o exec compton-trans 100

# 'pin' windows that are floating
bindsym $mod+Shift+p sticky toggle

# Move things to and from the scratchpad (think 'minimizing a window' in Windows)
bindsym $mod+Shift+plus move scratchpad
bindsym $mod+Shift+minus scratchpad show

# kill focused window
bindsym Mod1+F4 kill

# start rofi (program opener)
bindsym $mod+d exec rofi -show run
bindsym $mod+Shift+d exec rofi -show drun
bindsym $mod+Tab exec rofi -show window
bindsym $mod+Shift+m exec ws
# What if I have something like
# mod + shift + m = "move"
# which executes a rofi with 
# i3-msg move container to workspace <input here>
# And (maybe?) it lets you populate with existing
# workspaces. If you have workspace "example", you can
# easily move stuff to it

# Gaps!
bindsym $mod+o gaps inner all plus 10
bindsym $mod+p gaps inner all minus 10

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle
bindsym $mod+Shift+f gaps inner all set 0

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

set $ws11 "11"
set $ws12 "12"
set $ws13 "13"
set $ws14 "14"
set $ws15 "15"
set $ws16 "16"
set $ws17 "17"
set $ws18 "18"
set $ws19 "19"
set $ws20 "20"
set $wsNix "Nix"
set $wsChrome "Browser"
set $wsJava "Java"

# switch to workspace
bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+6 workspace $ws6
bindsym $mod+7 workspace $ws7
bindsym $mod+8 workspace $ws8
bindsym $mod+9 workspace $ws9
bindsym $mod+0 workspace $ws10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4
bindsym $mod+Shift+5 move container to workspace $ws5
bindsym $mod+Shift+6 move container to workspace $ws6
bindsym $mod+Shift+7 move container to workspace $ws7
bindsym $mod+Shift+8 move container to workspace $ws8
bindsym $mod+Shift+9 move container to workspace $ws9
bindsym $mod+Shift+0 move container to workspace $ws10

bindsym $mod+Shift+c reload
bindsym $mod+Shift+r restart
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'Exiting i3 in 2 seconds..' -f 'pango:Fira Code Medium 12' & sleep 1; i3-nagbar -t warning -m 'Exiting i3 in 1 second..' -f 'pango:Fira Code Medium 12' & sleep 1; i3-msg exit"
#"i3-nagbar -t warning -m 'You really want to exit i3?' -b 'Yup!' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
    bindsym h resize shrink width 10 px or 10 ppt
    bindsym j resize grow height 10 px or 10 ppt
    bindsym k resize shrink height 10 px or 10 ppt
    bindsym l resize grow width 10 px or 10 ppt

    # back to normal: Enter or Escape or $mod+r
    bindsym Return mode "default"
    bindsym Escape mode "default"
    bindsym $mod+r mode "default"
}

mode "workspace" {
	bindsym $mod+1 workspace $ws11
	bindsym $mod+2 workspace $ws12
	bindsym $mod+3 workspace $ws13
	bindsym $mod+4 workspace $ws14
	bindsym $mod+5 workspace $ws15
	bindsym $mod+6 workspace $ws16
	bindsym $mod+7 workspace $ws17
	bindsym $mod+8 workspace $ws18
	bindsym $mod+9 workspace $ws19
	bindsym $mod+0 workspace $ws20

	bindsym $mod+n workspace $wsNix
	bindsym $mod+q workspace $wsChrome
	bindsym $mod+j workspace $wsJava

	bindsym $mod+Shift+1 move container to workspace $ws11
	bindsym $mod+Shift+2 move container to workspace $ws12
	bindsym $mod+Shift+3 move container to workspace $ws13
	bindsym $mod+Shift+4 move container to workspace $ws14
	bindsym $mod+Shift+5 move container to workspace $ws15
	bindsym $mod+Shift+6 move container to workspace $ws16
	bindsym $mod+Shift+7 move container to workspace $ws17
	bindsym $mod+Shift+8 move container to workspace $ws18
	bindsym $mod+Shift+9 move container to workspace $ws19
	bindsym $mod+Shift+0 move container to workspace $ws20

	bindsym $mod+Shift+n move container to workspace $wsNix
	bindsym $mod+Shift+q move container to workspace $wsChrome
	bindsym $mod+Shift+j move container to workspace $wsJava


	# back to normal: Enter or Escape or $mod+r
    bindsym Return mode "default"
    bindsym Escape mode "default"
    bindsym $mod+w mode "default"

}

bindsym $mod+r mode "resize"
bindsym $mod+w mode "workspace"

bar {
    #status_command ~/github/i3status-rust/target/release/i3status-rs ${toFile "i3statusrust.toml" i3statusRustConfig}
    status_command ~/github/greshake-i3status-rust/target/release/i3status-rs ${toFile "i3statusrust.toml" i3statusRustConfig}
    font pango: Fira Code Medium, FontAwesome 12
    position bottom
    colors {
        separator ${color "bg"}
        background ${color "bg"}
        statusline #dddddd
        focused_workspace ${color "ac"} ${color "ac"} ${color 15}
        active_workspace ${color "bgl"} ${color "bgl"} ${color 15}
        inactive_workspace ${color "bgl"} ${color "bgl"} ${color 15}
        urgent_workspace #2f343a ${color 1} ${color 15}
    }
}
  '';

in
 toFile "i3config" config
