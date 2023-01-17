# -*- coding: utf-8 -*-
"""
Created on Thu May 31 18:59:29 2018

@author: kk
"""

import os
import pandas as pd
import wikipedia
from bs4 import BeautifulSoup
import csv

dir = "F:\\P2_WWAI\\birds\\movebank"
files = os.listdir(dir)
taxon=[]
birddict={}
for name in files:
    fullname = os.path.join(dir,name)
    if name.endswith(".csv"):
        df=pd.read_csv(fullname,low_memory=False)
        taxon = df['individual-taxon-canonical-name'].unique().tolist()
        birddict[name]=taxon

with open('animals_studies_dict.csv', 'wb') as csv_file:
    writer = csv.writer(csv_file)
    for key, value in birddict.items():
       writer.writerow([key, value])
#taxon = {x for x in taxon if x==x}
#sname=list(taxon)
#sname=birds107
cname=[]
order=[]
family=[]
birdclass=[]
errorbirds=[]
errorflag=0
for birdname in birds107:
    while True:
        try:
            birdpage=wikipedia.page(birdname)
            break
        except wikipedia.exceptions.DisambiguationError:
            errorbirds.append(birdname)
            errorflag=1
            break
        
    if errorflag==1:
        errorflag=0
        continue
    
    soup=BeautifulSoup(birdpage.html(),'html.parser')
    infotb=soup.find('table',attrs={'class':'infobox biota'})
    while True:
        try:
            birdclass.append(infotb.find("td", text="Class:").find_next_sibling("td").text)
            order.append(infotb.find("td", text="Order:").find_next_sibling("td").text)
            family.append(infotb.find("td", text="Family:").find_next_sibling("td").text)
            cname.append(infotb.find("th").contents[0])
            break
        except AttributeError:
            errorbirds.append(birdname)
            break
        

sname = birds107
for erbird in errorbirds:
    birds107.remove(erbird)
    
bird = [('sname',birds107),('cname',cname),('class',birdclass),('order',order),('family',family)]
birddf = pd.DataFrame.from_items(bird)
birddf.to_csv('F:/P2_WWAI/birds/movebank/animals2.csv', sep=',') 