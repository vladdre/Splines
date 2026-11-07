# Splines and Curve Interpolation in MATLAB

A robust MATLAB implementation of custom spline interpolation algorithms, numerical solvers, and curve visualization tools. Developed for numerical analysis, data interpolation, and smooth trajectory generation from scratch using pure MATLAB code.

---

## Features

- **Cubic Spline Interpolation:** Custom implementation of natural and clamped cubic splines by setting up and solving tridiagonal linear systems ($O(n)$ complexity).
- **Polynomial Evaluation:** Evaluates piecewise cubic polynomials, first derivatives, and second derivatives at arbitrary query points along the interpolated curve.
- **Matrix-Based Formulation:** Leverages MATLAB's optimized matrix operations for efficient coefficient calculations without relying on built-in toolboxes.
- **Visualization Tools:** Built-in plotting utilities to display control/data points alongside smooth interpolated curves and analytical comparisons.

---

## Implementation Details

### 1. Coefficient Calculation
The repository computes cubic splines by enforcing continuity conditions across intervals (value continuity s_i(x_i) = y_i, first derivative continuity s'_i(x_i) = s'_{i-1}(x_i), and second derivative continuity s''_i(x_i) = s''_{i-1}(x_i)). The resulting tridiagonal system is solved efficiently within MATLAB.

### 2. Core MATLAB Functions
- **`compute_splines.m`**: Builds the system matrix, handles boundary conditions, and computes polynomial coefficients (a, b, c, d) for each segment.
- **`evaluate_spline.m`**: Finds the corresponding interval for given query points and evaluates the cubic polynomial.
- **`main.m`**: Orchestrates data input, function execution, and automated plotting.

---

## Getting Started & Usage

### Prerequisites

- **MATLAB** (R2018a or newer recommended)

### Running the Code

1. Clone the repository:
   ```bash
   git clone https://github.com/vladdre/Splines.git
   cd Splines
   ```

2. Open MATLAB and set the working directory to the project folder.

3. Run the main script to execute the interpolation algorithm and view generated plots:
   ```matlab
   main
   ```
