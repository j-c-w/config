let mapleader=" "
" This is in a serparate file from my advanced settings so that this
" can easily be transported without the rest of the build (i.e.
"  the installations of Vundle and LatexSuite)

" For some reason, this is important here...
colorscheme desert

" filereadable("~/.vimrc_additions")
" I also set a few settings for these just to make them easier to use
if 1 
	so ~/.vimrc_additions
	" To alternate between solarized dark and light, use 
	set background=light " or light 

	" If the additions are installed, I am going to assume you
	" want solarized.
	colorscheme solarized
else 
	" Need to set the theme to something dark.. Obviously.
	" Some good alternatives are:
	" 	darkblue (dark)	
	" 	desert (gray)
	" 	koehler (dark)
	" 	peachpuff (light, but not good for sun)
	" 	zeller (for bright bright sun)
	" This is here so that it is loaded when solarized is not
	" avaliable
	colorscheme desert
endif


" This sets the font to a readable size when 
" the editor opens.
set guifont=Monospace\ 14

" This is for compiling languages.
" These are defined here rather than in the language
" specific places so I can compile a .sml file to python
" if I really want to (?)
command SML !sml %
command PSML !PolyML % 
command Python !python %
command CPP !(clang++ % && ./a.out)
command C !(clang % && ./a.out)
" Note that for these two commands to work, there can't be a package
" name, and also, autochdir needs to be set.
command Java !(javac % && echo Compile Successful && java %:r)
command Scala !(scalac % && echo Compile Successful && scala %:r)
command Verilog !(iverilog % -o %:r && echo Compile Successful && vvp %:r)
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

" There are also a few key mappings I use a lot
" nmap oo o<Esc>j " These two are for inserting lines without entering
" nmap OO O<Esc>k " insert mode.

" This is an alternative to <Esc>, which is very 
" far away
" All the different combinations are so that I can
" just hit j and k at the same time and it'll
" sort the rest out for me.
inoremap jk <Esc>
inoremap JK <Esc>
inoremap Jk <Esc>
inoremap jK <Esc>
inoremap kj <Esc>
inoremap Kj <Esc>
inoremap kJ <Esc>
inoremap KJ <Esc>

" Idea is to map a key to the write command so that we can write
" nice and quick
nnoremap <leader>w :w<CR>
" These are for quick copy/past to system clipboard
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>p "+gp
nnoremap <leader>P "+gP

" Add some mappings to move between tabs
nnoremap <leader>s :tabn<CR>
nnoremap <leader>a :tabp<CR>

" Map E and B to start and end of line for ease of access

" Map gV to select the text inserted in the last insert
nnoremap gV `[V`]

" Map j and k to go down a visual line rather than an actual line
nnoremap j gj
nnoremap k gk

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
endfunction

function Markdown()
	nnoremap <leader>ll :!pandoc -V geometry:margin=1in -o %:r.pdf %<CR>
	nnoremap <leader>lv :!evince %:r.pdf &<CR>
endfunction

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

" This sets up tabs as I want
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4

" This is just an autosave. Don't know how often etc.
set autowrite

" This sets the search to search as I type and 
" sets the search to highlight all the results
set incsearch
set hlsearch
			
" And this sets there to be line numbers
set number

" This sets up the spelling file that lets me use 
" the spell command
set spelllang=en_gb
set spellfile=$HOME/Dropbox/VIM/vim/vimfiles/spell/en.utf-8.add
