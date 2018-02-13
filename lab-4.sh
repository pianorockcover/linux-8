# chmod u+x lab-4.sh
# ./lab-4.sh

function show_help()
{
	echo "Created by E. Dovgy and N. Pavlyuk"
	echo "-n --name - show name of process"
	echo "-m --memory - show memory of process"
	echo "-s --state - show state of process"
}

showName=false
showMemory=false
showState=false

argsAmount=0

while [ "$1" != "" ]
do
	argsAmount=$((argsAmount+1))

	case "$1" in
		-n)
			showName=true

			shift;;

		--name)
			showName=true

			shift;;

		-m)
			showMemory=true

			shift;;
			
		--memory)
			showMemory=true

			shift;;

		-s)
			showState=true

			shift;;
			
		--state)
			showState=true

			shift;;

		-h)
			show_help
			exit 0;;

		--help)
			show_help
			exit 0;;

		*)
			 
			echo "Error: Wrong param $1"
		    exit 1;;
	esac
done

if [ "$argsAmount" -eq "0" ] ; then
	showName=true
	showMemory=true
	showState=true
fi

echo "PID|NAME|MEM|STAT" |
	sed 's/  */ /g;s/|/                   /g;s/\(.\{20\}\) */\1/g'

# for entry in "/proc"/*
for entry in `ls /proc | sort -V`; 
do
	# pid=$(basename "$entry")
	pid="$entry"

	if ! [[ $pid =~ ^-?[0-9]+$ ]]
	then
		continue
	fi

	if [ ! -f "/proc/${pid}/status" ]; then
	    continue
	fi


	while IFS='' read -r line || [[ -n "$line" ]]; do
		line="${line/	/ }"

	    if [[ $line = *"Name"* ]]; then
	    	
	    	str1="Name: "
	    	str2=""

			name="${line/$str1/$str2}"
		fi

	    if [[ $line = *"State"* ]]; then
	    	
	    	str1="State: "
	    	str2=""

			pstat="${line/$str1/$str2}"
		fi

	    if [[ $line = *"VmSize"* ]]; then
	    	
	    	str1="VmSize: "
	    	str2=""

			mem="${line/$str1/$str2}"
		fi
		
	done < "/proc/${pid}/status"


	if [ "$?" -eq 0 ]; then

		if [ "$showName" != true ] ; then
		    name=''
		fi

		if [ "$showMemory" != true ] ; then
		    mem=''
		fi

		if [ "$showState" != true ] ; then
		    pstat=''
		fi

	    echo "$pid|$name|$mem|$pstat" |
	    	sed 's/  */ /g;s/|/                 /g;s/\(.\{20\}\) */\1/g'

	fi

	# break
  # echo "$pid"
done
