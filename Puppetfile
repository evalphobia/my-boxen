# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

def github_other(user, name, version, options = nil)
  options ||= {}
  options[:repo] ||= "#{user}/puppet-#{name}"
  mod name, version, :github_tarball => options[:repo]
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.3.4"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",    "1.0.0"
github "foreman",    "1.0.0"
github "gcc",        "2.0.1"
github "git",        "1.2.5"
github "go",         "1.0.0"
github "homebrew",   "1.5.1"
github "hub",        "1.0.3"
github "inifile",    "1.0.0", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",      "1.4.2"
github "nodejs",     "3.3.0"
github "openssl",    "1.0.0"
github "phantomjs",  "2.0.2"
github "pkgconfig",  "1.0.0"
github "repository", "2.2.0"
github "ruby",       "6.7.2"
github "stdlib",     "4.1.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",       "1.0.0"
github "xquartz",    "1.1.0"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

# for webs
github "cyberduck", "1.0.1"
github "chrome", "1.1.2"
github "firefox", "1.1.7"
github "skype", "1.0.8"
github "dropbox", "1.2.0"
# for media
github "handbrake", "1.0.1"
github "vlc", "1.0.5"
# for development
github "android", "1.1.0"
github "heroku", "2.0.0"
github "iterm2", "1.0.4"
github "sourcetree", "1.0.0"
github "virtualbox", "1.0.10"
github "vagrant", "3.0.3"
# other
github "osx", "2.2.2"
github "tunnelblick", "1.0.4"

github_other "mrchrisadams", "omnidisksweeper", "0.0.2"
#github_other "jozefizso", "sublime_text_3", "1.0.2"
github_other "evalphobia", "sublime_text_3", "1.0.2b"
