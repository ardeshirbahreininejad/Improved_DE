import numpy as np

# Global variables to mimic Matlab's global behavior for constraints
c = []
sum_c = 0
problem = 1

def constraint_eval(x, problem_id):
    c_local = []
    if problem_id == 1:
        # Problem G10 CEC 2006  optim = 7049.24802052867
        # Note: Matlab indices are 1-based, Python are 0-based
        c_local.append(-1 + 0.0025 * (x[3] + x[5]))
        c_local.append(-1 + 0.0025 * (x[4] + x[6] - x[3]))
        c_local.append(-1 + 0.01 * (x[7] - x[4]))
        c_local.append(-x[0] * x[5] + 833.33252 * x[3] + 100 * x[0] - 83333.333)
        c_local.append(-x[1] * x[6] + 1250 * x[4] + x[1] * x[3] - 1250 * x[3])
        c_local.append(-x[2] * x[7] + 1250000 + x[2] * x[4] - 2500 * x[4])
    return np.array(c_local)

def constraints(x):
    global c, sum_c, problem
    total_sum = 0
    c = constraint_eval(x, problem)
    
    # Inequality constraints
    for i in range(len(c)):
        total_sum = total_sum + max(0, c[i])
    
    sum_c = total_sum
    return total_sum

def problems_funcs(x, problem_id):
    penalty = 1e10
    fitness_cost = 0
    if problem_id == 1:
        # Problem G10 CEC 2006 optim = 7049.24802052867
        fun = x[0] + x[1] + x[2]
        fitness_cost = fun + (penalty * constraints(x))
    return fitness_cost

def problems(problem_id):
    num_runs = 10 # Set the number of runs
    nvars = 0
    lb = []
    ub = []
    max_it = 0
    n_pops = 0
    
    if problem_id == 1:
        nvars = 8
        lb = np.array([100, 1000, 1000, 10, 10, 10, 10, 10])
        ub = np.array([10000, 10000, 10000, 1000, 1000, 1000, 1000, 1000])
        max_it = 2000
        n_pops = 50
        
    return nvars, lb, ub, max_it, n_pops, num_runs

# Main Script Execution
file_id = open('results.txt', 'a') # file to write to (Matlab 'w', 'a' is slightly ambiguous, 'a' appends)

problem_set = 1
problem = problem_set

print(f'problem:{problem} is running. Please wait...')
nvars, lb, ub, max_it, n_pops, num_runs = problems(problem)
var_size = nvars # size of variables

dw = 0.7
crp = 0.99

class Candidate:
    def __init__(self):
        self.position = None
        self.cost = None

best_sol = Candidate()
best_sol.cost = float('inf')
population = [Candidate() for _ in range(n_pops)]

for i in range(n_pops):
    population[i].position = np.random.uniform(lb, ub, var_size)
    population[i].cost = problems_funcs(population[i].position, problem)
    if population[i].cost < best_sol.cost:
        best_sol.position = population[i].position.copy()
        best_sol.cost = population[i].cost

best_cost = np.zeros(max_it)
count_run_violations = 0 # counting number of constraint violations per run

print('\n******* Results will be written in results.txt file ******')

f_results = np.zeros(num_runs)

for nrun in range(1, num_runs + 1):
    print(f'\n-------> Run number: {nrun}')
    print('')
    file_id.write(f'\n -------> Run number: {nrun}')
    file_id.write('\n')
    
    old_cost = 0
    
    for it in range(1, max_it + 1):
        for i in range(n_pops):
            x = population[i].position
            choice = np.random.permutation(n_pops)
            choice = choice[choice != i]
            selection1 = choice[0]
            selection2 = choice[1]
            selection3 = choice[2]
            
            y = (population[selection1].position + dw * (population[selection2].position - population[selection3].position))
            y = np.maximum(y, lb)
            y = np.minimum(y, ub)
            
            z = np.zeros(var_size)
            j0 = np.random.randint(0, var_size)
            for j in range(var_size):
                if j == j0 or np.random.rand() <= crp:
                    z[j] = y[j]
                else:
                    z[j] = x[j]
            
            new_solution = Candidate()
            new_solution.position = z
            new_solution.cost = problems_funcs(new_solution.position, problem)
            
            if new_solution.cost < population[i].cost:
                population[i].position = new_solution.position.copy()
                population[i].cost = new_solution.cost
                if population[i].cost < best_sol.cost:
                    best_sol.position = population[i].position.copy()
                    best_sol.cost = population[i].cost
        
        best_cost[it-1] = best_sol.cost
    
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
    
    violations = 0
    for i_c in range(len(c)):
        if c[i_c] > 0:
            violations = violations + 1
            
    if violations > 0:
        count_run_violations = count_run_violations + 1
        
    file_id.write(f'\n\nNumber of constraint violations {violations}')
    file_id.write('\n')
    
    f_results[nrun-1] = best_sol.cost

min_f = np.min(f_results)
max_f = np.max(f_results)

file_id.write(f'\nBest objective value is: {min_f:12.12f} for {nrun} runs')
file_id.write(f'\nWorst objective value = {max_f:12.12f}')
file_id.write(f'\nTotal cases of constraint violations = {count_run_violations} in {nrun} runs')
print('\n\n Results are stored in the file results.txt')

file_id.close()
