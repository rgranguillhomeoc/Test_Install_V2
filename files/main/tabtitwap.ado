



#delimit ;
capture program drop tabtitwap;
program define tabtitwap, rclass sortpreserve;
version 9.2;
args ntab ;
local   tabtit_1       =       "Table 1: Sectoral Price Changes (in %)"      ;
local   tabtit_2       =       "Table 2: Good Price Changes (in %)"      ;
local   tabtit_3       =       "Table 3: Population and Expenditures"      ;
local   tabtit_4       =       "Table 4: The Impact on Well-being"; 
local   tabtit_5       =       "Table 5: The Structure of the Impact on Well-being"; 
local   tabtit_6       =       "Table 6: The Impact on Poverty";   
local   tabtit_7       =       "Table 7: The Impact on Inequality"; 
return local tabtit `tabtit_`ntab'' ;
end;

