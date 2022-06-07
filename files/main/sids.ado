

#delimit ;
cap program drop sids;
program define sids, rclas;
syntax varlist(min=3 max=3)[, 
INCPAR(varname)
HGROUP(varname)
indcon(string) 
indcat(string) 
DEC(int  4)
DREGRES(int 0)
XFIL(string)
DGRA(int 0)   *
INCINT(int 0)
INC(int 1)];
version 12;
set matsize 800;
_get_gropts , graphopts(`options') ;
	local goptions `"`s(graphopts)'"';	

	
	
if ("`hgroup'"!="") {;

preserve;
capture {;

local lvgroup:value label `hgroup';
if ("`lvgroup'"!="") {;
uselabel `lvgroup' , clear;
qui count;
forvalues i=1/`r(N)' {;
local tem=value[`i'];
local grlab`tem' =  substr(label[`i'],1, 26);
};
};
};


restore;


preserve;
qui tabulate `hgroup', matrow(gn);
svmat int gn;
global indicag=r(r);
tokenize `varlist';
};


if ("`hgroup'"!="") {;
forvalues i=1/$indicag {;
local gr = gn1[`i'];
local sgrlab`gr' = "`hgroup'_`gr'" ;
if "`grlab`gr''"  == "" local grlab`gr' = "`hgroup'_`gr'" ;
local tmps =  subinstr("`grlab`gr''", " ", "_", .);
if  "`tmps'"  ~= "" local grlab`gr' = "`tmps'" ;
};
};







#delimit ; 
if ("`indcat'"~="") {;
foreach var of varlist `indcat' {;
qui sum  `var';
local rmi = r(min);
local rma = r(max);
forvalues i= `rmi'/`rma' {;
qui count if `var' == `i';
if `r(N)' !=0 {;
cap drop `var'_`i';
qui gen `var'_`i' = `var' == `i';
local name : label (`var') `i';
local uname = proper("`name'");
if "`uname'" == "" { ;
local uname = proper("`var'");
local uname `uname'_`i';
};
lab var `var'_`i' "`uname'";
local lnindcat `lnindcat' `var'_`i';
};
};
};
};

qui svyset ;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);


tokenize "`xfil'" ,  parse(".");
local tname `1'.xml;

if ( "`tjobs'"~="off" ) {;
if "`xfil'" ~= ""  { ;
tokenize "`xfil'" ,  parse(".");
local xfil `1'.xml ;
cap erase  `1'.xml ;
cap winexec   taskkill /IM excel.exe ;
};
};
estimates drop _all;

tokenize `varlist';
cap drop if `1' ==. ; 
cap drop if `2' ==. ;
cap drop if `3' ==. ;


if `incint' == 0 & `inc' == 1  local subcom  LnHH_Inc ;


