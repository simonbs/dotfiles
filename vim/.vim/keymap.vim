let mapleader="," " Set leader key to comma
" Fast saving
nmap <leader>w :w!<cr> 

" Start searching with space
map <space> / 
" Start backwards search with Ctrl-Space
map <c-space> ? 

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


