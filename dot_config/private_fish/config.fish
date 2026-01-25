fish_add_path $HOME/bin $HOME/.local/bin /user/local/bin

set -gx EDITOR nvim

set -gx TAVILY_API_KEY "{{ (keepassxc "Mcp/tavily").Password }}"
set -gx CONTEXT_7_API_KEY "{{ (keepassxc "Mcp/context7").Password }}"

alias cd = z
alias ls = 'eza --icons --all --no-user'
alias cat = bat
alias man = tldr
alias grep = rg

zoxide init fish | source
oh-my-posh init fish | source
fzf --fish | source
mise activate fish | source

gh completion -s fish | source
chezmoi completion fish | source
opencode completion fish | source

if status is-interactive
    fastfetch -c examples/8.jsonc
end
