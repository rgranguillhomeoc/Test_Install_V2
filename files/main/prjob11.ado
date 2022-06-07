
#delimit;
capture program drop prjob11;
program define prjob11, eclass;
version 9.2;
syntax varlist  [,  STAT(string) ];
preserve;
local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 
forvalues i=1/8 {;
tempvar stat`i';
qui gen `stat`i'' = . ;
};
_nargs `varlist';
tokenize `varlist';
tempvar itn ;
gen `itn' = "";

forvalues i=1/4 {;
tempvar  check`i';	
qui gen `check`i'' = 1;
};

forvalues i=1/$indica {;
qui replace  `itn' = "``i''" in `i' ;

qui count if ``i'' < 0;
qui replace  `stat1' = `r(N)' in `i' ;
qui replace `check1' =  `check1'*(``i''<0) ;

qui count if ``i'' == 0;
qui replace  `stat2' = `r(N)' in `i';
qui replace `check2' =  `check2'*(``i''==0) ;

qui count if ``i'' > 0;
qui replace  `stat3' = `r(N)' in `i';
qui replace `check3' =  `check3'*(``i''>0) ;

qui count if ``i'' ==.;
qui replace  `stat4' = `r(N)' in `i';
qui replace `check4' =  `check4'*(``i''==.);
};



local j = $indica + 1 ;
forvalues i=1/4 {;
qui count if `check`i'' == 1 ;
qui replace  `stat`i'' = `r(N)' in `j';
local reslist `reslist'  `stat`i'' ;
};


tempname mat11 ;
mkmat `reslist' in 1/`j', matrix(`mat11');
matrix coleq    `mat11' = "Observations with" "Observations with" "Observations with" "Observations with" ;
matrix colnames `mat11' = "values < 0"  "values = 0"  "values > 0"  "missing values";
matrix rownames `mat11' = `varlist' "Jointly checked" ;
ereturn matrix est = `mat11';
restore;
end;


