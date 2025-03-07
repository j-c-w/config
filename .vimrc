let mapleader=" "
set t_ut=

if !empty(glob("~/.vimrc_additions"))
    so ~/.vimrc_additions
    " To alternate between solarized 'dark' and 'light', use
    setlocal background=dark
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

function LocalSettings()
	let b:buffer_setup_complete = get(b:, 'buffer_setup_complete', 0)
	if b:buffer_setup_complete == 1
		" The buffer setup is already done, so we don't want to run it again.
		return
	endif
	" Local builds of VIM need this to have a working backspace.
	setlocal backspace=2
	" This sets the font to a readable size when the editor opens.
	setlocal guifont=Monospace\ 14
	" Make the timeout len very small.  It helps with typing
	" of 'j' followed by k (and keeps the fingers quick :).
	setlocal timeout timeoutlen=200

	" indent-heuristic tries to keep diffs more sensible around
	" indents.  algorithm:patience does a better job
	" (supposedly) at blocking changes together.  This
	" likely comes at the cost of speed.
	if has('diff') && (version > 801 || (version == 801 && has('patch360')))
		setlocal diffopt+=algorithm:patience
		setlocal diffopt+=indent-heuristic
	endif

	" This checks for a tags file all the way up to the root rather than just in
	" the current directory.
	setlocal tags=tags;/

	" This is for keeping track of the cursor. WARNING: makes vim a
	" lot slower.
	setlocal cursorline
	" Disabled due to performance issues.
	" set cursorcolumn
	" And this is for making the above a little bit faster
	setlocal lazyredraw

	" This sets up tabs as I want
	setlocal autoindent
	setlocal noexpandtab
	setlocal tabstop=4
	setlocal shiftwidth=4

	" This sets the search to search incrementally.
	setlocal incsearch
	" Sets the search to highlight all the results.
	setlocal hlsearch

	" Set line numbers
	setlocal number

	" This sets up the spelling file for the spelllang command.
	setlocal spelllang=en_gb
	setlocal spellfile=$HOME/.vimdict.add
	" Spelling mistakes underlined:
	hi SpellBad cterm=underline,bold

	" Make 'J' preserve formatting when joining.
	setlocal formatoptions+=j

	let b:buffer_setup_complete=1
endfunction

augroup LocalSettingsGroup
	au!
	autocmd BufNew * call LocalSettings()
	autocmd BufNewFile * call LocalSettings()
	autocmd BufRead * call LocalSettings()
augroup END

" Set extra colors
set t_Co=256

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

function ToggleSpell()
    if !exists("b:jcw_spell_on")
        " Assume spell check is off by default.
        let b:jcw_spell_on = 0
    endif

    if b:jcw_spell_on
		let b:jcw_spell_on = 0
		setlocal nospell
		echo "Spell off"
    else
		let b:jcw_spell_on = 1
        setlocal spell spelllang=en_gb
		echo "Spell on"
    endif
endfunction

function SetSpellOn()
	let b:jcw_spell_on = 1

	setlocal spell spelllang=en_gb
endfunction


" And set an alias for the spellang command
command Spell call ToggleSpell()

" These are alternatives to <Esc>.
inoremap jk <Esc>
inoremap JK <Esc>
inoremap Jk <Esc>
inoremap jK <Esc>
inoremap kj <Esc>
inoremap Kj <Esc>
inoremap kJ <Esc>
inoremap KJ <Esc>

" Fix last typo
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Write is a common action. Make it
" nice and quick
nnoremap <leader>w :w<CR>

" Map gV to select the text inserted in the last insert.
nnoremap gV `[V`]

" List the buffers and open a buffer switch command.
nnoremap gb :ls<CR>:b<Space>

" Map j and k to go down a visual line rather than an actual line
nnoremap j gj
nnoremap k gk

" Make cw cut the space after the word too, just like dw.
nnoremap cw dwi

" Map Y to yank until the end of the line.
nnoremap Y y$

" Map 'z,' to move the current line to about 10 from the top
nnoremap z, zt10<C-y>