cap drop  LnQuantity ;
qui gen   LnQuantity = ln(`1');
qui replace LnQuantity = 0 if LnQuantity==. ;
cap drop  LnPrice ;
qui gen   LnPrice  = ln(`2');

cap drop  LnHH_Inc ;
qui gen   LnHH_Inc  = ln(`3');

if "`incpar'" ~= "" {;
qui tab `incpar';
local nigr = `r(r)';
if `nigr' == 10 local iname = "Decile" ;
if `nigr' ==  5 local iname = "Quintile" ;
if `nigr' ==  4 local iname = "Quartile" ;
if `nigr' != 10 & `nigr' != 5 & `nigr' != 4   local iname = "IncGr" ;

											 local grgname = "`iname'";
if `nigr' != 10 & `nigr' != 5 & `nigr' != 4  local grgname = "Income_Partition (`nigr')";
};


if ("`incpar'" ~="") {;
cap drop LnPrice_`iname'_* ;
	forvalues i=1/`nigr' {;
	tempvar lnpr_`i';
	*gen `lnpr_`i'' = LnPrice*(`i'==`incpar') ;
	cap drop  LnPrice_`iname'_0`i' ;
	if `i' <= 9  gen LnPrice_`iname'_0`i' = LnPrice*(`i'==`incpar') ;
	cap drop  LnPrice_`iname'_`i' ;
	if `i' >= 10 gen LnPrice_`iname'_`i'  = LnPrice*(`i'==`incpar') ;
	*label var `lnpr_`i'' "LnPrice*Decile_`i'" ;
	};
	};

if ("`hgroup'" ~="") {;

if ("`incpar'" == "") {;

forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';
cap drop LnPrice_`sgrlab`gr'';
qui gen LnPrice_`sgrlab`gr'' =  LnPrice*(`gr'==`hgroup');
local price_group `price_group'  LnPrice_`sgrlab`gr'';
};
if `inc' == 1  local subcom  LnHH_Inc ;
};

if ( "`incpar'" ~= "") {;

forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';

if `incint' == 1 {;
cap drop LnHH_Inc_`sgrlab`gr'';
qui gen LnHH_Inc_`sgrlab`gr'' =  LnHH_Inc*(`gr'==`hgroup');
if (`inc'!=0) local subcom `subcom'  LnHH_Inc_`sgrlab`gr'';
};

if `incint' == 0 & `inc' == 1  local subcom  LnHH_Inc ;

forvalues i=1/`nigr' {;
cap drop LnPrice_`sgrlab`gr'';
if `i' <=  9  gen LnPrice_`iname'_0`i'_`sgrlab`gr'' =  LnPrice*(`i'==`incpar')*(`gr'==`hgroup');
if `i' >= 10  gen LnPrice_`iname'_`i'_`sgrlab`gr''  =  LnPrice*(`i'==`incpar')*(`gr'==`hgroup');
if `i' <=  9   local price_group `price_group'  LnPrice_`iname'_0`i'_`sgrlab`gr'';
if `i' >= 10   local price_group `price_group'  LnPrice_`iname'_`i'_`sgrlab`gr'';
};
};
};
};


                       local disreg = "";
if   (`dregres' == 0)  local disreg = "qui" ;
eststo clear;
if (`inc'!=0) `disreg' svy: reg LnQuantity LnPrice LnHH_Inc `lnindcat' `indcon';
if (`inc'==0) `disreg' svy: reg LnQuantity LnPrice          `lnindcat' `indcon';
return scalar est = _b[LnPrice];
return scalar se  = _se[LnPrice];
eststo m1;
estimates store mod1, title(Model 1) ;
local models mod1 ; 
if ("`incpar'" ~="") {;
             local fnigr 0`nigr' ;
if `nigr'>=10 local fnigr `nigr' ;
if (`inc'!=0) `disreg' svy: reg LnQuantity LnPrice_`iname'_01-LnPrice_`iname'_`fnigr'  LnHH_Inc `lnindcat' `indcon';
if (`inc'==0) `disreg' svy: reg LnQuantity LnPrice_`iname'_01-LnPrice_`iname'_`fnigr'           `lnindcat' `indcon';
 eststo m2;
 estimates store mod2, title(Model 2) ;
 local models `models' mod2;
};

if ("`hgroup'" ~="" & "`incpar'" ~= "" ) {;
`disreg' svy: reg LnQuantity  `subcom'
`price_group'
  `lnindcat' `indcon';
 eststo m3;
 estimates store mod3, title(Model 3) ;
  local models `models' mod3;
};



if ("`hgroup'" ~="" & "`incpar'" == "" ) {;
`disreg' svy: reg LnQuantity `subcom'
`price_group'
 `lnindcat' `indcon';
 eststo m3;
  estimates store mod3, title(Model 3) ;
  local models `models' mod3;
};

if ("`incpar'" =="" & "`hgroup'" =="") esttab m1, not  r2 mtitle("(Model 01)" ) nodepvars nonumbers b(`dec') varwidth(34) label;
if ("`incpar'" ~="" & "`hgroup'" =="") esttab m1 m2, not r2 mtitle("(Model 01)" "(Model 02)") nodepvars nonumbers b(`dec') varwidth(34) label;

if ("`incpar'" =="" & "`hgroup'" ~="") esttab m1 m3, not  r2 mtitle("(Model 01)" "(Model 03)" ) nodepvars nonumbers b(`dec') varwidth(34) label;
if ("`incpar'" ~="" & "`hgroup'" ~="") esttab m1 m2 m3, not r2 mtitle("(Model 01)" "(Model 02)" "(Model 03)") nodepvars nonumbers b(`dec') varwidth(34) label;


if ((`dgra'==1 )& "`incpar'" ~="" & "`hgroup'" =="" ) {;
             local fnigr 0`nigr' ;
if `nigr'>=10 local fnigr `nigr' ;
    qui svy: reg LnQuantity LnPrice_`iname'_01-LnPrice_`iname'_`fnigr' `subcom' `lnindcat' `indcon';
	matrix aa = r(table)';
	tempname varx ;
	local const1 (1\ ;
	forvalues i=2/`nigr' {;
	if `i'<`nigr'  local const1 `const1'  `i'\  ;
	if `i'==`nigr' local const1 `const1'  `i')  ;
	};
	
    /*matrix `varx' = (1 \2 \3 \4 \5 \6 \7 \8 \9 \10); */
	
	matrix `varx' = `const1';
	matrix bb = `varx', aa[1..`nigr',1..1],aa[1..`nigr',5..5],aa[1..`nigr',6..6];
	matrix cc = `varx', aa[1..`nigr',1..1],aa[1..`nigr',5..5],aa[1..`nigr',6..6];
};

if ((`dgra'==1 )& "`incpar'" ~="" & "`hgroup'" ~="" ) {;
             local fnigr 0`nigr' ;
if `nigr'>=10 local fnigr `nigr' ;
    *qui svy: reg LnQuantity LnPrice_`iname'_01-LnPrice_`iname'_`fnigr' `subcom' `lnindcat' `indcon';
	
	`disreg' svy: reg LnQuantity `price_group' `subcom'  `lnindcat' `indcon';
	matrix aa = r(table)';
	tempname varx ;
	local const1 (1\ ;
	forvalues i=2/`nigr' {;
	if `i'<`nigr'  local const1 `const1'  `i'\  ;
	if `i'==`nigr' local const1 `const1'  `i')  ;
	};
	
    /*matrix `varx' = (1 \2 \3 \4 \5 \6 \7 \8 \9 \10); */
	*set trace on; 
	matrix `varx' = `const1';
	forvalues g = 1/$indicag {;
	local tini = (`g' - 1)*`nigr' +1 ;
	local tifi = (`g'    )*`nigr'   ;
	matrix bb`g' =  aa[`tini'..`tifi',1..1],aa[`tini'..`tifi',5..5],aa[`tini'..`tifi',6..6];
	matrix cc`g' =  aa[`tini'..`tifi',1..1];
	};
	matrix bb  = `varx';
	matrix cc  = `varx';
	forvalues g = 1/$indicag {;
	matrix bb = bb,bb`g';
	matrix cc = cc,cc`g';
	};
	
	
};





if (`dgra'==1 & "`incpar'" ~="") {;

if ("`hgroup'"=="") {;
local totlabel lab1("Estimated elasticity") ;
};

if ("`hgroup'"~="") {;
forvalues i=1/$indicag {;
local tmp = gn1[`i'] ;
local totlabel  `totlabel' lab`i'("`grlab`tmp''") ;
};
};

cmnpe bb,  min(1) max(`nigr') band(1.0) 
title("The estimated price elasticity by income groups")  
subtitle("(`grgname')")
xtitle("`grgname'") 
ytitle("Estimated elasticities") 
 `totlabel'
`goptions'
;

};

cap drop  LnQuantity ;
cap drop  LnPrice ;
if "`nigr'"!="" {;
forvalues i=1/`nigr' {;
	cap drop  LnPrice_`iname'_0`i' ;
	cap drop  LnPrice_`iname'_i' ;
	};
};
cap matrix drop bb;

if  ("`xfil'" ~= "") {;
xml_tab `models',  format(sclb0 ncrr3 ncci3) stats(N r2) ///
save(`xfil') replace  ///
cblanks(2) cwidth(0 200, 3 4) ///
sheet(Results, color(2) nogridlines)  ///
lines(_cons 2 LAST_ROW 13 COL_NAMES 2 EST_NAMES 2) ///
title("Estimated Results");
};


if  ("`xfil'" ~= "") {;
cap !start "" /min "`xfil'" ; 
};

cap matrix drop _cc; 
cap matrix drop bb1; 
cap matrix drop bb2; 
cap matrix drop bb3; 
cap matrix drop bb4; 
cap matrix drop aa; 
cap matrix drop gn; 

end;

