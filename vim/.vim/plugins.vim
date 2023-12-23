" Load vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'terryma/vim-expand-region'
Plug 'keith/swift.vim' 

call plug#end()

filetype plugin indent on

set laststatus=2 " Make airline visible all the time
let g:airline_powerline_fonts = 1 " Enable powerline fonts

let g:NERDSpaceDelims = 1 " Add spaces after comments
let g:NERDCompactSexyComs = 1 " Use compact syntax
let g:NERDDefaultAlign = 'left' " Alignment
let g:NERDCommentEmptyLines = 1 " Allow commenting empty lines
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Use ag over ack for ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
