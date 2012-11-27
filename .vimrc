" github.com/fl0at/dotfiles
"
" Plenty of the following is poached from $VIMRUNTIME/vimrc_example.vim
" The reason? So I don't get screwed over by expecting sanity in random distros.
" Lots is also from from Steve Losh and ryanb:
" 	https://github.com/ryanb/dotfiles
" 	https://bitbucket.org/sjl/dotfiles
" 		(and see http://stevelosh.com/blog/2010/09/coming-home-to-vim/)
"	https://github.com/spf13/spf13-vim/blob/3.0/.vimrc

" TODO: incorporate this resizer?
" http://www.scarpa.name/2011/04/06/terminal-vim-resizing/

" I had to wrap this since some vim-minimals don't even have :let support compiled.
if has("eval")
	let @/ = '' " Forget last session's active search on reopen, since it's strange and very ugly when paired with hlsearch. It still remains in history.
endif

set nocompatible
if has("smartindent")
	set smartindent
elseif
	set autoindent
endif
set backspace=indent,eol,start
set nobackup
set nowritebackup
set shortmess=a " Always show the short message on the bottom!
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set hlsearch " highlight search matches. Common default, specified for redundancy.
set incsearch " do incremental/live searching
set mouse= " @@@ Disabled: mouse support in PuTTY is a bit disconcerting to me.
set history=50 " keep 50 lines of command line history
set scrolloff=1	" minimum lines to keep above and below cursor
" TODO: Vary scrolloff based on terminal height
" TODO: refactor the Resizer 

if has("autocmd")
	filetype plugin indent on
	autocmd FileType html setl sw=4 sts=4 ts=4 et " two-space "tabs" for html
	autocmd FileType css setl sw=4 sts=4 ts=4 et " two-space "tabs" for css
	autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0]) " Put cursor at start, instead of 'last location'
	autocmd BufRead .git/COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0]) " For older vim versions. Like mine.
	autocmd BufRead .git/COMMIT_EDITMSG setl textwidth=72 " see README, regarding line lengths. (Not needed for FileType since it's already there!)
	" TODO: portable "file changed while editing" test.
endif
 
" Unset search variable in addition to the regular Ctrl-L refresh.
" That is, turns off hlsearch's highlighting when done, without disabling it.
nnoremap <C-L> :let @/ = ""<CR><C-L> 
" TODO: use <esc> instead, without breaking arrows or making vim beep on start

if &t_Co > 2 || has("gui_running")
	if has("syntax")
		syntax on
	endif
	set background=dark
	set hlsearch
	if &t_Co >= 256
		silent! colorscheme xoria256 " TODO: or lucius, or jellybeans...
	else
		colorscheme desert
	endif
endif

if &diff && has("cursorbind")
	" In case you have a version that doesn't do this automatically...
	set cursorbind
endif

" Line numbers: show relative in Normal mode and absolute in Edit mode
" Credit to http://news.ycombinator.com/item?id=4172099
" https://gist.github.com/3012145
if has("autocmd") && has("eval")
	function Resizer () " TODO: test this more thoroughly in different versions " TODO: rename to s:Resizer, so it's script-local, but test!
		if &columns>120
			set number " TODO: toggle only if on when we started
			if version>=703
				set rnu
				set numberwidth=5
				autocmd BufEnter * :set rnu
				autocmd BufLeave * :set nu
				autocmd WinEnter * :set rnu
				autocmd WinLeave * :set nu
				autocmd InsertEnter * :set nu
				autocmd InsertLeave * :set rnu
				autocmd FocusLost * :set nu
				autocmd FocusGained * :set rnu
			endif
		else
			set nonumber
			if version>=703
				set nornu
			endif
		endif
	endfunction

	" Run the Resizer on screen size changes.
	" TODO: fix split sizes on window resize (Ctrl-W = helps)
	autocmd VimResized * :call Resizer()
	call Resizer()
endif

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
