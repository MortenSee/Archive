# -*- coding: utf-8 -*-
"""
Created on Tue Apr  6 13:27:28 2021

@author: Pelle
"""

import pygame
import sys
from pygame.locals import *


pygame.init()

# Global variables
PX = 70
ROWS = 5
COLS = 5
WIDTH = COLS * PX
HEIGHT = ROWS * PX
CANVAS = pygame.display.set_mode((WIDTH,HEIGHT))
BLACK = (0,0,0)
WHITE = (255,255,255)
CLOCK = pygame.time.Clock()


class cell():
    # cells of the game of life
    def __init__(self,x,y):
        self.x = x
        self.y = y
        self.state = 0
    def display(self):
        color = WHITE if self.state else BLACK
        pygame.draw.rect(CANVAS,color,(self.x,self.y,PX,PX))
    def flip(self):
        self.state = not self.state
    

#populate cells
CELLS = [ [cell(PX*x,PX*y) for x in range(COLS)] for y in range(ROWS)] 


#game loop
while True:
    CLOCK.tick(2)
    #detect quit
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            sys.exit()   
            
    for rows in CELLS:
        for element in rows:
            if element.x % 140 == 0:
                element.flip()
            element.display()
        
    #update visuals
    pygame.display.update()
    # pygame.time.delay(250)
    
    
    
