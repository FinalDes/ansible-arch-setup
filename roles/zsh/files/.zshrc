# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#editor
alias zed="env DISPLAY=:0 WAYLAND_DISPLAY=wayland-0 XDG_RUNTIME_DIR=/run/user/1000 ZED_ALLOW_EMULATED_GPU=1 VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.x86_64.json zeditor"
export EDITOR="helix"
export VISUAL="helix"
export PAGER="bat --paging=always"

# Core History Settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Syntax Highlighting (Must be loaded BEFORE autosuggestions)
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
#  Load and initialize the completion system (Put them here)
autoload -Uz compinit
compinit

# Set up fzf key bindings and fuzzy completion
#source <(fzf --zsh)
#source /usr/share/fzf/key-bindings.zsh
if [ -f /usr/share/fzf/completion.zsh ]; then
  source /usr/share/fzf/completion.zsh
fi
#source fzf-tab
if [ -f /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]; then
  source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
fi
#source forgit
if [ -f /usr/share/zsh/plugins/forgit/forgit.plugin.zsh ]; then
  source /usr/share/zsh/plugins/forgit/forgit.plugin.zsh
fi
if [ -f /usr/share/zsh/plugins/emoji-cli/emoji-cli.zsh ]; then
  source /usr/share/zsh/plugins/emoji-cli/emoji-cli.zsh
fi
# fzf settings
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
# Set the Ctrl+T options explicitly
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --line-range :500 {}'
  --preview-window=right:60%"
# Define the command as a Zsh Array (notice the parentheses)
ff_cmd=( fzf --preview 'bat --line-range :500 {}' )

#just fzf option
export JUST_CHOOSER="fzf --preview 'just --show {} | bat --color=always --style=numbers,changes --language=make' --preview-window=right:60%"

# Quick shortcut just to run the fzf finder
alias ff="${ff_cmd[*]}"

# Quick source file
alias sf='source $("${ff_cmd[@]}")'

# File finding and editing tools
alias fvim='vim $("${ff_cmd[@]}" -m)'
alias fnvim='nvim $("${ff_cmd[@]}" -m)'
alias fcode='code -n $("${ff_cmd[@]}")'

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env)"

  # pnpm
  export PNPM_HOME="/home/alex/.local/share/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
  # pnpm end

fi
# # Add uv managed tools to PATH only if uv is installed
# if command -v uv &> /dev/null; then
#     export PATH="$HOME/.local/bin:$PATH"
# fi

# Automatically keep $PATH unique (Fixes the P10K duplicate bug)
typeset -U path