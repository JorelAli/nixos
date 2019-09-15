let color = id: (import ./configutil.nix).getColor id true; in
''
/**
 * Inspired by vahnrr/rofi-menus
 */

* {
  background-color: @background;
  text-color: @foreground-list;
  font: @text-font;

  /* Global settings */
  accent:           ${color 5};
  background:       ${color "bg"};
  background-light: ${color "bgl"};
  background-focus: ${color 5};
  foreground:       ${color "fg"};
  foreground-list:  #ffffff;
  
  /* General */
  text-font:            "Fira Code Medium 16";
  inputbar-margin:      4px 4px;
  prompt-padding:       16px 20px;
  entry-padding:        18px 16px 16px 0px;

  list-element-padding: 20px;
  list-element-margin:  @inputbar-margin;
  list-element-border:  0px 0px 0px 8px;
  list-window-padding:  2px 3px;

  colon-padding: 16px;
}

#window {
  padding: @list-window-padding;
  width: 50%;
  height: 50%;
}

inputbar, prompt, textbox-prompt-colon, entry {
  background-color: @background-light;
}

#inputbar {
  children: [ prompt, textbox-prompt-colon, entry ];
  margin: @inputbar-margin;
}

#prompt {
  padding: @prompt-padding;
  background-color: @accent;
  text-color: @foreground-list;
}

#textbox-prompt-colon {
  expand: false;
  str: "->>";
  padding: @colon-padding; 
}

#entry {
  text-color: @accent;
  padding: @entry-padding;
}

#element {
  padding: @list-element-padding;
  margin: @list-element-margin;
  border: @list-element-border;
  background-color: @background-light;
  border-color: @background-light;
}

#element.selected {
  background-color: @background-focus;
  text-color: @foreground-list;
  border-color: @accent;
}
''
