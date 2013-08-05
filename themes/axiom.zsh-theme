# ┌- 1734 ben@taquter (r) ~/documents/code/colorscripts (master !) <venv> 
# └> |    |   |        |  |                              |      |   |
#    |    |   |        |  |                              |      |   +----- virtual environment
#    |    |   |	       |  |	      		         |      +--------- git untracked changes
#    |	  |   |        |  |			         +---------------- git branch
#    |    |   |        |  +----------------------------------------------- current directory
#    |    |   |        +-------------------------------------------------- remote indicator
#    |    |   +----------------------------------------------------------- hostname
#    |     +--------------------------------------------------------------- user
#    +-------------------------------------------------------------------- time


local first_line_prefix='┌- '
local second_line_prefix='└>>>>>> '
local env_prefix='<'
local env_suffix='>'
local vcs_prefix='('
local vcs_suffix=')'
local remote_indicator='(r)'

autoload -U colors zsh/terminfo
colors
setopt prompt_subst

# Standard 16 terminal color definitions
for color in red green yellow blue magenta cyan white; do
    eval $color='%{$fg[${color}]%}'; done

local reset=$FX[reset]
local bold=$FX[bold]
local italic=$FX[italic]
local uline=$FX[underline]

# Check the UID to determine the user level
if [[ $UID -ge 100 ]]; then
    eval user='%n'
elif [[ $UID -eq 0 ]]; then
    eval user='%n'
else
    eval user='%n'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
    eval host='$red%m'
    host=$host(r)
else
    eval host='$red%m'
fi

local user_host='$blue$user$magenta@$reset$host$reset'
local git_branch='$yellow$(git_prompt_info)$reset'
local time='$(date +"%H%M")'
local current_dir='$green${PWD/#$HOME/~}$reset'

add-zsh-hook precmd build_prompt
build_prompt () {
    [ $VIRTUAL_ENV ] && {
	venv_name=$(basename "$VIRTUAL_ENV")
	local venv_status='$env_prefix$venv_name$env_suffix'
    }
    
    PROMPT="$cyan${first_line_prefix}$blue${time} ${user_host} ${current_dir} ${git_branch} ${venv_status}
$cyan${second_line_prefix}$reset"
}

