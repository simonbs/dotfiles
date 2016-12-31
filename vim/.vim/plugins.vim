" Load vundle
if empty(glob('~/.vim/bundle/Vundle.vim'))
  silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  autocmd VimEnter * PluginInstall
endif

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'morhetz/gruvbox'
Plugin 'ctrlpvim/ctrlp.vim'

call vundle#end()
filetype plugin indent on
syntax enable

set laststatus=2 " Make airline visible all the time
let g:airline#extensions#tabline#enabled = 1 " Enable list of buffers (tabs) in airline
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the file name in tabs
let g:airline_powerline_fonts = 1 " Enable powerline fonts

let NERDTreeShowHidden=1 " Show hidden files in NERDTree

" Close vim if the only window left is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTred()) | q | endif


