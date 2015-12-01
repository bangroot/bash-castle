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

function setjdk() {
if [[ $platform == "darwin" ]]; then
	if [ $# -ne 0 ]; then
		removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
		if [ -n "${JAVA_HOME+x}" ]; then
			removeFromPath $JAVA_HOME
		fi
		export JAVA_HOME=`/usr/libexec/java_home -v $@`
		export PATH=$JAVA_HOME/bin:$PATH
	fi
fi
}

function removeFromPath() {
export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

function dockerInit() {
docker-machine start default
eval "$(docker-machine env default)"
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
set -o vi

setjdk 1.8
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
#https://gist.github.com/dougalcorn/7815725
alias open_ports="for port in `netstat -p tcp -na|grep '*.\d' | awk '{print $4}' | cut -f2 -d. `; do sudo lsof -P -i tcp | grep -i tcp | grep \":\$port \"; done" 
# mute the system volume
alias stfu="osascript -e 'set volume output muted true'"
export DOCKER_HOST=tcp://192.168.59.103:2375
export KUBERNETES_PROVIDER=vagrant

function parse_git_dirty {
[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
powerline-daemon -q
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

export PATH=/usr/local/sbin:$PATH:~/bin

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/e026391/.sdkman"
[[ -s "/Users/e026391/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/e026391/.sdkman/bin/sdkman-init.sh"

