# https://github.com/pry/pry/wiki/Customization-and-configuration

#@@@ Set an editor
Pry.config.editor = ENV["EDITOR"] || "vi"

#@@@ Use of a pager is enabled by default, since you probably won't like it:
Pry.config.pager = false
