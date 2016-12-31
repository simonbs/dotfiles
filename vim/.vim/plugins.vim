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

" Make airline visible all the time.
set laststatus=2

" Configure airline
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename in tabs
let g:airline#extensions#tabline#fnamemod = ':t'

" Enable powerline fonts
let g:airline_powerline_fonts = 1


