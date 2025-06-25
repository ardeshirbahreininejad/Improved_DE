% Differential Evolution Algorithm

clc;
clear;
close all;
%format long g

global c  sum_c  problem 

%=========== Open file to write data
fileID = fopen('results.txt', 'w', 'a'); % file to write to

%------------------------------------------------------
%% PROBLEMS
% Problem 1 G7 CEC 2006 and optimum = 24.30620906818
% Problem 2 G10 CEC 2006 (ex3_1_1) and optimum = 7049.24802052867
% Problem 3 G18 CEC 2006 and Optimum = -0.866025403784439
% Problem 4 Rolling element bearing
% Problem 5 Spring
% Problem 6 Pressure vessel 
% Problem 7 Welded Beam
% Problem 8 Himmelblau’s Function
% Problem 9 Ex5_4_2 Optim = 7512.22590
% Problem 10 hs103 Optim = 543.66690
% All problems variables, objective function, and constraints are in
% problem.m, problems_funcs.m, and constraint_eval.m files
%-------------------------------------------------------
problemSet= 2;   %%% select the number of one of the above problems
problem = problemSet;
num_runs = 30;  % set number of runs
%-------------------------------------------------------
fprintf('\nproblem %d is running. Please wait...\n',problem);

%============= Set Parameters reading from problems.m file
[nvars, LB, UB, MaxIt, nPops] = problems(problem);
varSize=[1 nvars];   % size of variables


% Setup Number of Runs 
fprintf('\n******* Results will be written in results.txt file ******\n');

% DE Parameters

CRP = 0.99;
DW = 0.6;

count_run_violations = 0;  % counting number of constraint violations per run   
sum_violations = 0;   % counting number of constraint violations for all runs

% START SIMULATION RUN
for nrun=1:num_runs   
    fprintf('\n\n-------> Run number: %g', nrun); 
    fprintf(fileID,'\n -------> Run number: %g', nrun); 
    fprintf(fileID,'\n');

  
%% Initialization
tic;  % Start time
raw_candidate.Position = [];
raw_candidate.Cost = [];
BestSol.Cost = inf;
population = repmat(raw_candidate, nPops,1);

for i=1:nPops  % number of population
    population(i).Position = unifrnd(LB,UB,varSize);
    population(i).Cost = problems_funcs(population(i).Position, problem);
    if population(i).Cost < BestSol.Cost
        BestSol = population(i);
    end
end

% initialize the best solution
BestCost = zeros(MaxIt,1);

old_Cost = 0;
%==============  DE Main Loop
    for it=1:MaxIt
    violations = 0;
        for i=1:nPops
            x = population(i).Position;
            Choice = randperm(nPops);
            Choice(Choice == i) = [];
            selection1 = Choice(1);
            selection2 = Choice(2);
            selection3 = Choice(3);
          
%----------------- Mutation
           %% 1) 1 - (2-3)
            y1 = (population(selection1).Position + ...
                (DW.*(population(selection2).Position - ...
                population(selection3).Position)));            
            y1_Solution.Position = y1;
            y1_Solution.Cost = problems_funcs(y1_Solution.Position, problem);
%%------------------------------------------------------------------------------------            
	    %% 2) 1 - (3-2)
            y2 = (population(selection1).Position + (DW.*(population(selection3).Position - population(selection2).Position)));
            y2_Solution.Position = y2;
            y2_Solution.Cost = problems_funcs(y2_Solution.Position, problem);         
            
	    %% 3) 2 - (1-3)
            y3 = (population(selection2).Position + (DW.*(population(selection1).Position - population(selection3).Position)));
            y3_Solution.Position = y3;
            y3_Solution.Cost = problems_funcs(y3_Solution.Position, problem);                
 %%------------------------------------------------------------------------------------
            %% 1) 2 - (3-1)
            y4 = (population(selection2).Position + (DW.*(population(selection3).Position - population(selection1).Position)));
            y4_Solution.Position = y4;
            y4_Solution.Cost = problems_funcs(y4_Solution.Position, problem);           
 %%------------------------------------------------------------------------------------           
	    %% 2) 3 - (1-2)
            y5 = (population(selection3).Position + (DW.*(population(selection1).Position - population(selection2).Position)));
            y5_Solution.Position = y5;
            y5_Solution.Cost = problems_funcs(y5_Solution.Position, problem);                  
%%------------------------------------------------------------------------------------            
	    %% 3) 3 - (2-1)
            y6 = (population(selection3).Position + (DW.*(population(selection2).Position - population(selection1).Position)));
            y6_Solution.Position = y6;
            y6_Solution.Cost = problems_funcs(y6_Solution.Position, problem);  
%%----------------------------------------------------------------------------            

 %% Compare
