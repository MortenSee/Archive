# -*- coding: utf-8 -*-
"""
Created on Wed Jun 10 10:52:36 2020

@author: Morten
"""

import os
import librosa
import numpy as np
import librosa.feature as libf
import pickle
from pydub import AudioSegment

def main(process, number_of_emotions):
    # =============================================================================
    # This file collects all audio files and runs through the following procedures
    # 
    # 1. asembles them in to a Nx2 matrix with N being the number of files and 
    #    the first argument is the .wav file, the second argument is the label where 
    #    1 is 'sad' and -1 is 'angry'
    # 
    # 2. compute 2 LLDs 
    #   1. MFCC 
    #   2. Estimated Tempo in BPM
    # possible other LLDs are
    #   3.  Chroma
    #   4.  Root-mean-squared Energy
    #   5.  Zero-crossing Rate
    #   6.  Spectral Centroid
    #   7.  Spectral Bandwith
    #   8.  Spectral Rolloff
    #   9.  Spectral Flatness
    #   10. Spectral Contrast
    # but none of these are used at this moment
    # 3. generate Mel-frequency scaled Spectogram 
    # 4. Add Spectogram as well as both LLDs to the data array
    #
    # At the end the data array is Nx4
    # data[0] = array of filenames
    # data[1] = array of emotion labels , 1='sad', -1='angry'
    # data[2] = array of mel-spectograms
    # data[3] = array of SVM input-vectors 
    # 
    # to reduce dimensionality of the svm vector one could compute 
    # min,max,mean,stddev and range of mfccs instead of using them as is.
    # =============================================================================
    # The used databases are:
    
    # The Ryerson Audio-Visual Database of Emotional Speech and Song (RAVDESS)
    # https://zenodo.org/record/1188976#.XN0fwnUzZhE
    
    # Berlin Database of Emotional Speech (EmoDB)
    # http://emodb.bilderbar.info/docu/
    
    # We considered adding the Toronto emotional speech set (TESS) but
    # ultimately decided against it due to the mismatch in utterances
    # while RAVDESS and EmoDB used different regular sentences, TESS only ever changed a single word
    # in it's phrase :  "Say the word _____' 

    
    #path to preprocessed files
    std_emo_paths=['data/split/EmoDB']
    std_rav_paths=['data/split/RAVDESS']

    aug_emo_paths = ['data/augmented/EmoDB']
    aug_rav_paths = ['data/augmented/RAVDESS']
    
    if process=='std':
        rav_paths=std_rav_paths
        emo_paths=std_emo_paths
        prefix='unaugmented-'
    elif process=='aug':
        rav_paths=aug_rav_paths
        emo_paths=aug_emo_paths
        prefix='augmented-'
    else:
        rav_paths=std_rav_paths + aug_rav_paths
        emo_paths=std_emo_paths + aug_emo_paths
        prefix=''
    
  
    # Data matrix 
    data=[[],[],[],[]]
    
    
    rav_labels=[4,5,1,3,6,7]
    emo_labels=['T','W','N','F','A','E']
    
    labels=[1,2,3,4,5,6]
    
    
    # =============================================================================
    # collect all files from RAVDESS  
    # Emotion is the third index
    # (01 = neutral, 02 = calm, 03 = happy, 04 = sad, 05 = angry, 06 = fearful, 07 = disgust, 08 = surprised).
    # =============================================================================
    
    for RAVDESS in  rav_paths:
        for file in os.listdir(RAVDESS):
            info = file.split('-')
            emotion = int(info[2])
            filename='/'.join([RAVDESS, file])
            if emotion in rav_labels[:number_of_emotions]:
                label=labels[rav_labels.index(emotion)]
                data[0].append(filename)
                data[1].append(label)
        
    
    # =============================================================================
    # collect all files from Berlin-EmoDB
    # Position 6: emotion (T=Traurig|Sad , W=Wütend|Angry)
    # =============================================================================
    for EmoDB in emo_paths:
        for files in os.listdir(EmoDB):
            emotion=files[5]
            if emotion in emo_labels[:number_of_emotions]:
                label=labels[emo_labels.index(emotion)]
                filename='/'.join([EmoDB,files])
                data[0].append(filename)
                data[1].append(label)
    
    # =============================================================================
    # process all files for steps 2 to 5
    # =============================================================================
    # length of the windowed signal after padding with zeros. in speech processing
    # the recommended length in speech processing is the nearest power of 2 to
    # sampling_rate*0.025 (25ms windows).While Ravdess files are sampled at 44k hz
    # EmoDB files are only provided at 16kHz thus we'll use 512 windows and a hop length of 128.
    
    #presets
    n_fft=512
    hop_length=128
    sampling_rate=16000
    #number of mfccs to use for svm
    n_mfcc=26
    # number of mfccs to use for spectogram ( first spectogram dimension)
    n_mels=128
    
    for filename in data[0]:
        audio, _ = librosa.load(filename,sr=sampling_rate)
        
        # step 2
        # 2.1 MFCC
        mfccs = libf.mfcc(audio,sampling_rate,n_mfcc=n_mfcc,n_fft=n_fft,hop_length=hop_length)
        #keep 13 mfccs to increase model accuracy
        mfccs= mfccs[:13][:]
        # assemble mfccs into 1x
        n,m=np.shape(mfccs)
        svm_vec=np.reshape(mfccs,n*m,order='C')
        #add to data
        data[3].append(svm_vec)
    
        
        # 2.2 estimated BPM
        # librosa.beat.tempo(audio,sr=sampling_rate,hop_length=hop_length)
        
        # 2.3 Chroma via STFT 
        # chroma = libf.chroma_stft(audio,sampling_rate,n_fft=n_fft,hop_length=hop_length)
        
        # 2.4 Root-mean-squared Energy
        # rms = libf.rms(audio,frame_length=n_fft,hop_length=hop_length)
        
        # 2.5 Zero crossing rate
        # zcr = libf.zero_crossing_rate(audio, frame_length=n_fft,hop_length=hop_length) 
        
        # 2.6 Spectral Centroid
        # spec_centroid = libf.spectral_centroid(audio,sampling_rate,n_fft=n_fft,hop_length=hop_length)
        
        # 2.7 Spectral bandwidth
        # spec_bandwidth = libf.spectral_bandwidth(audio,sampling_rate,n_fft=n_fft,hop_length=hop_length)
        
        # 2.8 Spectral Rolloff
        # spec_rolloff = libf.spectral_rolloff(audio,sampling_rate,n_fft=n_fft,hop_length=hop_length)
        
        # 2.9 Spectral flatness
        # spec_flat = libf.spectral_flatness(audio,n_fft=n_fft,hop_length=hop_length)
        
        # 2.10 Spectral Constrast
        # spec_contrast = libf.spectral_contrast(audio,sampling_rate,n_fft=n_fft,hop_length=hop_length)
        
        spectogram= libf.melspectrogram(audio,sampling_rate,n_fft=n_fft,hop_length=hop_length,n_mels=n_mels)
        #add to data
        data[2].append(spectogram)
        
        
    # =============================================================================
    # save database to disk as binary file
    # =============================================================================
    # get filelength
    file=data[0][0]
    signal=AudioSegment.from_file(file,format='wav')
    duration=len(signal)
    #generate appropriate name for database
    filename='-'.join([prefix,'database',str(duration) + 'ms',str(n_mfcc) + 'SVM_mfccs',str(n_mels) + 'Spectogram_mfccs'])
    #save database
    # with open(filename,'wb') as f:
    #     pickle.dump(data,f)
    
    return filename, data
    


