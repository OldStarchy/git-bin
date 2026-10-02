source /usr/share/bash-completion/completions/git

export PATH="$(dirname -- "${BASH_SOURCE[0]}")/bin:$PATH"

source "$(dirname -- "${BASH_SOURCE[0]}")/git-prompt.sh"
export PROMPT_COMMAND='__posh_git_ps1 "\[\033[01;32m\]${USER}@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] " "\\\$ ";'$PROMPT_COMMAND

# Replace -f with --force-with-lease (but still allow --force)
git() {
	if [ "$1" = "push" ]; then
		new_args=()
		for arg in "$@"; do
			if [ "$arg" = "-f" ]; then
				echo "Replacing $arg with --force-with-lease"
				new_args+=("--force-with-lease")
			else
				new_args+=("$arg")
			fi
		done
		set -- "${new_args[@]}"
	fi

	command git "$@"
}

alias gfpr='git fetch --prune --recurse-submodules'
alias gsur='git submodule update --recursive'
gcsu() {
	command git checkout "$@"
	gsur
}

# Tell git to autocomplete `gcsu |` as though it was `git checkout |`
__git_complete gcsu _git_checkout
