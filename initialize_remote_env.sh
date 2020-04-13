#!/bin/zsh

usage() {
  echo "Usage: $0 remotehost"
  echo "  Synchronize my environment to specified remote host."
  echo "  Usually, this script will be exectured on funasoul."
  echo "  (ex.) $0 bucket"
  exit 1
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

if [ $# -lt 1 ] || [ ${HOST} = $1 ]; then
  usage
  return 1
fi
remotehost=$1

if ssh $remotehost stat '$HOME/.zshrc' \> /dev/null 2\>\&1; then
  echo "You already have ~/.zshrc. I will not initialize your environemnt."
  exit 0
fi

ssh $remotehost "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# do not use default ~/.zshrc
ssh $remotehost rm '$HOME/.zshrc'
#cat >> ~/.zshrc <<_EOU_
#export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME="funa"
#ZSH_CUSTOM="$HOME/Dropbox/Sync/zsh/custom"
#_EOU_

# execute is_dropbox_running() on remote host
ssh $remotehost "$(typeset -f is_dropbox_running); is_dropbox_running"

if [ $? = 0 ]; then
  echo "Dropbox running"
else
  echo "Dropbox not running"
  ssh $remotehost mkdir -p '$HOME/Dropbox/Sync'
  rsync -auvz ~/Dropbox/Sync/.??* $remotehost:Dropbox/Sync/
  rsync -auvz ~/Dropbox/Sync/Emacs $remotehost:Dropbox/Sync/
  rsync -auvz ~/Dropbox/Sync/mutt $remotehost:Dropbox/Sync/
  rsync -auvz ~/Dropbox/Sync/nvim $remotehost:Dropbox/Sync/
  rsync -auvz ~/Dropbox/Sync/wombat.style $remotehost:Dropbox/Sync/
  rsync -auvz ~/Dropbox/Sync/zsh $remotehost:Dropbox/Sync/
  REMOTE_OSTYPE=$(ssh $remotehost echo '$OSTYPE')
  if [[ "$REMOTE_OSTYPE" == "darwin"* ]]; then
    rsync -auvz ~/Dropbox/Sync/com.googlecode.iterm2.plist $remotehost:Dropbox/Sync/
  fi
  ssh $remotehost rm '$HOME/Dropbox/Sync/{.zshrc.local,.zsh3rc,.zshrc4.dist,.zshenv4.dist}'
fi

# Create symbolic link
ssh -t $remotehost zsh -s << 'EOF'
cd
foreach i (.agignore .bash_profile .bashrc .exrc .gitconfig .gitignore_global .ideavimrc .inputrc .ispell_english .latexmkrc .muttrc .npmrc .pythonrc.py .screenrc .terminalizer .tmux .tmux.conf .vim .vimrc .vrapperrc .zlogin .zlogout .zshenv .zshrc)
  ln -s ~/Dropbox/Sync/$i .
end
ln -s ~/Dropbox/Sync/zsh/custom/zshrc-funa.zsh .zshrc.funa

mkdir -p ~/.config
cd ~/.config
ln -s ~/Dropbox/Sync/nvim .
EOF

echo "Syncenv done."
