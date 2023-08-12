#! /bin/bash

cd /usr/local/log-collection/
git pull origin main || (git stash drop && git pull origin main)

