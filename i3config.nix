{}: with builtins;

let
  
  i3statusRustConfig = ''
  theme = "solarized-dark"
  icons = "awesome"

  [[block]]
  block = "focused_window"
  max_width = 21

  [[block]]
  block = "cpu"
  interval = 1

  [[block]]
  block = "memory"
  clickable = false
  format_mem = "{Mum}/{MTm}MB ({Mupi}%)"
  interval = 2

  [[block]]
  block = "net"
  device = "wlp3s0"
  ip = true 
  speed_up = false 
  speed_down = false
  bitrate = false

  #[[block]]
  #block = "net"
  #device = "enp0s20f0u4"
  #ip = true
  #speed_up = false
  #speed_down = false
  #bitrate = false

  [[block]]
  block = "splitstatus"

  [[block]]
  block = "sound"
  step_width = 1

  [[block]]
  block = "battery"
  upower = true
  device = "BAT1"

  [[block]]
  block = "backlight"

  [[block]]
  block = "nightlight"
  color_temperature = 4500

  [[block]]
  block = "custom"
  on_click = "escrotum -sC"
  command = "echo "

  [[block]]
  block = "music"
  buttons = ["prev", "play", "next"]

  [[block]]
  block = "time"
  interval = 1
  format = "%a %e %b %r"
  '';

in let

  config = ''
# Use the 'Windows (super) key as my modifier
set $mod Mod4
set $terminal kitty

# Set default font to Fira Code Medium
font pango:Fira Code Medium 12

# Fix any keybindings whenever i3 starts
exec_always xmodmap ~/.Xmodmap

# Use i3Gaps!
for_window [class="^.*"] border pixel 0
for_window [title="^feh.*$"] floating enable
gaps inner 20                           # Default gap size is 20 
default_border none                     # No borders!

# Pulse Audio controls
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% #increase sound volume
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% #decrease sound volume
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # mute sound

# Screen brightness controls
bindsym XF86MonBrightnessUp exec brightnessctl s +20% # xbacklight -inc 20 # increase screen brightness
bindsym XF86MonBrightnessDown exec brightnessctl s 20%- # xbacklight -dec 20 # decrease screen brightness

# Media player controls
bindsym XF86AudioPlay exec playerctl play
bindsym XF86AudioPause exec playerctl pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous


# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# App launchers
bindsym $mod+space exec $terminal 
bindsym $mod+q exec qutebrowser
bindsym $mod+Shift+q exec google-chrome-stable 
bindsym $mod+Shift+n exec google-chrome-stable --incognito
bindsym $mod+j exec $terminal -e nixos-container login jshell 
#~/init.java
bindsym $mod+k exec $terminal 
bindsym $mod+n exec $terminal -e nix repl '<nixpkgs>'
bindsym $mod+e exec dolphin -stylesheet ~/.config/qt5ct/qss/DolphinFix.qss 
bindsym $mod+m exec google-play-music-desktop-player

bindsym Print exec escrotum '%Y-%m-%d-%H%M%S-screenshot.png' -e 'notify-send "Screenshot" "Saved at $f"'


# 'pin' windows that are floating
bindsym $mod+Shift+p sticky toggle

# Move things to and from the scratchpad (think 'minimizing a window' in Windows)
bindsym $mod+Shift+plus move scratchpad
bindsym $mod+Shift+minus scratchpad show

#bindsym $mod+b exec feh --bg-scale $(ls -d $HOME/Wallpapers/* | shuf -n 1)

# kill focused window
bindsym Mod1+F4 kill

# start rofi (program opener)
bindsym $mod+d exec rofi -show run
bindsym $mod exec rofi -show run
bindsym $mod+Tab exec rofi -show window

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

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
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


# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym h resize shrink width 10 px or 10 ppt
        bindsym j resize grow height 10 px or 10 ppt
        bindsym k resize shrink height 10 px or 10 ppt
        bindsym l resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

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

# Start i3bar to display a workspace bar (plus the system information i3status finds out, if available)
bar {
        status_command ~/github/i3status-rust/target/release/i3status-rs ${toFile "i3statusrust.toml" i3statusRustConfig}
        # ~/.config/i3/i3statusrust.toml
        font pango: Fira Code Medium, FontAwesome 12
#        font pango: FuraCode Nerd Font Medium 12, FontAwesome 12 #, FontAwesome 12
#
#		Inconsolata Nerd Font Mono Medium 8
#        font pango: FuraCode Nerd Font Medium 12
        position bottom

        colors {
            separator #002b36
            background #002b36
            statusline #dddddd
            focused_workspace #2aa198 #2aa198 #ffffff
            active_workspace #073642 #073642 #ffffff
            inactive_workspace #073642 #073642 #888888
            urgent_workspace #2f343a #dc322f #ffffff
        }
}
  '';
#  	status_command /home/jorel/github/i3status-rust/target/release/i3status-rs ${toFile "i3statusrust.toml" i3statusRustConfig}#~/.config/i3/i3statusrust.toml

in
 toFile "i3config" config
