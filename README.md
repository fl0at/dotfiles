Dotfiles
========

Nothing special about this repository: it intends to live in ~, with no symlink or install-script trickery.

Where possible, I attempt to be as compatible and low-impact as possible. Not only do I aim for POSIX/bourne compatibility and respect of existing environment variables, but also for cross-platform compatibility. This should be just as happy on OpenBSD, Cygwin, or Mac OS X as anywhere else  
Feel free to open pull requests for added functionality: even if I live in Linux, I want rich support for other platforms. This includes other editors, shells, tmux, and the like.

Caveats are noted, and all reasonable attempts are made to test an environment's functionality before enabling it.

Installation
============

To use this as a drop-in set of dotfiles, you'll likely need to tweak to taste:
 * .bashrc's PATH, EMAIL, LC_ALL, and LANG variables, and aliases
 * .gitconfig's email and name
 * .hgrc's email and name
 * ~/.bin's location and PATH, if you don't dig that spot

You, uh, probably want to delete this README as well. `:D`

There is also a commit-msg file. If installed in .git/hooks, it'll prevent commits with long summaries (>50chars) or bodies (>72chars), which are unfriendly to email subjects/bodies, github, etc.
For more information, see [Tim Pope's classic article](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)

I would recommend vetting these files, but if you want to clone in-place in your home directory, it is definitely designed for that:

```bash
cd ~; git init
git remote add origin http://github.com/fl0at/dotfiles.git
git pull origin master
```


Quirkiness
==========

Beyond everything mentioned above, there are also a few places where my own idioms might weird you out. They are preceded by a comment containing _`@@@`_.

For example, I like my shells to warn me of background screens/tmuxes when I first log in, and output a silly quote, too.

There is a .gitignore with a straight wildcard, so your whole homedir doesn't show up as untracked.

I also use a standard ANSI/VTxx escape sequence to force PuTTY windows to UTF-8 mode. This should also work on Unicode-capable xterms, but your mileage may vary, as I haven't tested it.  
I know I can just set that encoding manually in PuTTY, but if I'm using a fresh copy of PuTTY at a friend's house, for example... It's easy to forget, only to annoy you when you get accented characters instead of quotes in a manpage.

And then there's color detection:

Terminfo and Colors
===================

My default client is PuTTY. It has 256-color mode enabled by default, but annoyingly, it presents itself as straight xterm.
Thus, all programs assume it's only capable of 8 colors.
Not a big deal: change it to xterm-256color, and reap the benefits, right?

_WRONG_. It works, but even though tmux and screen will render in 256-color, their contained windows are presented PTYs as "screen", another 8-color terminfo.

Again, no big deal, right? Set your multiplexer to present screen-256color, and you're golden. And since both multiplxers are smart enough to downscale colors if you connect to them with an 8-color terminal, it's not "forcing" anything that'll break or look ugly.

Oh wait, guess what: RHEL/CentOS 5 doesn't ship with screen-256color, so you get terminfo errors, and everything inside your multiplexer falls back to 8-colour.
Fuck you, Red Hat. Fuck you.  

This leaves you with three options:

 # Custom terminfo files (TODO: cover that here)
 # Give up and force 256-colors on a per-program basis
 # Force screen/tmux to use xterm-256color, against their developer's recommendations.[1][01]
 
[01](http://tmux.svn.sourceforge.net/viewvc/tmux/trunk/FAQ)

Use `infocmp | grep color` or `tput colors` to check the alleged capabilities of a terminal.

If you choose #2, here is your code:

```vimscript
if match($TERM, "screen") !=-1
	set t_Co=256
endif
```

License
=======

Unless otherwise specified, (c) Scott Paeth, 2012  
No rights reserved. I'd appreciate a namedrop though.

Sources cited where possible. Main source of inspiration was rtomayko's dotfiles, but ryanb and many others weighed in heavily.
