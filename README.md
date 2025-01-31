# **Group 7 - Computational Algorithms & Data Science Projects**

## **Overview**
This repository contains various projects developed as part of the **Introduction to Focus Areas WS 22/23** at Freie Universität Berlin. The projects explore advanced algorithms, data science, machine learning, and computational techniques applied in real-world biological and medical datasets.

## **Projects & Reports**
### **1. Advanced Algorithms - Search Implementation**
- **Report:** [`here`](Reports/Advanced_Algorithms.pdf)
- **Poster:** [`here`](Poster/Poster_Advanced_Algorithms.pdf)
- **Programming Languages:** C++, Perl, R
- **Description:** Implemented and benchmarked various search algorithms:
  - **Naive Search**
  - **Suffix Array Search**
  - **FM-Index Search**
  - **FM-Index Search with Pigeonhole Principle**
  - **Performance evaluation (runtime & memory usage)**
- **Key Findings:** FM-Index search was the most efficient for large datasets, while naive search was computationally expensive.

### **2. Complex Systems - Viral Infection Modeling**
- **Report:** [`here`](Reports/Complex_Systems.pdf)
- **Programming Language:** Python
- **Description:**
  - Developed and simulated **ordinary differential equation (ODE) models** to study viral infections.
  - Performed **stochastic simulations** with the Stochastic Simulation Algorithm (SSA).
  - Estimated unknown parameters using **optimization methods**.
  - Analyzed how **infection probability changes** with viral exposure.
- **Key Findings:** Identified key parameters affecting infection dynamics and established relationships between viral exposure and infection probability.

### **3. Data Science - Classification & Machine Learning**
- **Report:** [`here`](Reports/Data_Science.pdf)
- **Presentation:** [`here`](Presentation/presentation.pdf)
- **Programming Language:** R, Python
- **Description:**
  - **Project 1:** Classification of heart disease using machine learning models.
    - Logistic Regression, Random Forest, Boosted Logistic Regression, k-Nearest Neighbors
    - Performance metrics: Accuracy, Sensitivity, Specificity, AUC-ROC
  - **Project 2:** Breast cancer classification using deep learning models.
    - Convolutional Neural Network (CNN)
    - Fully Connected Neural Network
    - Shallow Neural Network (SNN)
- **Key Findings:** CNN outperformed other models for breast cancer classification, while Boosted Logistic Regression had the best accuracy for heart disease classification.

#### **Breast Cancer Image Classification**
- **Programming Language:** Python (TensorFlow, Scikit-learn)
- **Dataset:** BreaKHis - 7909 microscopic images from breast cancer tissues
- **Description:**
  - Implemented deep learning models to classify **benign vs. malignant** tissues.
  - Used **CNN, Fully Connected NN, and Shallow NN** for classification.
  - Evaluated models with **confusion matrices, accuracy plots, ROC curves**.
- **Key Findings:** CNN performed best, while SNN and Fully Connected NN suffered from imbalanced training data.

## **Installation & Dependencies**
To run the code from the Jupyter notebooks or scripts, ensure you have the following installed:

```bash
pip install numpy pandas matplotlib seaborn tensorflow scikit-learn
```

For R-based projects, install the necessary libraries:

```r
install.packages(c("caret", "ggplot2", "randomForest", "MLeval"))
```

## **Contributors**
- **Abhinav Mishra** (Bioinformatics) – Algorithm development, data science, and optimization.
- **Jule Brenningmeyer** (Bioinformatics) – Machine learning and stochastic modeling.
- **Maike Herkenrath** (Bioinformatics) – Data preprocessing and deep learning.
- **Se Yeon Kim** (Data Science) – Heart disease classification and neural network training.

## **References**
- Detrano et al. (1989). *International application of a new probability algorithm for coronary artery disease*.
- Spanhol et al. (2016). *A Dataset for Breast Cancer Histopathological Image Classification*.
- Reinert, K. *FM-Index and Suffix Array Algorithms*