set nocompatible              " required
filetype off                  " required

execute pathogen#infect()
call pathogen#helptags()

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
" Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-easytags'
" Bundle 'Valloric/YouCompleteMe'
" Plugin 'scrooloose/syntastic'
" Plugin 'nvie/vim-flake8'
" Plugin 'tell-k/vim-autopep8'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let python_highlight_all=1
syntax on

" let g:ycm_autoclose_preview_window_after_completion=1
" map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=0 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
au BufNewFile,BufRead *.c
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=0 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
au BufNewFile,BufRead *.cl
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=0 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix


au BufNewFile,BufRead *.js
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab

au BufNewFile,BufRead *.tsx
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab

au BufNewFile,BufRead *.jsx
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab

au BufNewFile,BufRead *.yml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab

au BufNewFile,BufRead *.md
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab
highlight BadWhitespace ctermbg=darkgreen guibg=darkgreen
au BufRead,BufNewFile *.py match BadWhitespace /\s\+$/

set foldmethod=indent
set foldlevel=99
nnoremap <space> za
set encoding=utf-8
set nu
set statusline+=%{gutentags#statusline()}
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
set backspace=indent,eol,start
set colorcolumn=100
set rtp+=/usr/local/opt/fzf

nnoremap <silent> <F3> :call fzf#run({'sink': 'tabedit'}) <CR>
nnoremap <silent> <F2> :call fzf#run({'source': map(range(1, bufnr('$')), 'bufname(v:val)'), 'sink': 'buffer'}) <CR>

function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v -a ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
  \ 'down':    '40%',
  \ 'sink':    function('s:tags_sink')})
endfunction
command! Tags call s:tags()

let mapleader = ","
nnoremap <silent> <leader>t :Tags<CR>

let g:gutentags_ctags_extra_args=['--extra=+fq', '--fields=+Kl', '--fields=-k', '--python-kinds=-i']
nnoremap <C-]> <C-]>
