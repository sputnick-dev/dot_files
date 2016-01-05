PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000
#bindkey -v
bindkey -e
#bindkey -s '\el' 'ls\n'                             # [Esc-l] - run command: ls
#bindkey -s '\e.' '..\n'                             # [Esc-.] - run command: .. (up directory)
bindkey '^[[3~' delete-char
bindkey '^R' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '[1;5C' emacs-forward-word
bindkey '[1;5D' emacs-backward-word

# My own options (see man zshoptions)
# equivalent from bash: shopt
setopt auto_cd
setopt auto_pushd
setopt cdable_vars
#setopt cdable_vars
CDPATH=$CDPATH:$HOME
setopt pushd_ignore_dups
setopt hist_ignore_dups
setopt inc_append_history
setopt extended_history
setopt extended_glob
#setopt path_dirs
NULLCMD=:

# help
autoload -U run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-svk
unalias run-help 2>/dev/null
alias help=run-help

# Load files under .zsh/
for config_file (~$USER/.zsh/*.zsh) source $config_file

# Add ssh keys to agent if needed
ssh-add -L |grep "^ssh" >/dev/null || ssh-add

# Environment variables
PATH=$PATH:$HOME/bin
export SUDO_EDITOR=vi
export SVN_EDITOR=vi

# Automatic files handling
autoload zsh-mime-setup
zsh-mime-setup 2>/dev/null

# Quickly ssh through a bastian host without having to hard-code in ~/.ssh/config
alias pssh='ssh -o "ProxyCommand ssh $PSSH_HOST nc -w1 %h %p"'

# Auto-rehash to avoid problems after package installs
# http://www.zsh.org/mla/users/2011/msg00531.html
zstyle ':completion:*' rehash true

zstyle -e ':completion:*:(ssh|scp|sshfs|ping|telnet|nc|rsync):*' hosts '
  reply=( ${=${${(M)${(f)"$(</etc/ssh/config)"}:#Host*}#Host }:#*\**} )'

# Easy colors in ZSH scripting
autoload -U colors && colors

# precmd() for rvm prompt + no hist dirs
function precmd() {
  if ! test -z "$SIMPLE_PROMPT"; then
    PROMPT="$SIMPLE_PROMPT"
  else
    dir=$(pwd|perl -pe 's#^/(Users|home)/gilles#~#,s#^~/(botify|dev/botify|Projects/botify)#[B]#')
    if which ec2metadata >/dev/null; then
      #AWS machines
      env=$(ec2metadata --security-groups|head -n 1|cut -d. -f4|sed 's#%2F#/#')
      [ "$env" == "prod" ] && env="%{$fg[red]%}prod"
      [ "$env" == "staging" ] && env="%{$fg[cyan]%}staging"
      userhost="$env%{$reset_color%}|%n@%m"
    elif test -e /usr/local/rtm/bin/rtm; then
      #OVH machines
      env="%{$fg[blue]%}ovh"
      userhost="$env%{$reset_color%}|%n@%m"
    elif ! test -z "$SSH_CONNECTION"; then
      #other ssh-accessed machines
      userhost="%n@%m"
    else
      userhost="%n@local"
    fi
    if [ "$VIRTUAL_ENV" != "" ]; then
      virtualenv="($(basename $VIRTUAL_ENV))"
    else
      virtualenv=""
    fi
    if test -e $(pwd)/.ruby-version; then
      rvm_env="{$(current_rvm_env)}"
    else
      rvm_env=""
    fi
    PROMPT="$rvm_env$virtualenv$userhost:$dir%# "
  fi
}
# switch between simple and normal prompt
function sp() {
  if [ "$SIMPLE_PROMPT" ]; then
    unset SIMPLE_PROMPT
  else
    export SIMPLE_PROMPT="%# "
  fi
}

setopt prompt_subst
autoload -Uz vcs_info

function +vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
  [[ $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]] ; then
  hook_com[unstaged]+='%F{red}??%f'
fi
}

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        (( $ahead )) && gitstatus+=( "${c3}+${ahead}${c2}" )

        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        (( $behind )) && gitstatus+=( "${c4}-${behind}${c2}" )

        hook_com[branch]="${hook_com[branch]}${(j:/:)gitstatus}"
    fi
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+="%f (%F{1}STASH=${stashes}%f)"
    fi
}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true

#zstyle ':vcs_info:*' stagedstr '%F{3}A%f' 
zstyle ':vcs_info:*' stagedstr '%F{3}A%f' 
zstyle ':vcs_info:*' unstagedstr 'M' 
zstyle ':vcs_info:*' actionformats '%f(%F{2}%b%F{3}|%F{1}%a%f)  '
# format the git part
zstyle ':vcs_info:*' formats '%f(%b) %F{2}%c%F{3}%u%m%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stash git-st
zstyle ':vcs_info:*' enable git 
#zstyle ':vcs_info:*+*:*' debug true

# same as PROMPT_COMMAND in bash
precmd () { vcs_info }
# improve by putting branch name is red if branch is not clean
# conditional on exit code: %(?..%F) on affiche le code de retour uniquement si il est > 0
RPROMPT='%(?..[%F{red}ERROR%F{white}:%F{red}%?%f])'
PROMPT='%F{green}%n%F{orange}@%F{yellow}%m:%F{7}%3~%f ${vcs_info_msg_0_} %f%# '
