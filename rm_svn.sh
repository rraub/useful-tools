#!/bin/sh
# useful to remove .svn folders from the current directory and sub directories

echo "recursively removing .svn folders from"
pwd
rm -rf `find . -type d -name .svn`
