


#delimit;
capture program drop mcjob61b;
program define mcjob61b, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  WAPPR(int 1) MODEL(int 1) GVIMP(int 0) SUBS(real 0.4) MOVE(int 1) PLINE(string) NITEMS(int 1)];

tokenize  `varlist';
_nargs    `varlist';

//matrix list tab1_1;
local steps = rowsof(tab1_1);

local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 
tempvar fw;
qui gen `fw'=1;
if ("`hweight'"~="")    qui replace `fw'=`fw'*`hweight';
if ("`hsize'"~="")      qui replace `fw'=`fw'*`hsize';

forvalues it = 1/`nitems'  {;
cap drop `res_`it'';
tempvar res_`it' ;
qui gen `res_`it'' = 0;
};

tempvar res_all ;
qui gen `res_all' = 0;
forvalues s = 1/`steps'  {;

tempvar price_def;
qui gen `price_def' = 1;



forvalues i=1/$indica {;

local pointa = `s';


cap drop _prc`i';

/* if (`move'==-1 )  local prc`i' =  el(tab1_`i', 1, colsof(tab1_`i'))-el(tab1_`i', `pointa', colsof(tab1_`i')); */
if (`move'==-1 )   qui gen  _prc`i' = _pr_`i'_1 -  _pr_`i'_`pointa' ;

/* if (`move'== 1)   local prc`i' = -el(tab1_`i', 1, colsof(tab1_`i'))+el(tab1_`i', `pointa', colsof(tab1_`i')); */

if (`move'== 1)    qui gen  _prc`i' =   _pr_`i'_`pointa' -_pr_`i'_1  ; 


if (`wappr'==1)            imwmc ``i'' , prc(_prc`i') hsize(`hsize') move(`move');

if (`wappr'==2 & `model' ==1 ) {;
                  imwmc_cob_doug ``i'' , prc(_prc`i') hsize(`hsize') pcexp(`pcexp') meas(`wappr') move(`move');
				  qui replace `price_def' = `price_def' * __tdef;
				 };
				 
if (`wappr'==3 & `model' ==1 ) {;
                  imwmc_cob_doug ``i'' , prc(_prc`i') hsize(`hsize') pcexp(`pcexp') meas(`wappr') move(`move');
				  qui replace `price_def' = `price_def' * __tdef;
				 }; 
				 
				 
if (`wappr'==2 & `model' ==2 ) {;
                  imwmc_ces ``i'' , prc(_prc`i') hsize(`hsize') pcexp(`pcexp') meas(`wappr') subs(`subs') move(`move');
				  qui replace `price_def' = `price_def' * __tdef;
				 };
				 
if (`wappr'==3 & `model' ==2 ) {;
                  imwmc_ces ``i'' , prc(_prc`i') hsize(`hsize') pcexp(`pcexp') meas(`wappr')  subs(`subs') move(`move');
				  qui replace `price_def' = `price_def' * __tdef;
				 }; 
				 
				
tempvar imwmc_``i'' ;
qui gen  `imwmc_``i''' = __imwmc;
local nlist `nlist' `imwmc_``i''' ;
cap drop _imp_``i'' ;
if (`gvimp'==1 ) qui gen _imp_``i'' = __imwmc;
cap drop __imwmc;
cap drop __tdef;
cap drop _prc*;

};

if (`wappr'==1 ) {;
cap drop `tot_imp';
tempvar tot_imp;
qui gen `tot_imp' =0;
forvalues it = 1/`nitems'  {;
qui replace `tot_imp' = `tot_imp'+  `imwmc_``it''' ;
};
};

if (`wappr'==2 & `model' ==1) {;

tempvar tot_imp;
qui gen `tot_imp' =`move'*( (1 / `price_def') -  1 )*`pcexp' ;
};
 
 

if (`wappr'==3 & `model' ==1) {;
tempvar tot_imp;
qui gen `tot_imp' =`move'*( 1- `price_def')*`pcexp' ;
};
 
 if ((`wappr'==2 | `wappr'==3) & `model' ==2) {;
 forvalues i=1/$indica {;
cap drop _prc`i';
if (`move'==-1 )   qui gen  _prc`i' = _pr_`i'_1 -  _pr_`i'_`pointa' ;
if (`move'== 1)    qui gen  _prc`i' =   _pr_`i'_`pointa' -_pr_`i'_1  ; 
};
 
if $indica<10 {;
local j = $indica+1;
  forvalues i=`j'/10 {;
  cap drop _prc`i' ;  
  qui gen  _prc`i'=0 ;  
  };
  };
  
imwmc_ces_all `varlist' , 
prc1(_prc1)  prc2(_prc2)   prc3(_prc3)  prc4(_prc4)   prc5(_prc5) 
prc6(_prc6)  prc7(_prc7)   prc8(_prc8)  prc9(_prc9)   prc10(_prc10)  
hsize(`hsize') pcexp(`pcexp') meas(`wappr')  subs(`subs') move(`move');
tempvar tot_imp;
qui gen `tot_imp' = __imwmc; 
cap drop  __imwmc;

};

cap drop `pcexpi';
tempvar pcexpi ;
gen `pcexpi' = (`pcexp'+`tot_imp');
*qui fgini `pcexpi' [pw=`fw'];

local lista = "";
forvalues it = 1/`nitems'  {;

tempvar pcexpi_`it' ;
cap drop `pcexpi_`it'';
qui gen `pcexpi_`it'' = (`pcexp'+`imwmc_``it''');
qui fgini `pcexpi_`it'' [pw=`fw'];
qui replace `res_`it'' = r(gini) in `s' ;

local lista `lista' `res_`it'';
};

cap drop `pcexp_tot_im';
tempvar pcexp_tot_im ;
gen `pcexp_tot_im' = (`pcexp'+`tot_imp');
qui fgini `pcexp_tot_im' [pw=`fw'];
qui replace `res_all' = r(gini) in `s' ;
local lista `lista' `res_all';
};

list `lista' in 1/`steps';
mkmat  `lista' in 1/`steps', matrix(_gmat);
ereturn matrix gmat = _gmat;
end;






