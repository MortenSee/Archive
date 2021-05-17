# -*- coding: utf-8 -*-
"""
Created on Fri Jun 26 12:10:25 2020

@author: Morten

Augmenting the data to test robustness of our classifiers against noise and pitch-shifting
"""

import os
import numpy as np
import librosa

def main():
    #path to split files
    base_path='data/split'
    
    
    # sampling rate provided by emodb
    sr=16000
    #pitch shift in semitones
    pitches=[-12, -6, 0, 6, 12]
    pitchlevels=['m12','m6','0','p6','p12']
    # magnitued for noise generation, symetric, 0 = no noise , 1+ =  VERY loud noise
    noisyness=np.array([0, 0.005, 0.05])
    # noise level description for filenames
    noiselevel=['no-noise','slight-noise','strong-noise']
    
    #seed random to 0
    np.random.seed(0)
    # produce noise signal at 16khz
    noise_factor = np.random.uniform() *noisyness
    noise_signal=np.random.normal(size=16000)
    # for printing progress. 
    i=0
    
    for directories in os.listdir(base_path):
        
        for files in os.listdir(base_path+'/'+ directories):    
            print('augmented ',i,' file(s)')
            i+=1
            for j,pitch in enumerate(pitches):
                
                for k,noise in enumerate(noisyness):
                    #dont save files that wont be augmented at all
                    if not pitch==noise==0:
                        #load file
                        filepath='/'.join([base_path,directories,files])
                        signal,_ = librosa.load(filepath,sr=sr)
                        #change pitch
                        shifted_signal=librosa.effects.pitch_shift(signal, sr=sr,n_steps=pitch)
                        #scale noise to magnitude of signal
                        scale_factor= noise_factor[k]*np.amax(signal)
                        #add noise to signal
                        noisy_signal= shifted_signal + scale_factor * noise_signal[:shifted_signal.shape[0]]
                        # wav needs to be float32, converting as a precaution
                        noisy_signal= noisy_signal.astype('float32')
                        
                        #construct new filepath
                        newpath = '/'.join(['data/augmented',directories,files])
                        newpath= newpath[:-4] + '_pitch-'+pitchlevels[j] + '_'+ noiselevel[k] + '.wav' 
                        #save file to disk
                        librosa.output.write_wav(path=newpath, y=noisy_signal, sr=sr)
        
 