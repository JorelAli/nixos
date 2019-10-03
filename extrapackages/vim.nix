{ config, pkgs, ... }:

let

##### Custom Vim plugins #######################################################

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

  customPlugins.vim-illuminate = pkgs.vimUtils.buildVimPlugin {
    name = "vim-illuminate";
    src = pkgs.fetchFromGitHub {
      owner = "RRethy";
      repo = "vim-illuminate";
      rev = "d2b547c69df09cfc16c965f6289d06eba3685d0c";
      sha256 = "1xwy89qhcp0sfr61xv02iq90ayd8wky6p2vbnj57xqc1yk1rzbrm";
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
                set clipboard^=unnamed
                hi illuminatedWord cterm=underline gui=underline

                " Configured color pairs for rainbow parentheses
                let g:rbpt_colorpairs = [
                    \ ['brown',       'RoyalBlue3'],
                    \ ['red',    'SeaGreen3'],
                    \ ['magenta',    'DarkOrchid3'],
                    \ ['blue',   'firebrick3'],
                    \ ['cyan',    'RoyalBlue3'],
                    \ ['green',     'SeaGreen3'],
                    \ ['yellow', 'DarkOrchid3'],
                    \ ['brown',       'firebrick3'],
                    \ ['red',        'RoyalBlue3'],
                    \ ['magenta',       'SeaGreen3'],
                    \ ['blue', 'DarkOrchid3'],
                    \ ['cyan',    'firebrick3'],
                    \ ['green',   'RoyalBlue3'],
                    \ ['yellow',    'SeaGreen3'],
                    \ ['brown',     'DarkOrchid3'],
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

                inoremap <C-@> <c-x><c-o>

                let g:kronos_database = $HOME . '.kronos.database'

                " Enable quality autocompletion
                let g:deoplete#enable_at_startup = 1 

                " Rust programs 
                autocmd VimEnter *.rs TagbarOpen
                let g:deoplete#sources#rust#racer_binary = $HOME . '/.cargo/bin/racer'
                let g:deoplete#sources#rust#rust_source_path = $HOME . '/github/rust/src'
                let g:syntastic_rust_checkers = ['cargo']

                " Markdown
                let g:markdown_enable_mappings = 0
                let g:vim_markdown_folding_disabled = 1
                autocmd VimEnter *.md SoftPencil
                autocmd VimEnter *.md set spell spelllang=en_gb

                " Nix programs
                autocmd FileType nix let b:did_indent = 1
                autocmd FileType nix setlocal indentexpr=

                " Syntax highlighting for .rasi (rofi themes) 
                au BufNewFile,BufRead /*.rasi setf css

                " Elm programs
                au BufRead,BufNewFile *.elm set noexpandtab
                au BufRead,BufNewFile *.elm set tabstop=2

                " LaTeX documents
                let g:livepreview_previewer = 'zathura'
                let g:syntastic_loc_list_height = 2
                autocmd VimEnter *.md SoftPencil
                autocmd VimEnter *.md set spell spelllang=en_gb
              '';

              ### Vim packages #################################################

              packages.myVimPackage = with pkgs.vimPlugins // customPlugins; {
                
                start = [ 
                  ctrlp                  # Easy file opener using Ctrl+P
                  deoplete-nvim          # Dark powered autocompletion
                  deoplete-rust          # Autocompletion for rust
                  elm-vim                # Elm support for vim
                  gitgutter              # Shows git changes in sidebar
                  goyo                   # Makes vim look more like a doc editor
                  rainbow_parentheses    # Pairs parentheses with colors
                  solarized              # Solarized theme (of course)
                  supertab               # Tab key does suggestions
                  Syntastic              # Syntax checking for languages
                  tagbar                 # Shows declared file methods etc.

                  vim-airline           # Fancy bottom bar for vim
                  vim-airline-themes    # Theme support for bottom bar 
                  vim-commentary        # Easy comment using 'gcc' key shortcut
                  vim-dart              # Dart language support
                  vim-devdocs           # Easy file documentation using ':DevDocs'
                  vim-fugitive          # Git for vim
                  vim-markdown          # Markdown syntax highlighting
                  vim-nix               # Nix language syntax
                  vim-pencil            # Word wrapping for markdown documents
                  vim-toml              # Toml language syntax
                  vim-latex-live-preview # LaTeX compiling for vim

                  vim-illuminate         # Highlights similar words
                ];    
              };
          };
        }
      )


  ];

}
