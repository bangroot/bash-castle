#!/bin/bash
function setjdk() {
  if [ $# -ne 0 ]; then
   removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
   if [ -n "${JAVA_HOME+x}" ]; then
    removeFromPath $JAVA_HOME
   fi
   export JAVA_HOME=`/usr/libexec/java_home -v $@`
   export PATH=$JAVA_HOME/bin:$PATH
  fi
}
function removeFromPath() {
  export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

function dockerInit() {
  boot2docker start
  sudo sh -c 'echo "nameserver 172.17.42.1" >> /etc/resolv.conf' 
  sudo route add -net 172.17.42 192.168.59.103
}

function startMongo() {
  docker start dnsdock
  sleep 2
  docker start rs1_srv1 rs1_srv2 rs1_srv3 rs2_srv1 rs2_srv2 rs2_srv3 cfg1 cfg2 cfg3
  sleep 5
  docker start router1
}

function startEclim23() {
  /Applications/eclipse/eclimd -b -f ~/.eclim/eclim-groovy-2.3.rc
}

function startEclim21() {
  /Applications/eclipse/eclimd -b -f ~/.eclim/eclim-groovy-2.1.rc
}

if [ -f ~/.bash.local ]; then
	source ~/.bash.local
fi

setjdk 1.7
PATH="/usr/local/bin:$PATH"
export PATH
alias chrome="open -a \"Google Chrome\""
alias cl="fc -e -|pbcopy"
alias ls="ls -G"
alias la="ls -aF"
alias ld="ls -ld"
alias ll="ls -l"
alias lt='ls -At1 && echo "------Oldest--"'
alias ltr='ls -Art1 && echo "------Newest--"'
# mute the system volume
alias stfu="osascript -e 'set volume output muted true'"
export DOCKER_HOST=tcp://192.168.59.103:2375


function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 4)\]\u@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 4)\]\$(parse_git_branch) \\$ \[$(tput sgr0)\]"
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/e026391/.gvm/bin/gvm-init.sh" ]] && source "/Users/e026391/.gvm/bin/gvm-init.sh"
export PATH=/usr/local/sbin:$PATH:~/bin
