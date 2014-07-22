syntax enable
syntax on

"let g:bufExplorerMaxHeight=30
"let g:miniBufExplorerMoreThanOne=0
let Tlist_Show_One_File=1
let Tlist_ExitOnlyWindow=1

let g:winManagerWindowLayout='FileExplorer|TagList'
nmap wm :WMToggle<cr>

nnoremap <silent> <F3> :Grep -R<CR>

set nocp
filetype plugin indent on
map<C-F12> :!ctags -R -c++-kinds=+p -fields=+iaS -extra=+q.<CR>
set completeopt=longest,menu

" search context
set hlsearch
set incsearch
" display
set nu
" auto complete
set wildignore=*.o,*.obj
set wildmenu
set wildmode=list:longest
set path=.

set backspace=2
set mouse=v
hi Comment ctermfg=6;
set ts=4
set expandtab
set autoindent


nnoremap <C-N> :tabn<CR>
nnoremap <C-P> :set paste<CR>
nnoremap <C-J> :set nonu<CR>
nnoremap <C-K> :set nu<CR>
nnoremap <C-M> :tabp<CR>

