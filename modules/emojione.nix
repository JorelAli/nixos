# This will enable colorful emoji characters from the EmojiOne package.
{ config, pkgs, ... }:

let emojiFont = 
  #"Twitter Color Emoji"
  "EmojiOne Color"
; in
{
  fonts = {
    fonts = [
      pkgs.emojione
      pkgs.twemoji-color-font
    ];

    # Source: https://github.com/wireapp/wire-desktop/wiki/Colorful-emojis-on-Linux
    fontconfig.localConf = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>

        <!-- Add emoji generic family -->
        <alias binding="strong">
          <family>emoji</family>
          <default><family>${emojiFont}</family></default>
        </alias>

        <!-- Aliases for the other emoji fonts -->
        <alias binding="strong">
          <family>Apple Color Emoji</family>
          <prefer><family>${emojiFont}</family></prefer>
        </alias>
        <alias binding="strong">
          <family>Segoe UI Emoji</family>
          <prefer><family>${emojiFont}</family></prefer>
        </alias>
        <alias binding="strong">
          <family>Noto Color Emoji</family>
          <prefer><family>${emojiFont}</family></prefer>
        </alias>

        <!-- Do not allow any app to use Symbola, ever -->
        <selectfont>
          <rejectfont>
            <pattern>
              <patelt name="family">
                <string>Symbola</string>
              </patelt>
            </pattern>
          </rejectfont>
        </selectfont>
      </fontconfig>
    '';
  };
}
