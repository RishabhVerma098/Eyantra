1;
pkg load control

function draw_pendulum(y, L)
  theta = y(1);          ## Store the first variable of state vector in theta
  
  x = L*sin(theta);      ## x-coordinate of pendulum bob
  y = 1-L*cos(theta);  ## y coordinate of pendulum bob
  d = 0.1;               ## diameter of pendulum bob
  hold on;
  clf;
  axis equal;
  rectangle('Position',[x-(d/2),y-(d/2),d,d],'Curvature',1,'FaceColor',[1 0 0]);
  line ([0 x], [1 y], "linestyle", "-", "color", "k");
  xlim([-1 1])
  ylim([-0.5 2])
  drawnow
  hold off
endfunction

function dy = pendulum_dynamics(y, m, L, g, u)
  #TODO
  sin_theta = sin(y(1));
  cos_theta = cos(y(1));
  
  dy(1,1) = y(2);                                  
  dy(2,1) = -(g/L)*(sin_theta) + (1/m*L*L)*u  ;    
endfunction




function [A,B] = pendulum_AB_matrix(m, g, L)
  A = [0 1; g/L 0];
  B = [0 ; 1/m*L*L ];
endfunction





function [t,y] = pole_place_pendulum(m, g, L, y_setpoint, y0)
  [A,B] = pendulum_AB_matrix(m, g, L);                            ## Initialize A and B matrix
  eigs = [-1 ; -2];                             ## Initialise desired eigenvalues
  K = [ (2*m*L*L)+(m*g*L) , 3*m*L*L ]; 
  #state = [ 0 , 1 ; (g/L)-(K1/m*L*L) , -K2/m*L*L]
  K = place(A,B,eigs)
  tspan = 0:0.1:10;                  ## Initialise time step 
  [t,y] = ode45(@(t,y)pendulum_dynamics(y, m, L, g, -K*(y-y_setpoint)),tspan,y0);
endfunction

function [t,y] = lqr_pendulum(m, g, L, y_setpoint, y0)
  [A,B] = pendulum_AB_matrix(m, g, L);               ## Initialize A and B matrix
  Q = [1 0 ;0 2];                   ## Initialise Q matrix
  R = 1 ;                   ## Initialise R 
  
  K = lqr(A,B,Q,R);                   ## Calculate K matrix from A,B,Q,R matrices
  
  tspan = 0:0.1:10;                  ## Initialise time step 
  [t,y] = ode45(@(t,y)pendulum_dynamics(y, m, L, g, -K*(y-y_setpoint)),tspan,y0);
endfunction





function simple_pendulum_main()
  m = 1;             
  g = 9.8;
  L = 1.0;
  y_setpoint = [pi; 0];               ## Set Point 
  y0 = [pi/6 ; 0];                   ## Initial condtion
  
  #[t,y] = pole_place_pendulum(m,g,L, y_setpoint, y0)
  [t,y] = lqr_pendulum(m,g,L, y_setpoint, y0);        
  for k = 1:length(t)
    draw_pendulum(y(k, :), L);  
  endfor
endfunction
simple_pendulum_main