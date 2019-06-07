" Never be in compatible mode
set nocompatible


" =============================================================================
" ====  PLUGINS
" =============================================================================

" Load Plugin Manager
call plug#begin('~/.vim/plugged')

" Base
Plug 'ciaranm/securemodelines'

" Productivity
"Plug 'ctrlpvim/ctrlp.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Development
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-rooter'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

"if has("nvim")
"    Plug 'ncm2/ncm2'
"    Plug 'ncm2/ncm2-vim'
"    Plug 'Shougo/neco-vim'
"    Plug 'roxma/nvim-yarp'
"endif

if has("nvim")
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
endif
let g:deoplete#enable_at_startup = 1

" Language/completion plugins
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'}
Plug 'dag/vim-fish'
Plug 'leafgarland/typescript-vim'

" GUI / behaviour
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'scrooloose/nerdtree'
Plug 'techlivezheng/vim-plugin-minibufexpl'
Plug 'christoomey/vim-tmux-navigator'

" Themes
Plug 'fatih/molokai'
Plug 'morhetz/gruvbox'
Plug 'jnurmine/Zenburn'
Plug 'ciaranm/inkpot'

call plug#end()


" =============================================================================
" ====  SETTINGS
" =============================================================================

" Fish isn't extremely compatible
"set shell=/bin/bash

" Enable syntax highlighting
if has("syntax")
    syntax on
endif

" Enable filetype settings
filetype on
filetype plugin on
filetype indent on

set autoread " Autoread modified files
set autowrite " Autowrite modified files at certain points

" Search options
set noincsearch
set hlsearch
set ignorecase smartcase infercase
set magic

" Indentation
set autoindent
set smartindent
set shiftwidth=8
set softtabstop=8
set tabstop=8
set noexpandtab

" Don't insert comment prefix when on a comment row and hit o/O
set formatoptions-=o

" Use the completion menu
set wildmenu
set wildmode=list:longest
set completeopt=noinsert,menuone,noselect
set wildignore+=*.o,*~,.lo,.pyc
set suffixes+=.in,.a,.1

" Sensible wildmenu behaviour
inoremap <expr><Esc> (pumvisible() ? (empty(v:completed_item) ? "\<Esc>":"\<C-e>") : "\<Esc>")
inoremap <expr><Tab> (pumvisible() ? "\<C-n>" : "\<Tab>")
inoremap <expr><S-Tab> (pumvisible() ? "\<C-p>" : "\<Tab>")
inoremap <expr><CR> (pumvisible() ? (empty(v:completed_item)?"\<CR>\<CR>":"\<C-y>"):"\<CR>")

"" Use ncm2 for neovim
"if has("nvim")
"    autocmd BufEnter * call ncm2#enable_for_buffer()
"endif


" Use vertical split for diffs
set diffopt+=vertical

" Make backspace delete lots of things
set backspace=indent,eol,start

" Wrap on these
set whichwrap+=<,>,[,]

" enable virtual edit in vblock mode, and one past the end
set virtualedit=block,onemore

" Speed up macros
set lazyredraw

" Store backup-thingies elsewhere
set backupdir=~/.tmp
set directory=~/.tmp

" Enable a nice big viminfo file
set viminfo='1000,f1,:1000,/1000
set viminfo+=!
set history=500


" =============================================================================
" ====  LOOK 'N FEEL
" =============================================================================

set background=dark
let g:gruvbox_contrast_dark="hard"

" Set GUI fonts
if has("gui_gtk")
    set guifont=Inconsolata\ 12
elseif has("gui_running")
    set guifont=-xos4-terminus-medium-r-normal--11-140-72-72-c-80-iso8859-1
endif

" Enable relative line numbers
set number
set relativenumber

" If possible, try to use a narrow number column.
try
    setlocal numberwidth=3
catch
endtry

set colorcolumn=80

" Split in the right direction
set splitbelow
set splitright

" Try to show at least three lines and two columns of context when
" scrolling
set scrolloff=3
set sidescrolloff=2

" No icky toolbar, menu or scrollbars in the GUI
set guioptions-=m
set guioptions-=T
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" Show full tags when doing search completion
set showfulltag

" Show us the command we're typing
set showcmd

" Highlight matching parens
set showmatch

