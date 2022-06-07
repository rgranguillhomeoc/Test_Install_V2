
#delim ;
set more off;
capture program drop mcprcn;
program define mcprcn , eclass sortpreserve;
version 9.2;
syntax varlist (min=1 max=1) [if] [in] [,  
IT1(string) IT2(string)  IT3(string)  IT4(string) IT5(string)  
IT6(string) IT7(string)  IT8(string)  IT9(string) IT10(string)
NITEMS(int 1)
MPART(int 0)
MOVE(int 1)
SCEN1(string) SCEN2(string)  SCEN3(string)  SCEN4(string) SCEN5(string)  SCEN6(string)
NSCEN(int 1)
];

//set trace on;


tokenize `varlist' ;
 
local mylist  vn sn el st nf si scen;
forvalues i=1/`nitems' {;
extend_opt_item_mcwel test , `it`i'' ;
foreach name of local mylist {;
local `name'`i'  `r(`name')';

if  "`name'"~="sn" & "`name'"~="vn"  & "``name'`i''"=="" local `name'`i' = 0 ;
/*
if  "``name'`i''"=="." local `name'`i' = "" ;
dis "`name'`i' = ``name'`i'' ";
*/

if "`name'"=="sn" & "``name'`i''"==""  local `name'`i' = "`vn`i''"  ;

};
};

forvalues it=1/`nitems' {;
if (`nscen'>0) {;
tokenize `scen`it'' ;
forvalues j=1/`nscen' {;
local msi_`it'_`j' = ``j'' ;
dis " `msi_`it'_`j'' ";
};
};
tempname price`it' elas`it' size`it' nfirm`it'  nscen`it';
qui gen `price`it'' = . ;
qui gen `elas`it''  = . ;
qui gen `size`it''  = . ;
qui gen `nfirm`it'' = . ;
qui gen `nscen`it'' = "" ;
cap drop  ___Scenario`it';
qui gen ___Scenario`it'  = "" ;

/****************************************************************/
/* Computing the price variation with the market concentration */
local dp = 0;
if "`model'"=="" local model = 1; 
local typemc = `st`it'' ;
local elas = `el`it'' ;
local osize = `si`it'' ;
local nfirms = `nf`it'' ;

/* 1- Monopoly case */
local otypemc = `typemc';


if `typemc' == 1 {;
local typemc = 3 ;
local osize  = 1 ;
};

/* 2- Oligopoly: Nash Eqquilibrium */
if `typemc' == 2 & `nfirms' >= 2 {;
local etas = (`elas'*`nfirms' +1)/(`nfirms'+1);
local dp =  1/(1-`nfirms'*`elas');

if (`move'==-1)   local posa = 1;
if (`move'==1)   local posa= `nscen'+2;

qui replace `price`it'' =1+`dp' in `posa';
qui replace `elas`it'' =`elas' in `posa';
qui replace ___Scenario`it' = "Concentrated Market    "  in `posa';
qui replace `nfirm`it'' = `nfirms' in `posa';
local pos = 2;
local nscen1 = `nscen'+1;
local N = `nfirms';
forvalues i=2/`nscen1' {;

local posa = `pos';
/*
if `move'==-1    local  posa = `pos';
if `move'== 1    local  posa = `nscen'+2-`pos'+1;
*/
local h = `i'-1;
if (`N'<3000) {;
local N = `msi_`it'_`h'' ;
 if (`N'<3000)  local zz=`zz' + 1 ;
};


if (`N'>=3000) {;
   local N = int((`pos'-`zz'+1)*1000);

};
local em = (`etas'*(`N'+1)-1)/`N' ;
local dp = (1)/(1-`N'*`em');
qui replace `price`it'' =1+`dp'         in `posa';
qui replace `elas`it'' =`em'            in `posa';
if `move'==-1  local j =`i'-1;
if `move'== 1 local j =`posa'-1;

qui replace ___Scenario`it' = "Scenario : `j'"   in `posa';
qui replace `nfirm`it'' = `N'           in `posa';
local pos = `pos'+1;
};

if (`move'==-1) local posa = `pos';
if (`move'== 1) local posa = 1;
qui replace `price`it'' =1                         in `posa';
qui replace `elas`it'' =`etas'                     in `posa';
qui replace ___Scenario`it' = "Competitive  Market "    in `posa';
qui replace `nfirm`it'' = .                        in `posa';			
};

/* 3- Oligopoly: Partial Collusive Oligopoly */
if `typemc' == 3 {;
local dp  =  (1/(1+(`osize'/`elas'))-1); 
local etas = `elas'/(1+`dp'*(1-`elas'));
local r1   = `osize'*(1+`dp'*`etas')-`dp'*`etas';
local nsize = `r1';

if (`move'==-1) local posa = 1;
if (`move'== 1) local posa= `nscen'+2;

qui replace `price`it'' =1+`dp' in `posa';
qui replace `elas`it'' =`elas' in `posa';
qui replace ___Scenario`it' = "Concentrated Market"  in `posa';
qui replace `size`it'' = `osize'*100 in `posa';
local pos = 2;
local nscen1 = `nscen'+1;



forvalues i=2/`nscen1' {;
local posa = `pos';
/*
if `move'==-1    local  posa = `pos';
if `move'== 1    local  posa = `nscen'+2-`pos'+1;
*/
local h = `i'-1;
local msize = `msi_`it'_`h'' ;
local melas = `etas'*(`msize'+1)-`msize';
local mdp  =  (1/(1+(`msize'/`melas'))-1); 
qui replace `price`it'' =1+`mdp' in `posa';
qui replace `elas`it'' =`melas'  in `posa';
if `move'==-1 local j =`i'-1;
if `move'== 1 local j =`posa'-1;


qui replace ___Scenario`it' = "Scenario : `j'"      in `posa';
qui replace `size`it'' = `msize'*100 in `posa';
local pos = `pos'+1;
};

if (`move'==-1) local posa = `pos';
if (`move'== 1) local posa = 1;

qui replace `price`it'' =1     in `posa';
qui replace `elas`it'' =`etas' in `posa';
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
      .`table'.titles  "Scenario "   "`chtit'"  "Elasticity"  "Price"       ;
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
	  
	  matrix colnames tab1_`it' = "`chtit'"  "Elasticity"  "Price" ;
	  matrix rownames tab1_`it' = `rows' ;
	  ereturn matrix tab1_`it'=tab1_`it';
	  cap matrix drop tab1_`it';
	 };

	forvalues it=1/`nitems' {;
	cap drop  ___Scenario`it';
	};
	 
 end;
/*
mcprc pc_income, 
it1( sn() vn(pc_exp_combus_all)     el(-0.643)  st(2) nf(8) ) 
nscen(10) nitems(1) move(-1)
;
*/


