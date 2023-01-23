#!/usr/bin/env zsh

if [[ $# -lt 2 ]]; then
	echo "Usage:"
	echo "$0 UID GID"
	echo "   Where UID is the numerical ID of the host system's user that called this script (run 'id -u' to get it)"
	echo "   Where GID is the numerical ID of the host system's user's group that called this script (run 'id -g' to get it)"
	return 1
fi

echo "UID recieved: $1"
echo "GID recieved: $2"
echo "Starting site build"
jekyll build --source /source --destination /destination
echo "Changing destination ownership to $1:$2"
chown -R $1:$2 /destination

