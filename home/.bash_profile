#! /bin/bash
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
	platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
	platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
	platform='darwin'
elif [[ "$unamestr" =~ 'CYGWIN' ]]; then
	platform='cygwin'
fi

export EVENT_NOKQUEUE=1

function setjdk() {
if [[ $platform == "darwin" ]]; then
	if [ $# -ne 0 ]; then
		removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
		if [ -n "${JAVA_HOME+x}" ]; then
			removeFromPath "$JAVA_HOME/bin"
		fi
		export JAVA_HOME=`/usr/libexec/java_home -v $@`
		export PATH=$JAVA_HOME/bin:$PATH
	fi
elif [[ $platform == "cygwin" ]]; then
	if [ $# -ne 0 ]; then
		removeFromPath '/cygdrive/c/ProgramData/Oracle/Java/javapath'
		if [ -n "${JAVA_HOME+x}" ]; then
			removeFromPath "$JAVA_HOME/bin"
		fi
		export JAVA_HOME="/cygdrive/c/Program Files/Java/$(ls /cygdrive/c/Program\ Files/Java | grep jdk$@ | sort -rV | head -1)"
		export PATH=$JAVA_HOME/bin:$PATH
	fi
fi
}

function removeFromPath() {
	export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
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
if [ -f ~/.bash_aliases ]; then
	source ~/.bash_aliases
fi
#set -o vi

setjdk 1.8
PATH="~/bin:~/.vim/tools:/usr/local/bin:$PATH"
export PATH
alias chrome="open -a \"Google Chrome\""
alias cl="fc -e -|pbcopy"
alias ls="ls -G"
alias la="ls -aF"
alias ld="ls -ld"
alias ll="ls -l"
alias lt='ls -At1 && echo "------Oldest--"'
alias ltr='ls -Art1 && echo "------Newest--"'
#https://gist.github.com/dougalcorn/7815725
alias open_ports="for port in `netstat -p tcp -na|grep '*.\d' | awk '{print $4}' | cut -f2 -d. `; do sudo lsof -P -i tcp | grep -i tcp | grep \":\$port \"; done" 
# mute the system volume
alias stfu="osascript -e 'set volume output muted true'"

function parse_git_dirty {
[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
source /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
if [[ $platform == "darwin" ]]; then
	if [ -f $(brew --prefix)/etc/bash_completion ]; then
		. $(brew --prefix)/etc/bash_completion
	fi
fi

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

export PATH=/usr/local/sbin:$PATH

complete -C aws_completer aws

# add this configuration to ~/.bashrc
export HH_CONFIG=hicolor         # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh \C-j"'; fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/$USER/.sdkman"
[[ -s "/Users/$USER/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/$USER/.sdkman/bin/sdkman-init.sh"

