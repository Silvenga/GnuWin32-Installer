#! /bin/sh

for source in $1; do
	source-highlight --failsafe -f esc -i $source;
done
