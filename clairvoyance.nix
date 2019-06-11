{ 
  stdenv, fetchFromGitHub,
  autoFocusPassword ? false, 
  backgroundURL ? null, 
  enableHDPI ? false,
  fileType ? "jpg"
}:

let boolToStr = b: if b then "true" else "false";
    autoFocusPassword' = boolToStr autoFocusPassword;
    enableHDPI' = boolToStr enableHDPI;
    background = "Assets/Background." + fileType;
    themeConfig = builtins.toFile "theme.conf" ''
      [General]
      background=${background}
      autoFocusPassword=${autoFocusPassword'}
      enableHDPI=${enableHDPI'}
    '';

in stdenv.mkDerivation rec {
  name = "sddm-clairvoyance";
  src = fetchFromGitHub {
    owner = "eayus"; 
    repo = "sddm-theme-clairvoyance"; 
    rev = "fb0210303f67325162a5f132b6a3f709dcd8e181"; 
    sha256 = "17hwh0ixnn5d9dbl1gaygbhb1zv4aamqkqf70pcgq1h9124mjshj"; 
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/clairvoyance
    cp -r * $out/share/sddm/themes/clairvoyance
    cp ${themeConfig} $out/share/sddm/themes/clairvoyance/theme.conf
    ${if backgroundURL == null then "" else "cp ${builtins.fetchurl backgroundURL} $out/share/sddm/themes/clairvoyance/${background}"}
 '';

  meta = with stdenv.lib; {
    description = "eayus' sddm theme";
    homepage = https://github.com/eayus/sddm-theme-clairvoyance;
    platforms = platforms.linux;
  };
}
