# =============================
# Student Names: Travis Truong, Alexander Marinkovich, Winston Chu
# Group ID: 63
# Date: Thursday, January 30, 2025
# =============================
# CISC 352 - W23
# cagey_csp.py
# desc:
#

#Look for #IMPLEMENT tags in this file.
'''
All models need to return a CSP object, and a list of lists of Variable objects
representing the board. The returned list of lists is used to access the
solution.

For example, after these three lines of code

    csp, var_array = binary_ne_grid(board)
    solver = BT(csp)
    solver.bt_search(prop_FC, var_ord)

var_array is a list of all Variables in the given csp. If you are returning an entire grid's worth of Variables
they should be arranged linearly, where index 0 represents the top left grid cell, index n-1 represents
the top right grid cell, and index (n^2)-1 represents the bottom right grid cell. Any additional Variables you use
should fall after that (i.e., the cage operand variables, if required).

1. binary_ne_grid (worth 0.25/3 marks)
    - A model of a Cagey grid (without cage constraints) built using only
      binary not-equal constraints for both the row and column constraints.

2. nary_ad_grid (worth 0.25/3 marks)
    - A model of a Cagey grid (without cage constraints) built using only n-ary
      all-different constraints for both the row and column constraints.

3. cagey_csp_model (worth 0.5/3 marks)
    - a model of a Cagey grid built using your choice of (1) binary not-equal, or
      (2) n-ary all-different constraints for the grid, together with Cagey cage
      constraints.


Cagey Grids are addressed as follows (top number represents how the grid cells are adressed in grid definition tuple);
(bottom number represents where the cell would fall in the var_array):
+-------+-------+-------+-------+
|  1,1  |  1,2  |  ...  |  1,n  |
|       |       |       |       |
|   0   |   1   |       |  n-1  |
+-------+-------+-------+-------+
|  2,1  |  2,2  |  ...  |  2,n  |
|       |       |       |       |
|   n   |  n+1  |       | 2n-1  |
+-------+-------+-------+-------+
|  ...  |  ...  |  ...  |  ...  |
|       |       |       |       |
|       |       |       |       |
+-------+-------+-------+-------+
|  n,1  |  n,2  |  ...  |  n,n  |
|       |       |       |       |
|n^2-n-1| n^2-n |       | n^2-1 |
+-------+-------+-------+-------+

Boards are given in the following format:
(n, [cages])

n - is the size of the grid,
cages - is a list of tuples defining all cage constraints on a given grid.


each cage has the following structure
(v, [c1, c2, ..., cm], op)

v - the value of the cage.
[c1, c2, ..., cm] - is a list containing the address of each grid-cell which goes into the cage (e.g [(1,2), (1,1)])
op - a flag containing the operation used in the cage (None if unknown)
      - '+' for addition
      - '-' for subtraction
      - '*' for multiplication
      - '/' for division
      - '?' for unknown/no operation given

An example of a 3x3 puzzle would be defined as:
(3, [(3,[(1,1), (2,1)],"+"),(1, [(1,2)], '?'), (8, [(1,3), (2,3), (2,2)], "+"), (3, [(3,1)], '?'), (3, [(3,2), (3,3)], "+")])

'''

from cspbase import *
from itertools import permutations

def binary_ne_grid(cagey_grid):
    # Get grid size and list of cages
    n, cages = cagey_grid  
    csp = CSP("Binary NE Grid")
    
    # Create variables for each cell
    array = []
    for i in range(n):
        row = []
        for j in range(n):
            var = f"V_{i},{j}"
            domain = list(range(1, n + 1))  
            row.append(Variable(var, domain))  
        array.append(row)
    
    # Add variables to csp
    for i in array:
        for j in i:
            csp.add_var(j)

    # Add constraints
    for i in range(n):
        for j in range(n):
            for k in range(j + 1, n):
                row_constraint = Constraint(f"Row_{i + 1},{j + 1},{k + 1}", [array[i][j], array[i][k]])
                row_constraint.add_satisfying_tuples([[a, b] for a in range(1, n + 1) for b in range(1, n + 1) if a != b])
                csp.add_constraint(row_constraint)
                
                col_constraint = Constraint(f"Col_{j + 1},{i + 1},{k + 1}", [array[j][i], array[k][i]])
                col_constraint.add_satisfying_tuples([[a, b] for a in range(1, n + 1) for b in range(1, n + 1) if a != b])
                csp.add_constraint(col_constraint)
    
    # Return csp and list of variables
    vars = []
    for i in array:
        for j in i:
            vars.append(j)
    return csp, vars


def nary_ad_grid(cagey_grid):
    # Get grid size and list of cages
    n, cages = cagey_grid  
    csp = CSP("N-ary AD Grid")
    
    # Create variables for each cell
    array = []
    for i in range(n):
        row = []
        for j in range(n):
            var = f"V_{i},{j}"
            domain = list(range(1, n + 1))  
            row.append(Variable(var, domain))  
        array.append(row)
    
    # Add variables to csp
    for i in array:
        for j in i:
            csp.add_var(j)
    
    # Add constraints
    for i in range(n):
        row_vars = array[i]
        row_constraint = Constraint(f"Row_{i + 1}", row_vars)
        row_constraint.add_satisfying_tuples([perm for perm in permutations(range(1, n + 1), n)])
        csp.add_constraint(row_constraint)

        col_vars = [array[j][i] for j in range(n)]
        col_constraint = Constraint(f"Col_{i + 1}", col_vars)
        col_constraint.add_satisfying_tuples([perm for perm in permutations(range(1, n + 1), n)])
        csp.add_constraint(col_constraint)
    
    # Return csp and list of variables
    vars = []
    for i in array:
        for j in i:
            vars.append(j)
    return csp, vars

def cagey_csp_model(cagey_grid):
    # Get grid size and list of cages
    n, cages = cagey_grid  

    # Use n-ary ad model
    csp, vars = nary_ad_grid((n, cages))
    # Create dictionary to store the vars
    dict = {}
    for i in range(n):
        for j in range(n):
            dict[(i + 1, j + 1)] = vars[i * n + j]

    # Add cage constraints
    for target, cells, operator in cages:
        in_cage = [dict[cell] for cell in cells]
        constraint = Constraint(f"Cage_{cells}", in_cage)
        
        satisfying_tuples = []
        for perm in permutations(range(1, n+1), len(cells)):
            if operator == '+':
                if sum(perm) == target:
                    satisfying_tuples.append(perm)

            elif operator == '-':
                if max(perm) - min(perm) == target:
                    satisfying_tuples.append(perm)

            elif operator == '*':
                product = 1
                for p in perm:
                    product *= p
                if product == target:
                    satisfying_tuples.append(perm)

            elif operator == '/':
                if (max(perm) / min(perm)) == target and max(perm) % min(perm) == 0:
                    satisfying_tuples.append(perm)

            elif operator == '?':
                if (sum(perm) == target or max(perm) - min(perm) == target or (perm[0] * perm[1] if len(perm) == 2 else 1) == target
                    or (max(perm) / min(perm)) == target and max(perm) % min(perm) == 0):
                    satisfying_tuples.append(perm)
        
        constraint.add_satisfying_tuples(satisfying_tuples)
        csp.add_constraint(constraint)
    
    # Return csp and list of variables
    return csp, vars