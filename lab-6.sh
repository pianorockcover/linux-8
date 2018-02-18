# Generating a map
clear
tput civis -- invisible

declare -A field
rows=10
columns=35

while [ "$1" != "" ]
do
   case "$1" in
      max)
         shift
         IFS='x' read -r -a dimensionsArray <<< "$1"
         if [[ ${dimensionsArray[0]} =~ ^-?[0-9]+$ ]] && [[ ${dimensionsArray[1]} =~ ^-?[0-9]+$ ]] ; then
            rows=${dimensionsArray[0]}
            columns=${dimensionsArray[1]}
            break
         fi

         echo $'\e[31;1m☠ ☠ ☠ ☠ ☠ ☠ ☠ ☠ ☠ ☠ ☠ ☠ ☠ ☠ ☠ ☠'
         echo "Syntax Error! Try max 32x32 to change dimensions"
         exit 1;;
   esac

   shift
done


playerI=3
playerJ=6
newObjectI=$((playerI-1))
newObjectJ=$((playerJ))

lastDimension="w"

for ((i=1; i<=rows; i++)) do
    for ((j=1; j<=columns; j++)) do
      field[$i,$j]=$(( $RANDOM % 20 + 0 ))
      # field[$i,$j]="1"
    done
done

function generateField () {
      
   
   # Change postiton
   oldPlayerI="$playerI"
   oldPlayerJ="$playerJ"

   if [ "$1" = "w" ] ; then 
      ((playerI--))
      newObjectI=$((playerI-1))
      newObjectJ=$((playerJ))
   fi

   if [ "$1" = "a" ] ; then 
      ((playerJ--))
      newObjectJ=$((playerJ-1))
      newObjectI=$((playerI))
   fi

   if [ "$1" = "d" ] ; then 
      ((playerJ++))
      newObjectJ=$((playerJ+1))
      newObjectI=$((playerI))
   fi

   if [ "$1" = "s" ] ; then 
      ((playerI++))
      newObjectI=$((playerI+1))
      newObjectJ=$((playerJ))
   fi

   if [ "${field[$playerI,$playerJ]}" = "0" ] || [ "${field[$playerI,$playerJ]}" = "-1" ] || (($playerI <= 0)) || (($playerJ <= 0)) || (($playerI >= rows)) || (($playerJ >= columns)) ; then
      newObjectI=$((playerI))
      newObjectJ=$((playerJ))

      playerI="$oldPlayerI"
      playerJ="$oldPlayerJ"
   fi

   # Draw/remove object 
   if [ "$2" = true ] ; then 
      if [ "${field[$newObjectI,$newObjectJ]}" != "-1" ] ; then 
         field[$newObjectI,$newObjectJ]="-1"
      else
         field[$newObjectI,$newObjectJ]="1"
      fi
   fi

   # Draw player
   printf "\033c"
   tput civis -- invisible

   for ((i=1; i<=rows; i++)) do
      output=''
       for ((j=1; j<=columns; j++)) do
         if [ "$i" -eq "$playerI" ] && [ "$j" -eq "$playerJ" ] ; then
            toPrint=$'\e[1;33;1m🚀'
            output="$output$toPrint"

            continue
         fi

         if [ "${field[$i,$j]}" -eq "-1" ] ; then
            toPrint=$'\e[0;32;3m🌍'
            output="$output$toPrint"

            continue
         fi

         if [ "${field[$i,$j]}" != "0" ] ; then
            toPrint=$'\e[40;1m '
            output="$output$toPrint"
         else 
            toPrint=$'\e[1;37;3m⭐'
            output="$output$toPrint"
         fi
       done

       echo $output
   done   
}

# Rendering a main menu
echo "
*****************************************************
Developed By Evegeny Dovgiy and Nikita Pavlyuk KE-484

Keys:

 W - UP
 S - DOWN
 A - LEFT
 D - RIGHT
 E - pick/put blocks
 X - QUIT

Press Enter to continue
*****************************************************
"

while :
do
   read -s -n 1 key
   case "$key" in
   w) generateField "w" ;;
   a) generateField "a" ;;
   s) generateField "s" ;;
   d) generateField "d" ;;
   e) generateField "" true ;;
   
   *) generateField;;

   x)   
      tput cnorm   -- normal
      exit 0;;
   esac
done