import pathlib
import glob
import pandas as pd

import csv
import json

dataFields = ("Data as of", "Start week", "End Week", "State", "Sex", "Age", "group", "COVID-19 Deaths", "Total Deaths",
              "Pneumonia Deaths", "Pneumonia and COVID-19 Deaths", "Influenza Deaths", "Pneumonia",
              "Influenza or COVID-19 Deaths", "Footnote")


def make_json(csvFilePath, jsonFilePath):
    data = {}

    with open(csvFilePath, 'r', encoding='utf-8') as csvf:
        csvfReader = csv.DictReader(csvf)  # , dataFields)
        rows = list(csvfReader)
    csvf.close()

    with open(jsonFilePath, 'w', encoding='utf-8') as jsonf:
        json.dump(rows, jsonf)






