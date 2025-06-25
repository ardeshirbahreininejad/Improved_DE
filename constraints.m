%%% Defining the constraints calculations

function [sum] = constraints(x)

global c   problem sum_c

sum = 0;
sum_c = 0;
  

[c]=constraint_eval(x, problem);

% Inequality constraints
 
for i=1:length(c)   
       sum = sum + max(0, c(i)); 
end
     
sum_c = sum;
   





