
#delim ;
capture program drop _nargs;
program define _nargs, rclass;
version 9.2;
syntax varlist(min=0);
quietly {;
tokenize `varlist';
local k = 1;
mac shift;
while "``k''" ~= "" {; 
local k = `k'+1;
};
};
global indica=`k';
end;


capture program drop cmnpe2;
program define cmnpe2, rclass;
version 9.2;
args ww xxx yyy xval band  ;
preserve;
tempvar www;
qui gen `www'=`ww';
cap drop if `yyy'>=.;
cap drop if `www'>=.;
cap drop if `xxx'>=.;

tempvar _ra _npe  _t1 _t2  _kt5 _vy _vx _vx2 _vx3 _vx4;
cap drop  `_npe' ;
qui gen   `_npe' =0;
cap drop `_kt5' `_vy' `_vx' `_vx2';
qui gen `_kt5' = (exp(-0.5* ( ((`xval'-`xxx')/`band')^2  )  )   )^0.5;
qui gen `_vy'=`_kt5'*`yyy';
qui gen `_vx'=`_kt5'*(`xxx'-`xval');
qui gen `_vx2'=0.5*`_kt5'*(`xxx'-`xval')^2;

qui regress `_vy'  `_kt5' `_vx' `_vx2'  [aw = `www'],noconstant;
cap matrix drop _cc;
matrix _cc = e(b);
local _npe = el(_cc,1,1);
return scalar npe = `_npe';
restore;

end;


capture program drop gcmnpe2;
program define gcmnpe2, rclass;
version 9.2;
args ww xxx yyy min max band approach ;
preserve;
tempvar www;

qui gen `www'=`ww';
cap drop if `yyy'>=.;
cap drop if `www'>=.;
cap drop if `xxx'>=.;
tempvar _ra _npe  _t1 _t2  _kt5 _vy _vx _vx2 _vx3 _vx4;
cap drop `_ra' `_npe' ;
qui gen `_npe' =0;
qui gen `_ra'  =0;
local pas = (`max'-`min')/100;
qui count;
if (r(N)<101) qui set obs 101; 
forvalues j=1/101 {;
qui replace `_ra'=`min'+(`j'-1)*`pas' in `j';
};
                  



forvalues j=1/101 {;
cap drop `_kt5' `_vy' `_vx' `_vx2';
qui gen `_kt5' = (exp(-0.5* ( ((`_ra'[`j']-`xxx')/`band')^2  )  )   )^0.5;
qui gen `_vy'=`_kt5'*`yyy';
qui gen `_vx'=`_kt5'*(`xxx'-`_ra'[`j']);
qui gen `_vx2'=0.5*`_kt5'*(`xxx'-`_ra'[`j'])^2;
qui regress `_vy'  `_kt5' `_vx' `_vx2'  [aw = `www'],noconstant;
cap matrix drop _cc;
matrix _cc = e(b);
qui replace `_npe'  = el(_cc,1,1) in `j';
};
qui keep in 1/101;
set matsize 101;
cap matrix drop _xx;
mkmat `_npe' , matrix (_xx);
restore;
end;


capture program drop cmnpe;
program define cmnpe, rclass sortpreserve;
version 9.2;
syntax namelist(min=1)[, 
MULT(real 1)
BAND(real 0) 
MIN(string) 
MAX(string)
XVAL(string)
LAB1(string)
LAB2(string)
LAB3(string)
LAB4(string)
LAB5(string)
LAB6(string)
NCUV(int 3)
LRES(int 0)  SRES(string) DGRA(int 1) SGRA(string) EGRA(string) HGROUP(string) *];
preserve;
_get_gropts , graphopts(`options') ;
	local goptions `"`s(graphopts)'"';
	local hgroup = "";
	
tokenize `namelist' ;
local nn=colsof(`1');
local nn1=colsof(`1')-1;
cap drop __tvar*;

svmat `1' , names(__tvar);	

local xvar = "__tvar1";
forvalues i=2/`nn' {;
local myvarlist `myvarlist' __tvar`i' ;
};



/* Errors */


if ("`xvar'"=="") {;
disp as error "You need to specify the varname of xvar (see the help).";
exit;
};


cap drop _cor*;
cap drop _xx*;	



tokenize  `myvarlist';
_nargs    `myvarlist';

qui svyset ;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);
local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 


tempvar fw;
local _cory  = "";
local label = "";
qui gen `fw'=1;

if ("`hsize'"  ~="")       qui replace `fw'=`fw'*`hsize';
if ("`hweight'"~="")       qui replace `fw'=`fw'*`hweight';

