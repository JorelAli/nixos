{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.0";
  package-name = "Breeze-Adapta-Cursor";
  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "mustafaozhan";
    repo = package-name;
    rev = "32f6e0d4f98cec42930ca5944522c2dffbfe5c5d";
    sha256 = "1nim9dgc99y6f3dc8vm83mmrl6843am483adj1nrlvdi3wwd6q26";
  };

  installPhase = ''
    install -dm 755 $out/share/icons
    mkdir $out/share/icons/Breeze-Adapta
    cp -pr * $out/share/icons/Breeze-Adapta
  '';

  meta = with stdenv.lib; {
    description = "Breeze Adapta Cursor";
    homepage = https://github.com/mustafaozhan/Breeze-Adapta-Cursor; 
#    license = licenses.gpl3;
#    platforms = platforms.all;
#    maintainers = with maintainers; [ offline ];
  };
}
