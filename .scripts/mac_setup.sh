#!/bin/bash

# From here on, mostly stolen from https://github.com/nnja/new-computer/

# Some configs reused from:
# https://github.com/ruyadorno/installme-osx/
# https://gist.github.com/millermedeiros/6615994
# https://gist.github.com/brandonb927/3195465/

# Colorize

# Set the colours you can use
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# Resets the style
reset=`tput sgr0`

# Color-echo. Improved. [Thanks @joaocunha]
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}${reset}"
  return
}

echo ""
cecho "###############################################" $red
cecho "#        DO NOT RUN THIS SCRIPT BLINDLY       #" $red
cecho "#         YOU'LL PROBABLY REGRET IT...        #" $red
cecho "#                                             #" $red
cecho "#              READ IT THOROUGHLY             #" $red
cecho "#         AND EDIT TO SUIT YOUR NEEDS         #" $red
cecho "###############################################" $red
echo ""

# # Set continue to false by default.
# CONTINUE=false

# echo ""
# cecho "Have you read through the script you're about to run and " $red
# cecho "understood that it will make changes to your computer? (y/n)" $red
# read -r response
# if [ $response =~ ^([yY][eE][sS]|[yY])$ ]
# then
#   CONTINUE=true
# fi

# if ! $CONTINUE
# then
#   # Check if we're continuing and output a message if not
#   cecho "Please go read the script, it only takes a few minutes" $red
#   exit
# fi

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##############################
# Prerequisite: Install Brew #
##############################

export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
export HOMEBREW_NO_ENV_HINTS=TRUE

echo "Installing brew..."

if test ! $(which brew)
then
	## Don't prompt for confirmation when installing homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
fi

# echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/lee/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Latest brew, install brew cask
brew upgrade
brew update
# brew install cask

#############################################
### Generate ssh keys & add to ssh-agent
### See: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
#############################################
# if [ -e ~/.ssh/id_rsa ]
# then
#   echo "ssh key already exists."
# else 
#   echo "Generating ssh keys, adding to ssh-agent..."
#   read -p 'Input email for ssh key: ' useremail

#   echo "Use default ssh file location, enter a passphrase: "
#   ssh-keygen -t rsa -b 4096 -C "$useremail"  # will prompt for password
#   eval "$(ssh-agent -s)"

#   # Now that sshconfig is synced add key to ssh-agent and
#   # store passphrase in keychain
#   ssh-add -K ~/.ssh/id_rsa
# fi

# # If you're using macOS Sierra 10.12.2 or later, you will need to modify your ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in your keychain.
# if [ -e ~/.ssh/config ]
# then
#     echo "ssh config already exists. Skipping adding osx specific settings... "
# else
#   echo "Writing osx specific settings to ssh config... "
#   cat <<EOT >> ~/.ssh/config
# 	Host *
# 		AddKeysToAgent yes
# 		UseKeychain yes
# 		IdentityFile ~/.ssh/id_rsa
# EOT
# SSH_KEY=`cat ~/.ssh/id_rsa.pub`

#############################################
### Add ssh-key to GitHub via api
#############################################

echo "Adding ssh-key to GitHub (via api)..."
echo "Important! For this step, use a github personal token with the admin:public_key permission."
echo "If you don't have one, create it here: https://github.com/settings/tokens/new"

retries=3

for ((i=0; i<retries; i++)); do
      read -p 'GitHub username: ' ghusername
      read -p 'Machine name: ' ghtitle
      read -sp 'GitHub personal token: ' ghtoken

      gh_status_code=$(curl -o /dev/null -s -w "%{http_code}\n" -u "$ghusername:$ghtoken" -d '{"title":"'$ghtitle'","key":"'"$SSH_KEY"'"}' 'https://api.github.com/user/keys')

      if (( $gh_status_code -eq == 201))
      then
          echo "GitHub ssh key added successfully!"
          break
      else
			echo "Something went wrong. Enter your credentials and try again..."
     		echo -n "Status code returned: "
     		echo $gh_status_code
      fi
done

[[ $retries -eq i ]] && echo "Adding ssh-key to GitHub failed! Try again later."

#############################################
### Add ssh-key to GitHub via api
#############################################

