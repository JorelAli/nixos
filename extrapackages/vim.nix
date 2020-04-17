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
  
  customPlugins.kotlin-vim = pkgs.vimUtils.buildVimPlugin {
    name = "kotlinvim";
    src = pkgs.fetchFromGitHub {
      owner = "udalov";
      repo = "kotlin-vim";
      rev = "b9fa728701a0aa0b9a2ffe92f10880348fc27a8f";
      sha256 = "1yqzxabhpc4jbdlzhsysp0vi1ayqg0vnpysvx4ynd9961q2fk3sz";
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

                au BufReadPost *.p8 set syntax=lua

                " Show tabs as lines
                set listchars=tab:\¦\ 
                set list

                " Syntastic configuration
                " set statusline+=%#warningmsg#
                " set statusline+=%{SyntasticStatuslineFlag()}
                " set statusline+=%*
 
                " let g:syntastic_always_populate_loc_list = 1
                " let g:syntastic_auto_loc_list = 1
                " let g:syntastic_check_on_open = 1
                " let g:syntastic_check_on_wq = 0
                " let g:syntastic_tex_checkers = ['lacheck']
                " let g:syntastic_java_javac_config_file_enabled = 1

                inoremap <C-@> <c-x><c-o>

                let g:kronos_database = $HOME . '.kronos.database'

                " Enable quality autocompletion
                " let g:deoplete#enable_at_startup = 1 

                " Rust programs 
                autocmd VimEnter *.rs TagbarOpen
                let g:deoplete#sources#rust#racer_binary = $HOME . '/.cargo/bin/racer'
                let g:deoplete#sources#rust#rust_source_path = $HOME . '/github/rust/src'
                " let g:syntastic_rust_checkers = ['cargo']

                " Markdown
                let g:markdown_enable_mappings = 0
                let g:vim_markdown_folding_disabled = 1
                " let g:vim_markdown_conceal = 0
                let g:vim_markdown_conceal_code_blocks = 0
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
                " let g:elm_syntastic_show_warnings = 0
                let g:tagbar_type_elm = {
                  \ 'kinds' : [
                  \ 'f:function:0:0',
                  \ 'm:modules:0:0',
                  \ 'i:imports:1:0',
                  \ 't:types:1:0',
                  \ 'a:type aliases:0:0',
                  \ 'c:type constructors:0:0',
                  \ 'p:ports:0:0',
                  \ 's:functions:0:0',
                  \ ]
                 \}

                " LaTeX documents
                let g:livepreview_previewer = 'zathura'
                " let g:syntastic_loc_list_height = 2
                autocmd VimEnter *.tex SoftPencil
                autocmd VimEnter *.tex set spell spelllang=en_gb
                let g:vimtex_compiler_progname = 'nvr'

                """""""" COC CONFIG """"""

                " TextEdit might fail if hidden is not set.
                set hidden

                " Some servers have issues with backup files, see #649.
                set nobackup
                set nowritebackup

                " Give more space for displaying messages.
                set cmdheight=2
                
                " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
                " delays and poor user experience.
                set updatetime=300
                
                " Don't pass messages to |ins-completion-menu|.
                set shortmess+=c
                
                " Always show the signcolumn, otherwise it would shift the text each time
                " diagnostics appear/become resolved.
                set signcolumn=yes
                
                " Use tab for trigger completion with characters ahead and navigate.
                " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
                " other plugin before putting this into your config.
                inoremap <silent><expr> <TAB>
                      \ pumvisible() ? "\<C-n>" :
                      \ <SID>check_back_space() ? "\<TAB>" :
                      \ coc#refresh()
                inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
                
                function! s:check_back_space() abort
                  let col = col('.') - 1
                  return !col || getline('.')[col - 1]  =~# '\s'
                endfunction
                
                " Use <c-space> to trigger completion.
                inoremap <silent><expr> <c-space> coc#refresh()
                
                " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
                " position. Coc only does snippet and additional edit on confirm.
                " if has('patch8.1.1068')
                "  " Use `complete_info` if your (Neo)Vim version supports it.
                "  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
                " else
                "  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
                " endif

                " Use `[g` and `]g` to navigate diagnostics
                nmap <silent> [g <Plug>(coc-diagnostic-prev)
                nmap <silent> ]g <Plug>(coc-diagnostic-next)
                
                " GoTo code navigation.
                nmap <silent> gd <Plug>(coc-definition)
                nmap <silent> gy <Plug>(coc-type-definition)
                nmap <silent> gi <Plug>(coc-implementation)
                nmap <silent> gr <Plug>(coc-references)
                
                " Use K to show documentation in preview window.
                nnoremap <silent> K :call <SID>show_documentation()<CR>
                
                function! s:show_documentation()
                  if (index(['vim','help'], &filetype) >= 0)
                    execute 'h '.expand('<cword>')
                  else
                    call CocAction('doHover')
                  endif
                endfunction
                
                " Highlight the symbol and its references when holding the cursor.
                autocmd CursorHold * silent call CocActionAsync('highlight')
                
                " Symbol renaming.
                nmap <leader>rn <Plug>(coc-rename)
                
                " Formatting selected code.
                xmap <leader>f  <Plug>(coc-format-selected)
                nmap <leader>f  <Plug>(coc-format-selected)
                
                augroup mygroup
                  autocmd!
                  " Setup formatexpr specified filetype(s).
                  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
                  " Update signature help on jump placeholder.
                  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
                augroup end

                " Applying codeAction to the selected region.
                " Example: `<leader>aap` for current paragraph
                xmap <leader>a  <Plug>(coc-codeaction-selected)
                nmap <leader>a  <Plug>(coc-codeaction-selected)

                " Remap keys for applying codeAction to the current line.
                nmap <leader>ac  <Plug>(coc-codeaction)
                " Apply AutoFix to problem on the current line.
                nmap <leader>qf  <Plug>(coc-fix-current)
                
                " Introduce function text object
                " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
                xmap if <Plug>(coc-funcobj-i)
                xmap af <Plug>(coc-funcobj-a)
                omap if <Plug>(coc-funcobj-i)
                omap af <Plug>(coc-funcobj-a)
                
                " Use <TAB> for selections ranges.
                " NOTE: Requires 'textDocument/selectionRange' support from the language server.
                " coc-tsserver, coc-python are the examples of servers that support it.
                nmap <silent> <TAB> <Plug>(coc-range-select)
                xmap <silent> <TAB> <Plug>(coc-range-select)
                
                " Add `:Format` command to format current buffer.
                command! -nargs=0 Format :call CocAction('format')
                
                " Add `:Fold` command to fold current buffer.
                command! -nargs=? Fold :call     CocAction('fold', <f-args>)
                
                " Add `:OR` command for organize imports of the current buffer.
                command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
                
                " Add (Neo)Vim's native statusline support.
                " NOTE: Please see `:h coc-status` for integrations with external plugins that
                " provide custom statusline: lightline.vim, vim-airline.
                set statusline^=%{coc#status()}%{get(b:,'coc_current_function',\'\')}
                
                " Mappings using CoCList:
                " Show all diagnostics.
                nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
                " Manage extensions.
                nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
                " Show commands.
                nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
                " Find symbol of current document.
                nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
                " Search workspace symbols.
                nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
                " Do default action for next item.
                nnoremap <silent> <space>j  :<C-u>CocNext<CR>
                " Do default action for previous item.
                nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
                " Resume latest coc list.
                nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

                """ Custom coc keyboard shortcuts!
                inoremap <C-_> :Comment<CR>
                nnoremap <C-_> :Comment<CR>
              '';

              ### Vim packages #################################################

              packages.myVimPackage = with pkgs.vimPlugins // customPlugins; {
                
                start = [ 
                  coc-nvim
                  ctrlp                  # Easy file opener using Ctrl+P
                  #deoplete-nvim          # Dark powered autocompletion
                  #deoplete-jedi
                  #deoplete-rust          # Autocompletion for rust
                  elm-vim                # Elm support for vim
                  gitgutter              # Shows git changes in sidebar
                  goyo                   # Makes vim look more like a doc editor
                  rainbow_parentheses    # Pairs parentheses with colors
                  solarized              # Solarized theme (of course)
                  #supertab               # Tab key does suggestions
                  #Syntastic              # Syntax checking for languages
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
                  vim-snippets
                  coc-snippets
                  coc-html


                  vimtex
                  swift-vim

                  vim-illuminate         # Highlights similar words
                  kotlin-vim
                ];    
              };
          };
        }
      )


  ];

}
