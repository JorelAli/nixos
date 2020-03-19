rec {
  port = 9000;
  debugMode = true;
  asYaml = ''
server:
    port : ${builtins.toString port}
    secret_key : "ultrasecretkey" # change this!
    debug : ${if debugMode then "True" else "False"} # debug mode, only for development
    request_timeout : 2.0         # seconds
    base_url : False              # set custom base_url (or False)
    themes_path : ""              # custom ui themes path
    default_theme : oscar         # ui theme
    useragent_suffix : ""         # suffix of searx_useragent, could contain
                                  # informations like admins email address
    image_proxy : False           # proxying image results through searx
    default_locale : ""           # default interface locale

# uncomment below section if you want to use a proxy

#outgoing_proxies :
#    http : http://127.0.0.1:8080
#    https: http://127.0.0.1:8080

# uncomment below section only if you have more than one network interface
# which can be the source of outgoing search requests

#source_ips:
#  - 1.1.1.1
#  - 1.1.1.2

locales:
    en : English
    de : Deutsch
    he : Hebrew
    hu : Magyar
    fr : Français
    es : Español
    it : Italiano
    nl : Nederlands
    ja : 日本語 (Japanese)
    tr : Türkçe
    ru : Russian
    ro : Romanian
  '';
}

