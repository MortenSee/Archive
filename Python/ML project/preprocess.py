# -*- coding: utf-8 -*-
"""
Created on Thu Jun 11 18:37:09 2020

@author: Morten

Slice all files into 1 seconds long chunks, padds files longer than 650ms to 1s
assumed directory structure:
"""


from pydub import AudioSegment
from pydub.utils import make_chunks
import librosa
import os

def main():
    
    # The used databases are:
    path='data/'
    # The Ryerson Audio-Visual Database of Emotional Speech and Song (RAVDESS)
    # https://zenodo.org/record/1188976#.XN0fwnUzZhE
    RAVDESS = path+'RAVDESS'
    # Berlin Database of Emotional Speech (EmoDB)
    # http://emodb.bilderbar.info/docu/
    EmoDB = path+'EmoDB'
    # desired filelength in ms
    CHUNK_LENGTH=1000
    # pad files above and remove files less than 
    MIN_CHUNK=650
    

    # =============================================================================
    # deletion of files of wrong labels
    # =============================================================================
    # RAVDESS:
    # Filename identifiers , delimiter '-'
    # Modality (01 = full-AV, 02 = video-only, 03 = audio-only).
    # Vocal channel (01 = speech, 02 = song).
    # Emotion (01 = neutral, 02 = calm, 03 = happy, 04 = sad, 05 = angry, 06 = fearful, 07 = disgust, 08 = surprised).
    # Emotional intensity (01 = normal, 02 = strong). NOTE: There is no strong intensity for the 'neutral' emotion.
    # Statement (01 = "Kids are talking by the door", 02 = "Dogs are sitting by the door").
    # Repetition (01 = 1st repetition, 02 = 2nd repetition).
    # Actor (01 to 24. Odd numbered actors are male, even numbered actors are female).
    
    # number_of_labels=6
    # rav_labels=[4,5,1,3,6,7]
    # emo_labels=['T','W','N','F','A','E']
    
    # for actors in os.listdir(RAVDESS):
    #   for file in os.listdir(RAVDESS +'/'+ actors):
    #     info = file.split('-')
    #     emotion = int(info[2])
    #     if emotion not in rav_labels[:number_of_labels]: 
    #         filename='/'.join([RAVDESS,actors,file])
    #         os.remove(filename)
    #         print(filename + ' has been removed successfully')
            
      
    # Every utterance is named according to the same scheme:
    # Positions 1-2: number of speaker
    # Positions 3-5: code for text
    # Position 6: emotion (sorry, letter stands for german emotion word)
    # Position 7: if there are more than two versions these are numbered a, b, c ....
    
    
    # for files in os.listdir(EmoDB):
    #     emotion=files[5]
    #     if emotion not in emo_labels[:number_of_labels]:
    #         filename='/'.join([EmoDB,files])
    #         os.remove(filename)
    #         print(filename + ' has been removed successfully')
            
            
    path_to_save='data/split'
            
    # =============================================================================
    # cut all ravdess files into 1s chunks and export them
    # =============================================================================
    
    for actors in os.listdir(RAVDESS):
        for file in os.listdir(RAVDESS + '/' + actors):
            path='/'.join([RAVDESS,actors,file])
            
            #cut silence from start and end
            pre_signal,_= librosa.load(path,sr=16000)
            trim,_=librosa.effects.trim(pre_signal)
            librosa.output.write_wav(path, trim, sr=16000)
            #do the cutting into chunks
            
            signal=AudioSegment.from_file(path,format='wav')
            path2='/'.join([path_to_save,'RAVDESS', file])
            a=path2[:len(path2)-4]
            chunklength=CHUNK_LENGTH
            chunks=make_chunks(signal,chunklength)
            for i,chunk in enumerate(chunks):
                  newname='{a}-{i}.wav'.format(a=a,i=i)
                  print('exporting',newname)
                  chunk.export(newname,format='wav')
    # cut all emodb files into 1s chunks and export them
    # =============================================================================
    for files in os.listdir(EmoDB):
        path='/'.join([EmoDB,files])
        
        #cut silence from start and end
        pre_signal,_= librosa.load(path,sr=16000)
        trim,_=librosa.effects.trim(pre_signal)
        librosa.output.write_wav(path, trim, sr=16000)
        #do the cutting into chunks
        
        signal=AudioSegment.from_file(path,format='wav')
        path2='/'.join([path_to_save,'EmoDB',files])
        a=path2[:len(path2)-4]
        chunklength=CHUNK_LENGTH
        chunks=make_chunks(signal,chunklength)
        for i,chunk in enumerate(chunks):
              newname='{a}-{i}.wav'.format(a=a,i=i)
              print('exporting',newname)
              chunk.export(newname,format='wav')
    
    # =============================================================================
    # padding files that are nearly 1s to 1s and deleting the rest
    # =============================================================================
    
    for databases in os.listdir(path_to_save):
        for file in os.listdir(path_to_save + '/'+databases):
            filename='/'.join([path_to_save,databases, file])
            signal=AudioSegment.from_file(filename,format='wav')
            duration=len(signal)
            if MIN_CHUNK <= duration < CHUNK_LENGTH:
                padding=CHUNK_LENGTH-duration
                silence=AudioSegment.silent(duration=padding)
                padded_singal= signal+silence
                print('padded  ',filename)
                padded_singal.export(filename,format='wav')
            elif duration <MIN_CHUNK:
                os.remove(filename)
            
            
    # =============================================================================
    # check all filelengths
    # =============================================================================
    for databases in os.listdir(path_to_save):             
        for files in os.listdir(path_to_save + '/'+ databases):
            filename='/'.join([path_to_save,databases,files])
            signal=AudioSegment.from_file(filename,format='wav')
            duration=len(signal)
            if duration != CHUNK_LENGTH: print('Error: ',filename)
        

    
    


