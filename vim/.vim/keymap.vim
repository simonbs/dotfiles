let mapleader="," " Set leader key to comma
nmap <leader>w :w!<cr> " Fast saving

map <space> / " Start searching with space
map <c-space> ? " Start backwards search with Ctrl-Space

nmap <leader>T :enew<cr> " Open empty buffer (new tap)
nmap <leader>l :bnext<CR> " Move to next buffer (next tab)
nmap <leader>h :bprevious<CR> " Move to previous buffer (previous tab)
nmap <leader>bq :bp <BAR> bd #<CR> " Close current buffer and move to previous (close tab)
nmap <leader>bl :ls<CR> " Show all open buffers (tabs) and their status
map <leader>pp :setlocal paste!<cr> " Toggle paste mode on and off

nmap <silent> <C-D> :NERDTreeToggle<CR> " Show and hide NERDTree
map <leader>r :NERDTreeFind<cr> " Find current file in NERDTree


