#Group 7 BrenningmeyerHerkenrathMishra

import numpy as np

def Euler(s, k, x_0, tau, tFinal):
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

        # Update time
        t += tau
        if t > tFinal:
            break

        # Update states
        x += np.dot(s,R) *  tau
        times.append(t)
        states.append(x[1])

    return times, states


def ReactionRates(k,X):
        R = np.zeros((4,1))
        R[0] = k[0]*X[0]
        R[1] = k[1]*X[0]*X[1]
        R[2] = k[2]*X[0]*X[1]
        R[3] = k[3]*X[1]
        return R[:,0]

inputFile = np.loadtxt('Input1.txt')

# Stoichiometric matrix
s = np.array([[1,-1,-1,0],[0,0,1,-1]])

# Reaction parameters
lamda = 0.3
k1 = 0.01
k2 = 0.01
delta2 = 0.3

k = [lamda, k1, k2, delta2]

# Initial state
x_0 =[int(inputFile[0]), int(inputFile[1])]
tau = 0.1
tFinal = 10

times, states = Euler(s, k, x_0, tau, tFinal)

output = np.concatenate((np.array(times,ndmin=2),np.array(states,ndmin=2)), axis=0)

np.savetxt('Task1aTraj.txt',output,delimiter = ',',fmt='%1.2f')

