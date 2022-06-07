



#delimit ;
capture program drop imwmc;
program define imwmc, sortpreserve;
version 9.2;
syntax varlist(min=1 max=1)[ ,   PRC(varname) HSIZE(varname) MOVE(int 1)];
tokenize `varlist';
tempname wvar;
qui gen `wvar' = -`1'*`move'*`prc';                                                       
cap drop __imwmc;
qui gen  __imwmc=`wvar';
end;
