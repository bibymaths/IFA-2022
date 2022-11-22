# Group 7 
# IFA WiSe 22-23 
# Block: complex systems 
# Exercise 1 : homework 4

import numpy as np

# A: -----Fixed Quantities-----
#0. initial state
X0 = np.loadtxt('Input.txt')

# ===> fill here, everywhere where a "..." is <===

#1. Stoichiometric matrix
S = np.array([[1,-1,-1,0,1],[0,0,1,-1,-1],[0,0,0,0,1],[0,0,-1,0,0]]); 
# !!check dimension of the array!!

#2. Reaction parameters
k = [5,3,12,7,3];


# B: functions that depend on the state of the system X
def ReactionRates(k,X):
        R = np.zeros((5,1))
        R[0] = 5
        R[1] = 3*X[0]
        R[2] = 12*X[0]*X[3]
        R[3] = 7*X[1]
        R[4] = 3*X[1]
        return R
# ===>       -----------------------     <===

# compute reaction propensities/rates
R = ReactionRates(k,X0)

#compute the value of the ode with time step delta_t = 1
dX = np.dot(S,R)

## a) save stoichiometric Matrix
np.savetxt('SMatrix.txt',S,delimiter = ',',fmt='%1.0f');
## b) save ODE value as float with 2 digits after the comma  
## (determined with the c-style precision argument e.g. '%3.2f')
np.savetxt('ODEValue.txt',dX,delimiter=',',fmt='%1.2f');
