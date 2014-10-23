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
    "autojump"
)

# Homebrew Casks
# https://github.com/caskroom/homebrew-cask
declare -a HOMEBREW_CASKS=(
    "iterm2"
    "sizeup"
    "sublime-text"
    "the-unarchiver"
    "torbrowser"
    "transmission"
    "virtualbox"
    "vlc"
    "google-chrome"
    "firefox"
    "libreoffice"
    "the-unarchiver"
    "transmission"
    "virtualbox"
    "vlc"
    "github"
    "phpstorm"
    "rubymine"
    "skype"
    "silverlight"
    "plex-home-theater"
    "istat-menus"
    "sparkleshare"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cmd_exists() {
    [ -x "$(command -v "$1")" ] \
        && printf 0 \
        || printf 1
}

execute() {
    $1 &> /dev/null
    print_result $? "${2:-$1}"
}

print_error() {
    # Print output in red
    printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_info() {
    # Print output in purple
    printf "\n\e[0;35m $1\e[0m\n\n"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    [ "$3" == "true" ] && [ $1 -ne 0 ] \
        && exit
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}

print_question() {
    # Print output in yellow
    printf "\e[0;33m  [?] $1\e[0m"
}

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

install_applications

#brew tap homebrew/php
#brew install php55 --with-apache
