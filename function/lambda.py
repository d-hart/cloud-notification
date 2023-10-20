#------------------------------#
#-----------Imports------------#
#------------------------------#
import os
import logging
import boto3
import csv
import json
from boto3.dynamodb.conditions import Key, Attr
from datetime import datetime, timedelta, date
from botocore.exceptions import ClientError

#OS Environment------------------------------------------------------------------------------#
accounts_table = os.environ['account_table']

#Debugging------------------------------------------------------------------------------#
# set logging level- value options = CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET
logger = logging.getLogger('DelEbsSnapshots')
logger.setLevel(logging.DEBUG)

event = {
  "Name": "Rell",
  "Phone": "2025555555",
  "email": "email@email.com"
}

#Functions------------------------------------------------------------------------------#
def lambda_handler(event, context):
    name = event['Name']
    phone = event["Phone"]
    email = event["email"]
    