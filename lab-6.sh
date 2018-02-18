# Generating a map
clear
tput civis -- invisible

declare -A field
rows=35
columns=20

playerI=3
playerJ=6
newObjectI=$((playerI-1))
newObjectJ=$((playerJ))

lastDimension="w"

for ((i=1; i<=rows; i++)) do
    for ((j=1; j<=columns; j++)) do
      # field[$i,$j]=$(( $RANDOM % 10 + 0 ))
      field[$i,$j]="1"
    done
done

function generateField () {
   clear   
   
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

   if [ "${field[$playerI,$playerJ]}" = "0" ] || (($playerI <= 0)) || (($playerJ <= 0)) ; then
      newObjectI=$((playerI))
      newObjectJ=$((playerJ))

      playerI="$oldPlayerI"
      playerJ="$oldPlayerJ"
   fi

   # Draw/remove object 
   if [ "$2" = true ] ; then 
      if [ "${field[$newObjectI,$newObjectJ]}" != "0" ] ; then 
         field[$newObjectI,$newObjectJ]="0"
      else
         field[$newObjectI,$newObjectJ]="1"
      fi
   fi

   # Draw player
   for ((i=1; i<=rows; i++)) do
       for ((j=1; j<=columns; j++)) do
         if [ "$i" -eq "$playerI" ] && [ "$j" -eq "$playerJ" ] ; then
            printf "\e[31;1m🚀"
            generatedUser=true
            continue
         fi

         if [ "${field[$i,$j]}" != "0" ] && [ "${field[$i,$j]}" != "13" ] ; then
            printf " "
         elif [ "${field[$i,$j]}" = "13" ] ; then
            printf "\e[1;32m🌎"
         else 
            printf "\e[37;3m★"
         fi
       done
       echo
   done   
}

# Rendering a main menu
# clear
# echo "
# *****************************************************
# Developed By Evegeny Dovgiy and Nikita Pavlyuk KE-484

# Keys:

#  W - UP
#  S - DOWN
#  A - LEFT
#  D - RIGHT
#  SPACE - pick/put blocks
#  X - QUIT

# Press Enter to continue
# *****************************************************
# "

generateField

while :
do
   read -s -n 1 key
   case "$key" in
   w) generateField "w" ;;
   a) generateField "a" ;;
   s) generateField "s" ;;
   d) generateField "d" ;;
   e) generateField "" true ;;

   *)   
      tput cnorm   -- normal
      exit 0;;
   esac
done