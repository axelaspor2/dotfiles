#!/bin/bash
mkdir -p ~/.config/ghostty/animation_frames
for i in $(seq 1 235); do
    num=$(printf "%03d" $i)
    echo "Downloading frame $num..."
    curl -sL "https://raw.githubusercontent.com/ghostty-org/website/main/terminals/home/animation_frames/frame_${num}.txt" | sed 's/<[^>]*>//g' > ~/.config/ghostty/animation_frames/frame_${num}.txt
done
echo "Done! Downloaded $(ls ~/.config/ghostty/animation_frames/*.txt | wc -l) frames"
