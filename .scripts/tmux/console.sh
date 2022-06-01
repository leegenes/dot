#!/bin/bash

CONSOLE_SESSION="console"

TARGET_DIR=$HOME/src/gitlab/check/$CONSOLE_SESSION

### Functions
SESSIONEXISTS=$(tmux list-sessions | grep $CONSOLE_SESSION)

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    source $HOME/.scripts/tmux/check-api.sh
    # New detached session, run docker
    tmux new-session -d -s $CONSOLE_SESSION -n "django" -c $TARGET_DIR 'pipenv run python manage.py runserver localhost:8004' 
    tmux new-window -d -n "yarn" -c $TARGET_DIR 'yarn run start'
    tmux new-window -a -n $CONSOLE_SESSION -c $TARGET_DIR 'pipenv shell'
    
fi