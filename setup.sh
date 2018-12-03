#!/bin/bash

# install git
# TODO automate this
which -s git 
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING GIT:\n"
	echo "manually install git to continue."
	return 1
fi


# install brew
which -s brew
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING HOMEBREW:\n"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	printf "\nUPDATING HOMEBREW:\n"
	brew update
fi


# install vundle
if ! [ "$(ls -A ${HOME}/.vim/bundle/Vundle.vim)" ]; then
	printf "\nINSTALLING VUNDLE:\n"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi


# install fzf for fuzzy vim file search 
printf "\nINSTALLING FZF:\n"
brew install fzf
$(brew --prefix)/opt/fzf/install --completion --key-bindings --update-rc


# symlink vimrc
printf "\nSYMLINKING VIMRC:\n"
if [ -f ${HOME}/.vimrc ]; then
	read -p "local ~/.vimrc already found. Would you like to replace your local ~/.vimrc ? " -n 1 -r
	echo    # (optional) move to a new line
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "aborting script."
		return 1
	fi
fi
ln -fs ${HOME}/code/configs/dotfiles/vimrc ${HOME}/.vimrc


# install nvm
which -s nvm
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING NVM:\n"
	# following instructions from: https://github.com/edwmurph/nvm#git-install
	if ! [ -f "${HOME}/.nvm/nvm.sh" ]; then
		git clone https://github.com/edwmurph/nvm.git "${HOME}/.nvm"
	fi
	. "${HOME}/.nvm/nvm.sh"
fi


# install node
printf "\nINSTALLING NEWEST NODE.JS:\n"
nvm install node
nvm use node


# symlink bash_profile
printf "\nSYMLINKING BASH_PROFILE:\n"
if [[ -f ${HOME}/.bash_profile ]]; then
	read -p "local ~/.bash_profile already found. Would you like to replace your local ~/.bash_profile ? " -n 1 -r
	echo    # (optional) move to a new line
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "aborting script."
		return 1
	fi
fi
ln -fs ${HOME}/code/configs/dotfiles/bash_profile ${HOME}/.bash_profile
. ${HOME}/.bash_profile




echo 
echo "finished"