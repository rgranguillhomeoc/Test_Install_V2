


#delimit;
capture program drop mcjob52;
program define mcjob52, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  WAPPR(int 1) MODEL(int 1) GVIMP(int 0) SUBS(real 0.4) MOVE(int 1) PLINE(string) STEP(int 1)];


tokenize  `varlist';
_nargs    `varlist';




tempvar price_def;
qui gen `price_def' = 1;
forvalues i=1/$indica {;
tempvar Variable EST`i';
qui gen `EST`i''= 0;
local pointa = `step'+1;

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



if (`wappr'==2 & `model' ==1) {;

tempvar tot_imp;
qui gen `tot_imp' =`move'*( (1 / `price_def') -  1 )*`pcexp' ;
mcjobpov `tot_imp',    hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(total)  pcexp(`pcexp') alpha(1)  pline(`pline')  move(`move');
tempname mat52tot ;
matrix `mat52tot'= e(est); 

};
 
 

if (`wappr'==3 & `model' ==1) {;
tempvar tot_imp;
qui gen `tot_imp' =`move'*( 1- `price_def')*`pcexp' ;
mcjobpov `tot_imp',    hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(total)  pcexp(`pcexp') alpha(1)  pline(`pline')  move(`move');
tempname mat52tot ;
matrix `mat52tot'= e(est); 
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
cap drop _imp_total;
if (`gvimp'==1 ) qui gen _imp_total = __imwmc;

cap drop  __imwmc;
mcjobpov `tot_imp',    hs(`hsize') aehs(`aehs')  lan(`lan')    xrnames(`slist')   pcexp(`pcexp') alpha(1)  pline(`pline')  move(`move');
tempname mat52tot ;
matrix `mat52tot'= e(est); 
};

aggrvar `nlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
mcjobpov `flist',    hs(`hsize') aehs(`aehs')  lan(`lan')    xrnames(`slist')   pcexp(`pcexp') alpha(1)  pline(`pline')  move(`move');

cap drop `drlist';
tempname mat52 ;
matrix `mat52'= e(est);

if (`wappr' != 1 ) {;
local rowsize = rowsof(`mat52');
local colsize = colsof(`mat52');
forvalues i=1/`rowsize' {;
 matrix `mat52'[ `i',`colsize'] = el(`mat52tot',`i',1);
};
};


ereturn matrix est = `mat52';
end;



