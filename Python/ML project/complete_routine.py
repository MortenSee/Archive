# -*- coding: utf-8 -*-
"""
Created on Fri Jun 26 16:08:08 2020

@author: Morten
"""
import preprocess
import data_augmentation
import extract_and_assemble
import spectogram_fix
import cross_validation
import time


#Must be true if this is your first time running this script
#Set to false to skip splitting and augmenting the files.
preprocess_data=True


#choose number of emotions to use 
# range : 2-6
#Emotions used:
# ['sad','angry','neutral','happy','fearful','disgust']
# Lables
# [1, 2, 3, 4, 5, 6]
number_of_emotions=2
# Decide whether to include augmented data in the training
use_augmented_to_train=False

if preprocess_data:
    print('preprocessing now!')
    preprocess.main()
    data_augmentation.main()
    print('done with preprocessing!')
    
if use_augmented_to_train:   
    #extract features for all files at once
    filename, data =extract_and_assemble.main('', number_of_emotions)
    print('done with feature extraction')
    spectogram_fix.main(data,filename)
    print('fixed misshaped entries')
    cross_validation.main(filename,use_augmented_to_train)
    print('done with generating Cross validation datasets')
else:
    #extract features for unaugmented and augmented files seperately
    std_filename, std_data =extract_and_assemble.main('std', number_of_emotions)
    aug_filename, aug_data =extract_and_assemble.main('aug', number_of_emotions)
    #fix them
    spectogram_fix.main(std_data,std_filename)
    spectogram_fix.main(aug_data,aug_filename)
    print('fixed misshaped entries')
    # generate CV batches for training data
    cross_validation.main(std_filename,use_augmented_to_train)
    print('done with generating Cross validation datasets')
    



