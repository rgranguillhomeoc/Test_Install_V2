
#delim ;
set more off;
capture program drop mcprcne;
program define mcprcne , eclass sortpreserve;
version 9.2;
syntax varlist (min=1 max=1) [if] [in] [,  
IT1(string) IT2(string)  IT3(string)  IT4(string) IT5(string)  
IT6(string) IT7(string)  IT8(string)  IT9(string) IT10(string)
NITEMS(int 1)
MPART(int 0)
MOVE(int 1)
GSCEN(int 0)
];



tokenize `varlist' ;
local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 
tempvar _num _denum _w;
qui gen `_w'=1;
if (`"`hweight'"'~="") qui replace `_w'=`hweight'; 
local mylist  vn sn el st nf si scen;
forvalues i=1/`nitems' {;
extend_opt_item_mcwel test , `it`i'' ;
foreach name of local mylist {;
local `name'`i'  `r(`name')';

if  "`name'"~="sn"   &  "`name'"~="scen" & "`name'"~="it"   & "``name'`i''"=="" local `name'`i' = 0 ;
if  "`name'"=="scen" & "`name'`i'"=="" local `name'`i' = "" ;
/*
if  "``name'`i''"=="." local `name'`i' = "" ;
dis "`name'`i' = ``name'`i'' ";
*/

if "`name'"=="sn" & "``name'`i''"==""  local `name'`i' = "`vn`i''"  ;

};
};


forvalues it=1/`nitems' {;


if (`mpart'>0 & `gscen'==1) {;
tokenize `scen`it'' ;
forvalues j=1/`mpart' {;
local msi_`it'_`j' = ``j'' ;
};
};


tempname price`it' elas`it' size`it' nfirm`it' scen`it' nscen`it';
qui gen `price`it'' = . ;
qui gen `elas`it''  = . ;
qui gen `size`it''  = . ;
qui gen `nfirm`it'' = . ;
qui gen `scen`it''  = "" ;
qui gen `nscen`it'' = "" ;
cap drop  ___Scenario`it';
qui gen   ___Scenario`it'  = "" ;



/****************************************************************/
/* Computing the price variation with the market concentration */
local dp = 0;
if "`model'"=="" local model = 1; 
local typemc = `st`it'' ;

local elas "`el`it''" ;
cap drop _elas;
gen _elas = `el`it'';

local osize   `si`it'' ;
local nfirms  `nf`it'' ;
/* 1- Monopoly case */
local otypemc = `typemc';


if `typemc' == 1 {;
local typemc = 3 ;
local osize  = 1 ;
};

/* 2- Oligopoly: Nash Eqquilibrium */
if `typemc' == 2 & `nfirms' >= 2 {;
if (`move'==-1)   local posa = 1;
if (`move'==1)    local posa= `mpart'+2;

cap drop _etas;
cap drop _dp_`it'_`posa' ;
gen  _etas = (_elas*`nfirms' +1)/(`nfirms'+1);
/* local etas = (`elas'*`nfirms' +1)/(`nfirms'+1); */
gen _dp_`it'_`posa'  =  -1/(1+`nfirms'*_elas);
cap drop _pr_`it'_`posa' ;
qui gen _pr_`it'_`posa'  =  1+_dp_`it'_`posa';
qui sum _dp_`it'_`posa' [aw=`_w'] ;
qui replace `price`it'' =1+r(mean) in `posa';
qui sum _elas [aw=`_w'];
qui replace `elas`it'' = r(mean) in `posa';
qui replace ___Scenario`it' = "Concentrated Market    "  in `posa';
qui replace `nfirm`it'' = `nfirms' in `posa';
local pos = 2;
local nscen1 = `mpart'+1;
local N = `nfirms';
forvalues i=2/`nscen1' {;

local posa = `pos';
/*
if `move'==-1    local  posa = `pos';
if `move'== 1    local  posa = `mpart'+2-`pos'+1;
*/
local h = `i'-1;
if (`N'<3000) {;
 if (`gscen'==1) local N = `msi_`it'_`h'' ;

 if (`gscen'==0)  {;
if `i'==2   local N = int(`nfirms'*3/2);
if `i'>=3   local N = int(`nfirms'*(`i'-1));
};
 if (`N'<3000)  local zz=`zz' + 1 ;
};


if (`N'>=3000) {;
   local N = int((`pos'-`zz'+1)*1000);

};

