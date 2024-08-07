" Filetypes
filetype plugin on
filetype on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set hlsearch
set number
set guicursor=a:hor20-Cursor
set notermguicolors

autocmd FileType c setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType cpp setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType dart setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType scala setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType sh setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Maps
let mapleader = ' '
noremap <Leader><Leader> :let @/=''<cr>


" Visual aid
fun! Toggle80Line()
  if &colorcolumn == 0
    set colorcolumn=80
  else
    set colorcolumn=0
  endif
endfun

nnoremap <C-l> :call Toggle80Line()<CR>

" Forzar cambios a .py
set nosmarttab

" Binary files
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

" Trailing whitespaces
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

" Latex
" Must install: zathura, 
syntax enable
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" vim-plug
" for nvim:
"   curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin("~/.vim/plugged")
  " VIMTEX
  Plug 'lervag/vimtex'
  " live preview needs evince (gnome def) or okular for pdf viewers.

  " NERDTree
  Plug 'scrooloose/nerdTree', {'on': 'NERDTreeToggle'}
  nmap <C-n> :NERDTreeToggle<CR>

  " Markdown
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
"  runtime .vim/markdown_prev.vim
  nmap <C-b> :MarkdownPreview<CR>

  " dart
  Plug 'dart-lang/dart-vim-plugin'

  " pywal
  Plug 'dylanaraps/wal.vim'

  " support for yuck (eww's configuration language)
  Plug 'elkowar/yuck.vim'
call plug#end()

colorscheme wal
