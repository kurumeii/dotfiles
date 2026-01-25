#!/bin/bash
# Emoji Picker for Fuzzel

EMOJI_FILE="$HOME/.cache/emoji_list.txt"

# Download emoji list if it doesn't exist
if [ ! -f "$EMOJI_FILE" ]; then
    notify-send "Fuzzel" "Downloading emoji list..."
    curl -s https://raw.githubusercontent.com/muan/emojilib/main/dist/emoji-en-US.json | \
        jq -r 'to_entries | .[] | "\(.value[0]) \(.key)"' > "$EMOJI_FILE"
fi

selection=$(fuzzel --dmenu --prompt="Emoji: " < "$EMOJI_FILE")

if [ -n "$selection" ]; then
    emoji=$(echo "$selection" | awk '{print $1}')
    echo -n "$emoji" | wl-copy
    notify-send "Emoji" "Copied $emoji to clipboard"
fi
