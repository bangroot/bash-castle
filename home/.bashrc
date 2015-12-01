#!/bin/bash
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

#export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"



#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/e026391/.sdkman"
[[ -s "/Users/e026391/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/e026391/.sdkman/bin/sdkman-init.sh"

