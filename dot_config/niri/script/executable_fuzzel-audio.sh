#!/bin/bash
# Audio Sink Switcher using Fuzzel, pw-dump, and pw-metadata

# Get all sinks with ID, Name, and Description
sinks_json=$(pw-dump | jq -c '[.[] | select(.info.props["media.class"] == "Audio/Sink") | {id: .id, name: .info.props["node.name"], desc: .info.props["node.description"]}]')

if [ -z "$sinks_json" ] || [ "$sinks_json" == "[]" ]; then
    echo "No sinks found"
    exit 1
fi

# Get current default sink name
default_name=$(pw-metadata -n default | grep 'default.audio.sink' | sed -r "s/.*value:'(.*)'.*/\1/" | jq -r '.name' 2>/dev/null)

# Prepare lists for Fuzzel
mapfile -t ids < <(echo "$sinks_json" | jq -r '.[] | .id')
mapfile -t names < <(echo "$sinks_json" | jq -r '.[] | .name')
mapfile -t descs < <(echo "$sinks_json" | jq -r '.[] | .desc')

# Format for Fuzzel
selection=$(for i in "${!ids[@]}"; do
    if [ "${names[$i]}" == "$default_name" ]; then
        echo "󰄬 ${descs[$i]}"
    else
        echo "  ${descs[$i]}"
    fi
done | fuzzel --dmenu --prompt="Audio Picker: " --index)

if [ -n "$selection" ]; then
    target_id=${ids[$selection]}
    wpctl set-default "$target_id"
    
    # Optional notification
    new_desc=${descs[$selection]}
    if command -v notify-send >/dev/null; then
        notify-send "Audio" "Switched to $new_desc" 2>/dev/null || true
    fi
fi
