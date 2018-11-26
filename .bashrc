# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

### User specific aliases and functions
## aliases
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias ls='ls --color=auto -FC'
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls='ls -FCG'
else
  alias ls='ls -FC'
fi
alias ll='ls -lg'
alias la='ls -A'
alias lt='ls -t'
alias llt='ll -t'
alias j='jobs'
alias soz="source $HOME/.bashrc"
alias work="cd $(echo $HOME | sed -e 's/home/lustre/')"
alias d="cd $HOME/Downloads"
alias can="la $HOME/.Trash"
alias poipoi="rm -rf $HOME/.Trash/{*,.??*}"

## functions
function poi () {
  if (( $# == 0 ))
  then
    echo "Usage: $0 file [file ...]"
  fi
  for i
  do
    if [[ -a $i ]]
    then
      ls -FCGv -1d $i
      command mv $i $HOME/.Trash/
    fi
  done
}

### environment variables
export  LS_COLORS='di=01;36:*.tar=00;31:*.tgz=00;31:*.gz=00;31:*.bz2=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.rar=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.jpg=00;35:*.JPG=00;35:*.jpeg=00;35:*.gif=00;35:*.bmp=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:*.tiff=00;35:*.mp3=01;37:*.mpg=01;37:*.mpeg=01;37:*.mov=01;37:*.avi=01;37:*.asf=01;37:*.wma=01;37:*.wmv=01;37:*.gl=01;37:*.dl=01;37:*.rm=01;37:*.ram=01;37:*.pdf=00;33:*.ps=00;33:*.eps=00;33:*.xml=00;32:*.html=00;32:*.shtml=00;32:*.htm=00;32:*.css=00;32:*.doc=00;32:*.xls=00;32:*.ppt=00;32:*.pot=00;32'
export PYTHONSTARTUP=$HOME/.pythonrc.py
