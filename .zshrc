# Oh-my-zsh installation path
ZSH=/usr/share/oh-my-zsh/

# Powerlevel10k theme path
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=( git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting )
source $ZSH/oh-my-zsh.sh

# In case a command is not found, try to find the package that has it
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]]; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Detect AUR wrapper
if pacman -Qi yay &>/dev/null; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null; then
   aurhelper="paru"
fi

function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null; then
            arch+=("${pkg}")
        else
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        ${aurhelper} -S "${aur[@]}"
    fi
}

# Custom Aliases and Functions


# Helpful aliases
alias s='sudo -E zsh' # sudoedit
alias e='exit' # exit sudo mode
alias c='clear' # clear terminal
alias bt='bluetoothctl scan on' # clear terminal
alias fcc='fc-cache -fv' # reload font directory
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias yr='$aurhelper -Rns' # uninstall package
alias ysy='$aurhelper -Syu' # update system/package/aur
alias yqs='$aurhelper -Qs' # list installed package
alias yss='$aurhelper -Ss' # list available package
alias ysc='$aurhelper -Sc' # remove unused cache
alias yqq='$aurhelper -Qqd | $aurhelper -Rsu --print -' # remove unused packages, also try > '$aurhelper -Qtdq | $aurhelper -Rns -'
alias pr='sudo pacman -Rns' # To uninstall the packages
alias pfl='pacman -Fl' # To retrieve a list of the files installed by a remote package
alias psi='sudo pacman -Si' # To display extensive information about a given package
alias pss='sudo pacman -Ss' # To searching both in packages' names and descriptions
alias psyu='sudo pacman -Syu' # pacman system update
alias pqdt='pacman -Qdt' # To list all packages no longer required as dependencies (orphans)
alias pqet='pacman -Qet' # To list all packages explicitly installed and not required as dependencies
alias pql='pacman -Ql' # To retrieve a list of the files installed by a package
alias pqs='pacman -Qs' # To search for already installed packages
alias vc='code' # gui code editor

# GPU switcher [Optimus]
alias opth='prime-offload && optimus-manager --switch hybrid' #Switch to Hybrid mode
alias optn='prime-offload && optimus-manager --switch nvidia' #Switch to NVIDIA mode
alias opti='prime-offload && optimus-manager --switch integrated' #Switch to Integrated mode

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# System Fetch
catnap

# Exports
export PATH="$PATH:$(npm config get prefix)/bin"
export SUDO_EDITOR=nvim
