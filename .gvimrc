if has("gui_win32") || has("gui_win64")
	set guifont=Consolas:h10:cANSI
endif

" If not in GVimrc, this could be has('gui_macvim'), or OR'd with 'gui_running'
if has('mac')
	set gfn=Menlo:h14
endif

silent! colorscheme solarized " It's hard to test if it exists: just load it
set anti " antialiasing