echo "Adding ssh-key to GitLab (via api)..."
echo "Important! For this step, use a Gitlab personal token."

retries=3

for ((i=0; i<retries; i++)); do
      read -p 'GitLab username: ' glusername
      read -p 'Machine name: ' gltitle
      read -sp 'GitHub personal token: ' gltoken

      gl_status_code=$(curl -o /dev/null -s -w "%{http_code}\n" -d '{"title":"'$gltitle'","key":"'"$SSH_KEY"'"}' https://gitlab.com/api/v4/user/keys?private_token=$gltoken)

      if (( $gl_status_code -eq == 201))
      then
          echo "GitHub ssh key added successfully!"
          break
      else
			echo "Something went wrong. Enter your credentials and try again..."
     		echo -n "Status code returned: "
     		echo $gl_status_code
      fi
done

[[ $retries -eq i ]] && echo "Adding ssh-key to GitHub failed! Try again later."

##############################
# Install via Brew           #
##############################
echo "Starting brew app install..."

# Development
brew install --cask iterm2

brew install --cask docker
brew install postgresql
brew install redis

brew install git
brew install wget
brew install zsh
brew install tmux
brew install less

brew install --cask postman

# Python
brew install python
brew install pyenv

# Editors
brew install --cask visual-studio-code
brew install --cask pycharm

brew install --cask amethyst
brew install --cask flameshot
brew install --cask alfred
brew install --cask vivaldi

brew install --cask 1password

# Personal
brew install --cask obsidian
brew install --cask spotify
brew install --cask karabiner-elements
brew install --cask istat-menus


# Work

# Check
brew install --cask slack
brew install --cask loom
brew install --cask perimeter81
brew install --cask tuple
brew install --cask zoomus

## Clean
brew cleanup

#############################################
### Fonts
#############################################

echo "Installing fonts..."

brew tap caskroom/fonts

### programming fonts
brew install --cask font-fira-mono-for-powerline
brew install --cask font-fira-code

### SourceCodePro + Powerline + Awesome Regular (for powerlevel 9k terminal icons)
cd ~/Library/Fonts && { curl -O 'https://github.com/Falkor/dotfiles/blob/master/fonts/SourceCodePro+Powerline+Awesome+Regular.ttf?raw=true' ; cd -; }

#############################################
### Install few global python packages
#############################################

echo "Installing global Python packages..."

pip3 install --upgrade pip
pip3 install --user pylint
pip3 install --user flake8

###############################################################################
# vscode extenstions                                                          #
###############################################################################

code --install-extension atlassian.atlascode
code --install-extension batisteo.vscode-django
code --install-extension donjaymanne.git-extension-pack
code --install-extension donjaymanne.githistory
code --install-extension eamodio.gitlens
code --install-extension editorconfig.editorconfig
code --install-extension github.vscode-pull-request-github
code --install-extension gitlab.gitlab-workflow
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension vscode-icons-team.vscode-icons
code --install-extension vscodevim.vim
code --install-extension ziyasal.vscode-open-in-github
code --install-extension tomoki1207.pdf

#############################################
### Set OSX Preferences - Borrowed from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#############################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'


##################
### Finder, Dock, & Menu Items
##################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Only Show Open Applications In The Dock  
defaults write com.apple.dock static-only -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Use function F1, F, etc keys as standard function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Stop iTunes from responding to the keyboard media keys
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Dotfiles                                                                    #
###############################################################################
# More stealing from https://www.atlassian.com/git/tutorials/dotfiles

alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore

git clone --bare git@github.com:leegenes/dot.git $HOME/.dotfiles
function dot {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
dot checkout
if [ $? = 0 ]
then
  echo "Checked out config.";
  else
    mkdir -p .dot-backup
    echo "Backing up pre-existing dot files.";
    dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dot-backup/{}
fi;
dot checkout
dot config status.showUntrackedFiles no


echo ""
cecho "Done!" $cyan
echo ""
echo ""
cecho "################################################################################" $white
echo ""
echo ""
cecho "Note that some of these changes require a logout/restart to take effect." $red
echo ""
echo ""
echo -n "Check for and install available OSX updates, install, and automatically restart? (y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ]
then
  softwareupdate -i -a --restart
fi