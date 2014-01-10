class people::evalphobia {

  #====== Global Variables ======#

  $homedir    = "/Users/${::luser}" # Home Directory
  $local_repo = "${homedir}/repos" # Directory for Local Repositories
  $config_dir = "${homedir}/configs" # Directory for Local Repository of my configs
  $brew_path  = "${boxen::config::home}/homebrew/bin" 
  $remote_repo = {
    source => "git@bitbucket.org:<your name here>", # remote git url
    config => "configs"                             # repo name
  }
  $dotfiles  = { 
    source => "${config_dir}/mac/dotfiles",
    files => [
      '.bash_profile',
      '.vimrc',
    ]
  }
  # symbolic links for sublime text 3 configs
  $subl_conf_dir = "${homedir}/Documents/Dropbox/conf/sublime-text-3"


  #====== Local Repository Settings ======#
  repository { $config_dir:
    source  => "${remote_repo['source']}/${remote_repo['config']}.git",
    require => File[$local_repo],
  }
  file { $local_repo:
    ensure => directory;
      "${local_repo}/ios":
    ensure => directory;
      "${local_repo}/webapp":
    ensure => directory;
      "${local_repo}/vagrants":
    ensure => directory;
  }

  #====== dotfiles Settings ======#
  -> people::evalphobia::helper::create_symlink { $dotfiles['files']:
    source_dir => $dotfiles['source'],
    dest_dir   => $homedir,
  }

  #====== OSX Settings ======#
  # update
  include osx::software_update
  # Finder
  include osx::finder::unhide_library
  include osx::finder::show_hidden_files
  include osx::no_network_dsstores
  include osx::dock::position

  # Keyboard
  include osx::global::enable_keyboard_control_access
  class { 'osx::global::key_repeat_delay':
    delay => 10
  }
  class { 'osx::global::key_repeat_rate':
    rate => 2
  }
  boxen::osx_defaults { 'Disable press-and-hold character picker':
    key    => 'ApplePressAndHoldEnabled',
    domain => 'NSGlobalDomain',
    value  => 'false',
  }

  #====== Install Applications ======#
  # external configs
  include chrome
  include cyberduck
  include firefox
  include skype
  include dropbox
  include handbrake
  include vlc
  include go
  include heroku
  include android
  include sourcetree
  include iterm2::stable
  include virtualbox
  include vagrant
  include tunnelblick

  # manual install
  package {
    'BetterTouchTool':
      source   => "http://www.boastr.de/BetterTouchTool.zip",
      provider => compressed_app;
    'GoogleJapaneseInput':
      source => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
      provider => pkgdmg;
    'iTunesLame':
      source   => "http://blacktree-itunes-lame.googlecode.com/files/iTunes-LAME-2.0.9-34.zip",
      provider => compressed_app;
    'Mou':
      source   => "http://mouapp.com/download/Mou.zip",
      provider => compressed_app;
    'MySQLWorkBench':
      source => "http://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-6.0.7.1-osx-i686.dmg",
      provider => appdmg;
    'P4Merge':
      source => "http://filehost.perforce.com/perforce/r13.2/bin.macosx106x86_64/P4V.dmg",
      provider => pkgdmg;
    'SophosAntiVirus':
      source => "http://downloads.sophos.com/home-edition/savosx_80_he.10.8+.dmg",
      provider => pkgdmg;
    'XtraFinder':
      source   => "http://www.trankynam.com/xtrafinder/downloads/XtraFinder.dmg",
      provider => pkgdmg;
    'OmniDiskSweeper':
      source   => "http://downloads2.omnigroup.com/software/MacOSX/10.8/OmniDiskSweeper-1.9.dmg",
      provider => appdmg_eula;
  }

  # install with homebrew
  package {
    [
      'aircrack-ng',
      'autoconf',
      'automake',
      'htop-osx',
      'imagemagick',
      'libevent',
      'libpng',
      'libtiff',
      'libtool',
      'libxml2',
      'libxslt',
      'libyaml',
      'lv',
      'mcrypt',
      'mecab',
      'mecab-ipadic',
      #'mongodb',
      'mysql',
      'postgresql',
      'tmux',
      'wakeonlan',
      'watch',
      'wget',
    ]: ;
    'python' :
      install_options => [
        '--universal',
        '--framework',
      ];
  }

  #====== Sublime Text ======#
  include sublime_text_3
  include sublime_text_3::package_control

  sublime_text_3::create_symlinks { "Create Sublime Text 3 Symboliclinks" :
    source_dir => $subl_conf_dir ;
  }

  #install sublimte text 3 and packages
    sublime_text_3::package { 
    'Better CoffeeScript':
      source => 'aponxi/sublime-better-coffeescript';
    'BracketHighlighter':
      source => 'facelessuser/BracketHighlighter';
    'Capybara Snippets':
      source => 'asux/sublime-capybara-snippets';
    'Cucumber':
      source => 'drewda/cucumber-sublime2-bundle';
    'Djaneiro':
      source => 'squ1b3r/Djaneiro';
    'Emmet':
      source => 'sergeche/emmet-sublime';
    'GitGutter':
      source => 'jisaacks/GitGutter';
    'Local History':
      source => 'vishr/local-history';
    'Phix Color Scheme':
      source => 'stuartherbert/sublime-phix-color-scheme';
    'RSpec':
      source => 'SublimeText/RSpec';
    'Ruby on Rails snippets':
      source => 'tadast/sublime-rails-snippets';
    'SideBarEnhancements':
      source => 'titoBouzout/SideBarEnhancements',
      branch => 'st3';
    'Syntax highlighting for Sass':
      source => 'P233/Syntax-highlighting-for-Sass';
    'Theme - Soda':
      source => 'buymeasoda/soda-theme';
  }

  #====== Python ======#
  exec { "virtualenvwrapper":
      command => "${brew_path}/pip install virtualenvwrapper",
      require => Package['python'];
  }

  #====== Helper Methods ======#
  # create symlinks
  define helper::create_symlink($source_dir, $dest_dir) {
    file { "${dest_dir}/${name}":
      ensure => symlink,
      target => "${source_dir}/${name}",
    }
  }

  # install PyPI packages on virtualenvwrapper environment
  define helper::pip_with_venv($env_name, $pkg_name) {
    exec { "sh ${brew_path}/virtualenvwrapper.sh; workon ${env_name} && pip install ${pkg_name}":
      require => Exec["virtualenvwrapper"],
    }
  }

}


