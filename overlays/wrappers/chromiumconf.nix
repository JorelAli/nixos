with import ./../../programconfigs/configutil.nix;
let 
  color = id: getColor id false;
  rgb = hex: hexToDec (color hex);
  getRGBColor = list: index: builtins.toString (builtins.elemAt list index);
  rgbStr = list: "[ ${getRGBColor list 0}, ${getRGBColor list 1}, ${getRGBColor list 2} ]";
in
''
{
   "description": "An auto-generated theme using NixOS",
   "key": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5/M9xmiDoe5+yNuIcGHIRhrrRjoMOhVHuI0+GkzuHLtZ6TICaOeJgiP79iVl62IW50wbz7GA7dxA4BV1jkulvWcM0q8ySCWEDg6/1kssWJb9KA1zYe4fFvDvIfFtzPXhkYd+P/XYrmcvYyYYdql0DJze9QO3nt6AcRAgU9lYdBfu2i7xPJ6tEjNL3TaYByd2N3i5hEy7gnpDUCA4izq4c/ASHvXVx32N5BFOB2W/PGU9Eqivi/ydu72+/6g0HSzFIdhXfreh5qBD28pC2mlOzeTT6AtSdOJ22mjykBXINVFub0u8WMHhqAVXoOElMeG1fwlkswOxcA4dza1YkU17TwIDAQAB",
   "manifest_version": 2,
   "name": "NixOS generated theme",
   "theme": {
      "colors": {
         "bookmark_text": ${rgbStr (rgb 15)},
         "frame": ${rgbStr (rgb "bg")},
         "frame_inactive": ${rgbStr (rgb "bgl")},
         "frame_incognito": [ 51, 51, 51 ],
         "frame_incognito_inactive": [ 51, 51, 51 ], 
         "ntp_background": ${rgbStr (rgb "bg")},
         "ntp_text": ${rgbStr (rgb 15)},
         "tab_background_text": ${rgbStr (rgb 15)},
         "tab_text": ${rgbStr (rgb 15)},
         "toolbar": ${rgbStr (rgb "bgl")}
      },
      "properties": {
         "ntp_background_repeat": "repeat",
         "ntp_logo_alternate": 1
      },
      "tints": {
         "buttons": [ 0, 0, 1 ]
      }
   },
   "update_url": "https://clients2.google.com/service/update2/crx",
   "version": "1.0.0"
}
''
