




#delimit ;
capture program drop imwmc_ces;
program define imwmc_ces, sortpreserve rclass;
version 9.2;
syntax varlist(min=1 max=1)[ ,   PRC(varname)  HSIZE(varname)  PCEXP(varname) MEAS(int 2) SUBS(real 0.4) MOVE(int 1) ];

tokenize `varlist';


tempvar alpha;
qui gen `alpha'= `1'/`pcexp';

cap drop __tdef ;
qui gen  __tdef = (1+`prc')^`alpha';
qui replace __tdef = 1 if __tdef ==.; 

tempvar index0 index1;

if `meas'==2 {;
qui gen  `index0' = (`alpha'^`subs'                      + (1-`alpha')^`subs')^(-1/((1-`subs')));
qui gen  `index1' = (`alpha'^`subs'*(1+`prc')^(`subs'-1) + (1-`alpha')^`subs')^(-1/((1-`subs')));
qui cap drop __imwmc ;
qui gen __imwmc = `move'*`pcexp'*(`index0'/`index1' - 1); 
};

if `meas'==3 {;
qui gen  `index0' = (`alpha'^`subs' + (1-`alpha')^`subs')^(-1/((1-`subs')));
qui gen  `index1' = (`alpha'^`subs'*(1+`prc')^(`subs'-1) + (1-`alpha')^`subs')^(-1/((1-`subs')));
qui cap drop __imwmc ;
qui gen __imwmc = `move'*`pcexp'*(1-`index1'/`index0'); 
};

end;

