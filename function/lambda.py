#------------------------------#
#-----------Imports------------#
#------------------------------#
import os
import logging
import boto3
import csv
import json
import pytz
import concurrent.futures
from boto3.dynamodb.conditions import Key, Attr
from datetime import datetime, timedelta, date
from botocore.exceptions import ClientError
from tydirium import Tydirium


#------------------------------#
#--------OS Environment--------#
#------------------------------#

#------------------------------#
#----------Debugging-----------#
#------------------------------#
# set logging level- value options = CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET
logger = logging.getLogger('DelEbsSnapshots')
logger.setLevel(logging.DEBUG)

event = {
  "Name": "Rell",
  "Phone": "2025555555",
  "email": "email@email.com"
}

#------------------------------#
#----------Functions-----------#
#------------------------------#
def lambda_handler(event, context):
    