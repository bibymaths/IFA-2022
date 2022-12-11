#Group 7 BrenningmeyerHerkenrathMishra

import numpy as np
import math

def ssa(s, k, x_0, tFinal):
    # initialize lists
    times = []
    states = []
    t = 0.0
    x = x_0
    times.append(t)
    states.append(x[1])

    while t <= tFinal:
        # When?  
        R = ReactionRates(k,x)
        lambdaVar = np.sum(R)

        # make sure we don't divide by zero
        u1 = np.random.random()
        while u1 == 0:
            u1 = np.random.random()
        tau = (1/lambdaVar) * np.log(1/u1)      

        # End time reached
        if t + tau > tFinal:
            t = tFinal
            break
        
        # Update time
        t += tau

        # What reaction happens
        goal = lambdaVar * np.random.random()
        currentSum = 0
        j = 0
        for i, rate in enumerate(R):
            currentSum+= rate
            if(currentSum > goal):
                j = i
                break
            j = i

        # Update states
        x += s[:,j]
        times.append(t)
        states.append(x[1])

    return times, states

def ReactionRates(k,X):
        R = np.zeros((2,1))
        R[0] = k[0]*X[0]
        R[1] = k[1]*X[1]
        return R[:,0]


np.random.seed(seed=int(np.loadtxt('Input2.txt')))

# Stoichiometric matrix
s = np.array([[-1,0],[1,-1]])

k_a = 0.5 #describing the uptake of the drug from the body, unit mg/L
k_e = 0.3 #describing the elimination of the drug from the body, unit mg/L

k = [k_a,k_e]

# Initial state
x_0 = [200,0]
tFinal = 24

times, states = ssa(s, k, x_0, tFinal)

# Extracting state values for the time points [0,1,2, ...,24]
timesOut = np.arange(tFinal+1)
statesOut = []
statesOut.append(0.0)
timesCounter = 0

for i in timesOut:
    for j in range(len(times)-1):
        if times[j] < i and times[j+1] > i:
            statesOut.append(states[j])
            break

if len(statesOut) < len(timesOut):
    for i in range (len(timesOut) - len(statesOut)):
        statesOut.append(states[-1])

    
output = np.concatenate((np.array(timesOut,ndmin=2),np.array(statesOut,ndmin=2)), axis=0)
np.savetxt('Task2aTraj.txt',output,delimiter = ',',fmt='%1.2f')