cap drop _em;
cap drop _dp_`it'_`posa' ;

qui gen  _em = (_etas*(`N'+1)-1)/`N' ;
qui gen  _dp_`it'_`posa'  =  -(1)/(1+`N'*_em);
cap drop _pr_`it'_`posa' ;
qui gen  _pr_`it'_`posa'  =  1+_dp_`it'_`posa';

qui sum  _dp_`it'_`posa' [aw=`_w'];
qui replace `price`it'' =1+`r(mean)'         in `posa';
qui sum _em [aw=`_w'];
qui replace `elas`it'' =r(mean)            in `posa';
if `move'==-1  local j =`i'-1;
if `move'== 1 local j =`posa'-1;

qui replace ___Scenario`it' = "Step : `j'"   in `posa';
qui replace `nfirm`it'' = `N'           in `posa';
local pos = `pos'+1;
};

if (`move'==-1) local posa = `pos';
if (`move'== 1) local posa = 1;
qui replace `price`it'' =1                         in `posa';
cap drop _pr_`it'_`posa' ;
qui gen _pr_`it'_`posa'  =  1;
qui sum _etas [aw=`_w'];
qui replace `elas`it'' =r(mean)                     in `posa';
qui replace ___Scenario`it' = "Competitive  Market "    in `posa';
qui replace `nfirm`it'' = .                        in `posa';			
};

/* 3- Oligopoly: Partial Collusive Oligopoly */
if `typemc' == 3 {;

if (`move'==-1) local posa = 1;
if (`move'== 1) local posa= `mpart'+2;

cap drop _etas;
cap drop _dp_`it'_`posa' ;
gen _dp_`it'_`posa'  =  (1/(1+(`osize'/_elas))-1); 

cap drop _pr_`it'_`posa' ;
qui gen  _pr_`it'_`posa'  =  1+_dp_`it'_`posa';

cap drop _etas;
gen _etas = _elas/(1+_dp_`it'_`posa'*(1-_elas));

cap drop _r1;
cap drop _nsize;
qui gen _r1   = `osize'*(1+_dp_`it'_`posa'*_etas)-_dp_`it'_`posa'*_etas;
qui sum _r1 [aw=`_w'];
local nsize = `r(mean)';
qui sum  _dp_`it'_`posa' [aw=`_w'];
qui replace `price`it'' =1+`r(mean)'         in `posa';
qui sum _elas [aw=`_w'];
qui replace `elas`it'' =`r(mean)'            in `posa';




qui replace ___Scenario`it' = "Concentrated Market"  in `posa';
qui replace `size`it'' = `osize'*100 in `posa';
local pos = 2;
local nscen1 = `mpart'+1;



forvalues i=2/`nscen1' {;
local posa = `pos';
/*
if `move'==-1    local  posa = `pos';
if `move'== 1    local  posa = `mpart'+2-`pos'+1;
*/
local h = `i'-1;

  if (`gscen'==1)      local msize = `msi_`it'_`h'' ;
  if (`gscen'==0)      local msize = `osize'/`i'    ;
 
 


cap drop _melas;
qui gen  _melas = _etas*(`msize'+1)-`msize';

cap drop _dp_`it'_`posa' ;
qui gen  _dp_`it'_`posa'  =  (1/(1+(`msize'/_melas))-1);

