#!/bin/sh

killall -q gammastep
gammastep -P -O 3500 &

if pacmd list-sinks | grep -q auto_null; then
    pacmd set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo+input:analog-stereo
    pacmd set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo
fi
