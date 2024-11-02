#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "How may I help you?" 
  echo -e "\n1. cut\n2. color\n3. perm\n4. style\n5. trim"
  read MAIN_MENU_SELECTION

  case $MAIN_MENU_SELECTION in
    1) CUT_HAIR ;;
    2) COLOR_HAIR ;;
    3) PERM_HAIR ;;
    4) STYLE_HAIR ;;
    5) TRIM_HAIR ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

CUT_HAIR(){
  echo -e "\nYou chose a haircut. Let's get started!"
}

COLOR_HAIR(){
  echo -e "\nYou chose a hair color. Let's get started!"
}

PERM_HAIR(){
  echo -e "\nYou chose a perm. Let's get started!"
}

STYLE_HAIR(){
  echo -e "\nYou chose a style. Let's get started!"
}

TRIM_HAIR(){
  echo -e "\nYou chose a trim. Let's get started!"
}

# Start the main menu
MAIN_MENU







