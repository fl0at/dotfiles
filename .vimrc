" Most of the following is poached from $VIMRUNTIME/vimrc_example.vim 
" The reason? So I don't get screwed over by expecting sanity in random distros

" Lots is also from from Steve Losh and ryanb:
" 	https://github.com/ryanb/dotfiles
" 	https://bitbucket.org/sjl/dotfiles
" 		(and see http://stevelosh.com/blog/2010/09/coming-home-to-vim/)
"	https://github.com/spf13/spf13-vim/blob/3.0/.vimrc

" TODO: incorporate this resizer?
" http://www.scarpa.name/2011/04/06/terminal-vim-resizing/

set nocompatible
set autoindent
set backspace=indent,eol,start
filetype plugin indent on
autocmd FileType html setl sw=2 sts=2 ts=2 et " two-space "tabs" for html
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
" TODO: portable "file changed" test. The below doesn't work:
" autocmd FileChangedShell * echo "Warning: File changed on disk"
set nobackup
set nowritebackup
set shortmess=a		" Always show the short message on the bottom!
set mouse=		" Mouse support in PuTTY is a bit disconcerting.
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set scrolloff=1		" minimum lines to keep above and below cursor
 
" Unset search variable during Ctrl-L refresh
" That is, turns off hlsearch's highlighting when done, without disabling it
nnoremap <C-L> :let @/ = ""<CR><C-L> 
" TODO: use <esc> instead, without breaking arrows or making vim beep on start

if &t_Co > 2 || has("gui_running")
	syntax on
	set background=dark
	set hlsearch
	if &t_Co >= 256
		silent! colorscheme xoria256 " TODO: or lucius, or jellybeans...
	else
		colorscheme desert
	endif
endif

" Line numbers: show relative in Normal mode and absolute in Edit mode
" Credit to http://news.ycombinator.com/item?id=4172099
" https://gist.github.com/3012145
function Resizer () " TODO: test this function more thoroughly
	if &columns>120
		set number " TODO: toggle only if on when we started
		if version>=703
			set rnu
			set numberwidth=5
			au BufEnter * :set rnu
			au BufLeave * :set nu
			au WinEnter * :set rnu
			au WinLeave * :set nu
			au InsertEnter * :set nu
			au InsertLeave * :set rnu
			au FocusLost * :set nu
			au FocusGained * :set rnu
		endif
	else
		set nonumber
		if version>=703
			set nornu
		endif
	endif
endfunction

" Run the Resizer on screen size changes.
au VimResized * :call Resizer()
call Resizer()

" Training for hjkl controls.
" nnoremap <up> <nop>
" nnoremap <down> <nop>
" nnoremap <left> <nop>
" nnoremap <right> <nop>
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>
" nnoremap j gj
" nnoremap k gk

" This remaps F1 to act as Escape. Who needs Help?...
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Remaps insert-mode "jj" to count as Escape.
inoremap jj <ESC>
