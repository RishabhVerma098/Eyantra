pkg load symbolic      # Load the octave symbolic library
syms x1 x2             # Define symbolic variables x1 and x1

x1_dot = -x1 + 2*x1^3 + x2;       # Write the expressions for x1_dot and x2_dot
x2_dot = -x1 - x2; 

function eqbm_points = find_equilibrium_points(x1_dot, x2_dot)
  x1_dot == 0;
  x2_dot == 0;
  ################## ADD YOUR CODE HERE ######################
  eqbm_points = solve(x1_dot,x2_dot); 
  ############################################################  
endfunction
function jacobian_matrices = find_jacobian_matrices(eqbm_points, x1_dot, x2_dot)
  syms x1 x2
  solutions = {};
  jacobian_matrices = {};
  for k = 1:length(eqbm_points)
    x_1 = eqbm_points{k}.x1;
    x_2 = eqbm_points{k}.x2;
    soln = [x_1 x_2];
    solutions{k} = soln;
  endfor
  ################## ADD YOUR CODE HERE ######################
  ans = jacobian([x1_dot;x2_dot]);
  for i = 1:columns(eqbm_points)
      jacobian_matrices{i} = double(subs(ans,{x1 x2},{eqbm_points{i}.x1 eqbm_points{i}.x2}));
  endfor
  ############################################################  
endfunction
function [eigen_values stability] = check_eigen_values(eqbm_pts, jacobian_matrices)
  stability = {};
  eigen_values = {};
  for k = 1:length(jacobian_matrices)
    matrix = jacobian_matrices{k};
    flag = 1;
    ################## ADD YOUR CODE HERE ######################
    ans = eig(matrix);
    for i = 1:length(ans)
      if real(ans(i)) > 0
        flag = 0;
      endif
        
    endfor
    ############################################################
    if flag == 1
      fprintf("The system is stable for equilibrium point (%d, %d) \n",double(eqbm_pts{k}.x1),double(eqbm_pts{k}.x2));
      stability{k} = "Stable";
    else
      fprintf("The system is unstable for equilibrium point (%d, %d) \n",double(eqbm_pts{k}.x1),double(eqbm_pts{k}.x2)); 
      stability{k} = "Unstable";
    endif
  endfor
endfunction
equilibrium_points = find_equilibrium_points(x1_dot, x2_dot);
jacobians = find_jacobian_matrices(equilibrium_points, x1_dot, x2_dot);
[eigen_values stability] = check_eigen_values(equilibrium_points, jacobians); 







