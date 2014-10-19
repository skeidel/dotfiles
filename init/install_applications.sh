#!/bin/bash

# Homebrew Formulae
# https://github.com/Homebrew/homebrew
declare -a HOMEBREW_FORMULAE=(
		"coreutils"
		"moreutils"
		"gnu-sed --default-names"
		"bash"
    "bash-completion"
    "git"
    "imagemagick --with-webp"
    "wget --enable-iri"
    "caskroom/cask/brew-cask"
    "vim --override-system-vi"
    "homebrew/dupes/screen"
    "homebrew/dupes/grep"
    "ack"
    "git"
    "imagemagick --with-webp"
    "lynx"
    "node"
    "p7zip"
    "pigz"
    "zopfli"
    "pv"
    "rename"
    "tree"
)

# Homebrew Casks
# https://github.com/caskroom/homebrew-cask
declare -a HOMEBREW_CASKS=(
    "iterm2"
    "sublime-text"
    "the-unarchiver"
    "torbrowser"
    "transmission"
    "virtualbox"
    "vlc"
    "chromium"
    "firefox"
    "gimp-lisanet"
    "libreoffice"
    "macvim"
    "the-unarchiver"
    "transmission"
    "virtualbox"
    "vlc"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_applications() {

    local i="", tmp=""

    # XCode Command Line Tools
    if [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; then
        xcode-select --install &> /dev/null

        # Wait until the XCode Command Line Tools are installed
        while [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; do
            sleep 5
        done
    fi

    print_success "XCode Command Line Tools"
    printf "\n"

    # Homebrew
    if [ $(cmd_exists "brew") -eq 1 ]; then
        printf '\n' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        #  └─ simulate ENTER keypress
        print_result $? "brew"
    fi

    if [ $(cmd_exists "brew") -eq 0 ]; then

        execute "brew update" "brew [update]"
        execute "brew upgrade" "brew [upgrade]"
        execute "brew cleanup" "brew [cleanup]"

        # Homebrew formulae
        for i in ${!HOMEBREW_FORMULAE[*]}; do
            tmp="${HOMEBREW_FORMULAE[$i]}"
            [ $(brew list "$tmp" &> /dev/null; printf $?) -eq 0 ] \
                && print_success "$tmp" \
                || execute "brew install $tmp" "$tmp"
        done

        printf "\n"

        # Homebrew casks
        if [ $(brew list brew-cask &> /dev/null; printf $?) -eq 0 ]; then

            for i in ${!HOMEBREW_CASKS[*]}; do
                tmp="${HOMEBREW_CASKS[$i]}"
                [ $(brew cask list "$tmp" &> /dev/null; printf $?) -eq 0 ] \
                    && print_success "$tmp" \
                    || execute "brew cask install $tmp" "$tmp"
            done

            printf "\n"
        fi

    fi

}
