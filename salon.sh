#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # Get available services from the database
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  
  # Check if there are any available services
  if [[ -z $AVAILABLE_SERVICES ]]
  then
    echo "Sorry, we don't have any service available right now."
  else
    echo "$AVAILABLE_SERVICES" | while IFS="|" read SERVICE_ID NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
    
    # Prompt user to select a service
    read SERVICE_ID_SELECTED
    
    # If input is not a number
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      MAIN_MENU "That is not a valid number."
    else
      # Check if the selected service ID is available
      SERVICE_AVAILABILITY=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      
      if [[ -z $SERVICE_AVAILABILITY ]]
      then
        MAIN_MENU "I could not find that service. What would you like today?"
      else
        # Get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE
        
        # Check if the customer exists
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        
        if [[ -z $CUSTOMER_NAME ]]
        then
          # Get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME
          # Insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
        fi
        
        # Get the service name for confirmation message
        SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        
        echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
        read SERVICE_TIME
        
        # Get customer ID
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        
        # Insert the appointment
        INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
        
        if [[ $INSERT_APPOINTMENT_RESULT == "INSERT 0 1" ]]
        then
          echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
        else
          echo -e "\nThere was an error scheduling your appointment. Please try again."
        fi
      fi
    fi
  fi
}

MAIN_MENU

#pg_dump -cC --inserts -U freecodecamp salon > salon.sql
# You can rebuild the database by entering psql -U postgres < salon.sql