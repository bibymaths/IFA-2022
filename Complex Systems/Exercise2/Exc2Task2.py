import numpy as np
import matplotlib.pyplot as plt


def ssa(s, k, x_0, tFinal):
    # initialize lists
    times = []
    states = []
    t = 0.0
    x = x_0
    times.append(t)
    states.append(x)

    while t <= tFinal:
        # When?  
        R = ReactionRates(k,x)
        lambdaVar = np.sum(R)
        tau = (1/lambdaVar) * np.log(1/np.random.random())      

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
        x += s[j]
        times.append(t)
        states.append(x)

    return times, states


def ReactionRates(k,x):
        R = np.zeros((4,1))
        R[0] = k[0]*x*(x-1)
        R[1] = k[1]*x*(x-1)*(x-2)
        R[2] = k[2]
        R[3] = k[3]*x
        return R


inputFile = np.loadtxt('Input.txt')
np.random.seed(seed=int(inputFile[0]))
nrSimulations = int(inputFile[1])

# Stoichiometric matrix
s = [1,-1,1,-1]

# Reaction parameters
k = [0.15, 0.0015, 20.0, 3.5]

# Initial state
x_0 = 40
tFinal = 10

for i in range(nrSimulations):
    states, times = ssa(s, k, x_0, tFinal)
    
    print(times)

    plt.plot(states, times)
    plt.show()
    output = np.concatenate((np.array(states,ndmin=2),np.array(times,ndmin=2)), axis=0)
    
    np.savetxt('Task2Traj'+str(i+1)+'.txt',output,delimiter = ',',fmt='%1.3f')
    
    

