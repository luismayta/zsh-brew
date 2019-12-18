#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines install brew for osx or linux.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#

brew_package_name=brew


function brew::install::osx {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function brew::install::linux {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    brew vendor-install ruby
}

function brew::dependences::install {
    messages_info "Installing Dependences for ${brew_package_name}"
    messages_success "${brew_package_name} Dependences Installed"
}

function brew::dependences::checked {
    if ! type -p ruby > /dev/null; then
      messages_error "Please install ruby with rvm for  ${brew_package_name}"
    fi
}

function brew::install {
    brew::dependences::checked
    messages_info "Installing ${brew_package_name}"
    case "${OSTYPE}" in
    darwin*)
        brew::install:osx
        ;;
    linux*)
        brew::install::linux
      ;;
    esac
    messages_success "${brew_package_name} Installed"
}

function brew::post_install {
    if type -p brew > /dev/null; then
        brew install gcc

      case "${OSTYPE}" in
        darwin*)
          brew install \
            jq \
            the_silver_searcher \
            tree
          ;;
        linux*)
          case "${DIST}" in
            Redhat | RedHat)
              brew install homebrew/dupes/gperf
              ;;
            Debian | Ubuntu | "")
              brew install \
                jq
              ;;
          esac
          ;;
      esac

    else
        brew::install
    fi
}

function brew::load {
    case "${OSTYPE}" in
      darwin*) ;;
      linux*)
        case $DIST in
          RedHat | Redhat | Debian | "")
            if [ -d /home/linuxbrew/.linuxbrew ]; then
              export MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
              export INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
              path_prepend "/home/linuxbrew/.linuxbrew/bin"
            elif [ -d ~/.linuxbrew ]; then
              export MANPATH=$HOME/.linuxbrew/share/man:$MANPATH
              export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
              export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH
              path_prepend "${HOME}/.linuxbrew/bin"
            fi
            ;;
          Ubuntu)
            case $DIST_VERSION in
              12.04 | 14.04)
                if [ -d /home/linuxbrew/.linuxbrew ]; then
                  export MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
                  path_prepend "/home/linuxbrew/.linuxbrew/bin"
                elif [ -d ~/.linuxbrew ]; then
                  export MANPATH=$HOME/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
                  export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH
                  path_prepend "${HOME}/.linuxbrew/bin"
                fi
                ;;
              16.04 | 18.04)
                if [ -d /home/linuxbrew/.linuxbrew ]; then
                  export MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
                  export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib:$LD_LIBRARY_PATH
                  path_prepend "/home/linuxbrew/.linuxbrew/bin"
                elif [ -d ~/.linuxbrew ]; then
                  export MANPATH=$HOME/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
                  export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH
                  path_prepend "${HOME}/.linuxbrew/bin"
                fi
                ;;
            esac
            ;;
        esac
        ;;
    esac
}

brew::load

if ! type -p brew > /dev/null; then
    brew::install
    brew::post_install
fi