" Allow edit buffers to be hidden
set hidden

" 1 height windows
set winminheight=1

" Always show status line
set laststatus=2

" Enable setting of window title
set title

" Window title
if has('title') && (has('gui_running') || &title)
    set titlestring=%{v:progname}
    set titlestring+=\:\ %f                                           " file name
    set titlestring+=%h%m%r%w                                         " flags
    set titlestring+=\ \(%{substitute(getcwd(),\ $HOME,\ '~',\ '')})  " working directory
endif

" Include $HOME in cdpath
if has("file_in_path")
    let &cdpath=','.expand("$HOME").','.expand("$HOME").'/src'
endif

" Better include path handling
set path+=src/
let &inc.=' ["<]'

" Show tabs and trailing whitespace visually
if has("gui_running")
    set list listchars=tab:»·,trail:·,extends:…,precedes:…
elseif (&termencoding == "utf-8")
    set list listchars=tab:»·,trail:·,extends:>,precedes:<
else
    set list listchars=tab:>-,trail:.,extends:>,precedes:<
endif

" set up some more useful digraphs
if has("digraphs")
    digraph ., 8230    " ellipsis (…)
endif

" Enable fancy % matching
if has("eval")
    runtime! macros/matchit.vim
endif

" No annoying error noises
set noerrorbells visualbell t_vb=


" =============================================================================
" ====  WORD PROCESSING / AUTO-CORRECT
" =============================================================================

set dictionary=/usr/share/dict/words


" =============================================================================
" ====  FUNCTIONS
" =============================================================================

function! Hcontext()
    if (winline() <= 4 && line(".") != 1)
        exe "normal! \<pageup>H"
    else
        exe "normal! H"
    endif
    echo ''
endfunc

function! Lcontext()
    if (winline() > (winheight(0) - 4) && line(".") != line("$"))
        exe "normal! \<pagedown>L"
    else
        exe "normal! L"
    endif
    echo ''
endfunc

function! TrimTrailingLines()
    let cursor_pos = getpos(".")
    :silent! %s#\($\n\s*\)\+\%$##
    call setpos('.', cursor_pos)
endfun

" Force active window to the top of the screen without losing its size.
function! <SID>WindowToTop()
    let l:h=winheight(0)
    wincmd K
    execute "resize" l:h
endfun

function! <SID>check_pager_mode()
    if exists("g:loaded_less") && g:loaded_less
        " we're in vimpager / less.sh / man mode
        set laststatus=0
        set ruler
        set foldmethod=manual
        set foldlevel=99
        set nolist
    endif
endfun

" Visual selection thingie
function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" =============================================================================
" ====  KEY BINDINGS
" =============================================================================

let mapleader = ','

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" change indentation while selecting
vnoremap < <gv
vnoremap > >gv

" search for selected text with */#
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" PageUp/PageDown with H/L
nnoremap H :call Hcontext()<CR>
nnoremap L :call Lcontext()<CR>

" Tag-jumping
nnoremap ö g<C-]>

" Navigate splits
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" Keep search pattern at the center of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Fucking F1
noremap <F1> <Esc>
inoremap <F1> <Esc>

" Delete a buffer but keep layout
if has("eval")
    command! Kwbd enew|bw #
    nmap     <C-w>!   :Kwbd<CR>
endif

" <PageUp> and <PageDown> do silly things in normal mode with folds
noremap <PageUp> <C-u>
noremap <PageDown> <C-d>

" Make <space> in normal mode go down a page rather than left a
" character
nnoremap <space> <C-f>

" Quick save
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>

" Clear search highlight
nnoremap <silent><Leader>/ :nohls<CR>

" Select everything
nnoremap <Leader>aa ggVG

" Reindent everything
nnoremap <Leader>a= ggvG=

" Navigate buffers with MiniBufExplorer
let g:miniBufExplCycleArround = 1
nnoremap <Leader>bl :MBEFocus<CR>
nnoremap <Leader>bn :MBEbn<CR>
nnoremap <Leader>bp :MBEbp<CR>

" quickfix things
nnoremap <Leader>cwc :cclose<CR>
nnoremap <Leader>cwo :botright copen 5<CR><C-w>p
nnoremap <Leader>cn  :cnext<CR>
nnoremap <Leader>cp  :cprevious<CR>
nnoremap <Leader>ce  :clast<CR>
nnoremap - :cnext<CR>

" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>

" Enclose each selected line with markers
noremap <Leader>enc :<C-w>execute
            \ substitute(":'<,'>s/^.*/#&#/ \| :nohls", "#", input(">"), "g")<CR>

" Edit something in the current directory
nnoremap <Leader>ed :e <C-r>=expand("%:p:h")<CR>/<C-d>

" Reformat everything
nnoremap <Leader>gq gggqG

" Reformat paragraph
nnoremap <Leader>gp gqap

" Open NERDtree
nnoremap <Leader>t :NERDTreeToggle<CR>

" q: sucks
nnoremap q: :q


" =============================================================================
" ====  PLUGIN / SCRIPT / APP SETTINGS
" =============================================================================

" Syntastic
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
"let g:syntastic_always_populate_loc_list=1
"let g:syntastic_auto_loc_list=1

let g:syntastic_python_checkers=['pylint']
let g:syntastic_python_pylint_args=" -f parseable -r n -i y -d C0111"


" Python highlighting
let python_highlight_all=1


" Vim specific options
let g:vimsyntax_noerror=1
let g:vimembedscript=0


" Securemodelines verbose setting
let g:secure_modelines_verbose = 0


" Make sure solarized uses optimal colors
let g:solarized_termcolors = &t_Co + 0


" NERDtree settings
let NERDTreeIgnore = ['\.pyc$', '\.\(bmp\|gif\|png\|jpe\?g\)$']
let NERDTreeIgnore += ['\.db$']


" vim-go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

augroup GolangMaps
    autocmd!
    au FileType go nmap <Leader>d  <Plug>(go-def-split)
    "au FileType go nmap <Leader>d  <Plug>(go-def-vertical)
    au FileType go nmap <Leader>in <Plug>(go-info)
    au FileType go nmap <Leader>ii <Plug>(go-implements)
    au FileType go nmap <leader>e  <Plug>(go-rename)
    au FileType go nmap <leader>r  <Plug>(go-run)
    au FileType go nmap <leader>b  <Plug>(go-build)
    au FileType go nmap <leader>t  <Plug>(go-test)
    au FileType go nmap <leader>l  <Plug>(go-metalinter)
    au FileType go nmap <leader>v  <Plug>(go-vet)
    au FileType go nmap <leader>c  <Plug>(go-coverage)
    au FileType go nmap <Leader>d  <Plug>(go-doc)
    au FileType go nmap <Leader>f  :GoImports<CR>
augroup END



"-----------------------------------------------------------------------
" Auto commands
"-----------------------------------------------------------------------

augroup FileTemplates
    autocmd!

    autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e") |
                \ call TrimTrailingLines() | setlocal nomodified
augroup END

augroup MySettings
    autocmd!

    " No residual search highlighting when entering vim
    autocmd VimEnter * :call <SID>check_pager_mode()
    autocmd VimEnter * nohlsearch

    " Disable errorbell and visual errorbell
    autocmd GUIEnter * set noerrorbells visualbell t_vb=

    " Jump to last known position when opening a file
    autocmd BufReadPost *
                \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif

    " Always do a full syntax refresh
    autocmd BufWinEnter * syntax sync fromstart

    " More visible split panes
    if exists("&cursorline")
        au WinEnter * set cursorline
        au WinLeave * set nocursorline
    endif

    " Detect procmailrc
    autocmd BufRead *procmailrc :setfiletype procmail

    " Rofi configuration filetype
    autocmd BufRead *.rasi :setfiletype css

    " Complete hyphenated words in stylesheets
    autocmd FileType css,scss,sass setlocal iskeyword+=-

    " For help files, make <Return> behave like <C-]> (jump to tag)
    autocmd FileType help nmap <buffer> <Return> <C-]>

augroup END


"-----------------------------------------------------------------------
" Local settings
"-----------------------------------------------------------------------

if filereadable(glob("~/.vimrc.local")) 
    source ~/.vimrc.local
endif


"-----------------------------------------------------------------------
" Final settings
"-----------------------------------------------------------------------

colorscheme gruvbox

"-----------------------------------------------------------------------
" vim: set shiftwidth=4 softtabstop=4 expandtab                        :