" This is a function you can run when editing a mathematical document for
" my math shortcuts.
function MathAbbrev()
    iabbrev <buffer> mms \begin{align*}<CR><CR>\end{align*}<++><Esc>==kS
    iabbrev <buffer> mma \begin{align}<CR><CR>\end{align}<++><Esc>==kS
    iabbrev <buffer> mmi \begin{itemize}<CR><CR>\end{itemize}<++><Esc>==kS\item
    iabbrev <buffer> mme \begin{enumerate}<CR><CR>\end{enumerate}<++><Esc>==kS\item
    iabbrev <buffer> mmd \begin{description}<CR><CR>\end{description}<++><Esc>==kS\item[]<++><Esc>F]i
    iabbrev <buffer> mml \begin{lstlisting}[language=]<CR><++><CR>\end{lstlisting}<++><Esc>==kkf=a
    iabbrev <buffer> mmt \begin{tabular}{<++>}<CR><++><CR>\end{tabular}<++><Esc>2k3==0
	iabbrev <buffer> mmf \begin{frame}<CR>\frametitle{<++>}<CR>\end{frame}<++><Esc>kk<C-J>
	iabbrev <buffer> mmc \begin{columns}<CR>\begin{column}{0.5\textwidth}<CR><++><CR>\end{column}<CR>\begin{column}{0.5\textwidth}<CR><++><CR>\end{column}<CR>\end{columns}<++><Esc>^%<C-j>
	iabbrev <buffer> mmn <Esc>ggI\documentclass{article}<CR><CR>\begin{document}<CR><CR>\end{document}<Esc>ki

    " This if to keep some of the latex-suite mappings that
    " I liked.
    inoremap <buffer> $$ $$<++><Esc>F$i
    inoremap <buffer> ^^ ^{}<++><Esc>F}i
    inoremap <buffer> __ _{}<++><Esc>F}i
endfunction

" This gives markdown the same commands for building and viewing that I
" use for latex.
function Markdown()
    nnoremap <buffer> <leader>ll :!pandoc -V geometry:margin=1in -o %:r.pdf %<CR>
    nnoremap <buffer> <leader>lv :!evince %:r.pdf &<CR>
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

    augroup csrc
        au!
        autocmd FileType * setlocal nocindent smartindent
        autocmd FileType c,cpp setlocal cindent
    augroup END

    setlocal cinoptions=:0,g0,(0,Ws,l1
    setlocal smarttab
endfunction

function! PythonBufferIndent()
	setlocal expandtab
	setlocal tabstop=4
endfunction

function! RustBufferIndent()
	setlocal expandtab
	setlocal tabstop=4
endfunction


function! ProjectStyleLoad()
    let l:BufferName=expand("%:p")

    if l:BufferName =~? "gcc"
        call GNUIndent()
	elseif l:BufferName =~? "llvm"
        call LLVMBufferIndent()
	elseif l:BufferName =~? ".py"
		call PythonBufferIndent()
	endif
endfunction

" Load the appropriate style of indentation.
au BufRead,BufNewFile * call ProjectStyleLoad()

" LLVM specific filetype highlighting.  If this is not
" highlighting anything, there are some style files to copy
" into the syntax folder.
augroup filetype
  au! BufRead,BufNewFile *.ll     setlocal filetype=llvm
augroup END

augroup filetype
  au! BufRead,BufNewFile *.td     setlocal filetype=tablegen
augroup END

augroup filetype
 au! BufRead,BufNewFile *.rst     setlocal filetype=rest
augroup END

augroup filetype
 au! BufRead,BufNewFile *.rs      setlocal filetype=rust
augroup END

" These call the above functions that set up some
" default commands for that particular type of file.
au FileType markdown :call Markdown()
au FileType tex :call MathAbbrev()
" Set make program to latexmk for latex programs
au FileType tex setlocal makeprg='latexmk'
" Enable spelling by default on some file types.
au FileType tex,markdown :call SetSpellOn()
au FileType rust :call RustBufferIndent()

" Map <leader>lm to make:
nnoremap <leader>lm :make<CR>

" This is to make sure VIM is always centered on the current directory rather
" than the home directory.
setlocal autochdir

" This is for solarized in particular, which requests it.
syntax enable

" Various VIM plugins that are enabled:
if v:version >= 801 && v:version < 900
	" I'm guessing that this is already enabled
	" for 9.0 and up (or maybe just in vim mac?)
	" termdebug is only in 8.1 an up.
	packadd termdebug
endif
