#!/bin/bash

SESSION="check-api"

CHECK_API_DIR=$HOME/src/gitlab/check/$SESSION

### Functions
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    # New detached session, run docker
    tmux new-session -d -s $SESSION -n "docker" -c $CHECK_API_DIR 'docker-compose up' 
    # New detached pane for django server
    tmux new-window -d -n "django" -c $CHECK_API_DIR 'pipenv run python manage.py runserver localhost:8000'
    # New pane for a shell with env activated, attach to it
    tmux new-window -a -n "check-api" -c $CHECK_API_DIR 'pipenv shell'
fi
