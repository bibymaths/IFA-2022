# -*- coding: utf-8 -*-
"""
Created on Mon Dec 12 18:47:16 2022

@author: Group 7
"""
 
""" 
Snippet from the previous task: START 
"""
import numpy as np 
import pandas as pd 
import seaborn as sns
import statistics as stat
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
    y = odeint(RHS, X.flatten('K'), t_data,  
               args = (c2,c3,c4,c5), tfirst = True) 
    return y[:,2]
  
def RHS(t, X, c2, c3, c4, c5):  
    R = ReactionRates(X, c2, c3, c4, c5)
    dx = np.dot(np.transpose(s), R)
    return dx.flatten('K')

global s, k, X 
s = np.array([[1,0,0],[-1,0,0],[-1,1,-1], 
              [0,-1,0],[0,0,1],[0,0,-1]])
k = [100, 0.1]  
X = np.array([k[0]/k[1], 0, 20])
t_data, y_data = np.load('Data.npy')   
  
""" 
Snippet from the previous task: END
""" 
c2_par = [] 
c3_par = [] 
c4_par = [] 
c5_par = [] 
 
#################################
# parameter estimation 30 times #  
# with random start parameters  #
################################# 

for i in range(30):
    popt, pcov = curve_fit(ModelPrediction, t_data, 
                       y_data, bounds=(0,np.inf),
                       p0 = np.random.rand(4))    
     
###########################################
# Collect the inferred optimal parameters #  
###########################################  

    c2_par.append(popt[0]) 
    c3_par.append(popt[1]) 
    c4_par.append(popt[2])  
    c5_par.append(popt[3])  
  
opt = {'C2':c2_par,'C3':c3_par,'C4':c4_par,'C5':c5_par}

###########################################
# Normalization using mean values         #  
###########################################

opt_norm = {'C2':[x - int(stat.mean(c2_par)) for x in c2_par],
            'C3':[x - int(stat.mean(c3_par)) for x in c3_par],
            'C4':[x - int(stat.mean(c4_par)) for x in c4_par],
            'C5':[x - int(stat.mean(c5_par)) for x in c5_par]}

data = pd.DataFrame(opt)

data_norm = pd.DataFrame(opt_norm)


###########################################
# Boxplots with density and line  plots   #  
###########################################

sns.boxplot(data=data_norm, palette='flare').set_title('Mean Normalized Parameters Boxplot')

sns.displot(data=data_norm, kind="kde", fill=True).set(title='Mean Normalized Parameters Density Plot')

sns.lineplot(data=data)

plt.show()
