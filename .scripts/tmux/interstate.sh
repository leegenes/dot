#!/bin/bash

INTERSTATE_SESSION="interstate"

TARGET_DIR=$HOME/src/gitlab/check/$INTERSTATE_SESSION

### Functions
SESSIONEXISTS=$(tmux list-sessions | grep $INTERSTATE_SESSION)

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    source $HOME/.scripts/tmux/check-api.sh
    # New detached session, run docker
    tmux new-session -d -s $INTERSTATE_SESSION -n "django" -c $TARGET_DIR 'pipenv run python manage.py runserver localhost:4000' 
    tmux new-window -a -n $INTERSTATE_SESSION -c $TARGET_DIR 'pipenv shell'
fi