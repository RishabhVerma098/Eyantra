global A = csvread('csv_matter.csv');
global C = csvread('e_yantra_csv_output.csv');
global y_low_x = [];
global y_low_y = [];
global y_low_z = [];
global y_high_x = [];
global y_high_y = [];
global y_high_z = [];
global n_low = 0;
global n_high = 0;
global final_pitch = [];
global final_roll = [];
global pitch_count = 1;
global roll_count = 1 ;
#17161
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
  ax = bin2dec(strcat(eightBit{1},eightBit{2}));
  ay = bin2dec(strcat(eightBit{3},eightBit{4}));
  az = bin2dec(strcat(eightBit{5},eightBit{6}));
  
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
  lowpassfilter(combined_signals(1),combined_signals(2),combined_signals(3),5);
endfunction



function read_gyro(gxl,gxh,gyl,gyh,gzl,gzh)
  
 signals = [gxl,gxh,gyl,gyh,gzl,gzh];
  appendstr = '00000000';
  eightBit = {};
  scaling_factor = 17161;
  for i=1:length(signals)
    x = dec2bin(signals(i));
    if length(x) < 8
      diff = 8-length(x);
      y = appendstr(1:diff);
      x = strcat(y,x);
    endif
    eightBit{i} = x;
  endfor
  gx = bin2dec(strcat(eightBit{1},eightBit{2}));
  gy = bin2dec(strcat(eightBit{3},eightBit{4}));
  gz = bin2dec(strcat(eightBit{5},eightBit{6}));
  
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
  global pitch_count;
  global final_pitch;
  alpha = 0.03;
  dt    = 0.01;
  
  
  acc_pitch_intermediate = 180 * atan2 (ay,abs(az))/pi;
  gyro_pitch_intermediate = gx;
  
  
  if (pitch_count == 1)
    angle = 0;
    result1 = (gyro_pitch_intermediate*dt);
    result1 = result1 + angle;
    result2 = 1-alpha;
    result3 = alpha*acc_pitch_intermediate;
    result4 = result1*result2;
    result = result4 + result3;
    final_pitch{1} = result;
    pitch_count++;
  else
    angle = final_pitch{pitch_count-1};
    result1 = (gyro_pitch_intermediate*dt);
    result1 = result1 + angle;
    result2 = 1-alpha;
    result3 = alpha*acc_pitch_intermediate;
    result4 = result1*result2;
    result = result4 + result3;
    final_pitch{pitch_count} = result;
    pitch_count++;
  endif
endfunction 

function comp_filter_roll(ax,ay,az,gx,gy,gz)
  global roll_count;
  global final_roll;
  alpha = 0.03;
  dt    = 0.01;

  acc_roll_intermediate = 180 * atan2(ax,abs(az)) / pi;
  gyro_roll_intermediate = gy;
 
  if (roll_count == 1)
    angle = 0;
    result1 = (angle(1) + gyro_roll_intermediate*dt);
    result2 = 1-alpha;
    result3 = alpha*acc_roll_intermediate;
    result4 = result1*result2;
    result = result4 + result3;
    final_roll{1} = result;
    roll_count++;
  else
    angle = final_roll{roll_count-1};
    result1 = (angle + gyro_roll_intermediate*dt);
    result2 = 1-alpha;
    result3 = alpha*acc_roll_intermediate;
    result4 = result1*result2;
    result = result4 + result3;
    final_roll{roll_count} = result;
    roll_count++;
  endif
endfunction 

function execute_code
  global A;
  global C;
  global y_low_x;
  global y_low_y;
  global y_low_z;
  global n_low;
  global y_high_x;
  global y_high_y;
  global y_high_z;
  global n_high;
  global final_pitch;
  global final_roll;
  global pitch_count;
  global roll_count;
  for n = 1:rows(A)  
    read_accel(A(n,1),A(n,2),A(n,3),A(n,4),A(n,5),A(n,6));
    read_gyro(A(n,7),A(n,8),A(n,9),A(n,10),A(n,11),A(n,12));
    comp_filter_pitch(y_low_x(n),y_low_y(n),y_low_z(n),y_high_x(n),y_high_y(n),y_high_z(n));
    comp_filter_roll(y_low_x(n),y_low_y(n),y_low_z(n),y_high_x(n),y_high_y(n),y_high_z(n));
  endfor
   array_final_pitch = [];
   array_final_roll = [];
   for i = 1 : length(final_pitch)
      array_final_pitch(i) = final_pitch{i};
      array_final_roll(i) = final_roll{i};
   endfor
   col_pitch = C(:,1);
   plot(array_final_pitch);
   hold on;
   #plot(array_final_roll);
   #hold on;
   plot(col_pitch);
   disp("from here")
   for i = 1:length(array_final_pitch)
    for j = 1:2
      if j == 1
        B(i,j) =  array_final_pitch(i);
      else
        B(i,j) = array_final_roll(i);
      endif
    endfor
  endfor
  csvwrite('output_data_abhinav.csv',B);     
  y_low_x = [];
  y_low_y = [];
  y_low_z = [];
  n_low = 0;
  y_high_x = [];
  y_high_y = [];
  y_high_z = [];
  n_high = 0;
  final_pitch = [];
  final_roll = [];
  pitch_count = 1;
  roll_count = 1;
  B =[];
  
endfunction


execute_code        