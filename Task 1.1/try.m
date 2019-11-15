global A = csvread('csv_matter.csv');
global y_low_x = [];
global y_low_y = [];
global y_low_z = [];
global y_high_x = [];
global y_high_y = [];
global y_high_z = [];
global n_low = 0;
global n_high = 0;

function read_accel(axl,axh,ayl,ayh,azl,azh)  
  signals = [axl,axh,ayl,ayh,azl,azh];
  appendstr = '00000000';
  eightBit = {};
  scaling_factor = 16384;
  for i=1:length(signals)
    x = dec2bin(signals(i));
    if length(x) < 8
      diff = 8-length(x);
      y = appendstr(1:diff);
      x = strcat(y,x);
    endif
    eightBit{i} = x;
  endfor
  ax = bin2dec(strcat(eightBit{2},eightBit{1}));
  ay = bin2dec(strcat(eightBit{4},eightBit{3}));
  az = bin2dec(strcat(eightBit{6},eightBit{5}));
  
  combined_signals = [ax,ay,az];
  
  for i =1:length(combined_signals)
    if  combined_signals(i) >= -32767 && combined_signals(i) <= 32767
      continue
    else
      combined_signals(i) = combined_signals(i) -  65536;
    endif
  endfor
  for i =1:length(combined_signals)
    combined_signals(i) = combined_signals(i)/scaling_factor;
  endfor
 
  disp(combined_signals);
  lowpassfilter(combined_signals(1),combined_signals(2),combined_signals(3),5);
endfunction



function read_gyro(gxl,gxh,gyl,gyh,gzl,gzh)
  
 signals = [gxl,gxh,gyl,gyh,gzl,gzh];
  appendstr = '00000000';
  eightBit = {};
  scaling_factor = 16384;
  for i=1:length(signals)
    x = dec2bin(signals(i));
    if length(x) < 8
      diff = 8-length(x);
      y = appendstr(1:diff);
      x = strcat(y,x);
    endif
    eightBit{i} = x;
  endfor
  gx = bin2dec(strcat(eightBit{2},eightBit{1}));
  gy = bin2dec(strcat(eightBit{4},eightBit{3}));
  gz = bin2dec(strcat(eightBit{6},eightBit{5}));
  
  combined_signals = [gx,gy,gz];
  for i =1:length(combined_signals)
    if  combined_signals(i) >= -32767 && combined_signals(i) <= 32767
      continue
    else
      combined_signals(i) = combined_signals(i) -  65536;
    endif
  endfor
  for i =1:length(combined_signals)
    combined_signals(i) = combined_signals(i)/scaling_factor;
  endfor
  highpassfilter(combined_signals(1),combined_signals(2),combined_signals(3),5);

endfunction
function lowpassfilter(ax,ay,az,f_cut)
  global y_low_x;
  global y_low_y;
  global y_low_z;
  global n_low;
  dT = 0.01;  
  Tau= 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);    
  if length(y_low_x) == 0
    y_low_x(1) = (1-alpha)*ax; 
    y_low_y(1) = (1-alpha)*ay; 
    y_low_z(1) = (1-alpha)*az; 
    n_low++;
  else
    y_low_x(n_low+1) = (1-alpha)*ax + alpha*y_low_x(n_low); 
    y_low_y(n_low+1) = (1-alpha)*ay + alpha*y_low_y(n_low); 
    y_low_z(n_low+1) = (1-alpha)*az + alpha*y_low_z(n_low); 
    n_low++;
  endif 
endfunction
function highpassfilter(gx,gy,gz,f_cut)
  global y_high_x;
  global y_high_y;
  global y_high_z;
  global n_high;
  dT = 0.01;  
  Tau= 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);    
  if length(y_high_x) == 0
    y_high_x(1) = (1-alpha)*gx; 
    y_high_y(1) = (1-alpha)*gy; 
    y_high_z(1) = (1-alpha)*gz; 
    n_high++;
  else
    y_high_x(n_high+1) = (1-alpha)*gx + alpha*y_high_x(n_high); 
    y_high_y(n_high+1) = (1-alpha)*gy + alpha*y_high_y(n_high); 
    y_high_z(n_high+1) = (1-alpha)*gz + alpha*y_high_z(n_high); 
    n_high++;
  endif 
  
endfunction


function comp_filter_pitch(ax,ay,az,gx,gy,gz)

  ##############################################
  ####### Write a code here to calculate  ######
  ####### PITCH using complementry filter ######
  ##############################################

endfunction 

function comp_filter_roll(ax,ay,az,gx,gy,gz)

  ##############################################
  ####### Write a code here to calculate #######
  ####### ROLL using complementry filter #######
  ##############################################

endfunction 

function execute_code
  global A
  global y_low_x;
  global y_low_y;
  global y_low_z;
  global n_low;
  global y_high_x;
  global y_high_y;
  global y_high_z;
  global n_high;
  #temporary
  y_low_x = [];
  y_low_y = [];
  y_low_z = [];
  n_low = 0;
  y_high_x = [];
  y_high_y = [];
  y_high_z = [];
  n_high = 0;
  #for n = 1:rows(A)   #do not change this line
    
    ###############################################
    ####### Write a code here to calculate  #######
    ####### PITCH using complementry filter #######
    ###############################################
    
  #endfor
  read_accel(1,160,0,196,60,0);  
  read_gyro(254,140,0,132,0,76);
  disp(y_low_x);
  disp(y_low_y);
  disp(y_low_z);
  disp(n_low)
  disp(y_high_x);
  disp(y_high_y);
  disp(y_high_z);
  disp(n_high);
  
endfunction


execute_code        