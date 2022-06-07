
#delimit;
capture program drop prjob64;
program define prjob64, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  WAPPR(int 1) MODEL(int 1) GVIMP(int 0) SUBS(real 0.4) MATPEL(string) MATIEL(string) SOTM(int 1)];

tokenize  `varlist';
_nargs    `varlist';



tempvar price_def;
qui gen `price_def' = 1;

forvalues i=1/$indica {;
tempvar Variable EST`i';
qui gen `EST`i''= 0;
cap drop _prc`i';
qui gen  _prc`i' =   _pr_`i'; 
local wappr1 = `wappr'-1;

if (`wappr'==1)            imwmc ``i'' , prc(_prc`i') hsize(`hsize') ;

if (`wappr'==2)    {;
 forvalues j=1/$indica {;
cap drop _prc`j';
qui gen  _prc`j' =  _pr_`j';  
};
 
if $indica<10 {;
local j = $indica+1;
  forvalues v=`j'/10 {;
  cap drop _prc`v' ;  
  qui gen  _prc`v'=0 ;  
  };
  };
imwmc_el `varlist' , prc(_prc`i')  elas(_elas`i') hsize(`hsize')  matpel(`matpel') matiel(`matiel') sotm(`sotm')
prc1(_prc1)  prc2(_prc2)   prc3(_prc3)  prc4(_prc4)   prc5(_prc5) 
prc6(_prc6)  prc7(_prc7)   prc8(_prc8)  prc9(_prc9)   prc10(_prc10) posa(`i') pcexp(`pcexp') itexp(``i'');
};

if (`wappr'==3 & `model' ==1 ) {;
                  imwmc_cob_doug ``i'' , prc(_prc`i') hsize(`hsize') pcexp(`pcexp') meas(`wappr1') ;
				  qui replace `price_def' = `price_def' * __tdef;
				 };
				 
if (`wappr'==4 & `model' ==1 ) {;
                  imwmc_cob_doug ``i'' , prc(_prc`i') hsize(`hsize') pcexp(`pcexp') meas(`wappr1') ;
				  qui replace `price_def' = `price_def' * __tdef;
				 }; 
				 
				 
if (`wappr'==3 & `model' ==2 ) {;
                  imwmc_ces ``i'' , prc(_prc`i') hsize(`hsize') pcexp(`pcexp') meas(`wappr1') subs(`subs') ;
				  qui replace `price_def' = `price_def' * __tdef;
				 };
				 
if (`wappr'==4 & `model' ==2 ) {;
                  imwmc_ces ``i'' , prc(_prc`i') hsize(`hsize') pcexp(`pcexp') meas(`wappr1')  subs(`subs') ;
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



if (`wappr'==3 & `model' ==1) {;

tempvar tot_imp;
qui gen `tot_imp' =( (1 / `price_def') -  1 )*`pcexp' ;
mcjobratio `tot_imp',   hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp')       ;
tempname mat64tot ;
matrix `mat64tot'= e(est); 

};
 
 

if (`wappr'==4 & `model' ==1) {;
tempvar tot_imp;
qui gen `tot_imp' =( 1- `price_def')*`pcexp' ;
mcjobratio `tot_imp',   hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp')       ;
tempname mat64tot ;
matrix `mat64tot'= e(est); 
};
 
 if ((`wappr'==3 | `wappr'==4) & `model' ==2) {;
 forvalues i=1/$indica {;
cap drop _prc`i';
qui gen  _prc`i' =   _pr_`i'; 
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
hsize(`hsize') pcexp(`pcexp') meas(`wappr1')  subs(`subs') ;
tempvar tot_imp;
qui gen `tot_imp' = __imwmc; 
cap drop _imp_total;
if (`gvimp'==1 ) qui gen _imp_total = __imwmc;

cap drop  __imwmc;
prjobratio `tot_imp',   hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp')    ;
tempname mat64tot ;
matrix `mat64tot'= e(est); 
};

aggrvar `nlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
prjobratio `flist',   hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp')       ;

cap drop `drlist';
tempname mat64 ;
matrix `mat64'= e(est);


ereturn matrix est = `mat64';
end;



