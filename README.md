# Polynomial and Cubic Spline Interpolation

Octave/MATLAB implementation of two interpolation methods over a set of support points `(x_i, y_i)`:

- **Vandermonde interpolation**: a single global polynomial of degree `n` through `n + 1` points
- **Natural cubic spline interpolation (C2)**: a piecewise cubic polynomial that is continuous together with its first and second derivatives, with zero second derivative at both endpoints

The code follows the standard Numerical Methods (MN) formulation: assemble a linear system `A * coef = b`, solve for the coefficients with `inv(A) * y` (or `inv(A) * b`), then evaluate the interpolant at arbitrary query points.

---

## Repository layout

| File | Role |
| --- | --- |
| `parse_data.m` | Reads support points from a text file |
| `vandermonde.m` | Builds the Vandermonde matrix and returns polynomial coefficients |
| `P_vandermonde.m` | Evaluates the Vandermonde polynomial at query abscissae |
| `spline_c2.m` | Assembles and solves the natural cubic spline linear system |
| `P_spline.m` | Evaluates the piecewise cubic spline at query abscissae |
| `plot_vandermonde.m` | Plots the Vandermonde interpolant against the support points |
| `plot_spline.m` | Plots the cubic spline interpolant against the support points |
| `tests/input*.txt` | Sample datasets (small, dense, mixed-sign knots) |

There is no single driver script. Typical usage is to parse a file, compute coefficients, then plot or evaluate:

```matlab
[x, y] = parse_data('tests/input1.txt');
coef_v = vandermonde(x, y);
y_v = P_vandermonde(coef_v, linspace(min(x), max(x), 200)');

coef_s = spline_c2(x, y);
y_s = P_spline(coef_s, x, linspace(min(x), max(x), 200)');

plot_vandermonde(x, y, 200);
plot_spline(x, y, 200);
```

Requires GNU Octave or MATLAB.

---

## Input format

`parse_data(filename)` expects:

```
n
x0 x1 ... xn
y0 y1 ... yn
```

- The first integer is `n`, the number of intervals, **not** the number of points.
- There are `n + 1` abscissae and `n + 1` ordinates.
- Values are read with `fscanf` as integers (`%d`).

Example (`tests/input1.txt`): `n = 2` yields knots `x = [1, 3, 4]` and values `y = [5, 10, -10]`.

The function opens the file, reads `n`, increments it to `n + 1`, then reads the two vectors and closes the handle.

---

## Vandermonde interpolation

### Mathematical model

Given distinct knots `x_0, ..., x_n` and values `y_0, ..., y_n`, the unique polynomial of degree at most `n`

```
P(t) = c0 + c1 * t + c2 * t^2 + ... + cn * t^n
```

satisfies `P(x_i) = y_i`. In matrix form:

```
[ 1    x0    x0^2  ...  x0^n ] [ c0 ]   [ y0 ]
[ 1    x1    x1^2  ...  x1^n ] [ c1 ] = [ y1 ]
[ ...                        ] [ .. ]   [ .. ]
[ 1    xn    xn^2  ...  xn^n ] [ cn ]   [ yn ]
```

### Coefficient computation (`vandermonde.m`)

`coef = vandermonde(x, y)` allocates `A` as an `m x m` matrix of ones, where `m = length(x)`. Column 1 already holds `x_i^0 = 1`. Nested loops then fill columns `2 .. m` with successive powers:

- outer index walks rows (`x_i`)
- inner index walks exponents `1, 2, ..., m - 1`

The system is solved explicitly as

```matlab
coef = inv(A) * y;
```

so `coef` is a column vector `[c0, c1, ..., cn]^T`.

This is the textbook Vandermonde construction. For large `n` the matrix is severely ill-conditioned (see `tests/input2.txt`, 101 points). The implementation does not use QR, LU with pivoting beyond `inv`, or a Newton basis.

### Evaluation (`P_vandermonde.m`)

`y_interp = P_vandermonde(coef, x_interp)` evaluates `P` at each query `t` by building the monomial row

```
v(t) = [ t^0, t^1, ..., t^{deg} ]
```

and computing the inner product `v(t) * coef`. Powers are generated from 0 up to `length(coef) - 1`, so the degree is inferred from the coefficient vector, not from the original knots.

---

## Natural cubic spline (C2)

### Piecewise model

Let `n` be the number of intervals (`length(x) - 1`). On each `[x_i, x_{i+1}]`, `i = 0 .. n-1`, the spline is written in **local** (shifted) form:

```
s_i(t)    = a_i + b_i (t - x_i) + c_i (t - x_i)^2 + d_i (t - x_i)^3
s_i'(t)   =       b_i           + 2 c_i (t - x_i)  + 3 d_i (t - x_i)^2
s_i''(t)  =                       2 c_i            + 6 d_i (t - x_i)
```

There are **4n unknown coefficients**, stored in one stacked vector:

```
coef = [ a0, b0, c0, d0, a1, b1, c1, d1, ..., a_{n-1}, b_{n-1}, c_{n-1}, d_{n-1} ]^T
```

Indexing in code is 1-based for MATLAB arrays, but interval indices inside `spline_c2` and `P_spline` are computed as `index = i - 1` so that coefficient `a_i` sits at position `4 * index + 1`.

### Linear system (`spline_c2.m`)

`coef = spline_c2(x, y)` allocates square `A` (`4n x 4n`) and right-hand side `b` (`4n x 1`), then writes one block of equations after another, advancing `linie_A_b` after each row.

**1. Interpolation at the left endpoint of every interval** (`n` equations)

