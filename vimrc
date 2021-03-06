"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Developer: osolong
"             https://github.com/osolong/vim-scripts
"
" Version: 0.8
"
" How_to_install:
"    $ cd
"    $ git clone git://github.com/osolong/vim-scripts.git
"    $ cd vim_scripts
"    $ ./vim_install.sh
"
" How_to_upgrade:
"    $ pushd ~/vim-scripts
"    $ git pull origin master
"    $ popd
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Text, tab and indent related
"    -> Vim grep
"    -> Cscope
"    -> Taglist Plugin
"    -> NerdTree Plugin
"    -> Tag Generation
"    -> Hex Mode
"    -> clang_complete
"    -> Sessions
"
" From Version 0.6 changed to Vundle to manage the plugins
" Plugins included
"	ervandew/supertab
"	chazy/cscope_maps
"	vim-scripts/taglist.vim
"	Rip-Rip/clang_complete
"	ervandew/snipmate.vim
"	scrooloose/nerdtree
"	osolong/vim-perforce
"	mileszs/ack.vim
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on
filetype off
syntax on
let mapleader = ","

" Bundle plugin manager
set rtp+=~/vim-scripts/bundle/vundle/
call vundle#rc("~/vim-scripts/bundle")

 " let Vundle manage Vundle
 " required!
 Bundle 'gmarik/vundle'

" Bundle 'ervandew/supertab'
 Bundle 'chazy/cscope_maps'
 Bundle 'vim-scripts/taglist.vim'
" Bundle 'Rip-Rip/clang_complete'
" Bundle 'msanders/snipmate.vim'
 Bundle 'scrooloose/nerdtree'
 Bundle 'osolong/vim-perforce'
 Bundle 'mileszs/ack.vim'
 Bundle 'xolox/vim-session'
 Bundle 'xolox/vim-misc'
 Bundle 'sjl/gundo.vim'
 Bundle 'bling/vim-airline'
 Bundle 'Valloric/YouCompleteMe'
 Bundle 'SirVer/ultisnips'
 Bundle 'honza/vim-snippets'

filetype plugin indent on
" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/vim-scripts/vimrc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                          " display line number
set mouse=a                         " enable mouse
set mousemodel=extend               " enable extended mouse mode
set nocp                            " vim defaults, not vi!
set ofu=syntaxcomplete#Complete
set hlsearch                        " Highlight search items
set ignorecase                      " ignore case when searching
set showmatch                       " Show matching brackets on cursor over
set splitbelow
set wildmenu                        " Turn on Wild Menu
set cinoptions=:0,l1,t0,g0          " handle C indention
set ruler                           " Always show current position
set cmdheight=2                     " The commandbar height


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent smartindent          " turn on auto/smart indenting
set smarttab                        "make <tab> and <backspace> smarter
set tabstop=4                       " tabstops of 4
set shiftwidth=4                    " indents of 4
set noexpandtab                     " use tabs, not spaces
set foldmethod=marker
set foldmarker=<<<,>>>

" Tab management
map <leader>tn :tabnew %<cr>        " Open a new tab
map <leader>tc :tabclose<cr>        " Close current tab
map <leader>tm :tabmov              " Move to next tabn
map <C-@><C-@> :cs find s <C-R>=expand("<cword>")<CR><CR>


" Copy, paste and cut using <Ctrl-c> <Ctrl-v> and <Ctrl-x>
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" Indentation of a block of code <Ctrl-j>
nmap <C-J> vip=                     " forces reindentation of block of code

"Highlight in red extra white spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
syn keyword cType uint ubyte ulong uint64_t uint32_t uint16_t uint8_t boolean_t int64_t int32_t int16_t int8_t u_int64_t u_int32_t u_int16_t u_int8_t
syn keyword cOperator likely unlikely

"Toggle Show Hidden Characters
"Tabs, Trailing Spaces and EOL
let g:showHidden = 0
function! ToggleShowHiddenChars()
	if g:showHidden
		set nolist
	else
		set list listchars=tab:▸\ ,eol:¬,trail:·,nbsp:·
	endif
	let g:showHidden = !g:showHidden
endfunction

