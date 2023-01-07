#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 12 14:37:17 2022

@author: Group 7
""" 
 
import numpy as np
import matplotlib.pyplot as plt  
from scipy.optimize import curve_fit 
from scipy.integrate import odeint
  

def ReactionRates(X,c2,c3,c4,c5):  
        R = np.zeros((6,1))
        R[0] = k[0]
        R[1] = k[1]*X[1]
        R[2] = c2*X[0]*X[2]
        R[3] = c3*X[1]
        R[4] = c4*X[1]
        R[5] = c5*X[2]
        return R[:,0]   
 
def ModelPrediction(t_data, c2,c3,c4,c5): 
    y = odeint(RHS, X.flatten('K'), t_data, args = (c2,c3,c4,c5), tfirst = True) 
    return y[:,2]
  
def RHS(t, X, c2, c3, c4, c5):  
    R = ReactionRates(X, c2, c3, c4, c5)
    dx = np.dot(np.transpose(s), R)
    return dx.flatten('K')

global s, k, X 
# Stoichiometric matrix 

s = np.array([[1,0,0],[-1,0,0],[-1,1,-1],[0,-1,0],[0,0,1],[0,0,-1]])
#np.transpose()
# Reaction parameters 

k = [100, 0.1]  
X = np.array([k[0]/k[1], 0, 20])
t_data, y_data = np.load('Data.npy')   


popt, pcov = curve_fit(ModelPrediction, t_data, 
                       y_data, bounds=(0,np.inf)) 
                       #,p0 = np.array([0.1, 1, 5, 1]))  
                         
                     
 
# Best - fitted parameters  

print([ "{:1.2f}".format(x) for x in popt ])   
 
# Plotting the graph 

plt.plot(t_data, ModelPrediction(t_data, *popt), 'k',  
         label='prediction')  
plt.plot(t_data, y_data, ':bs', label='data') 
plt.xlabel('time')
plt.ylabel('Number Viruses')
plt.legend()
plt.show() 
 
"""
Add p0 = np.random.rand(4) to curve_fit for task 1b  
to perform the parameter estimation 30 times with  
random start parameters, and making boxplots.

""" 