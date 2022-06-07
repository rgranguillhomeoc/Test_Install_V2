




#delimit ;
capture program drop imwmc_cob_doug;
program define imwmc_cob_doug, sortpreserve rclass;
version 9.2;
syntax varlist(min=1 max=1)[ ,   PRC(varname)  HSIZE(varname)  PCEXP(varname) MEAS(int 2) MOVE(int 1)];

tokenize `varlist';



tempvar ishare;
qui gen `ishare'= `1'/`pcexp';
qui cap drop __tdef;

qui gen  __tdef = (1+`prc')^`ishare';
qui replace __tdef = 1 if __tdef ==.; 

if `meas'==2 {;
qui cap drop __imwmc ;
qui gen __imwmc =`move'*( 1 / __tdef -  1 )*`pcexp' ;
};

if `meas'==3 {;
qui cap drop __imwmc ;
qui gen __imwmc =`move'*( 1 - __tdef )*`pcexp' ;
};
end;
