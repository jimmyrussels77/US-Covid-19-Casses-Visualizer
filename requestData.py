import requests
import re
import os
from time import time

from multiprocessing.pool import ThreadPool


def getFileName_fromCd(cd):
    if not cd:
        return None

    fn = re.findall('filename=(.+)', cd)

    if len(fn) == 0:
        return None

    return fn[0]


def download_file(url):
    print("downloading", url)
    r = requests.get(url, allow_redirects=True, stream=True)  # get file
    filename = getFileName_fromCd(r.headers.get('content-disposition'))
    if r.status_code == requests.codes.ok:
        with open(filename, 'wb') as f:
            for data in r:
                f.write(data)
    return url


# Links in order are as follows:
# Death count by week ending date and state download link
# Provisional COVID-19 Death Counts by Sex, Age, and State
# Provisional COVID-19 Deaths: Focus on Ages 0-18 Years
# Provisional COVID-19 Death Counts by Sex, Age, and Week
# Provisional COVID-19 Death Counts in the United States by County
# Provisional Death Counts for Influenza, Pneumonia, and COVID-19
urls = ['https://data.cdc.gov/api/views/r8kw-7aab/rows.csv?accessType=DOWNLOAD',
        'https://data.cdc.gov/api/views/9bhg-hcku/rows.csv?accessType=DOWNLOAD',
        'https://data.cdc.gov/api/views/nr4s-juj3/rows.csv?accessType=DOWNLOAD',
        'https://data.cdc.gov/api/views/vsak-wrfu/rows.csv?accessType=DOWNLOAD',
        'https://data.cdc.gov/api/views/kn79-hsxy/rows.csv?accessType=DOWNLOAD',
        'https://data.cdc.gov/api/views/ynw2-4viq/rows.csv?accessType=DOWNLOAD',
        ]

results = ThreadPool(5).imap_unordered(download_file, urls)
for r in results:
    print(r)
