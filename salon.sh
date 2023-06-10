#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ SALON ~~~~~\n"

SERVICES(){
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME 
  do
    echo "$SERVICE_ID) $NAME"
  done
}
SERVICES
echo -e "\nWhich one would you like to book?"
read SERVICE_ID_SELECTED
SERVICE_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id= $SERVICE_ID_SELECTED")
if [[ -z $SERVICE_SELECTED ]]
then
  SERVICES "Please select a service from the list"
else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi
  echo -e "\nWhen would you like to schedule your appointment"
  read SERVICE_TIME
  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone= '$CUSTOMER_PHONE'")
  echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
fi