nmap <silent> <F5> <Esc>:call ToggleShowHiddenChars()<CR>
nmap <silent> <F6> <Esc>:retab<CR>
nnoremap <F7> :GundoToggle<CR>

""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
"Navigate through grep results
map <leader>n :cn<cr>               " Next grep result
map <leader>p :cp<cr>               " Previous grep result
map <leader>cw :botright cw 10<cr>  " Open quickfix window with a list of grep result
nnoremap <silent> <F2> :HexmodeDx<CR> " Toggle Hex Mode

""""""""""""""""""""""""""""""
" => Cscope
""""""""""""""""""""""""""""""
"Load Cscope
    function! LoadCscope()
        let db = findfile("cscope.out", "where_is_cscope")
        if (!empty(db))
            let path = strpart(db, 0, match(db, "/cscope.out$"))
            set nocscopeverbose " suppress 'duplicate connection' error
            exe "cs add " . db . " " . path
            set cscopeverbose
        endif
    endfunction
    au BufEnter /* call LoadCscope()

""""""""""""""""""""""""""""""
" => Taglist Plugin
""""""""""""""""""""""""""""""
" F4: Switch on/off TagList
nnoremap <silent> <F4> :TlistToggle<CR>
let Tlist_Show_One_File = 1         " Displaying tags for only one file~
let Tlist_Exist_OnlyWindow = 1      " if you are the last, kill yourself
let Tlist_Use_Right_Window = 1      " split to the right side of the screen
let Tlist_Sort_Type = "order"       " sort by order or name
let Tlist_Display_Prototype = 0     " do not show prototypes and not tags in the taglist window.
let Tlist_Compart_Format = 1        " Remove extra information and blank lines  from the taglist window.
let Tlist_GainFocus_On_ToggleOpen = 1 " Jump to taglist window on open.
let Tlist_Display_Tag_Scope = 1     " Show tag scope next to the tag name.
let Tlist_Close_On_Select = 0       " Close the taglist window when a file or tag is selected.
let Tlist_Enable_Fold_Column = 0    " Don't Show the fold indicator column in the taglist window.
let Tlist_WinWidth = 27

""""""""""""""""""""""""""""""
" => NerdTree plugin
""""""""""""""""""""""""""""""
    map <F3> :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


""""""""""""""""""""""""""""""
" => Tag Generation
""""""""""""""""""""""""""""""
map <C-x><C-x><C-T> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f ~/vim-scripts/tags<CR><CR>
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

""""""""""""""""""""""""""""""
" => Hex Mode
""""""""""""""""""""""""""""""
" helper function to toggle hex mode
function! ToggleHexDx()
" hex mode should be considered a read-only operation
" save values for modified and read-only for restoration later,
" and clear the read-only flag for now
     let l:modified=&mod
     let l:oldreadonly=&readonly
     let &readonly=0
        let l:oldmodifiable=&modifiable
        let &modifiable=1
        if !exists("b:editHex") || !b:editHex
            " save old options
            let b:oldft=&ft
            let b:oldbin=&bin
            " set new options
            setlocal binary " make sure it overrides any textwidth, etc.
            let &ft="xxd"
            " set status
            let b:editHex=1
            " switch to hex editor
            %!xxd
        else
            " restore old options
            let &ft=b:oldft
            if !b:oldbin
            setlocal nobinary
            endif
            " set status
            let b:editHex=0
            " return to normal editing
            %!xxd -r
        endif
     "restore values for modified and read only state
     let &mod=l:modified
     let &readonly=l:oldreadonly
     let &modifiable=l:oldmodifiable
endfunction
" ex command for toggling hex mode - define mapping if desired
command! -bar HexmodeDx call ToggleHexDx()

let g:session_autosave_periodic='no'
let g:session_autosave = 'no'
let g:session_autoload = 'no'

"Airline
let g:airline#extensions#tabline#enabled = 2
set laststatus=2

" Complete options (disable preview scratch window)
set completeopt=menu,menuone,longest
" Limit popup menu height
set pumheight=15
" Renable backspace
set backspace=indent,eol,start

let g:ycm_global_ycm_extra_conf = "~/vim-scripts/.ycm_extra_conf.py"
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" Trigger configuration.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
