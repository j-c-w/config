let mapleader=" "
"
" For some reason, this is important here...
colorscheme desert

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
    " This is here so that it is loaded when solarized is not
    " avaliable
    colorscheme desert
endif


" This sets the font to a readable size when
" the editor opens.
set guifont=Monospace\ 14

" This is for compiling languages.
command SML !sml %
command PSML !PolyML %
command Python !python %
command CPP !(clang++ % && ./a.out)
command C !(clang % && ./a.out)
" Note that for these two commands to work, there can't be a package
" name, and also, autochdir needs to be set.
command Haskell !(ghc % && echo Compile Successful && ./%:r )
command Java !(javac % && echo Compile Successful && java %:r)
command Scala !(scalac % && echo Compile Successful && scala %:r)
command Verilog !(iverilog -g2012 % -o %:r && echo Compile Successful && vvp %:r)
command Ruby !ruby %
command Xetex !xelatex %
command Prolog !prolog %

" These add commands to bring up the interactive shells for a
" few languages
command PythonShell !python
command ScalaREPL !scala
command SMLREPL !sml

" And set an alias for the spellang comment
command Spell set spell spelllang=en_gb

" This is an alternative to <Esc>, which is very
" far away
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
endfunction

" This gives markdown the same commands for building and viewing that I
" use for latex.
function Markdown()
    nnoremap <leader>ll :!pandoc -V geometry:margin=1in -o %:r.pdf %<CR>
    nnoremap <leader>lv :!evince %:r.pdf &<CR>
endfunction

" Set the indent style to be GNU style compliant.
function! GNUIndent()
    setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
    setlocal shiftwidth=2
    setlocal tabstop=8
endfunction

au FileType c,cpp call GNUIndent()

" This checks for a take file all the way up to the root
" rather than just in the current directory.
set tags=tags;/

" These call the above functions that set up some
" default comands for that particular type of file
au FileType markdown :call Markdown()
au FileType tex :call MathAbbrev()

" This is for slightly slower reset if I hesitate by accident
" when writing or something
set timeoutlen=1000

" This is to make sure VIM is always centered on the current
" directory rather than the home directory
set autochdir

" This is for solarized in particular, which requests it.
syntax enable

" This is for keeping track of the cursor. WARNING: makes vim a
" lot slower.
set cursorline
" set cursorcolumn
" And this is for making the above a little bit faster
set lazyredraw

" This sets up tabs as I want
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4

" This sets the search to search incrementally
" sets the search to highlight all the results
set incsearch
set hlsearch

" And this sets there to be line numbers
set number

" This sets up the spelling file that lets me use
" the spell command
set spelllang=en_gb
set spellfile=$HOME/Dropbox/VIM/vim/vimfiles/spell/en.utf-8.add
