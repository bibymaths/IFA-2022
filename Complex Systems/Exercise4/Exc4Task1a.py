#Group 7 BrenningmeyerHerkenrathMishra

import numpy as np
import matplotlib.pyplot as plt
from scipy import optimize, integrate

# Computes reaction rates with unknown parameters [c2,c5]
def propensities(X, c2, c3, c4, c5):
        R = np.zeros((6,1))
        R[0] = k[0]
        R[1] = k[1]*X[1]
        R[2] = c2*X[0]*X[2]
        R[3] = c3*X[1]
        R[4] = c4*X[1]
        R[5] = c5*X[2]
        return R[:,0]

def RHS(t, X, c2, c3, c4, c5):
    R = propensities(X, c2,c3,c4,c5)
    dX = np.dot(s, R)
    return dX.flatten('F')

def ModelPrediction(t_data, c2,c3,c4,c5):
    y = integrate.odeint(RHS, X0.flatten('F'), t_data, args=(c2,c3,c4,c5),tfirst=True)
    return y[:,2]

# Stoichiometric matrix
global s, k, X0
s = np.array([[1,-1,-1,0,0,0],[0,0,1,-1,1,0],[0,0,-1,0,0,-1]])

# Reaction parameters
k0 = 100
k1 = 0.1
k = [k0, k1]

# Initial states 
X0 = np.array([k0/k1, 0, 20])

# Trajectory of virus concentration in patient
t_data, y_data = np.load('Data.npy')

# Sumbmit with first line uncommented and second line commented
popt, pcov = optimize.curve_fit(ModelPrediction, t_data,y_data, bounds=(0,np.inf))
#popt, pcov = optimize.curve_fit(ModelPrediction, t_data, y_data.copy(), bounds=(0,np.inf), p0=[0.1,1,5,1])
np.savetxt('Params.txt',popt,delimiter = ',',fmt='%1.2f')

y_sim = ModelPrediction(t_data, popt[0], popt[1], popt[2], popt[3])

print('Diff from ref: \n{},\n{},\n{},\n{}'.format(popt[0]-0.0,popt[1]-0.65,popt[2]-10.18,popt[3]-13.3))

plt.plot(t_data, y_data, label = 'Virus concentration')
plt.plot(t_data, y_sim, label='simulation')
plt.legend()
plt.show()
