#!/bin/sh

FUNC="mute"
FIRST=`pactl list short sinks | cut -f 1 | sort | head -1`
LAST=`pactl list short sinks | cut -f 1 | sort | tail -1`

for i in $@; do
  case ${i} in
    extra|first|half|increase|init|decrease|full|last|mute)
      FUNC="${i}"
      ;;
    *)
      echo "Opions:"
      echo "  extra - volume 100%"
      echo "  first - first output device"
      echo "  half - volume 50%"
      echo "  increase - volume +5%"
      echo "  init - volume 0%"
      echo "  decrease - volume -5%"
      echo "  full - volume 80%"
      echo "  last - last output device"
      echo "  mute - volume mute"
      exit 0 
      ;;
  esac
done

for i in `pactl list sinks short | cut -f 2`
do
  case ${FUNC} in
    extra)
      pactl set-sink-volume ${i} 100%
      ;;
    first)
      pactl set-default-sink ${FIRST}
      ;;
    half)
      pactl set-sink-volume ${i} 50%
      ;;
    increase)
      pactl set-sink-volume ${i} +5%
      ;;
    init)
      pactl set-sink-volume ${i} 0%
      ;;
    decrease)
      pactl set-sink-volume ${i} -5%
      ;;
    full)
      pactl set-sink-volume ${i} 80%
      ;;
    last)
      pactl set-default-sink ${LAST}
      ;;
    mute)
      pactl set-sink-mute ${i} toggle
      ;;
  esac
done

