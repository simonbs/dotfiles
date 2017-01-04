let mapleader="," " Set leader key to comma
" Fast saving
nmap <leader>w :w!<cr>
" Edit file with file path
nmap <leader>e :e<cr>
" Open file with fzf
nmap <leader>o :Files<cr>

" Open empty buffer (new tap)
nmap <leader>T :enew<cr> 
" Move to next buffer (next tab)
nmap <leader>l :bnext<CR> 
" Move to previous buffer (previous tab)
nmap <leader>h :bprevious<CR> 
" Close current buffer and move to previous (close tab)
nmap <leader>bq :bp <BAR> bd #<CR> 
" Show all open buffers (tabs) and their status
nmap <leader>bl :ls<CR> 
" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr> 

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

" Clear search
map <leader>s :nohlsearch<cr>

" Move left and right with Option-Left and Option-Right
nmap b b
nmap f w
imap b <C-o>b
imap f <C-o>w
vmap b b
vmap f w

" Bash like keys
cmap <C-A> <Home>
nmap <C-A> <Home>
imap <C-A> <Home>
vmap <C-A> <Home>
cmap <C-E> <End>
nmap <C-E> <End>
imap <C-E> <End>
vmap <C-E> <End>
nmap <C-K> <C-U>
cmap <C-K> <C-U>
imap <C-K> <C-U>
vmap <C-K> <C-U>

