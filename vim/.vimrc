filetype plugin on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set hlsearch
set number

" Map Ctrl-Backspace to delete the previous word in insert mode.
imap <C-BS> <C-W>

autocmd FileType scala setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType dart setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

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

" Powerline
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" Maps
let mapleader = ' '
noremap <Leader><Leader> :let @/=''<cr>

" Trailing whitespaces
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

call plug#begin("~/.vim/plugged")
  " VIMTEX
  "Plug 'lervag/vimtex'
  " NERDTree
  Plug 'scrooloose/nerdTree', {'on': 'NERDTreeToggle'}
  nmap <C-n> :NERDTreeToggle<CR>
  " Markdown
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
  runtime .vim/markdown_prev.vim
  nmap <C-b> :MarkdownPreview<CR>
  " Dart
  Plug 'dart-lang/dart-vim-plugin'

  " Wal colors
  Plug 'dylanaraps/wal.vim'
call plug#end()

colorscheme wal
