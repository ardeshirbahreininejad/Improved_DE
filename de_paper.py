import numpy as np


def constraint_eval(x, problem_id):
    """
    Defining the constraints equations
    """
    c_out = []
    if problem_id == 1:
        # Problem G10 CEC 2006  optim = 7049.24802052867
        # Note: Matlab indices are 1-based, Python are 0-based
        c_out.append(-1 + 0.0025 * (x[3] + x[5]))
        c_out.append(-1 + 0.0025 * (x[4] + x[6] - x[3]))
        c_out.append(-1 + 0.01 * (x[7] - x[4]))
        c_out.append(-x[0] * x[5] + 833.33252 * x[3] + 100 * x[0] - 83333.333)
        c_out.append(-x[1] * x[6] + 1250 * x[4] + x[1] * x[3] - 1250 * x[3])
        c_out.append(-x[2] * x[7] + 1250000 + x[2] * x[4] - 2500 * x[4])
    
    return np.array(c_out)

def constraints(x):
    """
    Defining the constraints calculations
    """
    global c, sum_c, problem
    
    total_sum = 0.0
    # Penalty parameter
    # penalty=1e6;    

    c = constraint_eval(x, problem)

    # Inequality constraints
    for i in range(len(c)):
        total_sum = total_sum + max(0.0, c[i])
    
    sum_c = total_sum
    return total_sum

def problems_funcs(x, problem_id):
    """
    Defining the objective functions
    """
    penalty = 1e10
    fitness_cost = 0.0
    
    if problem_id == 1:
        # Problem G10 CEC 2006 optim = 7049.24802052867
        fun = x[0] + x[1] + x[2]
        fitness_cost = fun + (penalty * constraints(x))
        
    return fitness_cost

def problems(problem_id):
    """
    Defining the variables and parameters
    """
    # nvars = number of variable
    # MaxIt = maximum number of iterations
    # LB = lower bounds
    # UB = upper bounds
    # nPops = number of individuals in population

    num_runs = 10   # Set the number of runs

    if problem_id == 1:
        # Problem G10 CEC 2006  optim = 7049.24802052867
        nvars = 8
        lb = np.array([100, 1000, 1000, 10, 10, 10, 10, 10])
        ub = np.array([10000, 10000, 10000, 1000, 1000, 1000, 1000, 1000])
        max_it = 2000
        n_pops = 50
        
    return nvars, lb, ub, max_it, n_pops, num_runs

