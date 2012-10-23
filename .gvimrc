" github.com/fl0at/dotfiles

if has("gui_win32") || has("gui_win64")
	set guifont=Consolas:h10:cANSI
endif

if has('mac')
" Alternatively, has('gui_macvim'), or has('gui_running') || has('mac')
	set gfn=Menlo:h14
endif

silent! colorscheme solarized " It's hard to test if it exists: just load it
set antialias
