#!/bin/bash

correct_choice=0

time_checking()
{
  while :; 
  do
   currenttime=$(date +%H:%M)
   if [[ "$currenttime" > "21:00" ]] || [[ "$currenttime" < "07:30" ]]; then
	  busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 3500
   else
    busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 6500
   fi
   test "$?" -gt 128 && break
  done &
}

choices()
{
	echo "Would you like the redshift always on or prefered screen temperature change during the day-night?"

	while [ $correct_choice -eq 0 ];
	do
		echo -e "\n1 - always on redshift;"
		echo "2 - time according temperature;"
		echo "3 - quit;"
		read pref

		case $pref in

		  1)
		  	correct_choice=1
		  	echo "Screen temperature set to 3500"
	    	busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 3500
		    ;;

		  2)
		  	correct_choice=1
		    time_checking
		    ;;
		  3)
		  	correct_choice=1
		  	echo "Bye Bye"
		  	exit 0
		  	;;

		  *)
		    echo -n "Unnknown response, try again or close this application"
		    ;;
		esac
	done
}

# call the function
choices
