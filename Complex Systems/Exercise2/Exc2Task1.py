import numpy as np

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
        R = np.zeros((6,1))
        R[0] = k[0]
        R[1] = k[1]*X[0]
        R[2] = k[2]*X[0]*X[1]
        R[3] = k[1]*X[1]*(3*10**7)
        R[4] = k[3]*X[1]
        R[5] = k[1]*X[2]
        return R

inputFile = np.loadtxt('Input.txt')
np.random.seed(seed=int(inputFile[0]))
nrSimulations = int(inputFile[1])

# Stoichiometric matrix
s = np.array([[1,-1,-1,0,0,0],[0,0,1,-1,-1,0],[0,0,0,0,1,-1],[0,0,0,1,0,0]])

# Reaction parameters
lamda = 1*10**(-4)
delta = 1*10**(-8)
beta = 5*10**(-5)
kr = 0.3

k = [lamda, delta, beta, kr]

# Initial state
x_0 =[lamda/delta, 20, 0, 0]
tFinal = 10

for i in range(nrSimulations):
    states, times = ssa(s, k, x_0, tFinal)
    output = np.concatenate((np.array(states,ndmin=2),np.array(times,ndmin=2)), axis=0)
    
    np.savetxt('Task1Traj'+str(i+1)+'.txt',output,delimiter = ',',fmt='%1.3f')