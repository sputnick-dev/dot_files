
shopt -s cdable_vars							# cd bash = cd $bash
#shopt -s nullglob # ne pas activer : la completion ne marche plus !
shopt -s extglob
shopt -s dotglob								# <StaticShock> cp * omits hidden files, how can i fix that ?
shopt -s globstar 								# recursif **
shopt -s histappend
shopt -s autocd									# "/etc" fait un cd "/etc"

export HISTIGNORE="ls:[bf]g"				 	# ne pas ecrire ces commandes

####### ajout manuel pour un historique perpetuel http://www.debian-administration.org/articles/543
export HISTCONTROL=ignoredups
export export HISTTIMEFORMAT='%F %T ' # 2  2008-08-05 19:02:39 command

unset HISTFILESIZE
HISTSIZE=10000
# PROMPT_COMMAND="history -a" 									# ( voir /etc/prompt )
export HISTSIZE
###shopt -s checkwinsize 										# check the window size after each command and, if necessary,

[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"					# make less more friendly for non-text input files, see lesspipe(1)


# enable color support of ls and also add handy aliases
eval "`dircolors -b`"

alias ls='LC_COLLATE=C ls --color=auto -F'
alias dir='LC_COLLATE=C ls --color=auto --format=vertical'
alias vdir='LC_COLLATE=C ls --color=auto --format=long'
alias lr='LC_COLLATE=C ls -t | sed q'

alias grep='grep --color=auto'
alias la='LC_COLLATE=C ls -A'
alias ll='LC_COLLATE=C ls -l'
alias less='less -C' # "foo | less" keeps colors
alias vf=cd
alias vi=vim
alias ci=vim
alias bi=vim

ltr()
{
  /bin/ls -ltrh --color=auto -F -- "$@"
}

ltra()
{
  /bin/ls -ltrah -- "$@"
}

# man color CF http://wiki.archlinux.org/index.php/Post_Installation_Tips#Getting_a_colored_manpage
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


# Completes : voir PDF "advanced bash scripting"
complete -A shopt 		shopt
complete -A job -P '%'	fg jobs disown

PS2=''

export PAGER="/usr/bin/less -IJKMRW --shift 5"

PURPLE=$(tput setaf 5)
RED=$(tput setaf 1)
BLINKING_RED=$(tput blink; tput bold; tput setaf 1)
WHITE=$(tput setaf 7)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 4)
LIGHT_CYAN=$(tput setaf 6)
STOP=$(tput sgr0)

if which ec2metadata >/dev/null; then
  #AWS machines
  env=$(ec2metadata --security-groups|head -n 1|cut -d. -f4|sed 's#%2F#/#')
  if [[ $env == production ]]; then
    env="\[$RED\]prod\[$STOP\]"
  elif [[ $env == staging ]]; then
    env="\[$LIGHT_CYAN\]staging\[$STOP\]"
  fi
elif test -e /usr/local/rtm/bin/rtm; then
  #OVH machines
  env="\[$YELLOW\]ovh\[$STOP\]"
else
  # others
  env="undefined"
fi

if ((UID==0)); then
  _myuser="\[$RED\]ROOT\[$STOP\]"
  _mysigil='#'
else
  _myuser="\[$GREEN\]\u\[$STOP\]"
  _mysigil='$'
fi

userhost="$env|$_myuser@\h"

if [[ $VIRTUAL_ENV ]]; then
  virtualenv="($(basename $VIRTUAL_ENV))"
else
  virtualenv=""
fi

if test -e $(pwd)/.ruby-version; then
  rvm_env="{$(current_rvm_env)}"
else
  rvm_env=""
fi

  test -e /usr/share/git/completion/git-prompt.sh && . /usr/share/git/completion/git-prompt.sh
  test -e /usr/lib/git-core/git-sh-prompt && . /usr/lib/git-core/git-sh-prompt
  test -e ~/.git-prompt.sh && . ~/.git-prompt.sh

  git_branch_color(){
    if git rev-parse --git-dir >/dev/null 2>&1
    then
      color=""
      if git diff --quiet 2>/dev/null >&2
      then
        color="$GREEN"
      else
        color="$YELLOW"
      fi
    else
      return 0
    fi
    echo -ne $color
  }

  parse_git_branch(){
    if git rev-parse --git-dir >/dev/null 2>&1
    then
      gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    else
      return 0
    fi
    echo -e $gitver
  }

  PROMPT_COMMAND=$(
  cat<<'EOF'

_temp_var=$val_ret _pipe_status="${PIPESTATUS[@]}"

if((val_ret==0)); then
  _temp_var=$(( $(tr -s " " "+" <<< "$_pipe_status") ))
else
  _temp_var=$val_ret
fi

(($_temp_var > 0)) && _myerr="|\[$RED\]ERROR:$(( $(tr -s " " "+" <<< "$_pipe_status") ))\[$STOP\]|" || _myerr=

_git_prompt="\[$(git_branch_color)\]$(__git_ps1 ' (%s)')$stash\[$STOP\]" &>/dev/null

export PS1="$rvm_env$virtualenv$userhost:\w$_myerr$_git_prompt $_mysigil "
EOF
  )
fi

export VISUAL=vim
export EDITOR=vim

