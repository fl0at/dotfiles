Dotfiles
========

Nothing special about this repository: it intends to live in ~, with no build scripts, special installation procedure, or symlink trickery.

This set of dotfiles is to be as unobtrusive as possible. Environment variables are preserved, and there shouldn't be any issues with hardcoded paths, etc. Use your own file structure, quirks and all!
I aim for over-the-top POSIX compatibility whenever possible. For example, even ``.bashrc`` will run in straight POSIX/bourne shell, other than shopt/bind.
I also strive for cross-platform friendliness. This should be just as happy on OpenBSD, Cygwin, or Mac OS X as anywhere else.
Feel free to open pull requests for added functionality! Even though I'm a text-only vim-using CentOS Linux kind of guy, I want rich support for other platforms and workflows. Mac OS X defaults are especially high on my list of TODOs... :)

Caveats are noted, and all reasonable attempts are made to test environment-specific functionality before including it.

Installation
============

To use this as a drop-in set of dotfiles, you'll likely need to tweak these to taste:
 * .bashrc's PS1, PATH, EMAIL, LC_ALL, and LANG variables, and aliases
 * .gitconfig's email and name
 * .hgrc's email and name
 * ~/.bin's location and PATH, if you don't dig that spot

You, uh, probably want to delete this README as well. `:D`

I would recommend vetting these files and copying only what you like, but if you want to clone this repo in-place into your home directory, it is definitely designed to do that pretty unobtrusively:

```bash
cd ~; git init
git remote add origin http://github.com/fl0at/dotfiles.git
git pull origin master
```

Quirkiness
==========

Beyond everything mentioned above, there are also a few places where my own idioms might weird you out. They are preceded by a comment containing _`@@@`_.

For example, I like my shells to warn me of background screens/tmuxes when I first log in, and output a silly quote, too.  
You could always substitute `fortune` if you don't like my quotes.
Or, preferably, contribute more!

There is a .gitignore with an outright wildcard, so your whole homedir doesn't show up as untracked noise.

I also get creeped out by vim's mouse support in terminal emulators, so that's disabled.  
(I'd like it if not for passthrough when clicking back onto my terminal. Grr.)

Tmux's keymap is also set up to act like GNU Screen in most respects. I understand most people do this, but I figured I'd note it as a quirk just the same.

License
=======

Unless otherwise specified, (c) Scott Paeth, 2012  
No rights reserved. I'd appreciate a namedrop though.

Sources cited where possible. Main source of inspiration was rtomayko's dotfiles, but then, The Internet(tm).
