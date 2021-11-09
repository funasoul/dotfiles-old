#!/bin/zsh
setopt extendedglob

REMOTE_SYNC_DIR='Dropbox/Sync'

usage() {
  echo "Usage: $0 remotehost"
  echo "  Synchronize my environment to specified remote host."
  echo "  Usually, this script will be exectured on funasoul."
  echo "  (ex.) $0 bucket"
  exit 1
}

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 &>/dev/null )
}

can_ssh_via_publickey() {
  # Return 0 if ssh login via publickey.
  # https://unix.stackexchange.com/a/472829
  ssh -q -o BatchMode=yes -o PreferredAuthentications=publickey k40 /bin/true
  return $?
}

is_dropbox_running() {
  # Return 0 if dropbox is running.
  # Thanks to Official Dropbox Command Line Interface.
  # https://www.dropboxwiki.com/tips-and-tricks/using-the-official-dropbox-command-line-interface-cli
  if [[ -r ~/.dropbox/dropbox.pid ]]; then
    pid=$(cat ~/.dropbox/dropbox.pid)
  else
    return 1
  fi
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    if [[ -f /proc/${pid}/cmdline ]]; then
      grep -qi dropbox /proc/${pid}/cmdline
      return $?
    else
      return 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    ps -p $pid -o command | grep -qi dropbox.app
    return $?
  else
    # Unknown.
    return 1
  fi
}

rsync_env_files() {
  if [ $# -lt 1 ]; then
    echo "Please specify remote host."
    return 1
  fi
  local synclist=(Emacs mutt nvim ranger wombat.style zsh)
  local synclist_macos=(com.googlecode.iterm2.plist)
  local synclist_ignore=(.zshrc.local .zsh3rc .zshrc4.dist .zshenv4.dist)
  remotehost=$1
  echo "Rsync files to $remotehost..."
  ssh -x $remotehost mkdir -p '$HOME/'$REMOTE_SYNC_DIR
  # rsynd dot files except .DS_Store
  rsync -auz ~/Dropbox/Sync/.(??*~DS_Store) $remotehost:$REMOTE_SYNC_DIR
  foreach i ($synclist)
    rsync -auz ~/Dropbox/Sync/${i} $remotehost:$REMOTE_SYNC_DIR
  end
  # macOS specific files
  if [[ $(ssh -x $remotehost echo '$OSTYPE') == "darwin"* ]]; then
    foreach i ($synclist_macos)
      rsync -auz ~/Dropbox/Sync/${i} $remotehost:$REMOTE_SYNC_DIR
    end
  fi
  echo "Removing unnecessary files."
  ssh -x $remotehost 'cd $HOME/'$REMOTE_SYNC_DIR' ;' rm ${synclist_ignore[@]}
}

create_env_links() {
  if [ $# -lt 1 ]; then
    echo "Please specify remote host."
    return 1
  fi
  local linklist_home=(.agignore .bash_profile .bashrc .exrc .gitconfig .gitignore_global
                      .ideavimrc .inputrc .ispell_english .latexmkrc .muttrc .npmrc .pythonrc.py
                      .screenrc .source-highlight .terminalizer .tmux .tmux.conf .vim .vimrc .vrapperrc
                      .zlogin .zlogout .zshenv .zshrc)
  local linklist_config=(nvim ranger)
  remotehost=$1
  echo "Creating symbolic links on $remotehost..."
  # Passing an array to remote hosts via ssh
  # https://unix.stackexchange.com/a/342575
  linklist_home_def=$(typeset -p linklist_home)
  linklist_config_def=$(typeset -p linklist_config)
  ssh -x -t $remotehost zsh -s <<EOF
$linklist_home_def
$linklist_config_def
cd
foreach i ("\${linklist_home[@]}")
  if [ -L "\$i" ]; then
    rm "\$i"
  fi
  if [ -f "\$i" ]; then
    mv -f "\$i" "\$i".dist
  fi
  ln -s ~/$REMOTE_SYNC_DIR/"\$i" .
end
if [ -L .zshrc.funa ]; then
  rm .zshrc.funa
fi
ln -s ~/$REMOTE_SYNC_DIR/zsh/custom/zshrc-funa.zsh .zshrc.funa

mkdir -p ~/.config
cd ~/.config
foreach i ("\${linklist_config[@]}")
  if [ -L "\$i" ]; then
    rm "\$i"
  fi
  if [ -f "\$i" ]; then
    mv -f "\$i" "\$i".dist
  fi
  ln -s ~/$REMOTE_SYNC_DIR/"\$i" .
end
EOF
}

if [ $# -lt 1 ] || [ ${HOST} = $1 ]; then
  usage
  return 1
fi
remotehost=$1

if ! can_ssh_via_publickey ; then
  # Copy ssh public key to remotehost.
  if _has ssh-copy-id; then
    ssh-copy-id $remotehost
  else
    echo "This script will run ssh many times."
    echo "It is recommended that you register your public key on the remote host before running this script."
    echo "(ex.) % ssh-copy-id $remotehost"
    echo "      % $0 $remotehost"
    exit 1
  fi
fi

# check ~/.zshrc on remote host.
if ssh -x $remotehost stat '$HOME/.zshrc' \> /dev/null 2\>\&1; then
  echo "You already have ~/.zshrc. I will not initialize your environemnt."
  exit 1
fi

# install oh-my-zsh
ssh -x $remotehost "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# do not use default ~/.zshrc
ssh -x $remotehost rm '$HOME/.zshrc'

# execute is_dropbox_running() on remote host
ssh -x $remotehost "$(typeset -f is_dropbox_running); is_dropbox_running"

if [ $? = 0 ]; then
  echo "Dropbox running"
else
  echo "Dropbox not running"
  rsync_env_files $remotehost
fi

# Create symbolic link
create_env_links $remotehost

echo "Initialize remote env on $remotehost done."
