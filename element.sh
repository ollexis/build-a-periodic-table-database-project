#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else

  ELEMENT_TO_FIND=$1
  if [[ $ELEMENT_TO_FIND =~ ^[0-9]+$  ]]
  then
  
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements WHERE atomic_number=$ELEMENT_TO_FIND")

  else

    ELEMENT_INFO=$($PSQL "SELECT * FROM elements WHERE symbol='$ELEMENT_TO_FIND' OR name='$ELEMENT_TO_FIND'")

  fi


  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT_INFO" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
    do

      PROPERTIES_INFO=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      echo $PROPERTIES_INFO | while read ATOMIC_NUMBER BAR ATOMIC_MASS BAR MPC BAR BPC BAR TYPE_ID
      do
        TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a$TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."

      done

    done
  fi

fi

