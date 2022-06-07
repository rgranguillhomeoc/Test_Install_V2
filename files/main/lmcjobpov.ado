

#delimit ;



capture program drop basicpov;
program define basicpov, rclass;
syntax varlist(min=1 max=1) [, HSize(varname) AEHS(varname)  PLINE(varname)  APCEXP(varname) ALpha(real 0) ];
preserve; 
tokenize `varlist';
tempvar we ga0 ga10 ga1 hy;
gen `hy' = `1';


local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 
qui gen `we'=1;
if ("`hweight'"~="")    qui replace `we'=`we'*`hweight';


if "`stat'" == "" local stat = "exp_tt";

gen `ga0' = 0;
gen `ga10' = 0;
gen `ga1' = 0;


if (`alpha'==0) qui replace `ga0' = `hsize'*(`pline'>`apcexp');
if (`alpha'~=0) qui replace `ga0' = `hsize'*((`pline'-`apcexp')/`pline')^`alpha' if (`pline'>`apcexp');



if (`alpha'==0) qui replace `ga1' = `hsize'*(`pline'>`hy');
if (`alpha'~=0) qui replace `ga1' = `hsize'*((`pline'-`hy')/`pline')^`alpha' if (`pline'>`hy');



qui replace `ga10' = `ga1'-`ga0';


qui sum `hsize' [aweight= `we'];
local denom = r(mean);

qui sum `ga1' [aweight= `we'];
local fgt1 = r(mean)/`denom';



qui svydes;
local fr=`r(N_units)'-`r(N_strata)';

qui svy: ratio `ga10' / `hsize';
cap drop matrix _aa;
matrix _aa=e(b);
local est10 = el(_aa,1,1);
cap drop matrix _vv;
matrix _vv=e(V);
local ste10 = el(_vv,1,1)^0.5;



return scalar fgt1 = `fgt1'*100;


return scalar est10 = `est10'*100;


return scalar ste10 = `ste10'*100;



local tval = `est10'/`ste10';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `ste10'==0 local pval = 0; 
return scalar pval10 = `pval';



end;



capture program drop lmcjobpov;
program define lmcjobpov, eclass;
version 9.2;
syntax varlist(min=1)[, 
HSize(varname)  
AEHS(varname)  
PCEXP(varname)
XRNAMES(string) 
LAN(string) 
STAT(string)
ALPHA(real 0)
pline(varname)
];



*set trace on;
preserve;

tokenize `varlist';
_nargs    `varlist';
local indica2 = $indica+1;

tempvar total;
qui gen `total'=0;
tempvar Variable EST1 EST11 EST111 EST1111  ;
qui gen `EST1'=0;
qui gen `EST11'=0;
qui gen `EST111'=0;
qui gen `EST1111'=0;







tempvar Variable ;
qui gen `Variable'="";

tempvar _ths;
qui gen  `_ths'=1;
if ( "`hsize'"!="") qui replace `_ths'=`hsize';

cap svy: total;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);


tempvar apcexp;
gen `apcexp' = `pcexp';
if ("`aehs'" ~= "" ) qui replace `apcexp' = `pcexp'*`_ths'/`aehs' ;

basicpov `apcexp' ,  hsize(`_ths') pline(`pline') alpha(`alpha') apcexp(`apcexp');
qui replace `Variable' = "Pre-reform" in 1;
qui replace `EST1'=  `r(fgt1)'  in      1;
qui replace `EST11'=  . in      1;
qui replace `EST111'=  .  in    1;
qui replace `EST1111'=  .  in   1;


forvalues k = 1/$indica {;
local j = `k' +1;
tempvar sliving;
tempvar asliving;
qui gen `sliving' = `pcexp'+``k'';
qui gen `asliving' = `sliving';
if ("`aehs'" ~= "" ) qui replace `asliving' = `sliving'*`_ths'/`aehs' ;
basicpov `asliving' ,  hsize(`_ths') pline(`pline')  alpha(`alpha') apcexp(`apcexp');

qui replace `EST1'=  `r(fgt1)'  in `j';
qui replace `EST11'=  `r(est10)'  in    `j';
qui replace `EST111'=  `r(ste10)'  in   `j';
qui replace `EST1111'=  `r(pval10)'  in         `j';

};





/****TO DISPLAY RESULTS*****/

local cnam = "";

if ("`lan'"~="fr")  local cnam `"`cnam' "Poverty level""';
if ("`lan'"~="fr")  local cnam `"`cnam' "The change in poverty ""';
if ("`lan'"~="fr")  local cnam `"`cnam' "Standard error""';
if ("`lan'"~="fr")  local cnam `"`cnam' "P-Value""';



                                         


if ("`lan'"=="fr")  local cnam `"`cnam' "Niveau de pauvret�""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Le changement dans la pauvret�""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Erreur type""';
if ("`lan'"=="fr")  local cnam `"`cnam' "P-Value""';





local lng = (`indica2');
qui keep in 1/`lng';

local dste=0;



tempname zz;
qui mkmat   `EST1'  `EST11'  `EST111' `EST1111'  ,   matrix(`zz');



local rnam;
local rnam `"`rnam' "Pre reform""';
local count : word count `varlist';

tokenize `varlist' ;
forvalues i = 1/`count' {;
            local tmp = substr("``i''",1,30);
            local rnam `"`rnam' "`tmp'""';
};





matrix rownames `zz' = `rnam' ;
matrix colnames `zz' = `cnam' ;


cap matrix drop _vv _aa gn;

ereturn matrix est = `zz';

restore;

end;



