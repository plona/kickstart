set nobackup
set expandtab
set tabstop=4
set softtabstop=4
set autoindent
set bs=2
set ruler
set nowrap
" insert date/time
nmap <F3> i<C-R>=strftime("%Y-%m-%d %a %I:%M:%S %p")<CR><Esc>
imap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M:%S %p")<CR>
" max. liczba zakładek
set tabpagemax=999
" nie pamiętam do czego to było, chyba w erze przed utf8
" set isprint=@,128-255
syntax on
" Better command-line completion
set wildmenu
" Show partial commands in the last line of the screen
set showcmd
" Highlight searches
set hlsearch
" Always display the status line, even if only one window is displayed
set laststatus=2
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
" Enable use of the mouse for all modes
set mouse=a
" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2
" zapamiętanie pozycji w pliku
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
" tab move - działa dobrze w niektórych terminalach
" w szczególności (niestety) nie działa w screen
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
" ludzkie kolory
colorscheme desert
" odrysowanie ekranu + wyłączenie podświetlenia (:noh)
nnoremap <C-L> :nohl<CR><C-L>
" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$
" Use visual bell instead of beeping when doing something wrong
set visualbell
" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

