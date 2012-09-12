# Scott Paeth's ~/.bashrc -- http://github.com/fl0at/dotfiles
# Fully safe for non-interactive shells!
# (So be careful in the interactivity section!)

[ -f /etc/bashrc ] && . /etc/bashrc

set -o noclobber # don't allow interactive pipes to overwrite unless using |>
umask 0007 # since I'm in the apache group...
#set -o notify # notify of bg job completion immediately

# ----------------------------------------------------------------------
# Environment Variables
# ----------------------------------------------------------------------

# Ugly ol' PATH
PATH=/sbin:$PATH
PATH=~/.gem/ruby/*/bin:$PATH
PATH=~/.bin:$PATH
export PATH

# Fun environment variables
EMAIL=scott@paeth.ca
EDITOR=vim
PAGER=less
export EMAIL EDITOR PAGER

export HISTIGNORE="&:  *:*root@*"  # Hide any command history containing root@, duplicate commands, or any preceded by two spaces (ninja mode?)
export HISTSIZE=10000
#$TMOUT=n variable ends a bash session after n seconds of idling

# ----------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------

# be paranoid
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Quick-access aliases
alias la='ls -la'
alias ll='ls -l'
alias lt='ls -lt'
alias more="less" # because muscle memory wins...

# Sugar aliases
alias bc='bc -il ~/.bc' # use preset useful variables, see .bc
alias beep="echo -ne '\a'"
alias yyyy-mm-dd="date --iso-8601" # outputs a handy timestamp for log filenames, etc " TODO: see if GNU or POSIX compliant
alias fulldate="date --iso-8601=seconds"
alias sr="screen -d -R" # gimme a Screen! Existing or new, whichever. Add `-p =' to see windowlist on reconnect
alias tm="tmux attach || tmux"
alias h='fc -l' # TODO: see if posix
alias ls='ls --color=auto' # TODO: derp. Breaks on OS X and FreeBSD
alias grep="grep --colour=auto" # TODO: likely breaks on FreeBSD
alias tf="tail -n0 -f" # TODO: see if GNU only

# If `gem man` exists, alias overtop of regular `man`, since it passes through
ruby -r rubygems -e 'begin exit(Gem.available?("gem-man")) rescue exit(Gem::Specification.find_all_by_name("rails").empty?) end' &> /dev/null && alias man="gem man -s"

# Typo aliases
alias l=ls
alias s=ls
alias sl=ls
alias mroe=more
alias moer=more
alias ..="cd .."
alias cd..="cd .."

# "You so stupid!" aliases
#alias :w='echo NOT VI'
#alias :wq='exit 1'
#alias :q='exit 1'

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------
# Screen-specific functions will output to stdout, and will check $STY first

# NOTE: \e is a bashism. Use \033 for additional compatibility.
# I could use tput, but that depends on the reported $TERM...

# TODO: switch echo for printf, since it doesn't accept -- portably?

# Set window title in GNU Screen
title() {
	[ ! -z "$STY" ] && echo -ne "\ek$*\e\\"
}

# Sets hardstatus, a variable stored in the window. Used as PuTTY/xterm title.
#   Note: most distributions' $PROMPT_COMMAND will nullify, so unset first.
#   Note: screen's caption will likely override this.
#      Use %h in the caption to pass through the window's own hardstatus.
hardstatus() { 
	echo -ne "\e]0;$*\007" # xterm/PuTTY kludge: ANSI is <ESC> _ x <ESC> \\
} 

# Temporarily override Screen's hardstatus (eg for Alerts)
screenalert() {
	[ ! -z "$STY" ] && echo -ne "\e!$*\e\\"
}

#@@@ Spit out a goofy quote
quote() {
        len=`wc -l < ~/.quotes`
        let "ranline = $RANDOM % $len + 1" # noninclusive
        head -n $ranline ~/.quotes | tail -n 1
}


#@@@ So... warn the user of existing screen/tmux sessions in new logins, ish.
# This gets invoked in the interactivity section below.
multiplex-login() {
	which grep ls whoami &> /dev/null || return
	if [ -z "$STY$TMUX" ] # not in a multiplexer already
	then
		#This will reliably determine $SCREENDIR _unless_ it doesn't have an S- prefix.
		#That's only possible when SCREENDIR is set, or the build uses ~/.screen.
		#In any case, this is as good as I can get. Tolerant of spaces, ()s, etc.
		[ -z $SCREENDIR ] && SCREENDIR=$(screen -ls | grep 'S-' | sed -e 's@[^/]*\(/.*\)S-.*$@\1@')
		if [ "$(ls -A $SCREENDIR/S-`whoami` 2> /dev/null)" ]; then
			echo -n "There is a wild Screen about. "
			quote
		fi
		if tmux has-session &> /dev/null; then
			echo -n "There is a wild tmux about. "
			quote
		fi
	fi
}

# TODO: `number` command/function that changes tmux/screen window's number?

# ----------------------------------------------------------------------
# Interactivity mode is kicking in, aww yeah
# ----------------------------------------------------------------------

case "$-" in
	*i*) INTERACTIVE=true ;;
esac


if [ "$INTERACTIVE" ]; then
	if [ -z "$STY$TMUX" ]; then # If not inside a screen/tmux: raw terminal
		echo -ne '\033%G' #@@@ Force terminal to UTF-8 # TODO: breaks on Terminal.app, ConnectBot, iTerm2... # TODO: use tput to check if we can at least accept the escape?
	fi
	bind 'set match-hidden-files off' # Set here, as .inputrc affects all readlines
	LC_ALL="en_CA.utf8"
	LANG="en_CA.utf8"
	PS1='\[\e[1m\][\[\e[93m\]\u\[\e[91m\]@\h \[\e[94m\]\W\[\e[00m\]\[\e[1m\]]\$ \[\e[00m\]'
	# TODO: move PS1 to a (set of) function(s), see rtomayko
	# TODO: show git/mercurial branch in prompt if the dir exists:
	#    http://gitready.com/advanced/2009/01/23/bash-git-status.html
	#    http://henrik.nyh.se/2008/12/git-dirty-prompt
	#    https://gist.github.com/31631
	export LC_ALL LANG PS1

	multiplex-login #@@@ As above, warn of screen/tmux with a silly quote
fi

# TODO: deal with $TERM and 256color and screen/tmux (and [re]move UTF-8 SGR?)
# I can alias in $TERM, or point to per-$TERM config that sources main config
