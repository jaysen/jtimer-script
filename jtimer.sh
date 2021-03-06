#!/bin/bash
## JTIMER1.sh   
#
# Version: 1.0
# a (rough) timer
# takes a required argument of TIME in seconds
# arguments:
#      	arg 1: TIME in seconds (REQUIRED) 
#      	arg 2: interval between showing how much time is left
#		arg 3: string to say
#		arg 4: number of times to say the string
#		arg 5: pause time between alarm say (in seconds)
#
echo "started at - `date` ";


if [ $1 > 0 ] 
then
	TIME=$(($1/1));  #using the divide by one to convert input like 3*60 to 180 ...
else
	echo "No time given... exiting";
	echo "jt [time in secs] [secs between countdown refresh] ['alarm to say'] [alrm repetition] [secs between alarm]"
	exit;
fi

if [ $2 > 0 ]; then
	INT=$2;
	SHOW=true;
else
	SHOW=false;
fi

# break into minutes for string TIMESTR:
if [ ${TIME} -gt 60 ]; then
	let MIN=$TIME/60;
	let SEC=$TIME%60;
	TIMESTR="$MIN minutes $SEC seconds";
else
	TIMESTR="$TIME seconds";
fi


echo;

echo "Timer will run for $TIMESTR ...";

if $SHOW; then
	COUNT=$(($TIME/$INT));
	REM=$(($TIME%$INT));
	#echo "DEBUG - time is $TIME";
	#echo "DEBUG - interval is $INT";
	#echo "DEBUG - count is $COUNT";
	#echo "DEBUG - remainder is $REM";
	
	until [  $COUNT = 0 ]; do
		TL=$(($COUNT*$INT+$REM)); # Time Left equals the COUNT left mutiplied by INT interval between counts) plus the remainder of TIME/INT
		

		# break into minutes for string TIMESTR:
		if [ ${TL} -gt 60 ]; then
			let MIN=$TL/60;
			let SEC=$TL%60;
			TLSTR="$MIN minutes $SEC seconds";
		else
			TLSTR="$TL seconds";
		fi
		
		
		echo ".. $TLSTR left             ";printf "\033[A";  #printf "\033[A" resets line to beginning. so that it overwrites seconds left ...
		let COUNT-=1;
		sleep $INT;
	done;
	sleep $REM; 
else
	echo "no interval given - JTimer running for $TIME seconds";
	echo;
	sleep $TIME;
fi;

echo;
echo;
echo "stopped at - `date`";
echo;
echo "DONE. Timer ran for $TIMESTR";
say "DONE. Timer ran for $TIMESTR";
DEF="d";
if [ "$3" = "$DEF" ]; then
	SPEAKSTR="Timer Finished .... Come back now. Be here now..";
	COUNT=500;
	# echo "default is $SPEAKSTR";
else
	SPEAKSTR="$3";
	COUNT=$4;
	# echo "non default is $SPEAKSTR";
fi

if [ $5 > 0 ]; then
	PAUSE=$5;
else
	PAUSE=1;
fi

ALRMREPS=$COUNT;
if [ "$3" != "" ]; then
	if [ $COUNT > 0 ]; then
		until [  $COUNT = 0 ]; do
			say $SPEAKSTR;
			echo "alarm repetitions...$COUNT. with $PAUSE second pauses";printf "\033[A";  #printf "\033[A" resets line to beginning. so that it overwrites reps left ...
			sleep $PAUSE;
			let COUNT-=1;
		done;
	else
		say $SPEAKSTR;
	fi
fi

echo "alarm finished repeating $ALRMREPS times, with $PAUSE second pauses";
# echo "alarm repetitions";