```
s_i(x_i) = y_i    <=>    a_i = y_i
```

Only column `4 * index + 1` is set to `1`; `b_i, c_i, d_i` vanish because `(x_i - x_i) = 0`.

**2. Interpolation at the global right endpoint** (1 equation)

```
s_{n-1}(x_n) = y_n
```

With `h = x_n - x_{n-1}`:

```
a_{n-1} + b_{n-1} h + c_{n-1} h^2 + d_{n-1} h^3 = y_n
```

Together with block 1 this enforces `s(x_i) = y_i` at all `n + 1` knots. Continuity of the function at interior knots is still written separately (block 3) so the system matches the course template rather than being reduced.

**3. C0 continuity at interior knots** (`n - 1` equations)

```
s_i(x_{i+1}) = s_{i+1}(x_{i+1})
```

Left piece uses `h_i = x_{i+1} - x_i`:

```
a_i + b_i h_i + c_i h_i^2 + d_i h_i^3 - a_{i+1} = 0
```

The right piece contributes only `-a_{i+1}` because it is evaluated at its own left knot.

**4. C1 continuity of the first derivative** (`n - 1` equations)

```
s_i'(x_{i+1}) = s_{i+1}'(x_{i+1})
```

```
b_i + 2 c_i h_i + 3 d_i h_i^2 - b_{i+1} = 0
```

**5. C2 continuity of the second derivative** (`n - 1` equations)

```
s_i''(x_{i+1}) = s_{i+1}''(x_{i+1})
```

```
2 c_i + 6 d_i h_i - 2 c_{i+1} = 0
```

**6. Natural (free) boundary conditions** (2 equations)

```
s_0''(x_0)     = 0    <=>    2 c_0 = 0
s_{n-1}''(x_n) = 0    <=>    2 c_{n-1} + 6 d_{n-1} (x_n - x_{n-1}) = 0
```

Equation count: `n + 1 + 3(n - 1) + 2 = 4n`, so `A` is square.

The solve is again explicit inversion:

```matlab
coef = inv(A) * b;
```

No sparse storage, no Thomas algorithm on the usual tridiagonal second-derivative system. The dense 4n formulation is the one required by the assignment.

### Evaluation (`P_spline.m`)

`y_interp = P_spline(coef, x, x_interp)`:

1. For each query `t`, scan intervals `[x(j), x(j+1)]` and keep the first closed interval that contains `t`.
2. Map that interval `j` to coefficient offset `index_coef = j - 1`.
3. Unpack `a, b, c, d` from `coef(4 * index_coef + 1 : 4 * index_coef + 4)`.
4. Evaluate Horner-style in the local variable `delta = t - x_left`:

```
s(t) = a + b * delta + c * delta^2 + d * delta^3
```

Queries are assumed to lie inside `[min(x), max(x)]`. If a point falls outside every interval, the last `j` from the inner loop is reused, which is incorrect for extrapolation; the plotting helpers only sample `linspace(min(x), max(x), nr_points)`.

---

## Plotting

Both plot helpers:

1. Compute coefficients (`vandermonde` or `spline_c2`)
2. Sample `nr_points` uniformly on `[min(x), max(x)]` with `linspace`
3. Evaluate the interpolant (`P_vandermonde` or `P_spline`)
4. Draw a red polyline for the curve and filled red markers for the original knots, with a gray figure background and minor grid

Titles are in Romanian: `Traiectorie robot - Vandermonde` and `Traiectorie robot - Spline` (robot trajectory), which is the original homework framing: interpolate a 2D path given sampled positions.

---

## Complexity and numerical notes

| Stage | Cost (with `m = n + 1` knots) |
| --- | --- |
| Vandermonde fill | `O(m^2)` powering of entries |
| Vandermonde solve via `inv` | `O(m^3)` |
| Vandermonde evaluation of `q` points | `O(q * m)` |
| Spline system size | `4n x 4n` |
| Spline solve via `inv` | `O(n^3)` |
| Spline evaluation | `O(q * n)` interval scan (linear search, no binary search) |

Practical consequences:

- **Global polynomial vs spline.** Vandermonde of high degree oscillates (Runge phenomenon). The C2 natural spline stays locally cubic and is the appropriate model for a robot trajectory with many samples (`tests/input2.txt`).
- **`inv(A)`** is used instead of `A \ b`. Functionally equivalent for a well-conditioned nonsingular `A`, more expensive and slightly less stable.
- **Monomial powers** `x(i)^putere` can overflow or lose precision for large `|x_i|` combined with large degree.
- **Knots** are assumed strictly increasing and unique; the spline interval test uses closed bounds on both ends, so a query exactly equal to an interior knot is assigned to the leftmost matching interval.

---

## Sample datasets

| File | `n` (intervals) | Notes |
| --- | --- | --- |
| `tests/input1.txt` | 2 | Three points; useful for hand-checking coefficients |
| `tests/input4.txt` | 7 | Mixed-sign abscissae from `-14` to `61` |
| `tests/input2.txt` | 100 | 101 points; stresses Vandermonde conditioning |

---

## File-to-function map

Each `.m` file defines one function with the same name as the file (Octave/MATLAB convention), except that `plot_spline.m` currently declares `function plot_vandermonde(...)` while still calling `spline_c2` / `P_spline` and using the spline title. Call it as `plot_spline` from the filename, or rename the function declaration to match if Octave complains.

Core numerical kernels (system assembly and evaluation) are fully expanded loops with no vectorized `vander`, `spline`, or `interp1` from the standard library.
