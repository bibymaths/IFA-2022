import numpy as np
import matplotlib.pyplot as plt

def ssa(s, k, x_0):
    # initialize lists
    times = []
    states = []
    t = 0.0
    x = x_0
    times.append(t)
    states.append(x[2])

    while x[2] > 0 and x[2] <= 50:
        # When?  
        R = ReactionRates(x)

        # Update time
        t += 1

        # What reaction happens
        u2 =  np.random.random()
        j = np.sum(np.cumsum(R) < u2 * np.sum(R))

        # Update states
        x += s[:,j]
        times.append(t)
        states.append(x[2])

    return np.array(times), np.array(states)

def ReactionRates(X):  
        R = np.zeros((6,1))
        R[0] = k[0]
        R[1] = k[1]*X[0]
        R[2] = k[2]*X[0]*X[2]
        R[3] = k[3]*X[1]
        R[4] = k[4]*X[1]
        R[5] = k[5]*X[2]
        return R[:,0] 

global s, k, X 
# Stoichiometric matrix 
s = np.array([[1,-1,-1,0,0,0],[0,0,1,-1,0,0],[0,0,-1,0,1,-1]])

# Reaction parameters 
k = [100, 0.1, 0.01, 1.0, 10, 2]  

x2Values = 5
nrSim = 300


virus_gone = np.zeros(5)
virus_won = np.zeros(5)

for i in range(x2Values):
    for j in range(nrSim):
        # Initial values where x2 = i \in [1,2,3,4,5]
        X = np.array([k[0]/k[1], 0, i+1])
        current_times, current_states = ssa(s, k, X)
        #output = np.concatenate((np.array(current_times,ndmin=2),np.array(current_states,ndmin=2)), axis=0)
        
        if current_states[-1] == 0:
            virus_gone[i] += 1
        elif current_states[-1] >= 50:
            virus_won[i] += 1

        # Plot for all trajectories for X2 = i
        """ plt.plot(current_times, current_states)
        plt.ylabel('Virus')
        plt.xlabel('Time')
    plt.show() """

# Plot that shows  how many of the simulations ended with 
# the virus dying or surviving resp.
x_axis = range(1, x2Values+1)
plt.plot(x_axis, virus_gone, 's', label='Virus gone')
plt.plot(x_axis, virus_won, 's', label= 'Virus won') 
plt.legend()
plt.xlabel('X_2')
plt.xticks(ticks=x_axis)
plt.ylabel('Simulations')
plt.show()
        
        
