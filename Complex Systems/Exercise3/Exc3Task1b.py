import numpy as np
from scipy import integrate
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

def Euler(s, k, x_0, tau, tFinal):
    # initialize lists
    states = []
    x = x_0
    R = ReactionRates(k,x) 
    timepoints = np.arange(0,tFinal,tau)
    
    for time in timepoints:
        states.append(x[1])
        R = ReactionRates(k,x)  
        x += np.dot(s,R) *  tau
        
    return timepoints, states

def ODESolver(x_0, tau, tFinal):
    # initialize lists
    t = 0.0
    x = x_0

    test = []
    current = 0
    while current < tFinal*:
        test.append(current)
        current *= tau

    timepoints = np.arange(0,tFinal,tau)
    sol = solve_ivp(RHS,[t,tFinal],x, methode='RK45',t_eval=timepoints)
    return sol.t, sol.y[1]

def ReactionRates(k,X):
        R = np.zeros((4,1))
        R[0] = k[0]*X[0]
        R[1] = k[1]*X[0]*X[1]
        R[2] = k[2]*X[0]*X[1]
        R[3] = k[3]*X[1]
        return R[:,0]

def RHS(t,y):
    dx= np.dot(s,ReactionRates(k,y))
    return dx

inputFile = np.loadtxt('Input1.txt')

# Stoichiometric matrix
global s
s = np.array([[1,-1,-1,0],[0,0,1,-1]])

# Reaction parameters
lamda = 0.3
k1 = 0.01
k2 = 0.01
delta2 = 0.3

global k
k = [lamda, k1, k2, delta2]

# Initial state
x_0 =[int(inputFile[0]), int(inputFile[1])]
tau = [0.01,0.02,0.05,0.1]
tFinal = 100
t_0 = 0

error =[]
for time in tau:
    timepoints = np.arange(0,tFinal+time,time)
    Euler_t, Euler_s = Euler(s, k, x_0, time, tFinal+time)
    ODE_t, ODE_s = ODESolver(x_0, time, tFinal+time)
    
    plt.figure()
    plt.plot(Euler_t,Euler_s)
    plt.plot(ODE_t,ODE_s)
    plt.show()
    
    error.append(1/len(timepoints)*sum(np.abs(Euler_s-ODE_s)))

output = np.concatenate((np.array(tau,ndmin=2),np.array(error,ndmin=2)), axis=0)

np.savetxt('Error1bTraj.txt',output,delimiter = ',',fmt='%1.3f')