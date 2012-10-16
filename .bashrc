# Scott Paeth's ~/.bashrc -- http://github.com/fl0at/dotfiles
# Fully safe for non-interactive shells!
#  (So be careful in the interactivity section!)
# Made to be fully compatible with straight Bourne sh, other than shopt/bind

[ -f /etc/bashrc ] && . /etc/bashrc
[ -f /etc/bash.bashrc ] && . /etc/bash.bashrc # Debian-style

set -o noclobber # don't allow interactive pipes to overwrite unless using |>
umask 0007 # since I'm in the apache group...
bind 'set match-hidden-files off' # Don't show dotfiles in tab-tab-completes unless specified. Set here instead of .inputrc, since that would affect readlines in other programs too

# ----------------------------------------------------------------------
# Environment Variables
# ----------------------------------------------------------------------

# Ugly ol' PATH
PATH=/sbin:$PATH
PATH=~/.gem/ruby/*/bin:$PATH
PATH=~/.bin:$PATH
export PATH

# Fun environment variables
EMAIL=changeme@domain.tld
EDITOR=vim
PAGER=less
export EMAIL EDITOR PAGER

export HISTIGNORE="&:  *:*root@*"  # Hide any command history containing root@, duplicate commands, or any preceded by two spaces (ninja mode?)
export HISTSIZE=20000
shopt -s histappend # normally, history gets truncated, which makes it all ugleh when multiples are used
shopt -s checkwinsize # update cols/lines after commands finish. Set by default in essentially every distro, but here Just In Case(tm)!
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
alias vi=vim

# Sugar aliases
alias bc='bc -il ~/.bc' # use preset useful variables, see .bc
alias beep="printf '\a'"
alias yyyy-mm-dd="date +'%Y-%m-%d'" # outputs a handy datestamp for log filenames, etc
alias fulldate="date +'%Y-%m-%dT%H:%M:%S%z'" # Likewise, but timestamped too. # Note: while %z (timezone offset) is valid for POSIX's strftime(), it is not technically required to be implemented for the date command.
alias sr="screen -d -R" # gimme a Screen! Existing or new, whichever. Add `-p =' to see windowlist on reconnect
alias tm="tmux attach || tmux"
alias h='fc -l'
alias ls='ls --color=auto' # TODO: write test to guess --color=auto or -G or nada based on return status
alias grep="grep --colour=auto" # TODO: as above, use test to guess if --color=auto is applicable, but it looks like all modern Unix families except Solaris and OpenBSD use GNU Grep
alias egrep="egrep --color=auto" # Sucks to have to do this, since it's a symlink
alias fgrep="fgrep --color=auto" # Likewise, sucks. At least nobody uses fgrep, mirite?!1
alias tf="tail -n 0 -f"

# If `gem man` exists, alias overtop of regular `man`, since it passes through
ruby -r rubygems -e 'begin exit(Gem.available?("gem-man")) rescue exit(Gem::Specification.find_all_by_name("rails").empty?) end' > /dev/null 2>&1 && alias man="gem man -s"

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

# NOTE: \e is a GNU-ism. Using \033 for additional compatibility.
# I could use tput, but that depends on the reported $TERM...

# Set window title in GNU Screen
title() {
	[ ! -z "$STY" ] && printf "\033k%s\033\\" "$*"
}

# Sets hardstatus, a variable stored in the window. Used as PuTTY/xterm title.
#   Note: most distributions' $PROMPT_COMMAND will nullify, so unset first.
#   Note: screen's caption will likely override this.
#      Use %h in the caption to pass through the window's own hardstatus.
hardstatus() { 
	printf "\033]0;%s\007" "$*" # xterm/PuTTY kludge: ANSI is <ESC>_foo<ESC>\\
} 

# Temporarily override Screen's hardstatus (eg for Alerts)
screenalert() {
	[ ! -z "$STY" ] && printf "\033!%s\033\\" "$*"
}

#@@@ Spit out a goofy quote
quote() {
        local len=`wc -l < ~/.quotes`
	local ranline;
        let "ranline = $RANDOM % $len + 1" # noninclusive
        head -n $ranline ~/.quotes | tail -n 1
}


#@@@ So... warn the user of existing screen/tmux sessions in new logins, ish.
# This gets invoked in the interactivity section below.
multiplex_login() {
	which grep ls whoami > /dev/null 2>&1 || return
	if [ -z "$STY$TMUX" ] # not in a multiplexer already
	then
		#This will reliably determine $SCREENDIR _unless_ it doesn't have an S- prefix.
		#That's only possible when SCREENDIR is set, or the build uses ~/.screen.
		#In any case, this is as good as I can get. Tolerant of spaces, ()s, etc.
		[ -z $SCREENDIR ] && SCREENDIR=$(screen -ls | grep 'S-' | sed -e 's@[^/]*\(/.*\)S-.*$@\1@')
		if [ "$(ls -A $SCREENDIR/S-`whoami` 2> /dev/null)" ]; then
			printf "There is a wild Screen about. "
			quote
		fi
		if tmux has-session > /dev/null 2>&1; then
			printf "There is a wild tmux about. "
			quote
		fi
	fi
}

# ----------------------------------------------------------------------
# Interactivity mode is kicking in, aww yeah
# ----------------------------------------------------------------------

case "$-" in
	*i*) INTERACTIVE=true ;;
esac
# The standard test is if $PS1 was set, but it's possible the user unset it. The $- variable cannot be unset.
# Honestly though, I'm just being pedantic. Still! There is no downside here.


if [ "$INTERACTIVE" ]; then
	LC_ALL="en_CA.UTF-8"
	LANG="en_CA.UTF-8"
	PS1='\[\e[1m\][\[\e[93m\]\u\[\e[91m\]@\h \[\e[94m\]\w\[\e[00m\]\[\e[1m\]]\$ \[\e[00m\]'
	# TODO: move $PS1 to a (set of) function(s): see rtomayko
	# TODO: include PROMPT_COMMANDs as well

	# RHEL: PS1="[\u@\h \W]\\$ "
	# Debian-style: PS1='\u@\h:\w\$ '
	# Mac OS X: PS1='\h:\W \u\$ '

	# TODO: show git/mercurial branch in prompt if the dir exists:
	#    http://gitready.com/advanced/2009/01/23/bash-git-status.html
	#    http://henrik.nyh.se/2008/12/git-dirty-prompt
	#    https://gist.github.com/31631
	#    http://superuser.com/questions/31744/how-to-get-git-completion-bash-to-work-on-mac-os-x
	# easiest: bash_completion includes __git_ps1(), see below
	export LC_ALL LANG PS1

	multiplex_login #@@@ As above, warn of screen/tmux with a silly quote

	# Normally __git_ps1() is provided by bash_completion, but we can set it if not.
	# TODO: actually use __git_ps1()
	if ! type __git_ps1 2>&1 > /dev/null; then
		# http://effectif.com/git/config
		__git_ps1 ()
		{
		    local b="$(git symbolic-ref HEAD 2>/dev/null)";
		    if [ -n "$b" ]; then
			printf " (%s)" "${b##refs/heads/}"; # posix compliant, believe it or not!
		    fi
		}
	fi
fi

# BIG TODO: deal with unsupported $TERMs like 256color, in screen/tmux as well (and [re]move UTF-8 SGR?)
# For screen/tmux, I can detect $TERM and pass along a settings file which sources the main .screenrc or .tmux.conf but that's ugly.
# For shells, period, I need to properly detect if a term is supported, and fall back gracefully, rather than getting dumped.
# TODO: I also need to find a solution for ssh clients passing $TERM along to unsuspecting servers (and unlike above, I can't rely on programmatic fallback: that is, a virgin VPS will barf on screen-256color-bce)
# Probably, I will just wrap it in a function, since you can't unset ssh_config's SendEnv variable if set in /etc. Lame.
