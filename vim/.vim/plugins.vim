" Load vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'

call plug#end()

set laststatus=2 " Make airline visible all the time
let g:airline#extensions#tabline#enabled = 1 " Enable list of buffers (tabs) in airline
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the file name in tabs
let g:airline_powerline_fonts = 1 " Enable powerline fonts

let NERDTreeShowHidden=1 " Show hidden files in NERDTree

let g:NERDSpaceDelims = 1 " Add spaces after comments
let g:NERDCompactSexyComs = 1 " Use compact syntax
let g:NERDDefaultAlign = 'left' " Alignment
let g:NERDCommentEmptyLines = 1 " Allow commenting empty lines

" Close vim if the only window left is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
