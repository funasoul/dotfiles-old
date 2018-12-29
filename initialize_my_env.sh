#!/bin/zsh

usage() {
  echo "Usage: $0 hostname"
  echo "  Synchronize environment with specified host."
  echo "  (ex.) $0 funasoul"
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

if [[ -f ~/.zshrc ]]; then
  echo "You already have ~/.zshrc. I will not initialize your environemnt."
  exit 0
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cat > ~/.zshrc <<_EOU_
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="funa"
ZSH_CUSTOM=$HOME/Dropbox/Sync/zsh/custom
plugins=(docker docker-compose git github gitignore macports mosh osx screen sublime themes)
source $ZSH/oh-my-zsh.sh
_EOU_

is_dropbox_running

if [ $? = 0 ]; then
  echo "Dropbox running"
else
  echo "Dropbox not running"
  mkdir -p ~/Dropbox/Sync
  cd ~/Dropbox/Sync/
  rsync -auvz ${remotehost}':Dropbox/Sync/.??*' .
  rsync -auvz ${remotehost}:Dropbox/Sync/bin .
  rsync -auvz ${remotehost}:Dropbox/Sync/Emacs .
  rsync -auvz ${remotehost}:Dropbox/Sync/wombat.style .
  rsync -auvz ${remotehost}:Dropbox/Sync/zsh .
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo rsync -auvz ${remotehost}:Dropbox/Sync/com.googlecode.iterm2.plist .
  fi
fi

# Create symbolic link
cd
foreach i (.agignore .bash_profile .bashrc .exrc .gitconfig .gitignore_global .ideavimrc .inputrc .ispell_english .latexmkrc .pythonrc.py .screenrc .vim .vimrc .vrapperrc .zshrc .zshenv .zlogin .zlogout)
  ln -s ~/Dropbox/Sync/$i .
end
ln -s ~/Dropbox/Sync/zsh/custom/zshrc-funa.zsh .zshrc.funa

echo "Syncenv done."
