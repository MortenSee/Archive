# -*- coding: utf-8 -*-
"""
Created on Sat Jun 13 15:50:07 2020

@author: Morten

fix spectograms that have missing columns.
"""


import pickle
import numpy as np

def main(data,filename):
    #name of database file to fix
    # path_to_database=filename
    
    # with open(path_to_database,'rb') as f:
    #       data=pickle.load(f)
         
         
    ids=[]
    
    
    # get Ids where spectograms dont have the correct size
    for i,x in enumerate(data[2]):
        if x.shape !=(128,126):
            ids.append(i)
    
    total=len(ids)
    print('found: ',total)
    # loop through all faulty entries and fix them
    for i in ids:
    
        x=data[2][i]
        # extract last row as (1,128) array
        last_row= np.atleast_2d(x[:,-1])
        # reshape to (128,1)
        last_row=np.reshape(last_row,(128,1))
        n, m = x.shape
        
        for j in range(126-m):
            # append to (128,125) array    
            x=np.append(x,last_row,axis=1)
        
        
        data[2][i]=x
        
        #need to save within the loop for some weird reason otherwise it doesnt work.
        # with open(path_to_database,'wb') as f:
        #     pickle.dump(data,f)
        
    print('Done with spectograms!')
    
    ids=[]
    for i,x in enumerate(data[3]):
        if x.shape !=(1638,):
            ids.append(i)
            
    total=len(ids)        
    for i in ids:
    
        x=data[3][i]
        # duplicate the last 13 entries to pad entries of incorrect length
        last_entries= x[-13:]
        n, = x.shape
        number_of_cycles=(1638-n)//13
        for j in range(number_of_cycles):
            x=np.append(x,last_entries)
        
        
        data[3][i]=x
        
        #need to save within the loop for some weird reason otherwise it doesnt work.
        # with open(path_to_database,'wb') as f:
        #     pickle.dump(data,f)
    with open(filename,'wb') as f:
            pickle.dump(data,f)
            
    print('Done with SVM input!')