#!/bin/sh
lynx -dump www.showip.com | sed -n 's/   Your IP address is //p'

