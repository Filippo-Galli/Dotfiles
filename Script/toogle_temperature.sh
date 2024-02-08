#!/bin/bash

# Retrieve the current screen temperature
current_temperature=$(busctl --user get-property rs.wl-gammarelay / rs.wl.gammarelay Temperature | tr -d 'q')


if [ "$current_temperature" -eq 3500 ]; then
	busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 5500
	
else
	busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 3500
	
fi

