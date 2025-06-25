
%%% Defining the variables and parameters

function [nvars, LB, UB, MaxIt, nPops] = problems(problem)


% nvars = number of variable
% MaxIt = maximum number of iterations
% LB = lower bounds
% UB = upper bounds
% nPops = number of individuals in population


switch problem
         
	case 1    % Problem G7 CEC 2006 optim = 24.30620906818
		nvars = 10;    
		LB = -10 * ones(1, 10);
		UB = 10 * ones(1, 10);
		MaxIt = 500;
		nPops = 50;      
              
	case 2   % Problem G10 CEC 2006 (ex3_1_1) optim = 7049.24802052867 
        % Heat Exchanger Network Design 1
		nvars = 8;    
		LB = [1e2  1e3  1e3   10   10   10   10   10];
		UB = [1e4  1e4  1e4   1e3  1e3  1e3  1e3  1e3];
		MaxIt = 500;
		nPops = 50; 
        
	case 3     % G18 CEC2006 Optim = -0.866025403784439
		nvars = 9; 
		LB = [-10 -10 -10 -10 -10 -10 -10 -10 0];
		UB = [10 10 10 10 10 10 10 10 20];
		MaxIt = 500;
		nPops = 50;    
          

%----------------------- Engineering Problems -----\

	case 4    % Rolling element bearing  85539.192742604733
          nvars=10;
          D=160;
          d=90;
          LB=[0.5*(D+d) 0.15*(D-d) 4 0.515 0.515 0.4 0.6 0.3 0.02 0.6];
          UB=[0.6*(D+d) 0.45*(D-d) 50 0.6 0.6 0.5 0.7 0.4 0.1 0.85];
          MaxIt = 150;
          nPops = 50;  
        

    case 5  % Spring
        nvars = 3;
        LB = [0.05  0.25  2];
        UB = [2   1.3  15];
        MaxIt = 500;
        nPops = 50;         
        

      case 6  % Pressure vessel
        nvars = 4; 
        LB = [0  0  10  10];
        UB = [10  10  200  200];
        MaxIt = 500;
        nPops = 50;

      case 7  % Welded beam
        nvars = 4; 
        LB = [0.1  0.1  0.1  0.1];
        UB = [2   10    10   2];
        MaxIt = 500;
        nPops = 50;               
        
    case 8
        nvars = 5;  % Himmelblau’s Function
        LB = [78,33,27,27,27];
        UB = [102,45,45,45,45];
        MaxIt = 500;
        nPops = 50;
        

    case 9   % Ex7_4_2 Optim = 7512.22590
		nvars = 8;    
		LB = [1e2  1e3  1e3   10   10   10   10   10];
		UB = [1e4  1e4  1e4   1e3  1e3  1e3  1e3  1e3];
        MaxIt = 500;
        nPops = 50;         
        
     case 10  % hs103 Optim = 543.66690
		nvars = 7;    
		LB = [0 0 0 0 0 0 0];
		UB = [10 10 10 10 10 10 10];
        MaxIt = 500;
        nPops = 50;        
        
end

