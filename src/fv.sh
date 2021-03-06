#!/bin/sh

# FV
# Simon H Moore
#
# Find files and open them in your editor (vim is used if $EDITOR not set).
# 
# You can choose max depth of directory in first argument.
# Default max depth is 5.
# 
# Will use the fantastic fd (https://github.com/sharkdp/fd) utility if available
# otherwise it will default back to find.

# returns list of files
get_files(){
    if command -v fd > /dev/null; then
        fd . -d "$depth" -t f -x file {} | grep 'ASCII text' | cut -d':' -f1
    else
        find ./ -maxdepth "$depth" -name .git -prune -o -type f -exec file {} \; 2>/dev/null | grep 'ASCII text' | cut -d':' -f1
    fi
}

# get max depth to traverse for files.
[ $1 ] && depth="$1" || depth="5"

# get choice of file from fzf
choice="$(get_files | fzf --prompt="$(pwd)/" --preview='cat {}' --preview-window=up:60%:wrap)" || exit

# open file in $EDITOR or vim
${EDITOR:-vim} "$choice"
