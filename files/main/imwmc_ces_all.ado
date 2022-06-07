




#delimit ;
capture program drop imwmc_ces_all;
program define imwmc_ces_all, sortpreserve rclass;
version 9.2;
syntax varlist(min=1)[ ,   
PRC1(varname)  PRC2(varname)   PRC3(varname)   PRC4(varname)   PRC5(varname) 
PRC6(varname)  PRC7(varname)   PRC8(varname)   PRC9(varname)   PRC10(varname) 
HSIZE(varname)  PCEXP(varname) MEAS(int 2) SUBS(real 0.4) MOVE(int 1) ];

tokenize `varlist';
tempvar  tot_alpha ;
qui gen `tot_alpha'= 0;
tempvar index0 index1;
qui gen  `index0' = 0;
qui gen  `index1' = 0;
forvalues i=1/$indica {;
tempvar alpha`i'; 
qui gen `alpha`i''= ``i''/`pcexp';
qui replace  `tot_alpha'= `tot_alpha'+ `alpha`i'';
qui replace `index0' = `index0' + `alpha`i''^`subs';
qui replace `index1' = `index1' + `alpha`i''^`subs'*(1+`prc`i'')^(`subs'-1);
};
qui replace `index0' = `index0' + (1-`tot_alpha')^`subs';  
qui replace `index1' = `index1' + (1-`tot_alpha')^`subs'; 


qui replace `index0' = `index0'^(-1/((1-`subs'))); 
qui replace `index1' = `index1'^(-1/((1-`subs')));

if `meas'==2 {;
qui cap drop __imwmc ;
qui gen __imwmc = `move'*`pcexp'*(`index0'/`index1' - 1); 
};

if `meas'==3 {;
qui cap drop __imwmc ;
qui gen __imwmc = `move'*`pcexp'*(1-`index1'/`index0'); 
};

end;

