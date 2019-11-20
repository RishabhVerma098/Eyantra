function execute_code
  array_eyantra = csvread('e_yantra_csv_output.csv');
  array = csvread('output_data.csv');
  col1 = array(:,1);
  col2 = array_eyantra(:,1);
  plot(col2);
  hold on;
  plot(col1);
 
endfunction
execute_code                           #do not change this line
