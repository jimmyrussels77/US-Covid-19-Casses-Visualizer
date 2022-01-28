

import pymongo
import json
from pymongo import MongoClient

cluster = MongoClient("mongodb+srv://projectUser:user@cluster0.nxnvw.mongodb.net/Test?retryWrites=true&w=majority")
db = cluster["ProjectData"]
collection1 = db["DeathCountsbySexAgeState"]
collection2 = db["DeathCountsbySexAgeWeek"]
collection3 = db["DeathCountsbyWeekEndingDateState"]
collection4 = db["DeathCountsintheUnitedStatesbyCounty"]
collection5 = db["DeathsFocusonAges0-18Years"]
collection6 = db["DeathCountsforInfluenzaPneumoniaCOVID-19"]


with open('Provisional_COVID-19_Death_Counts_by_Sex__Age__and_State.json') as f:
    fileData = json.load(f)
    f.close()

with open('Provisional_COVID-19_Death_Counts_by_Sex__Age__and_Week.json') as f2:
    fileData2 = json.load(f2)
    f2.close()
with open('Provisional_COVID-19_Death_Counts_by_Week_Ending_Date_and_State.json') as f3:
    fileData3 = json.load(f3)
    f3.close()
with open('Provisional_COVID-19_Death_Counts_in_the_United_States_by_County.json') as f4:
    fileData4 = json.load(f4)
    f4.close()
with open('Provisional_COVID-19_Deaths__Focus_on_Ages_0-18_Years.json') as f5:
    fileData5 = json.load(f5)
    f5.close()
with open('Provisional_Death_Counts_for_Influenza__Pneumonia__and_COVID-19.json') as f6:
    fileData6 = json.load(f6)
    f6.close()


