# -*- coding: utf-8 -*-
"""
Created on Fri Jun 22 15:01:26 2018

@author: kk
"""

import requests
import json
import os.path

url = "http://comtrade.un.org/api/get?"

years = list(range(2016,2017))
years_str = [str(year) for year in years]

with open('partnerCode.json') as codef:
    r = json.load(codef)
reportercodes = [result['id'] for result in r['results']]

n = 5
years_group = [','.join((years_str[i:i + n])) for i in range(0, len(years_str), n)]
reportercodes_group = [','.join((reportercodes[i:i + n])) for i in range(0, len(reportercodes), n)]

header = "Classification,Year,Period,Period Desc.,Aggregate Level,Is Leaf Code,Trade Flow Code,Trade Flow,Reporter Code,Reporter,Reporter ISO,Partner Code,Partner,Partner ISO,2nd Partner Code,2nd Partner,2nd Partner ISO,Customs Proc. Code,Customs,Mode of Transport Code,Mode of Transport,Commodity Code,Commodity,Qty Unit Code,Qty Unit,Qty,Alt Qty Unit Code,Alt Qty Unit,Alt Qty,Netweight (kg),Gross weight (kg),Trade Value (US$),CIF Trade Value (US$),FOB Trade Value (US$),Flag\r\n"
data = header.replace('\r','')
for year in years_group:
    for reportercode in reportercodes_group:
        if(not(os.path.isfile(reportercode+"_"+year+'.txt'))):
            parameters = {"max":"50000","type":"C","freq":"A","px":"HS",
                  "ps":year,"r":reportercode,
                  "p":"all","rg":"all","cc":"0105","fmt":"csv"}
            myResponse = requests.get(url,params = parameters)
            tmpdata = myResponse.text
            if(len(tmpdata)>611):
                data +=tmpdata.replace(header,"")
                print("Poultry trade data of "+reportercode+" in "+year + " has been exported!")
#                f=open(reportercode+"_"+year+'.txt','w',encoding='utf-8')
#                f.write(data_csv)
#                f.close()
    print("all countries of "+year+" finished!")
print("all data has been exported!")
