%%% Defining the objective functions

function fitnessCost = problems_funcs(x, problem)

penalty = 1e10;

switch problem

    
    case 1    % Problem G7 CEC 2006  optim = 24.30620906818
	   fun = x(1)^2 + x(2)^2 + x(1)* x(2) - 14 * x(1) - 16 * x(2) + (x(3) - 10)^2 + ...
           4 * (x(4) - 5)^2 + (x(5) - 3)^2 + 2 * (x(6) - 1)^2 + ...
           5 * x(7)^2 + 7 * (x(8) - 11)^2 + 2 * (x(9) - 10)^2 + (x(10) - 7)^2 + 45;
	   fitnessCost = fun + (penalty*constraints(x));

	case 2    % Problem G10 CEC 2006 optim = 7049.24802052867
	   fun = x(1) + x(2) + x(3);
            fitnessCost = fun + penalty*(constraints(x));
  
         
 	case 3    % G18 CEC2006 Optim = -0.866025403784439
         fun = -0.5 * (x(1)* x(4) - x(2)* x(3) + ...
             x(3)* x(9) - x(5)* x(9) + x(5)* x(8) ...
             - x(6)* x(7));
 	     fitnessCost = fun + (penalty*constraints(x));             
      
            
%------------ Engineering Problems    ----------  

    case 4
        % Rolling element bearing
        gama=x(2)/x(1);
        fc=37.91*((1+(1.04*((1-gama/1+gama)^1.72)*((x(4)*...
            (2*x(5)-1)/x(5)*(2*x(4)-1))^0.41))^(10/3))^-0.3)*...
            ((gama^0.3*(1-gama)^1.39)/(1+gama)^(1/3))*(2*x(4)/(2*x(4)-1))^0.41;
 
        if x(2)<=25.4
            fun=-fc*x(3)^(2/3)*x(2)^1.8;   
        else
            fun=-3.647*fc*x(3)^(2/3)*x(2)^1.4;
        end
        fitnessCost = fun + (penalty*constraints(x));
             
    case 5
%     % Spring
        fun = (x(3)+2)*x(2)*(x(1)^2);
        fitnessCost = fun + (penalty*constraints(x));        
          

    case 6
%     % Pressure vessel
        fun = 0.6224*x(1)*x(3)*x(4)+1.7781*x(2)*x(3)^2+3.1661*x(1)^2*x(4)+19.84*x(1)^2*x(3);
        fitnessCost = fun + (penalty*constraints(x));            

    case 7
%     % Welded Beam
        fun = 1.10471*x(1)^2*x(2)+0.04811*x(3)*x(4)*(14+x(2));
        fitnessCost = fun + (penalty*constraints(x));         
             
    case 8  % Himmelblau’s Function
        fun = 5.3578547*x(3)^2 + 0.8356891*x(1)*x(5) + 37.293239*x(1) - 40792.141;
        fitnessCost = fun + (penalty*constraints(x));

        
	case 9   % Ex5_4_2 Optim = 7512.22590
	   fun = x(1) + x(2) + x(3);
            fitnessCost = fun + penalty*(constraints(x));
            
	case 10   % hs103 Optim = 543.66690
      %  x(1)=x1; x(2)=x2; x(3)=x3;x(4)=x4; x(5)=x5; x(6)=x6; x(7)=x7; x(8)=x8; x(9)=x9;
	   fun = 10*x(1)*x(4)^2*x(7)^0.5/(x(2)*x(6)^3) + 15*x(3)*x(4)/(x(1)*x(2)^2*x(5)*...
           x(7)^0.5) + 20*x(2)*x(6)/(x(1)^2*x(4)*x(5)^2)+25*x(1)^2*x(2)^2*...
           x(5)^0.5*x(7)/(x(3)*x(6)^2);
        fitnessCost = fun + penalty*(constraints(x));            
        
end







