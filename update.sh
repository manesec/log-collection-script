#! /bin/bash

cd /usr/local/log-collection/
git checkout .
git pull origin main || (git stash drop && git pull origin main)

