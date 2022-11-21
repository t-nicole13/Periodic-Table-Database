#! /usr/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]
then
  echo 'Please provide an element as an argument.'
  exit
fi

# if argument is a number or string
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = '$1'")
else 
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
fi

# if element doesn't exist
if [[ -z $ELEMENT ]]
then 
  echo -e 'I could not find that element in the database.'
  exit
fi

# show element info
echo $ELEMENT | while IFS=" |" read atomic_number symbol name type atomic_mass melting_point_celsius boiling_point_celsius
do
  echo -e "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
done
