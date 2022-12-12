#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 12 14:37:17 2022

@author: Group 7
""" 
 
import numpy as np
#import matplotlib.pyplot as plt  
from scipy.optimize import curve_fit 
from scipy.integrate import odeint
  

def ReactionRates(X,c2,c3,c4,c5):  
        k = [100, 0.1] 
        R = np.zeros((6,1))
        R[0] = k[0]
        R[1] = k[1]*X[1]
        R[2] = c2*X[0]*X[2]
        R[3] = c3*X[1]
        R[4] = c4*X[1]
        R[5] = c5*X[2]
        return R[:,0]   
 
def ModelPrediction(t_data, c2,c3,c4,c5): 
    y = odeint(RHS, X.flatten('F'), t_data, args = (c2,c3,c4,c5), tfirst = True) 
    return y[:,2] 
  
def RHS(t_data, X, c2, c3, c4, c5):  
    R = ReactionRates(X, c2, c3, c4, c5)
    dx = np.dot(s, R)
    return dx.flatten('F')


# Stoichiometric matrix 

s = np.transpose(np.array([[1,0,0],[-1,0,0],[-1,1,-1],[0,-1,0],[0,0,1],[0,0,-1]]))

# Reaction parameters 

k = [100, 0.1]  
X = np.array([k[0]/k[1], 0, 20])
t_data, y_data = np.load('Data.npy')   


popt, pcov = curve_fit(ModelPrediction, t_data, 
                       y_data,bounds=(0,np.inf)) 
                       #p0 = np.array([0.1, 1, 5, 1])) 
 
# Best - fitted parameters  

print([ "{:1.2f}".format(x) for x in popt ])