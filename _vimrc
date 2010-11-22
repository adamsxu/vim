
" 一般性配置
set linebreak
set textwidth=80
set nocompatible
set history=400
set ruler
set number
set hlsearch
set noincsearch
set expandtab
set noerrorbells
set novisualbell
set t_vb= "close visual bell
set foldmethod=marker
set tabstop=4
set shiftwidth=4
set nobackup
set nowritebackup
"set noswapfile
set smarttab
set smartindent
set autoindent
set cindent
set wrap
set autoread
set cmdheight=1
set showtabline=2 
"set clipboard+=unnamed "是否共同系统粘贴板(Windows)
set tabpagemax=20
set laststatus=2

" 返回当前文件夹
function! CurrectDir()
    return substitute(getcwd(), "", "", "g")
endfunction
" 状态栏
set statusline=\ [File]\ %F%m%r%h\ %w\ \ [PWD]\ %r%{CurrectDir()}%h\ \ %=[Line]\ %l,%c\ %=\ %P

" 配置多语言环境
if has("multi_byte")
    set encoding=utf-8
    set termencoding=utf-8
    set formatoptions+=mM
    set fencs=utf-8,gbk

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif

    if has("win32")
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
        source $VIMRUNTIME/mswin.vim
        behave mswin
        language messages zh_CN.utf-8
    endif 
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

if has('gui_running')
    if has("win32")
        source $VIMRUNTIME/mswin.vim
    endif

    " Always show file types in menu
    let do_syntax_sel_menu=1

    unmap  <C-Y>|  " <C-Y> for Redo is kept in insert mode
    iunmap <C-A>|  " <C-A> for Select-All is kept in normal mode
    " Key mapping to switch windows quickly (<C-Tab> is already mapped)
    nnoremap <C-S-Tab> <C-W>W
    inoremap <C-S-Tab> <C-O><C-W>W

    " 针对 Windows 的配置
    if has("win32")
        set guifont=Consolas:h12:cANSI
        au GUIEnter * simalt ~x " 最大化窗口
    elseif has("unix") 
        set guifont=
    elseif has("mac") || has("macunix")
        set guifont=
    endif

    colorscheme tango
    set guioptions=
    set guioptions+=r
    set cursorline
else
    " English messages only
    language messages en

    " set the default theme in no-GUI 
    colorscheme default

    " Do not increase the windows width in taglist
    let Tlist_Inc_Winwidth=0

    " Set text-mode menu
    if has('wildmenu')
        set wildmenu
        set cpoptions-=<
        set wildcharm=<C-Z>
        nmap <F10>      :emenu <C-Z>
        imap <F10> <C-O>:emenu <C-Z>
    endif

    " Change encoding according to the current console code page
    if &termencoding != '' && &termencoding != &encoding
        let &encoding=&termencoding
        let &fileencodings='ucs-bom,utf-8,' . &encoding
    endif
endif

" 自运行项目
if has("autocmd")
    filetype plugin indent on
    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=80
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
    augroup END
    

    function! AutoClose()
        :inoremap ( ()<ESC>i
        :inoremap " ""<ESC>i
        :inoremap ' ''<ESC>i
        :inoremap { {}<ESC>i
        :inoremap [ []<ESC>i
        :inoremap ) <c-r>=ClosePair(')')<CR>
        :inoremap } <c-r>=ClosePair('}')<CR>
        :inoremap ] <c-r>=ClosePair(']')<CR>
    endf

    function! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endf

    "auto close for PHP and Javascript script
    au FileType php,c,python,javascript exe AutoClose()
endif

" 配置快捷键
map tn :tabnext<cr>
map tp :tabprevious<cr>
map td :NERDTree <cr>
map te :tabedit
map tc :tabclose<cr>
map cs :!php -l %<cr>
map bf :BufExplorer<cr>


" 确保语法高亮
syntax on