# Main Execution Script
if __name__ == "__main__":
    # get constraints
    global c, sum_c, problem 

    file_id = open('results2.txt', 'a') # file to write to (append mode)

    problem_set = 1   ### select problem from problems.m file
    problem = problem_set

    print(f'problem:{problem} is running. Please wait...')
    nvars, lb, ub, max_it, n_pops, num_runs = problems(problem)
    var_size = nvars   # size of variables
          
    dw = 0.7
    crp = 0.99

    class Candidate:
        def __init__(self):
            self.position = None
            self.cost = None

    best_sol = Candidate()
    best_sol.cost = float('inf')
    population = [Candidate() for _ in range(n_pops)]

    for i in range(n_pops):  # number of population
        population[i].position = np.random.uniform(lb, ub, var_size)
        population[i].cost = problems_funcs(population[i].position, problem)
        if population[i].cost < best_sol.cost:
            best_sol.position = population[i].position.copy()
            best_sol.cost = population[i].cost

    # initialize the best solution
    best_cost_history = np.zeros(max_it)

    count_run_violations = 0  # counting number of constraint violations per run   

    #### Setup Number of Runs 
    print('\n******* Results will be written in results2.txt file ******')

    f_results = np.zeros(num_runs)

    for nrun in range(1, num_runs + 1):   
        print(f'\n-------> Run number: {nrun}') 
        print('')
        file_id.write(f'\n -------> Run number: {nrun}') 
        file_id.write('\n')

        old_cost = 0
        #==============  DE Main Loop
        for it in range(1, max_it + 1):
            violations = 0
            for i in range(n_pops):
                x = population[i].position
                choice = np.random.permutation(n_pops)
                choice = choice[choice != i]
                selection1 = choice[0]
                selection2 = choice[1]
                selection3 = choice[2]
              
                #----------------- Mutation
                ## 1) 1 - (2-3)
                y1 = (population[selection1].position + 
                    (dw * (population[selection2].position - 
                    population[selection3].position)))            
                y1_solution = Candidate()
                y1_solution.position = y1
                y1_solution.cost = problems_funcs(y1_solution.position, problem)
                
                ## 2) 1 - (3-2)
                y2 = (population[selection1].position + (dw * (population[selection3].position - population[selection2].position)))
                y2_solution = Candidate()
                y2_solution.position = y2
                y2_solution.cost = problems_funcs(y2_solution.position, problem)         
                
                ## 3) 2 - (1-3)
                y3 = (population[selection2].position + (dw * (population[selection1].position - population[selection3].position)))
                y3_solution = Candidate()
                y3_solution.position = y3
                y3_solution.cost = problems_funcs(y3_solution.position, problem)                

                ## 4) 2 - (3-1)
                y4 = (population[selection2].position + (dw * (population[selection3].position - population[selection1].position)))
                y4_solution = Candidate()
                y4_solution.position = y4
                y4_solution.cost = problems_funcs(y4_solution.position, problem)           
                
                ## 5) 3 - (1-2)
                y5 = (population[selection3].position + (dw * (population[selection1].position - population[selection2].position)))
                y5_solution = Candidate()
                y5_solution.position = y5
                y5_solution.cost = problems_funcs(y5_solution.position, problem)                  
                
                ## 6) 3 - (2-1)
                y6 = (population[selection3].position + (dw * (population[selection2].position - population[selection1].position)))
                y6_solution = Candidate()
                y6_solution.position = y6
                y6_solution.cost = problems_funcs(y6_solution.position, problem)  

                ## Compare
                if (y1_solution.cost < y2_solution.cost and y1_solution.cost < y3_solution.cost and 
                    y1_solution.cost < y4_solution.cost and y1_solution.cost < y5_solution.cost and 
                    y1_solution.cost < y6_solution.cost):
                    y = y1
                elif (y2_solution.cost < y1_solution.cost and y2_solution.cost < y3_solution.cost and 
                      y2_solution.cost < y4_solution.cost and y2_solution.cost < y5_solution.cost and 
                      y2_solution.cost < y6_solution.cost):
                    y = y2
                elif (y3_solution.cost < y1_solution.cost and y3_solution.cost < y2_solution.cost and 
                      y3_solution.cost < y4_solution.cost and y3_solution.cost < y5_solution.cost and 
                      y3_solution.cost < y6_solution.cost):
                    y = y3
                elif (y4_solution.cost < y1_solution.cost and y4_solution.cost < y2_solution.cost and 
                      y4_solution.cost < y3_solution.cost and y4_solution.cost < y5_solution.cost and 
                      y4_solution.cost < y6_solution.cost):
                    y = y4
                elif (y5_solution.cost < y1_solution.cost and y5_solution.cost < y2_solution.cost and 
                      y5_solution.cost < y3_solution.cost and y5_solution.cost < y4_solution.cost and 
                      y5_solution.cost < y6_solution.cost):
                    y = y5   
                else:
                    y = y6

                y = np.maximum(y, lb)  
                y = np.minimum(y, ub)  

                #-------------- Crossover   
                v = np.zeros(x.shape)
                j0 = np.random.randint(0, len(x))
                for j in range(len(x)):  
                    if j == j0 or np.random.rand() <= crp:
                        v[j] = y[j]
                    else:
                        v[j] = x[j]

                new_solution = Candidate()
                new_solution.position = v
                new_solution.cost = problems_funcs(new_solution.position, problem)
                if new_solution.cost < population[i].cost:
                    population[i] = new_solution
                    if population[i].cost < best_sol.cost:
                        best_sol.position = population[i].position.copy()
                        best_sol.cost = population[i].cost
                         
            # Update Best Cost
            best_cost_history[it-1] = best_sol.cost

        # End of main for loop
        file_id.write(f'\nTotal iterations = {it}')
        file_id.write(f'\n\n>>> Minimum Function Value: {best_sol.cost:12.12f}')
        file_id.write('\n----- Best Design Variables:\n')
        for val in new_solution.position:
            file_id.write(f'\n{val:e}')
        file_id.write('\n\n---- Constraints:') 
        for val in c:
            file_id.write(f'\n{val:e}')
        file_id.write('\n\n---- Sum Constraints:') 
        file_id.write(f'\n{sum_c:e}')

        ## count number of violated constraints
        violations = 0
        for i in range(len(c)):
            if c[i] > 0:
                violations = violations + 1
        
        if violations > 0:
            count_run_violations = count_run_violations + 1
        
        file_id.write(f'\n\nNumber of constraint violations {violations}')
        file_id.write('\n')
        
        f_results[nrun-1] = best_sol.cost   
    # end of run loop

    min_f = np.min(f_results)
    max_f = np.max(f_results)

    file_id.write(f'\nBest objective value is: {min_f:12.12f} for {nrun} runs') 
    file_id.write(f'\nWorst objective value = {max_f:12.12f}')
    file_id.write(f'\nTotal cases of constraint violations = {count_run_violations} in {nrun} runs')
    print('\n\n Results are stored in the file results.txt')

    file_id.close()
