if has("gui_win32")
	set guifont=Consolas:h10:cANSI
endif

if has('mac')
	set gfn=Menlo:h14
endif

silent! colorscheme solarized " Turns out it's hard to test: just do it
set anti               " antialiasing
