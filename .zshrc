# ZSH OPTIONS
setopt append_history       # each session will append to ~/.zsh_history instead of replacing it
setopt extended_glob        # enable inverse globs and other glob tricks, e.g ls [^foo]bar
setopt hist_find_no_dups    # don't display dups if you find them in .zsh_history during a ctrl+r search
setopt hist_ignore_all_dups # remove older command if it's a dup of the most recent command
setopt hist_ignore_space    # don't record commands in history if they start with a space
setopt hist_reduce_blanks   # trim unnecessary whitespace
setopt hist_save_no_dups    # remove dups on save
setopt inc_append_history   # add commands to history as they are entered, not at shell exit
setopt no_case_glob         # case insensitive globbing
setopt share_history        # all zsh sessions share ~/.zsh_history. makes ctrl+r searches better

# KEY BINDINGS
bindkey -v # use vim commands in the line editor

# ENV VARS
export EDITOR='code'
export FZF_ALT_C_COMMAND=" fd --type d --hidden . $HOME /usr /etc"
export FZF_CTRL_T_COMMAND="fd --type f --hidden . $HOME /usr /etc"
export HISTSIZE='50000'
export RUSTFLAGS='--codegen target-cpu=native'
export SAVEHIST="$HISTSIZE"

# ALIASES
alias cat='bat'
alias ls='exa --color=auto --group-directories-first'

# SOURCES
source "/usr/share/fzf/completion.zsh"
source "/usr/share/fzf/key-bindings.zsh"

# FUNCTIONS
zle-keymap-select() {
	if [[ ${KEYMAP} == "vicmd" ]]; then
		echo -ne "\e[3 q"                # set cursor to blinking _
	elif [[ ${KEYMAP} == "main" ]]; then # main keymap is viins (INSERT mode)
		echo -ne "\e[5 q"                # set cursor to blinking |
	fi
}

zle-line-init() {
	echo -ne '\e[5 q'
}

zle -N zle-keymap-select
zle -N zle-line-init

# ENABLE COMPLETIONS
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
	compinit
	compdump
else
	compinit -C # avoid recompiling .zcompdump
fi
