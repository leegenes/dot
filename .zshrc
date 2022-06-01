# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export CHECK_DEV_DIR="~/src/gitlab/check/"

# Aliases
alias zload="source ~/.zshrc"
alias ps="pipenv shell"
alias pr="pipenv run"
alias prm="pr python manage.py"
alias gcml="gcm && gl"
alias gcam.="ga . && gcam"
alias check-api="cd ${CHECK_DEV_DIR}/check-api/ && code . && pips"
alias console="cd ${CHECK_DEV_DIR}/console/ && code . && pips"
alias interstate="cd ${CHECK_DEV_DIR}/interstate/ && code . && pips"
alias onboard="cd ${CHECK_DEV_DIR}/onboard/ && code . && pips"
alias tmapi="source ~/.scripts/tmux/check-api.sh"
alias tmint="source ~/.scripts/tmux/interstate.sh"
alias tmonb="source ~/.scripts/tmux/onboard.sh"
alias tmcon="source ~/.scripts/tmux/console.sh"
alias v="vim"

alias sp="spt playback -t >/dev/null"
alias sn="spt playback -n >/dev/null"
alias sb="spt playback -p >/dev/null"
alias sbb="spt playback -pp >/dev/null"
alias slt="spt playback --share-track | pbcopy"
alias sla="spt playback --share-album | pbcopy"

alias wtf="wtfutil"

alias clr="clear"

export PATH="/usr/local/bin:$PATH"
# export PATH="/usr/local/opt/python@3.8/bin:$PATH"

# Created by `pipx` on 2021-07-26 16:48:01
export PATH="$PATH:/Users/lee/.local/bin:/usr/local/bin"

# # Keybindings for substring search plugin. Maps up and down arrows.
# bindkey -M main '^[OA' history-substring-search-up
# bindkey -M main '^[OB' history-substring-search-down
# bindkey -M main '^[[A' history-substring-search-up
# bindkey -M main '^[[B' history-substring-search-up

# # Keybindings for autosuggestions plugin
# bindkey '^ ' autosuggest-accept
# bindkey '^f' autosuggest-accept

# Gray color for autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

# # # fzf settings. Uses sharkdp/fd for a faster alternative to `find`.
# FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git --exclude .cache'
# FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

# Load plugins
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "woefe/wbase.zsh"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "jeffreytse/zsh-vi-mode"
zplug "rupa/z", use:"z.sh"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "ohmyzsh/ohmyzsh", use:"plugins/git/git.plugin.zsh"
zplug load

# Actually install plugins, prompt user input
if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Make it possible to press and hold hjkl in vscode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
