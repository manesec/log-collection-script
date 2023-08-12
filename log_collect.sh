#! /bin/bash

cd /usr/local/log-collection
chmod +x -R ./bash
run-parts ./bash/ --regex=".sh"
