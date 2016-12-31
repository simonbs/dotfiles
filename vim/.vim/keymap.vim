let mapleader="," " Set leader key to comma
" Fast saving
nmap <leader>w :w!<cr> 

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

" Show and hide NERDTree
nmap <silent> <C-D> :NERDTreeToggle<CR> 
" Find current file in NERDTree
map <leader>r :NERDTreeFind<cr> 

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
cmap <C-P> <Up>
nmap <C-P> <Up>
imap <C-P> <Up>
vmap <C-P> <Up>
cmap <C-N> <Down>
nmap <C-N> <Down>
imap <C-N> <Down>
vmap <C-N> <Down>

" Clear search
map <leader>h :nohlsearch<cr>

