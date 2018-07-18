let mapleader=" "

if !empty(glob("~/.vimrc_additions"))
    so ~/.vimrc_additions
    " To alternate between solarized 'dark' and 'light', use
    set background=light
    colorscheme solarized
else
    " Some good alternatives are:
    "     darkblue (dark)
    "     desert (gray)
    "     koehler (dark)
    "     peachpuff (light, but not good for sun)
    "     zeller (for bright bright sun)
    " This is here so that it is loaded when solarized is not available
    colorscheme desert
endif

" This sets the font to a readable size when the editor opens.
set guifont=Monospace\ 14

" This is for compiling languages.
command SML !sml %
command PSML !PolyML %
command Python !python %
command CPP !(g++ % && ./a.out)
command C !(gcc % && ./a.out)
" Note that for these two commands to work, there can't be a package
" name, and also, autochdir needs to be set.
command Haskell !(ghc % && echo Compile Successful && ./%:r )
command Java !(javac % && echo Compile Successful && java %:r)
command Scala !(scalac % && echo Compile Successful && scala %:r)
command Verilog !(iverilog -g2012 % -o %:r && echo Compile Successful && vvp %:r)
command Ruby !ruby %
command Xetex !xelatex %
command Prolog !prolog %

" These add commands to bring up the interactive shells for a few languages.
command PythonShell !python
command ScalaREPL !scala
command SMLREPL !sml

" And set an alias for the spellang command
command Spell set spell spelllang=en_gb

" These are alternatives to <Esc>.
inoremap jk <Esc>
inoremap JK <Esc>
inoremap Jk <Esc>
inoremap jK <Esc>
inoremap kj <Esc>
inoremap Kj <Esc>
inoremap kJ <Esc>
inoremap KJ <Esc>

" Write is a common action. Make it
" nice and quick
nnoremap <leader>w :w<CR>
" These are for quick copy/paste to system clipboard
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>p "+gp
nnoremap <leader>P "+gP

" Add some mappings to move between tabs
nnoremap <leader>s :tabn<CR>
nnoremap <leader>a :tabp<CR>

" Map gV to select the text inserted in the last insert
nnoremap gV `[V`]

" Map j and k to go down a visual line rather than an actual line
nnoremap j gj
nnoremap k gk

" Map 'z,' to move the current line to about 10 from the top
nnoremap z, zt10<C-y>

" This is a function you can run when editing a mathematical document for
" my math shortcuts.
function MathAbbrev()
    iabbrev mms \begin{align*}<CR><CR>\end{align*}<++><Esc>==kS
    iabbrev mma \begin{align}<CR><CR>\end{align}<++><Esc>==kS
    iabbrev mmi \begin{itemize}<CR><CR>\end{itemize}<++><Esc>==kS\item
    iabbrev mme \begin{enumerate}<CR><CR>\end{enumerate}<++><Esc>==kS\item
    iabbrev mmd \begin{description}<CR><CR>\end{description}<++><Esc>==kS\item[]<++><Esc>F]i
    iabbrev mml \begin{lstlisting}[language=]<CR><++><CR>\end{lstlisting}<++><Esc>==kkf=a
    iabbrev mmt \begin{tabular}{<++>}<CR><++><CR>\end{tabular}<++><Esc>2k3==0

    " This if to keep some of the latex-suite mappings that
    " I liked.
    inoremap $$ $$<++><Esc>F$i
    inoremap ^^ ^{}<++><Esc>F}i
    inoremap __ _{}<++><Esc>F}i
endfunction

" This gives markdown the same commands for building and viewing that I
" use for latex.
function Markdown()
    nnoremap <leader>ll :!pandoc -V geometry:margin=1in -o %:r.pdf %<CR>
    nnoremap <leader>lv :!evince %:r.pdf &<CR>
endfunction

" This toggles between using relative numbers and absolute numbering systems.
function ToggleRelativeNumbers()
    if (&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunction

" Set the indent style to be GNU style compliant.
function! GNUIndent()
    setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
    setlocal shiftwidth=2
    setlocal tabstop=8
endfunction

function! LLVMBufferIndent()
    " Constructed from /llvm/utils/vim/vimrc
    setlocal softtabstop=2
    setlocal shiftwidth=2
    setlocal expandtab

    " Highlight trailing whitespace and lines longer than 80 columns.
    highlight LongLine ctermbg=DarkYellow guibg=DarkYellow
    highlight WhitespaceEOL ctermbg=DarkYellow guibg=DarkYellow
    if v:version >= 702
      " Lines longer than 80 columns.
      au BufWinEnter * let w:m0=matchadd('LongLine', '\%>80v.\+', -1)

      " Whitespace at the end of a line.
      " This little dance suppresses
      " whitespace that has just been typed.
      au BufWinEnter * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
      au InsertEnter * call matchdelete(w:m1)
      au InsertEnter * let w:m2=matchadd('WhitespaceEOL', '\s\+\%#\@<!$', -1)
      au InsertLeave * call matchdelete(w:m2)
      au InsertLeave * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
    else
      au BufRead,BufNewFile * syntax match LongLine /\%>80v.\+/
      au InsertEnter * syntax match WhitespaceEOL /\s\+\%#\@<!$/
      au InsertLeave * syntax match WhitespaceEOL /\s\+$/
    endif

    augroup csrc
        au!
        autocmd FileType * set nocindent smartindent
        autocmd FileType c,cpp set cindent
    augroup END

    set cinoptions=:0,g0,(0,Ws,l1
    set smarttab

    augroup filetype
      au! BufRead,BufNewFile *.ll     set filetype=llvm
    augroup END

    augroup filetype
      au! BufRead,BufNewFile *.td     set filetype=tablegen
    augroup END

    augroup filetype
     au! BufRead,BufNewFile *.rst     set filetype=rest
    augroup END
endfunction


function! ProjectStyleLoad()
    let l:BufferName=expand("%:p")

    if l:BufferName =~? "gcc"
        call GNUIndent()
	elseif l:BufferName =~? "llvm"
        call LLVMBufferIndent()
    endif
endfunction

" If this is a GCC project, then use GNU Indent.
au BufRead,BufNewFile * call ProjectStyleLoad()

" This checks for a tags file all the way up to the root rather than just in
" the current directory.
set tags=tags;/

" These call the above functions that set up some
" default commands for that particular type of file.
au FileType markdown :call Markdown()
au FileType tex :call MathAbbrev()
" Set make program to latexmk for latex programs
au FileType tex set makeprg='latexmk'
" Enable spelling by default on some file types.
au FileType tex,markdown :Spell

" Map <leader>lm to make:
nnoremap <leader>lm :make<CR>

" This maps gl to toggle the line numberings from relative to absolute.
nnoremap gl :call ToggleRelativeNumbers()<CR>

" This is for slightly slower reset if I hesitate by accident when writing.
set timeoutlen=1000

" This is to make sure VIM is always centered on the current directory rather
" than the home directory.
set autochdir

" This is for solarized in particular, which requests it.
syntax enable

" This is for keeping track of the cursor. WARNING: makes vim a
" lot slower.
set cursorline
" Disabled due to performance issues.
" set cursorcolumn
" And this is for making the above a little bit faster
set lazyredraw

" This sets up tabs as I want
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4

" This sets the search to search incrementally.
set incsearch
" Sets the search to highlight all the results.
set hlsearch

" Set number means that the focused line has the actual line number.
set number
" And this sets there to be line numbers.
set relativenumber

" This sets up the spelling file for the spelllang command.
set spelllang=en_gb
set spellfile=$HOME/Dropbox/VIM/vim/vimfiles/spell/en.utf-8.add
