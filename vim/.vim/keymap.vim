let mapleader="," " Set leader key to comma
" Fast saving
nmap <leader>w :w!<cr>
" Edit file with file path
nmap <leader>e :e<space>
" Open file with fzf
nmap <leader>o :Files<cr>

"'christoomey/vim-tmux-navigator' Open empty buffer (new tap)
nmap <leader>T :enew<cr> 
" Toggle paste mode on and off
set pastetoggle=<leader>p

" Make search tolerable as described in 
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
nnoremap / /\v
vnoremap / /\v
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" Hard mode. Use h, j, k and l for navigation
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Enter normal mode from insert mode with jj
inoremap jj <ESC>

" Start Ack (using ag, set in plugins.vim)
nmap <leader>a :Ack<space>

" Show and hide NERDTree
nmap <silent> <C-D> :NERDTreeToggle<CR> 
" Find current file in NERDTree
map <leader>r :NERDTreeFind<cr> 

" Keybindingis for expanding regions
" https://github.com/terryma/vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" fzf
map <C-p>f :Files<cr>
nmap <C-p>f :Files<cr>
map <C-p>l :Lines<cr>
nmap <C-p>l :Lines<cr>
map <C-p>b :Buffers<cr>
nmap <C-p>b :Buffers<cr>
map <C-p>m :Maps<cr>
nmap <C-p>m :Maps<cr>
map <C-p>c :Commits<cr>
nmap <C-p>c :Commits<cr>
map <C-p>h :History<cr>
nmap <C-p>h :History<cr>
map <C-p>g :GFiles<cr>
nmap <C-p>g :GFiles<cr>

" Clear search
map <leader>s :nohlsearch<cr>

" Go to next and previous buffers
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>

" Move left and right with Option-Left and Option-Right
nmap b b
nmap f w
vmap b b
vmap f w

" Bash like keys
cmap <C-A> <Home>
nmap <C-A> <Home>
vmap <C-A> <Home>
cmap <C-E> <End>
nmap <C-E> <End>
vmap <C-E> <End>
nmap <C-K> <C-U>
cmap <C-K> <C-U>
vmap <C-K> <C-U>

