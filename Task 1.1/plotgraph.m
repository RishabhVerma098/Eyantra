function execute_code
  Array_eyantra = csvread('e_yantra_csv_output.csv');
  Array = csvread('output_data.csv');
  col1 = Array(:,1);
  col2 = Array_eyantra(:,1);
  plot(col1);
  hold on;
  plot(col2);
 
endfunction
execute_code                           #do not change this line
