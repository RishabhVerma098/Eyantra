global A = csvread('csv_matter.csv');
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
  disp(eightBit);
  ax = bin2dec(strcat(eightBit{1},eightBit{2}));
  ay = bin2dec(strcat(eightBit{3},eightBit{4}));
  az = bin2dec(strcat(eightBit{5},eightBit{6}));
  
  combined_signals = [ax, ay,az];
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
  ####################################################
  # Call function lowpassfilter(ax,ay,az,f_cut) here #
  ####################################################

endfunction

function lowpassfilter(ax,ay,az,f_cut)
  dT = 0.01;  
  Tau= 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);    
  
  #y[n] = (1-alpha).x[n] + alpha.y[n-1]
  
  
  
  
  
  ################################################
  ##############Write your code here##############
  ################################################
  
endfunction


function execute_code
  global A
  #for n = 1:rows(A)   #do not change this line
    
    ###############################################
    ####### Write a code here to calculate  #######
    ####### PITCH using complementry filter #######
    ###############################################
    
  #endfor
  read_accel(1,160,0,196,60,0);  
  
endfunction


execute_code        