if y1_Solution.Cost < y2_Solution.Cost &&  y1_Solution.Cost < y3_Solution.Cost && y1_Solution.Cost < y4_Solution.Cost ...
        && y1_Solution.Cost < y5_Solution.Cost && y1_Solution.Cost < y6_Solution.Cost
    y = y1;
elseif y2_Solution.Cost < y1_Solution.Cost && y2_Solution.Cost < y3_Solution.Cost && y2_Solution.Cost < y4_Solution.Cost ...
        && y2_Solution.Cost < y5_Solution.Cost && y2_Solution.Cost < y6_Solution.Cost
    y = y2;
elseif  y3_Solution.Cost < y1_Solution.Cost && y3_Solution.Cost < y2_Solution.Cost && y3_Solution.Cost < y4_Solution.Cost ...
        && y3_Solution.Cost < y5_Solution.Cost && y3_Solution.Cost < y6_Solution.Cost
     y = y3;
elseif  y4_Solution.Cost < y1_Solution.Cost && y4_Solution.Cost < y2_Solution.Cost && y4_Solution.Cost < y3_Solution.Cost ...
        && y4_Solution.Cost < y5_Solution.Cost && y4_Solution.Cost < y6_Solution.Cost
     y = y4;
elseif y5_Solution.Cost < y1_Solution.Cost && y5_Solution.Cost < y2_Solution.Cost && y5_Solution.Cost < y3_Solution.Cost ...
        && y5_Solution.Cost < y4_Solution.Cost && y5_Solution.Cost < y6_Solution.Cost
    y = y5;   
else
    y = y6;
end

y = max(y, LB);  
y = min(y, UB);  

%-------------- Crossover   
v = zeros(size(x));
j0 = randi([1 numel(x)]);
for j = 1:numel(x)  
  if j == j0 || rand <= CRP
     v(j) = y(j);
  else
     v(j) = x(j);
  end
end

new_Solution.Position = v;
new_Solution.Cost = problems_funcs(new_Solution.Position, problem);
if new_Solution.Cost < population(i).Cost 
   population(i) = new_Solution;
   if population(i).Cost < BestSol.Cost 
         BestSol = population(i);
   end
end 
             

end  %%% End of inner nPop for loop
    
    % Update Best Cost
        
BestCost(it) = BestSol.Cost;

% Uncomment to show Iteration Information - use if it is desired to see results at
    % each iteration on the screen
    
%fprintf('\nIteration: %g\tCost: %12.10f',it, BestSol.Cost);

end  %%% end of main for loop
fprintf('\n');
toc;  %% End of timing
   
    %%% Print to file

fprintf(fileID,'\nTotal iterations = %g', it);
fprintf(fileID,'\nNumber of function evaluations = %g ', it * nPops);
fprintf(fileID,'\n\n>>> Minimum Function Value: %12.11f',BestSol.Cost); %fprintf(fileID, '\tBest: 7049.24802052867');    fprintf(fileID,'\n----- Best Design Variables:\n');
fprintf(fileID,'\n\nSolutions:');
fprintf(fileID,'\n%12.20f',new_Solution.Position);
fprintf(fileID,'\n\n---- Constraints:'); 
fprintf(fileID,'\n%6.16f', c);
fprintf(fileID,'\n\n---- Sum Constraints:'); 
fprintf(fileID,'\n%6.16f', sum_c);

%% count number of violated constraints
 
for i = 1:length(c)
   if c(i) > 1e-10
     violations = violations + 1;
   end    
end
if violations > 0
   count_run_violations = count_run_violations + 1;
end
    
sum_violations = sum_violations + violations;
    
fprintf('Cost: %6.11f',BestSol.Cost);
fprintf('\nNumber of constraint violations %g', violations);
fprintf(fileID,'\n\nNumber of constraint violations %g', violations);
fprintf(fileID,'\n');
    
F(nrun)=BestSol.Cost; 
end  %%% end of run loop

%%% Print the best, worst, average and standard deviation run results
Min_F=min(F);
Max_F=max(F);
Ave_F=mean(F);
SD_F=std(F);

fprintf(fileID,'\nBest objective value is: %6.11f for %g runs', Min_F, nrun); 
fprintf(fileID,'\nWorst objective value = %6.11f', Max_F);
fprintf(fileID,'\nAverage objective value = %6.11f', Ave_F);
fprintf(fileID,'\nSTD objective value = %6.11f', SD_F);
fprintf(fileID,'\nTotal cases of constraint violations = %g in %g runs', count_run_violations, nrun);
fprintf(fileID,'\nTotal sum of violations is %g for %g runs', sum_violations, nrun);
fprintf('\n\n Results are stored in the file results.txt\n');
%% Close file
fclose(fileID);
%%