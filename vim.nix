{ config, pkgs, ... }:

let

##### Custom Vim plugins #######################################################

  # Java Complete 2, with pre-built packages (todo: extract into Nix expression
  # for a more "pure" installation of Java Complete 2)
  customPlugins.vim-javacomplete2 = pkgs.vimUtils.buildVimPlugin {
    name = "vim-javacomplete2";
    src = pkgs.fetchFromGitHub {
      owner = "JorelAli";
      repo = "vim-javacomplete2";
      rev = "cc140af15dc850372655a45cca5b5d07e0d14344";
      sha256 = "1kzx80hz9n2bawrx9lgsfqmjkljbgc1lpl8abnhfzkyy9ax9svk3";
    };
  };

  customPlugins.vim-devdocs = pkgs.vimUtils.buildVimPlugin {
    name = "vim-devdocs";
    src = pkgs.fetchFromGitHub {
      owner = "rhysd";
      repo = "devdocs.vim";
      rev = "1c91c619874f11f2062f80e6ca4b49456f21ae91";
      sha256 = "1nxww2mjabl2g2wchxc4h3a58j64acls24zb5jmfi71b8sai8a9b";
    };
  };

  customPlugins.vim-dart = pkgs.vimUtils.buildVimPlugin {
    name = "vim-dart";
    src = pkgs.fetchFromGitHub {
      owner = "dart-lang";
      repo = "dart-vim-plugin";
      rev = "8ffc3e208c282f19afa237d343fa1533146bd2b4";
      sha256 = "1ypcn3212d7gzfgvarrsma0pvaial692f3m2c0blyr1q83al1pm8";
    };
  };

in {

  environment.variables = { EDITOR = "nvim"; };

  environment.systemPackages = with pkgs; [

    ( with pkgs;
      neovim.override {
          vimAlias = true;              # Lets you use 'vim' as alias for 'nvim'
          configure = {
            customRC = ''
                " Generic vim configuration here  
                syntax enable
                set tabstop=4
                set shiftwidth=4
                set background=dark
                let g:solarized_termtrans = 1
                colorscheme solarized
                set number relativenumber
                set mouse=a
                let g:airline_powerline_fonts = 1
                set backspace=indent,eol,start
                set ignorecase

                " Enable TagBar support for rust files
                autocmd VimEnter *.rs TagbarOpen

                " Configured color pairs for rainbow parentheses
                let g:rbpt_colorpairs = [
                    \ ['brown',       'RoyalBlue3'],
                    \ ['Darkblue',    'SeaGreen3'],
                    \ ['darkgray',    'DarkOrchid3'],
                    \ ['darkgreen',   'firebrick3'],
                    \ ['darkcyan',    'RoyalBlue3'],
                    \ ['darkred',     'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['brown',       'firebrick3'],
                    \ ['gray',        'RoyalBlue3'],
                    \ ['black',       'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['Darkblue',    'firebrick3'],
                    \ ['darkgreen',   'RoyalBlue3'],
                    \ ['darkcyan',    'SeaGreen3'],
                    \ ['darkred',     'DarkOrchid3'],
                    \ ['red',         'firebrick3'],
                    \ ]

                let g:rbpt_max = 16
                let g:rbpt_loadcmd_toggle = 0

                au VimEnter * RainbowParenthesesToggle
                au Syntax * RainbowParenthesesLoadRound
                au Syntax * RainbowParenthesesLoadSquare
                au Syntax * RainbowParenthesesLoadBraces

                " Let Alloy Analyser java Java syntax highlighting
                au BufReadPost *.als set syntax=java
                au BufReadPost *.vue set syntax=html

                " Show tabs as lines
                set listchars=tab:\¦\ 
                set list

                " Enable file specific dev docs
                let g:devdocs_filetype_map = {
                  \ 'java': 'java',
                  \ 'javacc': 'java',
                  \ 'haskell': 'haskell',
                  \ 'rust': 'rust',
                  \  }

                nmap K <Plug>(devdocs-under-cursor)

                " Syntastic configuration
                set statusline+=%#warningmsg#
                set statusline+=%{SyntasticStatuslineFlag()}
                set statusline+=%*

                let g:syntastic_always_populate_loc_list = 1
                let g:syntastic_auto_loc_list = 1
                let g:syntastic_check_on_open = 1
                let g:syntastic_check_on_wq = 0

                " Some Java Complete 2 setup (might be unnecessary)
                let g:JavaComplete_JavaviLogDirectory = $HOME . '/javavilogs'
                let g:JavaComplete_Home = $HOME . '/.vim/bundle/vim-javacomplete2'
                let $CLASSPATH .= '.:' . $HOME . '/.vim/bundle/vim-javacomplete2/lib/javavi/target/classes'

                nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
                imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
                nmap <F5> <Plug>(JavaComplete-Imports-Add)
                imap <F5> <Plug>(JavaComplete-Imports-Add)
                nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
                imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
                nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
                imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

                inoremap <C-@> <c-x><c-o>

                autocmd FileType java setlocal omnifunc=javacomplete#Complete
                autocmd FileType javacc setlocal omnifunc=javacomplete#Complete

                " Enable quality autocompletion
                let g:deoplete#enable_at_startup = 1 

                " Rust stuff
                let g:deoplete#sources#rust#racer_binary = $HOME . '/.cargo/bin/racer'
                let g:deoplete#sources#rust#rust_source_path = $HOME . '/github/rust/src'
                let g:syntastic_rust_checkers = ['cargo']

                " Markdown
                let g:markdown_enable_mappings = 0
                let g:vim_markdown_folding_disabled = 1

                let g:kronos_database = $HOME . '.kronos.database'

                " Don't indent .nix files!
                autocmd FileType nix let b:did_indent = 1
                autocmd FileType nix setlocal indentexpr=

                " autocmd VimEnter *.md Goyo
                autocmd VimEnter *.md SoftPencil
                autocmd VimEnter *.md set spell spelllang=en_gb


              '';

              ### Vim packages #################################################

              packages.myVimPackage = with pkgs.vimPlugins // customPlugins; {
                
                start = [ 
                  deoplete-nvim         # Dark powered autocompletion
                  deoplete-rust         # Autocompletion for rust

                  gitgutter             # Shows git changes in sidebar
                  rainbow_parentheses   # Pairs parentheses with colors
                  solarized             # Solarized theme (of course)
                  supertab              # Tab key does suggestions
                  Syntastic             # Syntax checking for languages
                  tagbar                # Shows declared file methods etc.

                  vim-airline           # Fancy bottom bar for vim
                  vim-airline-themes    # Theme support for bottom bar 
                  vim-commentary        # Easy comment using 'gcc' key shortcut
                  vim-dart              # Dart language support
                  vim-devdocs           # Easy file documentation using ':DevDocs'
                  vim-fugitive          # Git for vim
                  #vim-javacomplete2    # Java IDE features (autocomplete)
                  vim-markdown          # Markdown syntax highlighting
                  vim-nix               # Nix language syntax
                  vim-pencil            # Word wrapping for markdown documents
                  vim-toml              # Toml language syntax

                  ctrlp                 # Easy file opener using Ctrl+P
                  goyo

                ];    
              };
          };
        }
      )


  ];

}