cap drop _pr_`it'_`posa' ;
qui gen _pr_`it'_`posa'  =  1+_dp_`it'_`posa';

qui sum  _dp_`it'_`posa' [aw=`_w'];
qui replace `price`it'' =1+`r(mean)' in `posa';
qui sum  _melas [aw=`_w'];
qui replace `elas`it'' =`r(mean)'  in `posa';
if `move'==-1 local j =`i'-1;
if `move'== 1 local j =`posa'-1;


qui replace ___Scenario`it' = "Step : `j'"      in `posa';
qui replace `size`it'' = `msize'*100 in `posa';
local pos = `pos'+1;
};

if (`move'==-1) local posa = `pos';
if (`move'== 1) local posa = 1;

qui replace `price`it'' =1     in `posa';
cap drop _pr_`it'_`posa' ;
qui gen _pr_`it'_`posa'  =  1;
qui sum _etas [aw=`_w'];
qui replace `elas`it'' =`r(mean)' in `posa';
qui replace ___Scenario`it' = "Competitive  Market"    in `posa';
qui replace `size`it'' = 0*100     in `posa';
};



/**************************************************************/
/* Treatment of exceptions                                    */
/**************************************************************/

if `otypemc' == 1 & `elas' >=-1 {;
        di in r "For the monopoly market structure, the elasiticity must be lower than minus one.";
	  exit 198;

};

if `otypemc' == 3 & `elas' >=-`osize' {;
        di in r "For the PCO market structure, the elasiticity must be lower than -1*(market size).";
	  exit 198;

};

 }; 


forvalues j=1/`pos' {;
local tmp = ""+___Scenario1[`j'];
local this = strtoname(trim("`tmp'")) ;
local rows `rows' `this';
};

dis _n _col(5) "Table 1.1: Models and parameters";
set trace off;	
tempname table;
        .`table'  = ._tab.new, col(4)  separator(0) lmargin(4);
        .`table'.width  24|16 16  16 ;
        .`table'.strcolor . . yellow   yellow     ;
        .`table'.numcolor yellow yellow .  .  ;

   
        .`table'.numfmt %24.0g  %16.3f  %16.4f %16.6f   ;
               noi di _col(5) in smcl in gr "{hline 24}{c TT}{hline 48}";
		forvalues it=1/`nitems' {;
		
	    local chtit= "Market size (in%)";
		if `st`it'' ==2 local chtit= "# of firms";
		
	                    local labst = "Monopoly";
	    if `st`it'' ==2 local labst = "Oligopoly: Nash Equilibrium";
	    if `st`it'' ==3 local labst = "Partial Collusive Oligopoly";
		
                 noi di in smcl in gr _col(5) "Item: `sn`it''"  _col(29) "{c |}" _col(32)  `"Market type : `labst'  "';
                 noi di in smcl in gr _col(5) "{hline 24}{c +}{hline 48}"; 
      .`table'.titles  "Step "   "`chtit'"  "Elasticity"  "Price"       ;
      .`table'.sep, mid;
	  forvalues i=1/`pos' {;
      if `st`it'' != 2 .`table'.row ___Scenario`it'[`i']    `size`it''[`i']    `elas`it''[`i']  `price`it''[`i']; 
	  if `st`it'' == 2 .`table'.row ___Scenario`it'[`i']    `nfirm`it''[`i']   `elas`it''[`i']  `price`it''[`i']; 
	
	 };
	  if `it' <  `nitems'  .`table'.sep,mid;
	  if `it' == `nitems'  .`table'.sep,bot;
	  if `st`it'' != 2 mkmat `size`it'' `elas`it'' `price`it'' in 1/`pos' , matrix(tab1_`it');
	  if `st`it'' == 2 mkmat `nfirm`it'' `elas`it'' `price`it'' in 1/`pos' , matrix(tab1_`it');
	  cap drop `size`it'';
	  
	  matrix colnames tab1_`it' = "`chtit'"  "Average  HH Elasticity"  "Average HH Price" ;
	  matrix rownames tab1_`it' = `rows' ;
	  ereturn matrix tab1_`it'=tab1_`it';
	  cap matrix drop tab1_`it';
	 };

	forvalues it=1/`nitems' {;
	cap drop  ___Scenario`it';
	};
	cap drop _dp_*;
	cap drop _em*;
	cap drop _elas*; 
	cap drop _melas*;
	cap drop _r1*;
	cap drop _etas*;
 end;

