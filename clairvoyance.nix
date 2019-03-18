with import <nixpkgs> {};

stdenv.mkDerivation rec {
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
  '';
  meta = with stdenv.lib; {
    description = "Ellis' sddm theme";
    homepage = https://github.com/eayus/sddm-theme-clairvoyance;
    platforms = platforms.linux;
  };
}
