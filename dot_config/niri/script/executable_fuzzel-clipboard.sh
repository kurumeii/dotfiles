#!/bin/bash
# Clipboard History using Fuzzel and Cliphist

selection=$(printf "Clear History\n%s" "$(cliphist list | head -n 20)" | fuzzel --dmenu --prompt="Clipboard: ")

if [ -n "$selection" ]; then
    if [ "$selection" = "Clear History" ]; then
        cliphist wipe
				notify-send "Clipboard history cleared!"
    else
        echo "$selection" | cliphist decode | wl-copy
				notify-send "Copied to clipboard!"
    fi
fi
