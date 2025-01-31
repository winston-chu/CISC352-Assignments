# =============================
# Student Names: Travis Truong, Alexander Marinkovich, Winston Chu
# Group ID: 63
# Date: Thursday, January 30, 2025
# =============================
# CISC 352 - W23
# heuristics.py
# desc:
#


#Look for #IMPLEMENT tags in this file. These tags indicate what has
#to be implemented to complete problem solution.

'''This file will contain different constraint propagators to be used within
   the propagators

1. ord_dh (worth 0.25/3 points)
    - a Variable ordering heuristic that chooses the next Variable to be assigned 
      according to the Degree heuristic

2. ord_mv (worth 0.25/3 points)
    - a Variable ordering heuristic that chooses the next Variable to be assigned 
      according to the Minimum-Remaining-Value heuristic


var_ordering == a function with the following template
    var_ordering(csp)
        ==> returns Variable

    csp is a CSP object---the heuristic can use this to get access to the
    Variables and constraints of the problem. The assigned Variables can be
    accessed via methods, the values assigned can also be accessed.

    var_ordering returns the next Variable to be assigned, as per the definition
    of the heuristic it implements.
   '''

def ord_dh(csp):
    ''' return next Variable to be assigned according to the Degree Heuristic '''
    next_var = None

    # Find the variable that has the most constraints with other unassigned variables
    for var in csp.get_all_unasgn_vars():
        if next_var == None or len(csp.get_cons_with_var(var)) > len(csp.get_cons_with_var(next_var)):
            next_var = var
        
    return next_var

def ord_mrv(csp):
    ''' return Variable to be assigned according to the Minimum Remaining Values heuristic '''
    next_var = None
    
    # Find the variable with the smallest domain size (minimum legal values)
    for var in csp.get_all_unasgn_vars():
        if next_var is None or var.cur_domain_size() < next_var.cur_domain_size():
            next_var = var
        
    return next_var
