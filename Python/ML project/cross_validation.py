# -*- coding: utf-8 -*-
"""
Created on Thu Jun 18 12:28:49 2020

@author: Morten

split Data into 5 sets for CV purposes with help of
https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.StratifiedShuffleSplit.html#sklearn.model_selection.StratifiedShuffleSplit

ids is a list of 5 lists of the form [training_ids,test_ids] where training_ids and test_ids are lists of ids.
"""


import os
import numpy as np
import pickle
from sklearn.model_selection import StratifiedShuffleSplit

def main(filename,option):
    # Change to correct datafile including path if not in the same directory
    datafile=filename
    id_file='CV-ids-for-'+datafile
    
    #load database as data
    with open(datafile,'rb') as f:
          data=pickle.load(f)
         
    '''
     database assumed to be ordered as follows:
         ravdess data
         emodb data
    '''
    
    #EmoDB and RAVDESS folders location relative to location of this file.
    RVD_SIZE=count_files(data[0],'RAVDESS')
    EDB_SIZE=len(data[0]) - RVD_SIZE
    
    rvd_labels=data[1][0:RVD_SIZE]
    emo_labels=data[1][RVD_SIZE:]
    
    # number k of CV sets
    k=5
    emodb_ids=[]
    rvd_ids=[]
    
    sss = StratifiedShuffleSplit(n_splits=k, test_size=0.2, random_state=1)
    
    # splits ravdess data into 5 CV sets s.t. labels are evenly distributed among test and training sets for each CV set.
    for train_index,test_index in sss.split(np.zeros(RVD_SIZE),rvd_labels):
       rvd_ids.append(train_index)
       rvd_ids.append(test_index)
       
    # splits emodb data into 5 CV sets s.t. labels are evenly distributed for each set.
    for train_index,test_index in sss.split(np.zeros(EDB_SIZE),emo_labels):
       emodb_ids.append(RVD_SIZE + train_index)
       emodb_ids.append(RVD_SIZE + test_index)
       
    #Combines the ravdess and emodb sets to create 5 CV sets 
    ids=[]
    for i in range(k):
        trainings_ids_1=rvd_ids[2*i]
        trainings_ids_2=emodb_ids[2*i]
        trainings_ids=np.append(trainings_ids_1,trainings_ids_2)
        
        test_ids_1=rvd_ids[2*i + 1]
        test_ids_2=emodb_ids[2*i + 1]
        test_ids=np.append(test_ids_1,test_ids_2)
        ids.append([trainings_ids,test_ids])
        
    with open(id_file,'wb') as f:
        pickle.dump(ids,f)
        
        
    # =============================================================================
    # 
    # split the database acording to the ids obtained above
    # 
    # =============================================================================
        
    #converting data lists to np.array for ease of indexing
    namearray=np.array(data[0])
    labelarray=np.array(data[1]) 
    specarray=np.array(data[2])
    svmarray=np.array(data[3])
        
    
    for i in range(5):
        #get ids
        training_ids=ids[i][0].tolist()
        test_ids=ids[i][1].tolist()
        #get training data
        training_names=namearray[training_ids].tolist()
        training_labels=labelarray[training_ids].tolist()
        training_spec=specarray[training_ids].tolist()
        training_svm=svmarray[training_ids].tolist()
        
        training_data=[training_names,training_labels,training_spec,training_svm]
        #get test data
        test_names=namearray[test_ids].tolist()
        test_labels=labelarray[test_ids].tolist()
        test_spec=specarray[test_ids].tolist()
        test_svm=svmarray[test_ids].tolist()
        
        test_data=[test_names,test_labels,test_spec,test_svm]
        
        print('processing batch nr:',i)
        #combine into one to save to file
        batch=[training_data,test_data]
        batchname='Batch_'+str(i)+'-'+datafile
        with open(batchname,'wb') as f:
            pickle.dump(batch,f)
            
            
    print('Done with CV set creation!')
        
    
    

def count_files(data,match):
    i=0
    for string in data:
        if string.split('/')[2] == match:
            i+=1
    return i-1















