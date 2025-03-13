#!/usr/bin/env bash

# in scripts/asdf_plugins.sh
# install necessary plugins

_main() {

  for arg in "$@"; do
    case "$arg" in
    --alias | -a)
      alias_flag=true
      ;;
    --brew | -b)
      brew_flag=true
      ;;
    --init | -i)
      initial_flag=true
      ;;
    --optional | -o)
      optional_flag=true
      ;;
    --all)
      print -P "%B%F{green} No options set. Setting all flags true.%f%b"
      alias_flag=true
      brew_flag=true
      initial_flag=true
      optional_flag=true
      ;;
    *)
      echo "You probably want to run this with --all if you don't have Homebrew installed. Otherwise, -a -i -o flags."

      ;;
    esac
  done

  plugins=(
    "elixir"
    "erlang"
    "postgres"
    "nodejs"
  )

  ALIASES=(
    'PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"'
    '. /opt/homebrew/opt/asdf/libexec/asdf.sh'
    'alias dc="docker compose"'
    'alias gc="git add . && git commit -m"'
    'alias sourceme="source $HOME/.bashrc"'
    'alias changeme="code $HOME/.bashrc"'
    'autoload -U +X bashcompinit && bashcompinit'
  )

  if [[ $alias_flag == true ]]; then
    for ALIAS in "${ALIASES[@]}"; do
      # -F: matches a fixed string
      # -x: requires full line match
      # -q: quiet (no output)
      if ! grep -Fxq "$ALIAS" "$HOME/.bashrc"; then
        echo "Adding: $ALIAS"
        echo "$ALIAS" >>"$HOME/.bashrc"
      else
        echo "Already exists: $ALIAS"
      fi
    done

    source "$HOME/.bashrc"
  fi

  if [[ $brew_flag == true ]]; then
    echo "Installing homebrew"

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  fi

  if [[ $initial_flag == true ]]; then
    echo "Installing brew packages"

    brew install \
      gnupg \
      gnu-sed \
      kind \
      asdf 

    brew install \
      --cask visual-studio-code \
      --cask docker \
      --cask gitkraken \
      --cask livebook \
      --cask obsidian \
      --cask iterm2

  fi

  if [[ $optional_flag == true ]]; then
    #Thefuck is an extremely useful cli utility for helping prevent typos
    brew install \
      zoxide \
      thefuck

    if ! grep -Fxq 'eval $(thefuck --alias)' "$HOME/.bashrc"; then
      echo 'eval $(thefuck --alias)' >>"$HOME/.bashrc"
    fi

  fi

  source "$HOME/.bashrc"

  echo "adding development plugins"
  for plugin in "${plugins[@]}"; do
    asdf plugin add "$plugin"
    asdf install "$plugin" latest
    asdf global "$plugin" latest
  done

  echo "Installing development versions"

  asdf install

  echo "%B%F{green}Installation complete, sourcing zshell. The following were added to your zshell file%f%b"

  for ALIAS in "${ALIASES[@]}"; do
    echo "%B%F{blue} -- $ALIAS%f%b"
  done

  brew cleanup
  source "$HOME/.bashrc"

}

_main "$@"
