


#delimit ;



capture program drop basicpov_light;
program define basicpov_light, rclass;
syntax varlist(min=1 max=1) [, HSize(varname) HGROUP(varname) AEHS(varname)  PLINE(varname)  APCEXP(varname) ALpha(real 0) ];
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

if (`alpha'==0) qui replace `ga0' = `we'*(`pline'>`apcexp');
if (`alpha'~=0) qui replace `ga0' = `we'*((`pline'-`apcexp')/`pline')^`alpha' if (`pline'>`apcexp');



if (`alpha'==0) qui replace `ga1' = `we'*(`pline'>`hy');
if (`alpha'~=0) qui replace `ga1' = `we'*((`pline'-`hy')/`pline')^`alpha' if (`pline'>`hy');



qui replace `ga10' = `ga1'-`ga0';
qui sum `ga10' [aweight= `we'];
local dif = r(mean);

end;



capture program drop mcjobpov_light;
program define mcjobpov_light, eclass;
version 9.2;
syntax varlist(min=1)[, 
HSize(varname)  
HGROUP(varname)
AEHS(varname)  
PCEXP(varname)
XRNAMES(string) 
LAN(string) 
STAT(string)
ALPHA(real 0)
pline(varname)
MOVE(int 1)
];



*set trace on;
preserve;

tokenize `varlist';
_nargs    `varlist';
local indica2 = $indica+2;

tempvar total;
qui gen `total'=0;
tempvar Variable DIF   ;
qui gen `DIF'=0;

forvalues i=1/$indica {;
qui replace `total'=`total'+``i'';
};



tempvar Variable ;
qui gen `Variable'="";

tempvar _ths;
qui gen  `_ths'=1;
if ( "`hsize'"!="") qui replace `_ths'=`hsize';

cap svy: total;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);


tempvar apcexp;
gen `apcexp' = `pcexp';
if (`move'==1)     {; 
tempvar sliving asliving osliving;
qui gen `sliving' = `pcexp'-`total';
qui gen `asliving' = `sliving';
if ("`aehs'" ~= "" ) qui replace `asliving' = `sliving'*`_ths'/`aehs' ;
gen `osliving' = `asliving' ;
basicpov_light `asliving' ,  hsize(`_ths') pline(`pline') alpha(`alpha') apcexp(`pcexp');
};
if (`move'==-1)     {; 
tempvar sliving asliving osliving;
qui gen `sliving' = `pcexp'+`total';
qui gen `asliving' = `sliving';
if ("`aehs'" ~= "" ) qui replace `asliving' = `sliving'*`_ths'/`aehs' ;
gen `osliving' = `asliving' ;
basicpov_light `pcexp' ,  hsize(`_ths') pline(`pline') alpha(`alpha') apcexp(`asliving');
};


qui replace `Variable' = "Pre-reform" in 1;
qui replace `DIF'=  `r(dif)'  in 	1;



forvalues k = 1/$indica {;
local j = `k' +1;
tempvar sliving;
tempvar asliving;
if (`move'== 1)   qui gen `sliving'  = `pcexp'-`total'+``k'';
if (`move'==-1)   qui gen `sliving'   = `pcexp'+``k'';
qui gen `asliving' = `sliving';
if ("`aehs'" ~= "" ) qui replace `asliving' = `sliving'*`_ths'/`aehs' ;
if (`move'== 1)   basicpov_light `asliving' ,  hsize(`_ths') pline(`pline')  alpha(`alpha') apcexp(`osliving');
if (`move'==-1)   basicpov_light `asliving' ,  hsize(`_ths') pline(`pline')  alpha(`alpha') apcexp(`pcexp');
qui replace `DIF'=  `r(dif)'  in `j';


};

if (`move'==-1)     {; 

tempvar sliving asliving;
qui gen `sliving' = `pcexp'+`total';
qui gen `asliving' = `sliving';
if ("`aehs'" ~= "" ) qui replace `asliving' = `sliving'*`_ths'/`aehs' ;
basicpov_light `asliving' ,  hsize(`_ths') pline(`pline') alpha(`alpha') apcexp(`pcexp');
};
if (`move'==1)     {; 
tempvar sliving asliving;
qui gen `sliving' = `pcexp'+`total';
qui gen `asliving' = `sliving';
if ("`aehs'" ~= "" ) qui replace `asliving' = `sliving'*`_ths'/`aehs' ;
basicpov_light `pcexp' ,  hsize(`_ths') pline(`pline') alpha(`alpha') apcexp(`osliving');
};
qui replace `DIF'=  `r(dif)' in `indica2';
qui replace `Variable' = "Post-reform" in `indica2';



list `Variable' `DIF' in 1/`indica2' ;


/*

/****TO DISPLAY RESULTS*****/

local cnam = "";

if ("`lan'"~="fr")  local cnam `"`cnam' "Poverty level""';
if ("`lan'"~="fr")  local cnam `"`cnam' "The change in poverty ""';
if ("`lan'"~="fr")  local cnam `"`cnam' "Standard error""';
if ("`lan'"~="fr")  local cnam `"`cnam' "P-Value""';



					 


if ("`lan'"=="fr")  local cnam `"`cnam' "Niveau de pauvreté""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Le changement dans la pauvreté""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Erreur type""';
if ("`lan'"=="fr")  local cnam `"`cnam' "P-Value""';





local lng = (`indica2');
qui keep in 1/`lng';

local dste=0;



tempname zz;
qui mkmat   `EST1'  `EST11'  `EST111' `EST1111'  ,   matrix(`zz');

if `move'== 1 {;
local inlab = "Competitive  Market" ;
local filab = "Concentrated Market" ;
};
if `move'==-1 {;
local filab = "Competitive  Market" ;
local inlab = "Concentrated Market" ;
};

local rnam;
local rnam `"`rnam' "`inlab'""';
if ("`xrnames'"~="") {;
local xrna  "`xrnames'";
local xrna : subinstr local xrna " " ",", all ;
local xrna : subinstr local xrna "|" " ", all ;
local count : word count `xrna';
tokenize "`xrna'";
forvalues i = 1/`count' {;
	local `i': subinstr local `i' "," " ", all ;
	    local tmp = substr("``i''",1,30);
	    local rnam `"`rnam' "`tmp'""';
	
};
};

local rnam `"`rnam' "`filab'""';



matrix rownames `zz' = `rnam' ;
matrix colnames `zz' = `cnam' ;


cap matrix drop _vv _aa gn;

ereturn matrix est = `zz';
*/
restore;

end;



