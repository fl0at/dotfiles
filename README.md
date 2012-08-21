Dotfiles
========

Nothing special about this repository: it intends to live in ~, with no symlink or install-script trickery.

Where possible, I attempt to be as compatible as possible. Not only do I aim for POSIX/bourne compatibility, but for cross-platform compatibility. This should be just as happy on OpenBSD, Cygwin, or Mac OS X as anywhere else. Feel free to open pull requests for added functionality: even if I live in Linux, I want rich support for other platforms. This includes other editors, shells, and the like.
Caveats are noted, and all reasonable attempts are made to test an environment's functionality before enabling it.

Installation
------------

To use this as a drop-in set of dotfiles, you'll likely need to tweak to taste:
 * .bashrc's PATH, EMAIL, LC_ALL, and LANG variables, and aliases
 * .gitconfig's email and name
 * .hgrc's email and name
 * ~/.bin's location and PATH, if you don't dig that spot
You, uh, probably want to delete this README as well. `:D`

There is also a commit-msg file. If installed in .git/hooks, it'll prevent commits with long summaries (>50chars) or bodies (>72chars), which are unfriendly to email subjects/bodies, github, etc.

I would recommend vetting these files, but if you want to clone in-place in your home directory, it is definitely designed for that:

```bash
cd ~; git init
git remote add origin http://github.com/fl0at/dotfiles.git
git branch --set-upstream master origin/master
git pull origin master
```


Quirkiness
----------

Beyond everything mentioned above, there are also a few places where my own idioms might weird you out. They are preceded by a comment containing _`@@@`_.

For example, I like my shells to warn me of background screens/tmuxes when I first log in, and output a silly quote, too.

There is a .gitignore with a straight wildcard, so your whole homedir doesn't show up as untracked.

I also use a standard ANSI/VTxx escape sequence to force PuTTY windows to UTF-8 mode. This should also work on Unicode-capable xterms, but your mileage may vary, as I haven't tested it.
I know I can just set that encoding manually in PuTTY, but if I'm using a fresh copy of PuTTY at a friend's house, for example... It's easy to forget, only to annoy you when you get accented characters instead of quotes in a manpage.

License
-------

Unless otherwise specified, (c) Scott Paeth, 2012
No rights reserved. I'd appreciate a namedrop though.

Sources cited where possible. Main source of inspiration was rtomayko's dotfiles, but ryanb and many others weighed in heavily.
