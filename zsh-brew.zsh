#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines install brew for osx or linux.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#

package_name=brew

plugin_dir=$(dirname "${0}":A)

# shellcheck source=/dev/null
source "${plugin_dir}"/src/helpers/messages.zsh

# shellcheck source=/dev/null
source "${plugin_dir}"/src/helpers/tools.zsh

function brew::install::osx {
    if [ -x "$(command which ruby)" ]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
}

function brew::install::linux {
    if [ -x "$(command which ruby)" ]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
        brew vendor-install ruby
    fi
}


function brew::install {
    message_info "Installing ${package_name}"
    case "${OSTYPE}" in
    darwin*)
        brew::install:osx
        ;;
    linux*)
        brew::install::linux
      ;;
    esac
    message_success "${package_name} Installed"
}

function brew::dependences {
    message_info "Installing Dependences for ${package_name}"
    message_success "${package_name} Dependences Installed"
}

function brew::post_install {
    if [ -x "$(command which brew)" ]; then
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
              path::prepend "/home/linuxbrew/.linuxbrew/bin"
            elif [ -d ~/.linuxbrew ]; then
              export MANPATH=$HOME/.linuxbrew/share/man:$MANPATH
              export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
              export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH
              path::prepend "${HOME}/.linuxbrew/bin"
            fi
            ;;
          Ubuntu)
            case $DIST_VERSION in
              12.04 | 14.04)
                if [ -d /home/linuxbrew/.linuxbrew ]; then
                  export MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
                  path::prepend "/home/linuxbrew/.linuxbrew/bin"
                elif [ -d ~/.linuxbrew ]; then
                  export MANPATH=$HOME/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
                  export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH
                  path::prepend "${HOME}/.linuxbrew/bin"
                fi
                ;;
              16.04 | 18.04)
                if [ -d /home/linuxbrew/.linuxbrew ]; then
                  export MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
                  export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib:$LD_LIBRARY_PATH
                  path::prepend "/home/linuxbrew/.linuxbrew/bin"
                elif [ -d ~/.linuxbrew ]; then
                  export MANPATH=$HOME/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
                  export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH
                  path::prepend "${HOME}/.linuxbrew/bin"
                fi
                ;;
            esac
            ;;
        esac
        ;;
    esac
}

brew::load

if [ ! -x "$(command which brew)" ]; then
    brew::install
    brew::post_install
fi
