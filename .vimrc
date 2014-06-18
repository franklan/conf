
" set runtimepath+=~/._tk.vim

" --------------------
" general options
" --------------------
set nocompatible
set nobackup
set history=50
set showcmd!

" --------------------
" display options
" --------------------
" syntax
syntax on
" color
try
    colorscheme mycolor
catch /E185:/
    colorscheme delek
endtry
" display
set nu
set ruler
set nowrap
" tabstop and indent
set tabstop=4
set shiftwidth=4
set autoindent
" chinese
set enc=prc

" --------------------
" search
" --------------------
" search context
set hlsearch
set incsearch
" auto complete
set wildignore=*.o,*.obj
set wildmenu
set wildmode=list:longest
set path=.


" --------------------
" actions
" --------------------
" move between lines
set whichwrap=b,s,h,l,<,>,[,]
" windows
nnoremap <C-Tab> :tabn<CR>
nnoremap <F8> <C-W>w
nnoremap <C-H> <C-W><
nnoremap <S-H> <C-W>5<
nnoremap <S-L> <C-W>5>
nnoremap <C-L> <C-W>>
nnoremap <C-J> <C-W>+
nnoremap <C-K> <C-W>-
" tabs
nnoremap <C-T> :tabe<CR>
nnoremap <C-N> :tabn<CR>
nnoremap <C-P> :tabp<CR>
" format file
map <C-\> ggVG= <C-O><C-O>
" edit
set backspace=indent,eol,start whichwrap+=<,>,[,]
vnoremap <BS> d

" open tag list
nnoremap ` :TlistToggle<cr>

" --------------------
" session
" --------------------
nmap ,s :mksession! ~/.vim/.session<CR> :qa!<CR>
nmap ,l :source ~/.vim/.session<CR>

" --------------------
" GUI options
" --------------------
" menu
set guioptions=mbrL
" max window when started
au GUIEnter * simalt ~x

