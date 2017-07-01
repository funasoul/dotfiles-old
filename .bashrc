# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

### User specific aliases and functions
alias ls='ls --color=auto -FC'
alias ll='ls -lg'
alias la='ls -A'
alias lt='ls -t'
alias llt='ll -t'
alias j='jobs'
alias soz="source $HOME/.bashrc"
alias work="cd $(echo $HOME | sed -e 's/home/lustre/')"

### environment variables
export  LS_COLORS='di=01;36:*.tar=00;31:*.tgz=00;31:*.gz=00;31:*.bz2=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.rar=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.jpg=00;35:*.JPG=00;35:*.jpeg=00;35:*.gif=00;35:*.bmp=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:*.tiff=00;35:*.mp3=01;37:*.mpg=01;37:*.mpeg=01;37:*.mov=01;37:*.avi=01;37:*.asf=01;37:*.wma=01;37:*.wmv=01;37:*.gl=01;37:*.dl=01;37:*.rm=01;37:*.ram=01;37:*.pdf=00;33:*.ps=00;33:*.eps=00;33:*.xml=00;32:*.html=00;32:*.shtml=00;32:*.htm=00;32:*.css=00;32:*.doc=00;32:*.xls=00;32:*.ppt=00;32:*.pot=00;32'

### colors
red="\[$(tput setaf 1)\]"
green="\[$(tput setaf 2)\]"
yellow="\[$(tput setaf 3)\]"
blue="\[$(tput setaf 4)\]"
purple="\[$(tput setaf 5)\]"
cyan="\[$(tput setaf 6)\]"
white="\[$(tput setaf 7)\]"
reset="\[$(tput sgr0)\]"

### prompt
function prompt() {
  # Most part of this implementation is taken from: https://superuser.com/questions/187455/right-align-part-of-prompt/1203400#1203400
  PS1="${reset}\u[${cyan}\h${reset}] "
  # Create a string like:  "[ ~/Downloads ]" with $PWD in GREEN
  mydir=$(echo $PWD | sed -e "s,^$HOME,~,")
  printf -v PS1RHS "\e[0m[ \e[0;1;32m$mydir \e[0m]"

  # Strip ANSI commands before counting length
  # From: https://www.commandlinefu.com/commands/view/12043/remove-color-special-escape-ansi-codes-from-text-with-sed
  PS1RHS_stripped=$(sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"$PS1RHS")

  # Reference: https://en.wikipedia.org/wiki/ANSI_escape_code
  local Save='\e[s' # Save cursor position
  local Rest='\e[u' # Restore cursor to save point

  # Save cursor position, jump to right hand edge, then go left N columns where
  # N is the length of the printable RHS string. Print the RHS string, then
  # return to the saved position and print the LHS prompt.

  # Note: "\[" and "\]" are used so that bash can calculate the number of
  # printed characters so that the prompt doesn't do strange things when
  # editing the entered text.

  PS1="\[${Save}\e[${COLUMNS}C\e[${#PS1RHS_stripped}D${PS1RHS}${Rest}\]${PS1}"
}

PROMPT_COMMAND=prompt
