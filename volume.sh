#!/bin/sh

FUNC="mute"

for i in $@; do
	case ${i} in
		extra|half|increase|init|decrease|full|mute)
			FUNC="${i}"
			;;
		*)
		  echo "Opions:"
		  echo "  extra - volume 100%"
		  echo "  half - volume 50%"
		  echo "  increase - volume +5%"
		  echo "  init - volume 0%"
		  echo "  decrease - volume -5%"
		  echo "  full - volume 80%"
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
	  mute)
	    pactl set-sink-mute ${i} toggle
	    ;;
	esac
done