qui su `xvar' [aw=`fw'], detail;            
local tmp = (`r(p75)'-`r(p25)')/1.34;                           
local tmp = (`tmp'<`r(sd)')*`tmp'+(`tmp'>=`r(sd)')*`r(sd)';     
                       local h   =     0.9*`tmp'*_N^(-1.0/5.0);  
if (`band'==0) local band=`h';   


if ("`ctitle'"   ~="")     local ftitle ="`ctitle'";
if ("`cstitle'"  ~="")     local stitle ="`cstitle''";




if ($indica>1) local tits="s";
                     local ftitle = "Non parametric regression";



if (`band' >= 1 ) local ba = round(`band'*100)/100;
if (`band'  < 1 ) local ba = round(`band'*100000)/100000;

local stitle = "(Linear Locally Estimation Approach  | Bandwidth = `ba' )";                      local ytitle = "E(Y|X)";
local xtitle = "X values";
if ("`cytitle'"  ~="") local ytitle ="`cytitle'";
if ("`cxtitle'"  ~="") local xtitle ="`cxtitle'";
if ("`rtype'"=="lvl") {;
if ("`min'"  =="")      local min =`r(min)';
if ("`max'"  =="")      local max =`r(max)';
};

if ("`rtype'"=="prc") {;
if ("`min'"  =="")      local min =0;
if ("`max'"  =="")      local max =1;
};

if ("`type'"  =="")     local type ="yes";
if ("`approach'"=="")   local approach = "lle";
qui count;
if (r(N)<101) qui set obs 101;

forvalues k = 1/$indica {;

local _cory  = "`_cory'" + " _cory`k'";
local f=`k';
if ("`hgroup'"=="") {;
local label`f'  =  "``k''";
gcmnpe2 `fw' `xvar' ``k'' `min' `max'   `band'   ;
qui svmat float _xx;
cap matrix drop _xx;
rename _xx1 _cory`k';
qui replace  _cory`k' =  _cory`k'*`mult' ;

};
};

qui keep in 1/101;
gen _corx=0;
local m5  = (`max'-`min')/5;
local pas = (`max'-`min')/100;
forvalues j=1/101 {;
qui replace _corx=`min'+(`j'-1)*`pas' in `j';
};

if( `lres' == 1) {;
set more off;
list _corx _cory*;
};
local nc=`nn1'/3;
local colo1 red ;
local colo2 blue ;
local colo3 yellow ;
local colo4 green ;
local colo5 lime;
local colo6 maroon;

if "`lab2'"~="" local lord "" ;
if "`lab2'"==""  {;
local lord 1 ;
local remlab `remlab' label(1 "CI 95% ") ;
};
forvalues i=1/`nc' {;
if `i'> 7 local colo`i' grid`i' ;
local v=(`i'-1)*3+1;
local k=(`i'-1)*3+2;
local l=(`i'-1)*3+3;
local rarea`i'  ( rarea _cory`k' _cory`l'  _corx, fcolor(`colo`i'') fintensity(20) lcolor(white) lwidth(thin)  sort ) ;
local lcor `lcor' _cory`v' ;
local j = `nc'+`i';
local lord `lord' `j' ;
local remlab `remlab' label(`j'  `"`lab`i''"') ;
};

quietly {;
if (`dgra'!=0) {; 
twoway 
`rarea1' `rarea2' `rarea3' `rarea4' `rarea5'  `rarea6' ||
(
line `lcor' _corx, 
lcolor(black) lpattern(solid)
title(`ftitle')
/*subtitle(`stitle')*/
ytitle(`ytitle')
xtitle(Deciles) 
xscale(range(`min' `max'))
xlabel(`min'(1)`max', labsize(small), , grid gmin gmax gextend)
ylabel(, labsize(small))
plotregion(margin(zero))
leg( on order(`lord')  
label(1 "") 
`remlab' 
)  
)


,

 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(3.6)) 
  ylabel(, angle(horizontal) labsize(3.6))
  xtitle(, size(3.8) margin(0 0 0 2))
  ytitle(, size(3.8))  
  title(, size(4.6))
  scheme(s2mono)
  /*subtitle("")*/
  `goptions'
;
};



cap matrix drop _xx;
if( "`sres'" ~= "") {;
keep _corx _cory*;
save `"`sres'"', replace;
};

if( "`sgra'" ~= "") {;
graph save `"`sgra'"', replace;
};

if( "`egra'" ~= "") {;
graph export `"`egra'"', replace;
};

cap drop _cor*;
cap drop _npe;
cap drop _nped;
cap drop _gn1;
cap drop __tvar*;
}; // end of quietly
end;

