{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 4,
   "metadata": {},
   "outputs": [],
   "source": [
    "# provided to you by the best bioinformatics lecturer you'll ever have (starts with M, ends with t)\n",
    "\n",
    "import numpy as np\n",
    "\n",
    "# A: -----Fixed Quantities-----\n",
    "#0. initial state\n",
    "X0 = np.loadtxt('Input.txt')\n",
    "\n",
    "# ===> fill here, everywhere where a \"...\" is <===\n",
    "\n",
    "#1. Stoichiometric matrix\n",
    "S = np.array([[1,-1,-1,0,1],[0,0,1,-1,-1],[0,0,0,0,1],[0,0,-1,0,0]]);# !!check dimension of the array!!\n",
    "\n",
    "#2. reaction parameters\n",
    "k = [5,3,12,7,3];\n",
    "\n",
    "\n",
    "# B: functions that depend on the state of the system X\n",
    "def ReactionRates(k,X):\n",
    "        R = np.zeros((5,1))\n",
    "        R[0] = 5\n",
    "        R[1] = 3*X[0]\n",
    "        R[2] = 12*X[0]*X[3]\n",
    "        R[3] = 7*X[1]\n",
    "        R[4] = 3*X[1]\n",
    "        return R\n",
    "# ===>       -----------------------     <===\n",
    "\n",
    "# compute reaction propensities/rates\n",
    "R = ReactionRates(k,X0)\n",
    "\n",
    "#compute the value of the ode with time step delta_t = 1\n",
    "dX = np.dot(S,R)\n",
    "\n",
    "##a) save stoichiometric Matrix\n",
    "np.savetxt('SMatrix.txt',S,delimiter = ',',fmt='%1.0f');\n",
    "##b) save ODE value as float with 2 digits after the comma (determined with the c-style precision argument e.g. '%3.2f')\n",
    "np.savetxt('ODEValue.txt',dX,delimiter=',',fmt='%1.2f');\n",
    "\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[ 1, -1, -1,  0,  1],\n",
       "       [ 0,  0,  1, -1, -1],\n",
       "       [ 0,  0,  0,  0,  1],\n",
       "       [ 0,  0, -1,  0,  0]])"
      ]
     },
     "execution_count": 3,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "S\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
