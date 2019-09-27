let color = id: (import ./../../programconfigs/configutil.nix).getColor id true; in
''
[global]
    ### Display ###

    monitor = 0
    follow = mouse
    geometry = "0x5-20+20"
    indicate_hidden = yes
    shrink = no
    transparency = 20
    notification_height = 0
    separator_height = 2
    padding = 8
    horizontal_padding = 8
    frame_width = 3
    frame_color = "${color "ac"}"
    separator_color = frame
    sort = yes
    idle_threshold = 120
    
    ### Text ###
    
    font = Fira Code Medium 14
    line_height = 0
    markup = full
    format = "<b>%s %p</b>\n%b"
    alignment = center 
    show_age_threshold = 60
    word_wrap = yes
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    
    ### Icons ###

    icon_position = left 
    max_icon_size = 32
    icon_path = /run/current-system/sw/share/icons/Papirus-Light/16x16/status/:/run/current-system/sw/share/icons/Papirus-Light/16x16/devices/
    
    ### History ###

    sticky_history = yes
    history_length = 20
    
    ### Misc/Advanced ###
    
    dmenu = /run/current-system/sw/bin/rofi -dmenu -p dunst:
    browser = xdg-open
    always_run_script = true
    
    # Define the title of the windows spawned by dunst
    title = dunst
    
    # Define the class of the windows spawned by dunst
    class = dunst
    startup_notification = false
    
    ### Legacy
    
    force_xinerama = false

    mouse_left_click = close_current
    mouse_middle_click = do_action
    mouse_right_click = close_all
    
[experimental]
    per_monitor_dpi = false
    
[shortcuts]
    
    close = ctrl+space
    close_all = ctrl+shift+space
    history = ctrl+grave
    context = ctrl+shift+period
    
[urgency_low]
    background = "${color "bg"}"
    foreground = "#586e75"
    timeout = 10
    #icon = /path/to/icon
    
[urgency_normal]
    background = "${color "bg"}"
    foreground = "${color "fg"}"
    timeout = 10
    #icon = /path/to/icon
    
[urgency_critical]
    background = "${color 1}"
    foreground = "${color "bg"}"
    frame_color = "${color 6}"
    timeout = 0
    #icon = /path/to/icon
    
[play_sound]
    summary = "*"
    script = /home/jorel/.config/dunst/notifsound.sh
    Notif sound: https://notificationsounds.com/notification-sounds/quite-impressed-565/download/mp3
''
