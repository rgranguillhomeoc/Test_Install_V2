/*************************************************************************/
/* mcema: Market	Competition	and	the	Extensive	Margin	Analysis	 */
/*************************************************************************/
/* Conceived  by :                                                       */
/*     Abdelkrim Araar                                                   */
/*     Eduardo Malasquez                                                 */
/*     Sergio Olivieri                                                   */
/*     Carlos Rodriguez-Castelan                                         */
/* email : aabd@ecn.ulaval.ca                                            */
/*   August/2019                                                        */
/*************************************************************************/
/* mcema.ado                                                             */
/*************************************************************************/
/* Description:                                                          */
/* The mcema module is designed to the impact of change in welfare or price*/ 
/* the proportion of consumers or users.                                 */
/* Intermediatelly, the estimation is based on a probit model            */
/*************************************************************************/


/* 
varlist (one dycotomic variable): 1 if the consumption of the good is higher than zero and 0 otherwise 
*/

#delimit ;
cap program drop mcem2;
program define mcem2, eclass ;
syntax varlist(min=2 max=2)[, 
welfare(varname)
hsize(varname)
pline(varname)
price(varname)
ICHANGE(varname)
PCHANGE(varname)
INCPAR(varname)
HGROUP(varname)
indcon(string) 
indcat(string) 
PSWP(real 1.0)
PSWE(real 1.0)
DEC(int  4)
DREG(int 0)
EXPSHARE(varname)
XFIL(string)
DGRA(int 0)   
UM(int 1)
DISGR(varname)
expmod(int 1)
NQUANTile(int 20)
GRMOD1(varname)
GRMOD2(varname)
FEX(int 1)
FPR(int 1)
FIN(int 1)
OOPT(string)
CINDCAT(string)
CINDCON(string) 
INISAVE(string)
EXNUM(int 0)
GRMAC(varname)
TOTENTR(varname)
TOTUSER(varname)
ELIGIBLE(varname)
SEED(int 123456)
*];

version 12;
set matsize 800;
cap drop _key;
qui gen _key = _n;


/* To put all of the user graph options in the local goptions */
_get_gropts , graphopts(`options'); local goptions `"`s(graphopts)'"';	
if ("`expshare'" == "") {;
tempvar expshare ;
qui gen `expshare' = 1.0 ;
};

if ("`eligible'" == "") {;
tempvar eligible ;
qui gen `eligible' = 1.0 ;
};
tokenize `varlist' ;




/* IN PROGRESS : Apdate the swe prob*/
 
/* To capture the name of the variable sampling weight if the user declare it with the command svyset */
local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear;



/* The final weight = sampling weight if declared or 1 (by default)   */

tempvar   sw;
qui gen `sw'=1;
if ("`hweight'"~="")        qui replace `sw'=`sw'*`hweight';
if ("`hsize'"~="")          qui replace `sw'=`sw'*`hsize';

/* 
Starting from the categorical variable hgroup, the following routine will:
1- Find the number of groups and store it in $indicag;
2- If they are declared, put the label values in local macros : grlab`g' and `g' is the group value;
3- generate the variable gn1 that contains the group values (short vector) example : 1,3 to indicate two groups with the codes 1 and 3. 
*/

/* Generating the categorical variable (quintiles) */
if "`disgr'"==""  {;
tempvar disgr;
qui xtile  `disgr'=`welfare'  [aw=`sw'],  nq(5);
cap label drop quint;
forvalues i=1/5 {;
  lab def quint `i' "Quintile `i'", add;
};
lab val `disgr' quint; 
};



if ("`disgr'"~="") {;
preserve;
capture {;
local lvgroup:value label  `disgr' ;
if ("`lvgroup'"!="") {;
uselabel `lvgroup' , clear;
qui count;
forvalues i=1/`r(N)' {;
local tem=value[`i'];
local grlabm`tem' =  substr(label[`i'],1, 26);
};
};
};
restore;
qui tabulate  `disgr', matrow(gm);
global indicagm=r(r);
tokenize `varlist';
};



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
cap drop gn1;
svmat int gn;
global indicag=r(r);
tokenize `varlist';
};


if ("`hgroup'"=="") {;
preserve;
tokenize `varlist';
};


/*
Replacing the spaces by  in the label values;
If the label values are not declared, we give the label `hgroup'_`gr', example : rururb_0 rururb_1
*/
if ("`hgroup'"!="") {;
forvalues i=1/$indicag {;
local gr = gn1[`i'];
local sgrlab`gr' = "`hgroup'_`gr'" ;
if "`grlab`gr''"  == "" local grlab`gr' = "`hgroup'_`gr'" ;
local tmps =  subinstr("`grlab`gr''", " ", "_", .);
if  "`tmps'"  ~= "" local grlab`gr' = "`tmps'" ;
};
};


/* 
If the user selects the stepwise estimation instead of simple probit model, 
the probit command must be preceded by the prefix:  stepwise, options: probit..
The options are:
1- pr(`psw') : example pr(0.1) // keep if the P-Value is 0.1 or lower;
2- lockterm1 : keep the first term for any level of P-Value. 
*/ 
  
if `pswp'!=1.0 local stp stepwise, pr(`pswp') lockterm1: ;

/*
The following temporary variables will contain:
elap       : The probability elasticity with respect to price or welfare;
dif        : The estimated change in the probability of use -or consumption- of the good;
*/



tempvar prop_ch;
qui gen `prop_ch' = 0;

tempvar dif prdif;
qui g `dif' = 0 ;
qui g `prdif' = 0 ;


/*  
If we have categorical variables, the following routine generates new dichotomious variables.
Example : categorical variable 1  (educ )is the education level with the modalities 1,2 and 3, 
          we generate the variables educ_1, educ_2 and educ_3. 
The local `lnindcat' will contain a set of variables designed according to the modalities of the categorical variables, 
ex: educ_1, educ_2, educ_3, socio_1, socio_2... etc.  
*/


#delimit ; 
if ("`indcat'"~="") {;
foreach var of varlist `indcat' {;
local posa = 1;
qui sum  `var';
local rmi = r(min);
local rma = r(max);
forvalues i= `rmi'/`rma' {;
qui count if `var' == `i';
if `r(N)' !=0 {;
cap drop `var'_`i';
qui gen `var'_`i' = `var' == `i';
local name "`var'_`i'";
local uname = proper("`name'");
if "`uname'" == "" { ;
local uname = proper("`var'_`i'");
local uname `uname';
};
lab var `var'_`i' "`uname'";
if `posa' != 1 local lnindcat `lnindcat' `var'_`i';
local posa = `posa'+1 ;
};
};
};
};


/* If the sampling design is not initialized, we set it to its default status (a Random Sampling) */
qui svyset ;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);

/* We create the name of the xfil with its extention */
tokenize "`xfil'" ,  parse(".");
local tname `1'.xml;


/* 
If we have results with tables,
1- we try to erase the excel or xml file;
2- we try to close the excel tool. This will help to reopen Excel with our xml  file 
*/


if ( "`tjobs'"~="off" ) {;
if "`xfil'" ~= ""  { ;
tokenize "`xfil'" ,  parse(".");
local xfil `1'.xml ;
cap erase  `1'.xml ;
};
};
estimates drop _all;

tokenize `varlist';
cap drop if `1' ==. ; 

/* We add the prefix "qui" if the user did not like to display the results of the probit models */

                            local disprobit  = "";
if  (`dreg' == 0)           local disprobit  = "qui" ;

                            local disreg  = "";
if  (`dreg' == 0)           local disreg  = "qui" ;
qui replace `1' = 0 if `1'==. ;

/* We generate the variables log(price) and log(welfare) */


if ("`welfare'" ~= "" ) {;
cap drop  LnInc ;
qui gen   LnInc  = ln(`welfare');
local Main Inc ;
};

if ("`price'" ~= "" ) {;
cap drop    LnPrice ;
qui gen     LnPrice  = ln(`price');
qui replace LnPrice  = 0 if LnPrice ==. ;
local Main Price ;
local pLnInc LnInc;
};

/* The basic name  of the welfare partition variable: example, if the welfare group modules are 1,2,3,4 and 5, we have quintiles i.e., basic name is: Quintile_ */ 
if "`incpar'" ~= "" {;
qui tab `incpar';
local nigr = `r(r)';
if `nigr' == 10 local iname = "Decile" ;
if `nigr' ==  5 local iname = "Quintile" ;
if `nigr' ==  4 local iname = "Quartile" ;
if `nigr' != 10 & `nigr' != 5 & `nigr' != 4   local iname = "IncGr" ;

											 local grgname = "`iname'";
if `nigr' != 10 & `nigr' != 5 & `nigr' != 4  local grgname = "welfare_Partition (`nigr')";
};

eststo clear;

/*set trace on; */


forvalues i=1/6 {;
local em`i' = 0;	
};
if ("`incpar'" == "") & ("`hgroup'" == "") {;
local local mymodels 1 ;
local subcom_m1 Ln`Main';
local em1=1;
};

if ("`incpar'" ~= "") & ("`hgroup'" == "") {;
local local mymodels 1 2 ;
local subcom_m1 Ln`Main';
local em1=1; local em2=1;  

};

if ("`incpar'" == "") & ("`hgroup'" ~= "") {;
local local mymodels 1 3 5;
local em1=1; local em3=1;  local em5=1; 
};

if ("`incpar'" ~= "") & ("`hgroup'" ~= "") {;
local local mymodels 1 2 3 4 5 6;
local em1=1; local em2=1; local em3=1; local em4=1; local em5=1; local em6=1; 
};



local subcom_m1 Ln`Main';
if (`em2') {;
local subcom_m2 "";
forvalues i=1/`nigr' {;
cap drop Ln`Main'_0`i';
cap drop Ln`Main'_`i';
if `i' <=  9  qui gen Ln`Main'_0`i'     =  Ln`Main'*(`incpar'==`i');
if `i' >= 10  qui gen Ln`Main'_`i'      =  Ln`Main'*(`incpar'==`i');
if `i' <=  9   local subcom_m2 `subcom_m2'  Ln`Main'_0`i';
if `i' >= 10   local subcom_m2 `subcom_m2'  Ln`Main'_`i';
};
};


if (`em3') {;
forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';
qui gen Ln`Main'_`sgrlab`gr''  =  Ln`Main'*(`hgroup'==`gr');
local subcom_m3 `subcom_m3'  Ln`Main'_`sgrlab`gr'';
};
};

if (`em4') {;

forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';
forvalues i=1/`nigr' {;
if `i' <=  9   qui gen Ln`Main'_`iname'_0`i'_`sgrlab`gr'' =  Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
if `i' >= 10   qui gen Ln`Main'_`iname'_`i'_`sgrlab`gr''  =  Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
if `i' <=  9   local subcom_m4 `subcom_m4'  Ln`Main'_`iname'_0`i'_`sgrlab`gr'';
if `i' >= 10   local subcom_m4 `subcom_m4'  Ln`Main'_`iname'_`i'_`sgrlab`gr'';
};
};


};

if (`em5') {;
forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';
cap drop Ln`Main'_`sgrlab`gr'';
qui gen Ln`Main'_`sgrlab`gr''  =  Ln`Main'*(`hgroup'==`gr');
local subcom_m5_`gr' `subcom_m5_`gr''   Ln`Main'_`sgrlab`gr'';
};


};

if (`em6') {;

forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';
forvalues i=1/`nigr' {;
cap drop Ln`Main'_`iname'_0`i'_`sgrlab`gr'';
cap drop Ln`Main'_`iname'_`i'_`sgrlab`gr'';
if `i' <=  9   qui gen Ln`Main'_`iname'_0`i'_`sgrlab`gr'' =  Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
if `i' >= 10   qui gen Ln`Main'_`iname'_`i'_`sgrlab`gr''  =  Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
if `i' <=  9   local subcom_m6_`gr' `subcom_m6_`gr''  Ln`Main'_`iname'_0`i'_`sgrlab`gr'';
if `i' >= 10   local subcom_m6_`gr' `subcom_m6_`gr''  Ln`Main'_`iname'_`i'_`sgrlab`gr'';
};
};
};

forvalues i=1/6 {;
if (`em`i''==1 & `i' <= 4) {;
	       `disprobit'  `stp' probit `1'  `pLnInc' `subcom_m`i'' `modp' `lnindcat' `indcon' [pw=`sw'];	
	        eststo m`i';
			local mm `mm' m`i' ;
            estimates store mod`i', title(Model `i') ;
            local models `models' mod`i';
			local  mytitmod`i'  `"`"Model `i'"'"'   ;

            };
			
			
if (`em`i''==1 & `i' >  4)  {;
            if (`um' == 5 | `um' == 6) {;
					forvalues g=1/$indicag {;
					local gr = gn1[`g'];
					local lvgroup:value label `hgroup';
					`disprobit'  `stp' probit `1'  `pLnInc'`pri_group'  `subcom_m`um'_`gr'' `lnindcat' `indcon' [pw = `sw']  if (`hgroup'==`gr');
					eststo m_`gr' ;
					local ttgr `ttgr'   "`grlab`gr''"  ;
					estimates store m_`gr' , title("`grlab`gr''") ;
					local modelsgr `modelsgr'  m_`gr' ;
					local  mytitmodr`g'    `"`"`grlab`gr''"'"'     ;
			      };
			
            };			
			
};
};




/* All of the possible estimated probit models are reported in table 01 */
dis _n as result  "Table 01: Estimates of probability of consumption model(s)" ;
esttab `mm', not pr2    mtitle(`mytitmod1' `mytitmod2' `mytitmod3' `mytitmod4')  nodepvars nonumbers b(`dec') varwidth(34) label;
if (`um' == 5 | `um' == 6) {;
dis _n "The rest of_Table 01: Estimates of probability of consumption model `um'" ;
esttab m_*, not pr2    mtitle(
`mytitmodr1' `mytitmodr2' `mytitmodr3' `mytitmodr4' `mytitmodr5' `mytitmodr6' `mytitmodr7' `mytitmodr8'`mytitmodr9' `mytitmodr10'
`mytitmodr11' `mytitmodr12' `mytitmodr13' `mytitmodr14' `mytitmodr15' `mytitmodr16' `mytitmodr17' `mytitmodr18'`mytitmodr19' `mytitmodr20'
 )  nodepvars nonumbers b(`dec') varwidth(34) label;
};


 cap drop `pr1';
tempvar   pr1; 



 if (`um'==1 ) {;
qui  `stp' probit `1'  `pLnInc' `subcom_m1' `lnindcat' `indcon' [pw=`sw'];
qui predict `pr1';

};


 if (`um'==2) {;
`disprobit'  `stp' probit `1'  `pLnInc'  `subcom_m2' `modp' `lnindcat' `indcon' [pw=`sw'];
qui predict `pr1';


}; 


 if (`um'==3) {;
`disprobit'  `stp' probit `1'  `pLnInc' `subcom_m3'  `modp'  `lnindcat' `indcon' [pw = `sw'] ;
qui predict `pr1' ;


};



 if (`um'==4) {;
`disprobit'  `stp' probit `1'  `pLnInc' `subcom_m4' `modp'  `lnindcat' `indcon' [pw = `sw'] ;
qui predict `pr1';



};




if (`um'==5) {;

gen `pr1' = 0;

forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';
cap drop Ln`Main'_`sgrlab`gr'';
qui gen  Ln`Main'_`sgrlab`gr'' =  Ln`Main'*(`hgroup'==`gr');
`disprobit'  `stp' probit `1'  `pLnInc' Ln`Main'_`sgrlab`gr'' `modp'  `lnindcat' `indcon' [pw = `sw'] if (`hgroup'==`gr');
eststo mod5_`grlab`gr'', title("`grlab`gr''") ;
local ttgr `ttgr'   "`grlab`gr''"  ;
estimates store mod5_`grlab`gr'' , title("`grlab`gr''") ;
local models `models'  mod5_`grlab`gr'' ;
cap drop `prg';
tempvar prg;
qui predict `prg' if (`hgroup'==`gr');
qui replace `pr1' = `prg'  if (`hgroup'==`gr');
};
};


/*
set trace on ;
set tracedepth 1;
*/
if (`um'==6) {;
qui gen `pr1' = 0;



forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';
forvalues i=1/`nigr' {;
cap drop Ln`Main'_`iname'_0`i'_`sgrlab`gr'';
cap drop Ln`Main'_`iname'_`i'_`sgrlab`gr'';
if `i' <=  9    qui gen Ln`Main'_`iname'_0`i'_`sgrlab`gr'' =  Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
if `i' >= 10    qui gen Ln`Main'_`iname'_`i'_`sgrlab`gr''  =  Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
};
};


forvalues g=1/$indicag {;
local gr = gn1[`g'];
`disprobit'  `stp' probit `1'  `pLnInc'  `subcom_m`um'_`gr'' `lnindcat' `indcon' [pw = `sw']  if (`hgroup'==`gr');
eststo mod6_`grlab`gr'', title("`grlab`gr''") ;
local ttgr `ttgr'   "`grlab`gr''"  ;
estimates store mod6_`grlab`gr'' , title("`grlab`gr''") ;
local models `models'  mod6_Group_`gr' ;
cap drop `prg' ;
tempvar prg;
qui predict `prg' if (`hgroup'==`gr');
};
};


/***/

cap matrix drop _cc; 
cap matrix drop bb1; 
cap matrix drop bb2; 
cap matrix drop bb3; 
cap matrix drop bb4; 
cap matrix drop aa; 
cap matrix drop gn; 

/* incpar and hgroup can be 1 by default */

if  ("`incpar'"=="" & "`hgroup'" == "" ) {;
tempvar incpar;
cap drop `incpar';
qui gen  `incpar' = 1;
};

if "`hgroup'"  == "" {;
tempvar hgroup ;
cap drop  `hgroup' 
g `hgroup' = 1; 
};

/* capturing the label values of the hgroup variable*/ 
cap drop gn1;
cap drop _fgroup;
if "`incpar'"~="" {;
gen  _fgroup = `incpar';
local lvgroup:value label `incpar';
if "`lvgroup'" ~= "" lab val  _fgroup `lvgroup' ;
};
if ("`incpar'"=="") & ("`hgroup'" ~=  "") {;
gen  _fgroup = `hgroup';
local lvgroup:value label `hgroup';
if "`lvgroup'" ~= "" lab val  _fgroup `lvgroup' ;
};



qui tabulate  `disgr', matrow(gm);
global indicagm=r(r);
cap drop gm1;
svmat int gm;

tokenize `varlist';



/* mcjobstat command estimates the averages of the variables by groups (_fgroup) */
/* the rest of the code is to use the returned matrix of the mcjobstat command to display and save the results */
qui mcjobstat  `1' `pr1' ,   hsize(`hsize') hgroup(`disgr') lan(`lan')    stat(exp_pc) tpop(1);
tempname  mat00 ; 
matrix `mat00'= e(est);

local nc = colsof(`mat00') -1;
local nr = rowsof(`mat00');
if `nr' == 2 local nr = 1;
tabtitmc 00; 
local tabtit = "`r(tabtit)'";
matrix aaa= `mat00'[1..`nr', 1..`nc'] ;
if `nr' == 1 matrix rownames aaa = "Population" ;

local compo welfare;
if "`price'" ~= "" & "`ichange'"=="" local compo price ;
local Compo welfare;
if "`price'" ~= "" & "`ichange'"==""  local Compo Price ;
if ("`expshare'"~="") & "`ichange'"~="" local isinf  = "(adjusted by share)" ;

tempvar coltit1 coltit2 coltit3;
qui gen     `coltit1' = ""; qui gen     `coltit2' = ""; qui gen     `coltit3' = "";



qui replace `coltit1' = "[1] Observed         " 			in 1 ; 
qui replace `coltit2' = "     proportion of   " 			in 1 ;
qui replace `coltit3' = "     consumers/users " 			in 1 ;

qui replace `coltit1' = "[2] Predicted          "      in 2 ;
qui replace `coltit2' = "     probability with  "      in 2 ;
qui replace `coltit3' = "     initial `compo'(s)"      in 2 ;


matrix colnames aaa =  "[1] Obs. prop. of consumers" " [2] Predicted  prob. (intial values)"   ;
dis _n as result  "Table 02: Estimated impact on the proportions of consummers" ;
if `nr' == 1  distable2 aaa, dec(`dec') atit(`langr')	head1(`r(tabtit)')  head2(`head2') coltit1(`coltit1')  coltit2(`coltit2')  coltit3(`coltit3');
if `nr' > 1   distable  aaa, dec(`dec') atit(`langr')	head1(`r(tabtit)')  head2(`head2') coltit1(`coltit1')  coltit2(`coltit2')  coltit3(`coltit3');
dis as result  "Notes:";
dis as text " [1]- Estimated based on population/groups." ;
dis " [2]- Based on predicted individual -househcurrent- probabilities." ;


/* **/
/*
dis "OK" ;
tokenize `varlist' ;
//set trace on ;
set tracedepth 1 ;
tempvar pr1;
gen double `pr1' = _pred_exp;
dis "OK" ;
*/
/*****/

tempvar type_consumer;	
qui levelsof `grmac', local(regions);
/* Create the 3 types of consumers (Never consume / Already consume / New consumer) */
 qui   qui gen      `type_consumer'  = 0;
 qui   replace      `type_consumer'  = 1 if `1'==1;

 lab define l`type_consumer' 0 "No entrant" 1 "Current user" 2 "New user";
 lab val `type_consumer' l`type_consumer';
qui levelsof `grmac', local(regions);
/* use of one data file   */

local mystr `r(levels)';
local ngr `: word count `mystr'';
foreach x of local regions { ;

local pos = 1;    
if ("`totuser'" ~= "" ) {	; 
qui sum `totuser'  if `grmac' == `x'  & `eligible' == 1;
if `r(sum)'!=0    local myres `r(mean)' ;
if `r(sum)' == 0  local myres = 0;
local target_`x'  = `myres';
local ptarget_`x' = `myres';
};

if ("`totentr'" ~= "" ) {;	 	
qui sum `totentr'  if `grmac' == `x'  & `eligible' == 1;
if `r(sum)'!=0    local myres `r(mean)' ;
if `r(sum)' == 0  local myres = 0;
local m1 = `myres';

local nptarget_`x'  = r(mean);  
qui sum `1' [aw=`sw'] if `grmac' == `x';
local current_`x' = `r(sum)' ;
local  target_`x'    = `r(sum)' + `m1';
local ptarget_`x'    = `target_`x'';

};


	qui sum `1'  if  `grmac'==`x' [aw=`sw'];
	local tcurrentu_`x'  = r(sum);
	qui sum `sw'  if  `grmac'==`x' ;
	local tot_pop_`x' = r(sum) ;
    if (`ptarget_`x'' > (`tot_pop_`x'') )   local target_`x' = `tot_pop_`x'';
	local ntarget_`x'    = `target_`x'' - `tcurrentu_`x'';
	
 if ("`totuser'" ~= "" ) {;	
	     if (`ptarget_`x'' > (`tot_pop_`x''+0.1) )    dis "Warning: Group `x' : The planned `ptarget_`x''  total users is replaced by `target_`x'' (Total eligible population)." ;  
	 };

	  if ("`totentr'" ~= "" ) {	;
	      if (`nptarget_`x'' > (`ntarget_`x''+0.1) )  {;
		  dis "Warning: Group `x' : The planned `nptarget_`x''  total new users is replaced by `ntarget_`x'' (Total eligible new users)." ; 
		  local  target_`x'    = `ntarget_`x'' ;
	  	  local nptarget_`x' = `ntarget_`x''  ;
		  };
	  };

};

//set trace on;

/* Start to update here...*/
    tempvar frho ;
	qui gen `frho' = 0;
	tempvar          kappa_all ;
	qui gen  double `kappa_all'=0 ;
	foreach x of local regions { ;
    /*Proportion of users within the group : rho_x*/
    qui sum `sw' if `grmac'==`x' & (`1'==0)  & (`eligible'==1) ;
	local tot_pot_`x'  = r(sum);
	qui sum `1' [aw=`sw'] if  `grmac'==`x' ;
	local current_reg_`x' = r(sum);
	local rho_`x' =  (`ntarget_`x'')/`tot_pot_`x'' ;
	qui replace  `frho' = (`ntarget_`x'')/`tot_pot_`x'' if (`grmac'==`x') & (`1'==0) ;
	qui sum `pr1' [aw=`sw'] if  (`grmac'== `x') & (`eligible'==1) & (`1'==0); 
	local meanpr_`x' = r(mean) ;
	qui replace    `kappa_all'       =  `rho_`x''*(`pr1'/`meanpr_`x'')  if  (`grmac'==`x') & (`eligible'==1) & (`1'==0);
	qui sum        `kappa_all' [aw=`sw']                                if  (`grmac'==`x') & (`eligible'==1) & (`1'==0); 
    local target_reg_`x' = r(sum) ;
	qui sum `sw';
	local prop_new_reg_`x' = `target_reg_`x'' / `r(sum)' *100;	

	qui sum `sw';
	local prop_current_reg_`x' = `current_reg_`x'' / `r(sum)' *100;	
	/*
    dis "`x' : proportion = " `rho_`x'' " `ntarget_`x'' =" `ntarget_`x'' "target_reg_`x'  = " `target_reg_`x'' ; 
	*/	
	};

	//set trace on ;
	foreach x of local regions { ;
    /*Proportion of users within the group : rho_x*/
	  set seed 65434564 ;
      tempvar random ;
      qui gen `random' = uniform()*`pr1' ;
	  qui replace `random' = 0  if  `grmac'==`x' | `eligible'!=1;
      qui replace `random' = 0  if  `1' == 1 ;
      tempvar tkey ;
      qui gen `tkey' = _n ;
	  tempvar negran ;
	  qui gen `negran' = -`random';
      sort `1'  `negran' , stable  ;
      tempvar   tpsum ;
      qui gen       `tpsum' = sum(`sw'*(`1'==0)*(`grmac'==`x')) ;
      qui replace   `type_consumer' = 2 if `tpsum' <= `ntarget_`x''  & `grmac'==`x' & (`1'==0)  & (`eligible'==1) ; 
      sort `tkey'  ;
      qui sum `sw' if `grmac'==`x' & `type_consumer'==2 ; 
	   /*
	   dis `r(sum)' " vs " `ntarget_`x'' ;
	   stop;
       */
	};
	


local tot_new_plan = 0;
local tot_new_dist = 0;
local tot_current      = 0;
local tot_all      = 0;


foreach x of local regions {; 
local tot_new_plan = `tot_new_plan' + `target_reg_`x'' ;
local tot_current      = `tot_current'      + `current_reg_`x'' ;
local tot_all      = `tot_all'      + `current_reg_`x'' + `target_reg_`x''  ;
} ;



qui sum `sw' ;
local tot_pop = r(sum);

/* ARAAR: I remove the MI. At this stage, I simply use the average exp. at PSU level */  
/* Later, I will use the mi (Stata multiple imputation to have some variability of the estimated expendittures) */ 

tempname  Group;
qui gen  `Group'="";
tempvar _res0 _res1 _res2 _res3   _res4 _res5 _res6;
qui gen double  `_res0' = .	;	// Number of population
qui gen double  `_res1' = .	;	// Number of current users
qui gen double  `_res2' = . ;	// Total number of new users
qui gen double  `_res3' = . ;	// Total number of users

qui gen double  `_res4' = .	;	// Share of current users
qui gen double  `_res5' = .	;	// Share of new users
qui gen double  `_res6' = .	;	// Share of total users


/*set trace on; */
local pos = 1;
qui levelsof `grmac', local(regions);
qui levelsof `disgr', local(gresu);
local lbe : value label  `grmac' ;
foreach x of local regions { ;
cap local f`x' : label `lbe' `x';
};
foreach x of local regions { ;
qui replace `Group' = "`x'_`f`x''"  in `pos';
local rname `rname'   "`x'_`f`x''  ";
qui replace `_res0' = `tot_pop_`x'' in `pos' ;
qui replace `_res1' = `current_reg_`x'' in `pos' ;

if ("`totuser'" ~= "" ) {;
qui replace `_res2' = `target_reg_`x''     in `pos' ;
qui replace `_res3' = `target_reg_`x''+`current_reg_`x'' in `pos' ;
};

/*set trace on; */
if ("`totentr'" ~= "" ) {;
qui replace `_res2' = `target_reg_`x''      in `pos' ;
qui replace `_res3' = `target_reg_`x''+`current_reg_`x'' in `pos' ;    
};

local total2 = `total2' + `target_reg_`x'' ;
local total3 = `total3' + `target_reg_`x''+`current_reg_`x'' ;

qui replace `_res4' =  `prop_current_reg_`x'' in `pos' ;
qui replace `_res5' =  `prop_new_reg_`x'' in `pos' ;
qui replace `_res6' =  `prop_current_reg_`x''+`prop_new_reg_`x'' in `pos' ;
local pos = `pos'+1 ;
} ;




qui replace `_res0' = `tot_pop' in `pos' ;
qui replace `_res1' = `tot_current' in `pos' ;
qui replace `_res2' =  `total2'  in `pos' ; 
qui replace `_res3' =  `total3'  in `pos' ; 

qui replace `_res4' = `tot_current' /`tot_pop'*100 in `pos' ;
qui replace `_res5' = `tot_new_plan' /`tot_pop'*100   in `pos' ;
qui replace `_res6' =  `tot_all' /`tot_pop'*100    in `pos' ;


local ngr = `pos'-1 ;
local ngr1 = `ngr' + (`ngr'>1) ;
local rname `rname'   "Population  " ;


tempvar macres;
qui gen  double `macres' = 0;
local totmac = 0;
local pos = 1;
foreach x of local regions { ;
if ("`totuser'" ~= "" ) {	; 
qui sum `totuser'  if `grmac' == `x'  ;
if `r(sum)'!=0 local myres = `r(mean)';
if `r(sum)'==0 local myres=0;

qui replace `macres'    = min(`myres' , `tot_pop_`x'')  in `pos' ;
local totmac = `totmac' + min(`myres' , `tot_pop_`x'') ;
local pos = `pos' + 1 ;  
};

if ("`totentr'" ~= "" ) {;	 	
qui sum `totentr'  if `grmac' == `x'  ;
qui replace `macres'    = `nptarget_`x''  in `pos' ;
local totmac = `totmac' + `nptarget_`x'' ;
local pos = `pos' + 1 ; 
};
};
qui replace `macres' = `totmac' in `pos' ;


tempname resa1 resa2 ;
 mkmat `_res0' `_res1' `_res2' `macres'  `_res3'  in 1/`ngr1', matrix(`resa1') ;
 mkmat `_res4'-`_res6' in 1/`ngr1', matrix(`resa2') ;
 if (`ngr'>1) {;
 matrix rownames `resa1' = `rname' ; 
 matrix rownames `resa2' = `rname' ;
 };
 
  if (`ngr'==1) { ;
 matrix rownames `resa1' = "Population" ;
 matrix rownames `resa2' = "Population" ;
 } ;
tempname   coltit  coltit2 coltit3 ;


if ("`totuser'" ~= "" ) {;
 qui gen     `coltit' = "[1]: Population "         in 1 ;
 qui replace `coltit' = "[2]: Current Users  "         in 2 ;
 qui replace `coltit' = "[3]: New Users  "   in 3 ;
 qui replace `coltit' = "[4]: Total Users"         in 4 ;
 qui replace `coltit' = "[5]: All Users  "   in 5 ;
 
 qui gen     `coltit2' = "(Micro)      "         in 1 ;
 qui replace `coltit2' = "(Micro)      "         in 2 ;
 qui replace `coltit2' = "(Macro/Micro)"   in 3 ;
 qui replace `coltit2' = "(Macro)      "         in 4 ;
 qui replace `coltit2' = "(Macro/Micro)"   in 5 ;
 local note1 "[1]: Estimation based on micro data (ex. sampling weight and househcurrent size variables)." ;
 local note2 "[2]: Estimation based on the micro data (ex. observed users in the micro data)." ;
 local note3 "[3]: Estimation based on micro/macro data (new users  : based on total users (Macro) and current users (Micro).)" ;
 local note4 "[4]: Estimation based on macro data (total users: based on the  total users (Macro)).)" ;
 local note5 "[5]: Estimation based on micro/macro data (total users: based on total users (Macro) and new users (Micro)).)" ;
};

if ("`totentr'" ~= "" ) {;
 qui gen     `coltit' = "[1]  Population "         in 1 ;
 qui replace `coltit' = "Current Users  "         in 2 ;
 qui replace `coltit' = "New Users  "         in 3 ;
 qui replace `coltit' = "New Users  "   in 4 ;
 qui replace `coltit' = "All Users  "   in 5 ;
 
 qui gen     `coltit2' = "(Micro)"         in 1 ;
 qui replace `coltit2' = "(Micro)"         in 2 ;
 qui replace `coltit2' = "(Macro/Micro)"   in 3 ;
 qui replace `coltit2' = "(Macro)"         in 4 ;
 qui replace `coltit2' = "(Macro/Micro)"   in 5 ;
 
 local note1 "[1]: Estimation based on micro data (ex. sampling weight and househcurrent size variables)." ;
 local note2 "[2]: Estimation based on the micro data (ex. observed users in the micro data)." ;
 local note3 "[3]: Estimation based on micro/macro data (new users  : based on total users (Macro/Micro) and current users (Micro).)" ;
 local note4 "[4]: Estimation based on macro data (new users: based on the  new users (Macro)).)" ;
 local note5 "[5]: Estimation based on micro/macro data (total users: based on new users (Macro) and current users (Micro)).)" ;
};


 qui gen     `coltit3' = "Current Users"  in 1 ;
 qui replace `coltit3' = "New Users"  in 2 ;
 qui replace `coltit3' = "All Users"  in 3 ;

 local dsmidl = 0 ;
 if `ngr1' == 1  local dsmidl = -1 ;
 dis _n as result "Table 03:  Number of current and new consumers" ;
 if ("`totuser'" ~= "" ) {;

 matrix colnames `resa1' =  "[1] Population (Micro) "  "[2] Current Users (Micro)"  "[3] New Users (Macro/Micro)"   "[4]  All Users (Macro)" "[5] All Users (Macro/Micro)" ;
 };
  if ("`totentr'" ~= "" ) {;
 matrix colnames `resa1' =  "Population (Micro) "  "Current Users (Micro)"  "New Users (Macro/Micro)"   "New Users (Macro)" "All Users (Macro/Micro)" ;
 };
 matrix colnames `resa2' =  "Current Users"  "New Users"  "All users" ;
  distable `resa1', dec1(5) dec2(5) dec3(5) dec4(5)  dec5(5)  coltit1(`coltit') coltit2(`coltit2')  dsmidl(`dsmidl')  ;
  dis as result  "Notes:";
  forvalues i=1/5 {;
  	dis as text "`note`i''";
  } ;

 
 
 /*tab `grmac' `type_consumer' [aw=`sw'] , cell nofreq; */

 
 dis as result  "Table 04:  Percentages of current and new consumers" ;
  distable `resa2', dec1(3) dec2(3) dec3(3) dsmidl(1)  ;

 cap drop _est_* ;
 cap drop _I*;
 cap drop ___*;

/*
set trace on ; 
*/

if  ("`xfil'" ~= "") {;

xml_taba2 `models',  format(sclb0 ncrr3 ncrr3) stats(N r2_p) ///
save(`xfil') replace  ///
cblanks(2) cwidth(0 220, 3 4)  font("Cambria" 10)   ///
sheet(Table_01,  nogridlines)  ///
lines(_cons 2 LAST_ROW 13 COL_NAMES 2 EST_NAMES 2) ///
title("Table 01: Estimates of probability of consumption model(s)")
;

matrix taaa = aaa' ;

qui xml_taba2 taaa,  format(sclb0 ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec') save(`xfil') ///
   cwidth(0 170, . 90) font("Cambria" 10)  ///
sheet(Table_02,  nogridlines)  ///
lines(0 2 /*COL_NAMES 2*/ LAST_ROW 13)  ///
notes(0 Notes: , 0 [1]- Estimated based on population/groups. , 0 [2]- Based on predicted individual -househcurrent- probabilities.)
title("Table 02: Estimated impact on the proportions of consummer")  newappend
;

local dec = 0;
local lst1 = rowsof(`resa1')-1;
if `lst1'==1 local lst1 =="";
qui xml_taba2 `resa1',  format(sclb0 ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec') ///
save(`xfil')    cwidth(0 140,1 120, 2 120, 3 120, 4 120, 5 120) font("Cambria" 10)  ///
sheet(Table_03,  nogridlines)  ///
lines(0 2  COL_NAMES 2 `lst1' 2  LAST_ROW 13)  ///
notes(0 Notes: , 0 [1]: Estimation based on micro data (ex. sampling weight and househcurrent size variables). , 0 [2]: Estimation based on the micro data (ex. observed users in the micro data). , 0 [3]: Estimation based on micro/macro data (new users  : based on total users (Macro) and current users (Micro)). ,  0 [4]: Estimation based on macro data (total users: based on the  total users (Macro)). , 0 [5]: Estimation based on micro/macro data (total users: based on total users (Macro) and new users (Micro)). )
title("Table 03:  Number of current and new consumers") newappend;

local dec = 2 ;
local lst1 = rowsof(`resa2')-1;
if `lst1'==1 local lst1 =="";
qui xml_taba2 `resa2',  format(sclb0 ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec' ncrr`dec') ///
save(`xfil')    cwidth(0 210,1 90, 2 90, 3 90, 4 90, 5 90, 6 90, 7 90, . 90) font("Cambria" 10)  ///
sheet(Table_04,  nogridlines)  ///
lines( 0 2 /*COL_NAMES 2*/ `lst1' 2 LAST_ROW 13)  ///
title("Table 04:  Percentages of current and new consumers") newappend;

};


qui replace `kappa_all' = 0 if `kappa_all'==.;
cap drop _pred_exp;
tempvar  _pred_exp;

if "`grmod1'" == "" {;
tempvar grmod1;
qui gen `grmod1' = 1;
};
if "`grmod2'" == "" {;
tempvar grmod2;
qui gen `grmod2' = 1;
};
if (`expmod' == 1) {;
tempvar var1 var2 nomi denomi ;
qui gen `var1' = `sw'*`2' ; 
qui gen `var2' = `sw' ; 
qui by `grmod1' `grmod2', sort : egen float `nomi'   = total(`var1');
qui by `grmod1' `grmod2', sort : egen float `denomi' = total(`var2');
qui gen `_pred_exp' =  `nomi'/`denomi' ;
qui gen  _pred_exp  = `_pred_exp' ;
qui replace _pred_exp = `2' if `1' == 1 ;
};


if (`expmod' == 2) {;
cap drop _ID;
cap drop _merge;
cap drop _outcome* ;
qui gen _ID=_n ;
tempfile mydata;
qui save `mydata', replace;
cap drop     _outcome ;
qui gen      _outcome = `2' ;
qui replace  _outcome = .  if `1' == 0 ;
qui gen _outcome_hd = _outcome ;
cap erase Impu_all_1 ;
qui hotdeck _outcome_hd  using  Impu_all_, by(`grmod1' `grmod2') keep(_ID) store seed(`seed') ;
use `mydata', replace;
qui merge 1:1 _ID using Impu_all_1 ;
cap drop _merge
cap erase Impu_all_1.dta ;
qui gen `_pred_exp' = _outcome_hd ;
qui gen  _pred_exp  = `_pred_exp' ;
qui replace _pred_exp = `2' if `1' == 1;

};



if (`expmod'  == 3 | `expmod'  == 4) {;
qui gen `_pred_exp' =  . ;
tempvar res;
qui gen `res' = . ;
if `pswe'!=1.0 local stpe stepwise, pr(`pswe'): ;
if "`2'"~="Expenditure" qui gen Expenditure = `2' ; 
                        local  vexp Expenditure ; 
if `fex' == 2 {;
 qui gen LnExpend = log(`2') ; 
 local  vexp LnExpend ; 
 };
 
local model_expend `model_expend' `vexp' ;
if "`welfare'"~="_Inc" qui gen _Inc = `welfare' ; 
               local  vexp _Inc ; 
if `fin' == 2  local  vexp  LnInc ; 
if `fin' == 3  local  vexp "" ; 
local model_expend `model_expend' `vexp' ;

if ("`price'"~="")  {;
if "`price'" ~="Price " qui gen Price = `price' ; 
               local  vexp Price ; 
if `fpr' == 2  local  vexp LnPrice ; 
if `fpr' == 3  local  vexp "" ; 
local model_expend `model_expend' `vexp' ;
};

#delimit ; 
if ("`cindcat'"~="") {;
foreach var of varlist `cindcat' {;
local posa = 1;
qui  sum  `var';
local rmi = r(min);
local rma = r(max);
forvalues i= `rmi'/`rma' {;
qui count if `var' == `i';
if `r(N)' !=0 {;
cap drop `var'_`i';
qui gen `var'_`i' = `var' == `i';
local name "`var'_`i'";
local uname = proper("`name'");
if "`uname'" == "" { ;
local uname = proper("`var'_`i'");
local uname `uname';
};
lab var `var'_`i' "`uname'";
if `posa' != 1 local clnindcat `clnindcat' `var'_`i';
local posa = `posa'+1 ;
};
};
};
}; 



local model_expend `model_expend' `clnindcat'  ;

qui levelsof `grmod1', local(gr1) ;
qui levelsof `grmod2', local(gr2) ;

if (`expmod'  == 3 ) {;
foreach l of local gr1 {;
foreach m of local gr2 {;
`disreg' xi:  `stpe' regress `model_expend' `cindcon'  [pw=`sw'] if `grmod1' == `l' & `grmod2' == `m'  , `oopt' ;
cap drop `mytmp' ;
tempvar mytmp ;
qui predict `mytmp' , xb;
qui replace `_pred_exp' = `mytmp'  if `grmod1' == `l' & `grmod2' == `m' ;
qui replace `res'      = `res'    if `grmod1' == `l' & `grmod2' == `m' ;

};
};

if `fex' == 2 qui replace `_pred_exp' = exp(`_pred_exp') ;
qui gen    _pred_exp  = `_pred_exp' ;
qui replace _pred_exp = `2' if `1' == 1;

};

//set trace on ;
if (`expmod'  == 4 ) {;
foreach l of local gr1 {;
foreach m of local gr2 {;
`disreg' xi:  `stpe' regress `model_expend' `cindcon'  [pw=`sw'] if `grmod1' == `l' & `grmod2' == `m'  , `oopt' ;
cap drop `mytmp' ;
tempvar mytmp ;
cap drop `res' ;
tempvar res ;
qui predict `res' , res;
qui predict `mytmp' , xb;
qui replace `_pred_exp' = `mytmp'  if `grmod1' == `l' & `grmod2' == `m' ;
qui replace `res'      = `res'  if `grmod1' == `l' & `grmod2' == `m' ;
};
};
tempvar  _pred_exp0 ;
qui gen `_pred_exp0' =`_pred_exp' ;
if `fex' == 2 qui replace `_pred_exp' = exp(`_pred_exp0') ;

cap drop _ID;
cap drop _merge;
cap drop _res* ;
qui gen _ID=_n ;
tempfile mydata;
qui gen _rsa = `res';
qui gen _prd = `_pred_exp0' ;
qui save `mydata', replace;
qui use `mydata' , replace;
cap drop     _res ;
qui gen      _res = _rsa ;
qui replace   _res = .  if `1' == 0 ;
qui gen _rs_hd = _res ;
cap erase Impu_all_1 ;
qui hotdeck _rs_hd  using  Impu_all_  , by(`grmod1' `grmod2') keep(_ID) store seed(`seed') ;
use `mydata', replace;
qui merge 1:1 _ID using Impu_all_1 ;
cap drop _merge
cap erase Impu_all_1.dta ;
qui replace `_pred_exp0' = _prd + _rs_hd  if `1' == 0  ;
if `fex' == 2 qui replace `_pred_exp' = exp(`_pred_exp0') ;
qui gen _pred_exp = `_pred_exp';
qui gen tag1 = _pred_exp<0 & `1' == 0;
//bysort `1':  sum _pred_exp  ;
cap drop _merge;
qui save `mydata', replace;
qui sum tag1 ;
local toma = r(sum);
local mina = 0;
while `toma'!=0 {;
local condi = 0;

qui gen      _res = _rsa ;
qui replace  _res = .  if tag1 == 1 ;
cap drop _rs_hd ;
qui gen  _rs_hd = _res ;



qui count;
if ((`toma'/`r(N)')  < 0.001)  {;
qui replace _rs_hd =  `2'      if tag1 != 1 & `1'==0;
qui replace _rs_hd =  _pred_exp if tag1 != 1 & `1'==1;
replace _prd = 0 ;
qui replace _rs_hd =   .  if tag1 == 1 ;
local condi = 1;
};


cap erase Impu_all2_1 ;
qui hotdeck _rs_hd  using  Impu_all2_  , by(`grmod1' `grmod2') keep(_ID) store seed(`seed');
use `mydata', replace;
cap drop _rs_hd ;
qui merge 1:1 _ID using Impu_all_1 ;
cap drop _merge
cap erase Impu_all2_1.dta ;
              qui replace `_pred_exp0' = _prd + _rs_hd                  if tag1 == 1  ;
if `fex' == 1 qui replace _pred_exp    = `_pred_exp0'                    if tag1 == 1  ;
if `fex' == 2 & `condi' == 0 qui replace _pred_exp    = exp(`_pred_exp0')               if tag1 == 1  ;

qui sum _pred_exp if tag1 == 1;
qui replace tag1 = _pred_exp<0 ;
cap drop _merge;
qui save `mydata', replace;
qui sum tag1 ;
local toma = r(sum);
};
//bysort `1':  sum _pred_exp  ;

qui replace _pred_exp = `2' if `1' == 1;

};



/*
dis _n "Table 03: Estimates of the expenditures model" ;
esttab modexp, not r2    mtitle("(Model 01)" ) nodepvars nonumbers b(`dec') varwidth(34) label;
*/
};



/** new **/


if (`expmod'  == 5 | `expmod'  == 6) {;
qui gen `_pred_exp' =  . ;
tempvar res;
qui gen `res' = . ;
if `pswe'!=1.0 local stpe stepwise, pr(`pswe'): ;
if "`2'"~="Expenditure" qui gen Expenditure = `2' ; 
                        local  vexp Expenditure ; 
if `fex' == 2 {;
 qui gen LnExpend = log(`2') ; 
 local  vexp LnExpend ; 
 };
 
local model_expend `model_expend' `vexp' ;
if "`welfare'"~="_Inc" qui gen _Inc = `welfare' ; 
               local  vexp _Inc ; 
if `fin' == 2  local  vexp  LnInc ; 
if `fin' == 3  local  vexp "" ; 
local model_expend `model_expend' `vexp' ;

if ("`price'"~="")  {;
if "`price'" ~="Price " qui gen Price = `price' ; 
               local  vexp Price ; 
if `fpr' == 2  local  vexp LnPrice ; 
if `fpr' == 3  local  vexp "" ; 
local model_expend `model_expend' `vexp' ;
};

#delimit ; 
if ("`cindcat'"~="") {;
foreach var of varlist `cindcat' {;
local posa = 1;
qui  sum  `var';
local rmi = r(min);
local rma = r(max);
forvalues i= `rmi'/`rma' {;
qui count if `var' == `i';
if `r(N)' !=0 {;
cap drop `var'_`i';
qui gen `var'_`i' = `var' == `i';
local name "`var'_`i'";
local uname = proper("`name'");
if "`uname'" == "" { ;
local uname = proper("`var'_`i'");
local uname `uname';
};
lab var `var'_`i' "`uname'";
if `posa' != 1 local clnindcat `clnindcat' `var'_`i';
local posa = `posa'+1 ;
};
};
};
};


local model_expend `model_expend' `clnindcat'  ;

qui levelsof `grmod1', local(gr1) ;
qui levelsof `grmod2', local(gr2) ;

/*
set trace on ;
set tracedepth 1;
*/
if (`expmod'  == 5 )   {;
foreach l of local gr1 {;
foreach m of local gr2 {;
cap drop  __grq ;
qui xtile __grq = `welfare' [aw=`sw']  if  `grmod1' == `l' & `grmod2' == `m' , nquantiles(`nquantile');
forvalues q=1/`nquantile' {;
local tq = `q'/`nquantile';
gepwe `welfare'  if  `grmod1' == `l' & `grmod2' == `m' , nper(1) per1(`tq');
`disreg' xi:  `stpe' regress `model_expend' `cindcon'  [pw=_pcw] if `grmod1' == `l' & `grmod2' == `m'  , `oopt' ;
cap drop `mytmp' ;
tempvar mytmp ;
qui predict `mytmp' , xb;
qui replace `_pred_exp' = `mytmp'  if `grmod1' == `l' & `grmod2' == `m' & __grq == `q' ;
qui replace `res'      = `res'    if `grmod1' == `l' & `grmod2' == `m'  & __grq == `q' ;
};
};
};

if `fex' == 2 qui replace `_pred_exp' = exp(`_pred_exp') ;
qui gen    _pred_exp  = `_pred_exp' ;
qui replace _pred_exp = `2' if `1' == 1;

};

//set trace on ;
if (`expmod'  == 6 )   {;
foreach l of local gr1 {;
foreach m of local gr2 {;
cap drop __grq;
qui xtile __grq = `welfare' [aw=`sw'] , nquantiles(`nquantile');
forvalues q=1/`nquantile' {;
local tq = `q'/`nquantile';
gepwe `welfare'  if `grmod1' == `l' & `grmod2' == `m' , nper(1) per1(`tq');
`disreg' xi:  `stpe' regress `model_expend' `cindcon'  [pw=_pcw] if `grmod1' == `l' & `grmod2' == `m'  , `oopt' ;
cap drop `mytmp' ;
tempvar mytmp ;
cap drop `res' ;
tempvar res ;
qui predict `res' , res;
qui predict `mytmp' , xb;
qui replace `_pred_exp' = `mytmp'  if `grmod1' == `l' & `grmod2' == `m' & __grq == `q' ;
qui replace `res'      = `res'  if `grmod1' == `l' & `grmod2' == `m' & __grq == `q' ;
};
};
};
tempvar  _pred_exp0 ;
qui gen `_pred_exp0' =`_pred_exp' ;
if `fex' == 2 qui replace `_pred_exp' = exp(`_pred_exp0') ;

cap drop _ID;
cap drop _merge;
cap drop _res* ;
qui gen _ID=_n ;
tempfile mydata;
qui gen _rsa = `res';
qui gen _prd = `_pred_exp0' ;
qui save `mydata', replace;
qui use `mydata' , replace;
cap drop     _res ;
qui gen      _res = _rsa ;
qui replace   _res = .  if `1' == 0 ;
qui gen _rs_hd = _res ;
cap erase Impu_all_1 ;
qui hotdeck _rs_hd  using  Impu_all_  , by(`grmod1' `grmod2') keep(_ID) store seed(`seed') ;
use `mydata', replace;
qui merge 1:1 _ID using Impu_all_1 ;
cap drop _merge
cap erase Impu_all_1.dta ;
qui replace `_pred_exp0' = _prd + _rs_hd  if `1' == 0  ;
if `fex' == 2 qui replace `_pred_exp' = exp(`_pred_exp0') ;
qui gen _pred_exp = `_pred_exp';
qui gen tag1 = _pred_exp<0 & `1' == 0;
//bysort `1':  sum _pred_exp  ;
cap drop _merge;
qui save `mydata', replace;
qui sum tag1 ;
local toma = r(sum);
local mina = 0;
while `toma'!=0 {;
local condi = 0;


qui gen      _res = _rsa ;
qui replace  _res = .  if tag1 == 1 ;
cap drop _rs_hd ;
qui gen  _rs_hd = _res ;

qui count;
if ((`toma'/`r(N)')  < 0.001)  {;
qui replace _rs_hd =  `2'      if tag1 != 1 & `1'==0;
qui replace _rs_hd =  _pred_exp if tag1 != 1 & `1'==1;
replace _prd = 0 ;
qui replace _rs_hd =   .  if tag1 == 1 ;
local condi = 1;
};


cap erase Impu_all2_1 ;
qui hotdeck _rs_hd  using  Impu_all2_  , by(`grmod1' `grmod2') keep(_ID) store seed(`seed');
use `mydata', replace;
cap drop _rs_hd ;
qui merge 1:1 _ID using Impu_all_1 ;
cap drop _merge
cap erase Impu_all2_1.dta ;
              qui replace `_pred_exp0' = _prd + _rs_hd                  if tag1 == 1  ;
if `fex' == 1 qui replace _pred_exp    = `_pred_exp0'                    if tag1 == 1  ;
if `fex' == 2 & `condi' == 0 qui replace _pred_exp    = exp(`_pred_exp0')               if tag1 == 1  ;

qui sum _pred_exp if tag1 == 1;
qui replace tag1 = _pred_exp<0 ;
cap drop _merge;
qui save `mydata', replace;
qui sum tag1 ;
local toma = r(sum);
};
//bysort `1':  sum _pred_exp  ;

qui replace _pred_exp = `2' if `1' == 1;

};



/*
dis _n "Table 05: Estimates of the expenditures model" ;
esttab modexp, not r2    mtitle("(Model 01)" ) nodepvars nonumbers b(`dec') varwidth(34) label;
*/
};
/** new **/

cap drop __grq;
cap drop _pcw ;
qui replace `_pred_exp' =  _pred_exp ;

/*
set trace on;
set tracedepth 1;
*/

tempvar _fexpen benif tbenif   nbenif   ;
qui      gen `_fexpen' = `_pred_exp' if `1' == 0; 
qui replace  `_fexpen' = `2'         if `1' == 1; 


qui gen   double  `tbenif' = -`2' * `pchange'*(`1'==1)  ;
qui replace `tbenif' = 0 if (`1'==0) ;
qui gen   double  `nbenif'  =  -`frho'*`_pred_exp'* `pchange'*(`1' == 0) ;
qui replace `nbenif'  = 0 if (`1'==1) ;

qui gen   double  `benif  ' = `tbenif' + `nbenif' ;
qui replace `benif'        =  -`frho'*`_pred_exp'* `pchange'       if `1' == 0 ;


tempvar res0 ;
qui gen `res0' = "";
forvalues i=1/8 {;
tempvar res`i' ;
qui gen `res`i'' = 0;
};

cap drop `prdif';
tempvar  prdif;
qui gen `prdif' = `kappa_all';


tempvar sww;
qui gen     `sww' = `sw'             if (`1'==1) ;
qui replace `sww' = `sw'*`kappa_all' if (`1'==0) ;

forvalues i=1/$indicagm {;
local k = gm1[`i'];
qui sum `sww' if (`1'==0) & `disgr'==`k' ; local m1 = r(sum) ;
qui sum `sw'  if (`1'==0) & `disgr'==`k' ; local m2 = r(sum) ;
qui replace `sww' = `sww'*`m2'/`m1' if (`1'==0) & `disgr'==`k' ;
};


if ("`disgr'" ~= "") {;
qui tabulate  `disgr', matrow(gm);
global indicagm=r(r);
cap drop gm1;
qui svmat int gm;

forvalues i=1/$indicagm {;

local k      = gm1[`i'];
local grm`i' = gm1[`i'];

if ( "`grlabm`i''" == "") local grlabm`i' = "Group_`k'";

qui replace `res0' = "`k'_`grlabm`k''" in `i';

qui sum `2' [aw=`sw'] if  `disgr'==`k' & `1' == 1 ;
qui replace `res1' = r(mean) in `i';

qui sum `_pred_exp' [aw=`sw'] if  `disgr'==`k' & `1' == 0 ;
qui replace `res2' = r(mean) in `i';


qui sum `tbenif' [aw=`sw'] if  `disgr'==`k' ;
qui replace `res3' = r(mean) in `i';

qui sum  `nbenif'  [aw=`sww']    if  `disgr'==`k' ;
qui replace `res4' = `r(mean)' in `i';

qui replace `res5' = `res3'[`i']+`res4'[`i'] in `i';

};
};



if ("`disgr'" == "") global indicagm = 0;
global indicagm1 = $indicagm +1;
local i = $indicagm1 ;

qui replace `res0' = "Population" in `i';

qui sum `2' [aw=`sw']        if   `1' == 1 ;
qui replace `res1' = r(mean) in `i';

qui sum `_pred_exp' [aw=`sw'] if   `1' == 0 ;
qui replace `res2' = r(mean) in `i';


qui sum `tbenif'      [aw=`sw'] ;
qui replace `res3' = r(mean) in `i';

qui sum  `nbenif'  [aw=`sww']    ;
qui replace `res4' =  `r(mean)' in `i';


qui replace `res5' = `res3'[`i']+`res4'[`i'] in `i';


tempname resmat4t resmat4 ;
qui mkmat `res1' `res2' `res3' `res4' `res5'   in 1/$indicagm1 , matrix(`resmat4t') rownames(`res0');
matrix zzz = `resmat4t';
matrix `resmat4' = `resmat4t';


matrix colnames `resmat4' = 
"[1] Expenditures (current users)" 
"[2] Predicted expend. (new users)" 
"[3] Imp. on well. current" 
"[4] Imp. on well. new" 
"[4] Imp. on well. all" 
;



dis _n as result "Table 05: Estimated impact on well-being" ;
   tempname table;
        .`table'  = ._tab.new, col(6);
        .`table'.width |30|16 16 || 20 20 | 23|;
        .`table'.strcolor . . . . . .;
        .`table'.numcolor yellow yellow yellow  yellow yellow yellow   ;
        .`table'.numfmt %16.0g  %16.`dec'f  %16.`dec'f  %20.`dec'f  %20.`dec'f %23.`dec'f;
        .`table'.sep, top;
        .`table'.titles "Group  " "[1] Expenditures " "[2] Predicted "      "[3] Impact on        "   "[4] Impact on  "   "[5] Impact on  "    ;
	    .`table'.titles "       " "  (current users)" "   expenditures"    " well-being   "    "  well-being    "   "  well-being    ";
        .`table'.titles "       " "                " "   (new users) "       "current users "    "   new users"  " all users" ;
        .`table'.sep, mid;
        local nalt = "ddd";
       if $indicagm !=1 {;
	   forvalues i=1/$indicagm {;
		.`table'.row `res0'[`i']  `res1'[`i']  `res2'[`i']  `res3'[`i']  `res4'[`i'] `res5'[`i']  ;
		 };
local i = $indicagm1;		 
if $indicagm!=0 .`table'.sep, mid;
	   };
.`table'.row `res0'[`i']  `res1'[`i']  `res2'[`i']  `res3'[`i']  `res4'[`i'] `res5'[`i']  ;
.`table'.sep,bot;

dis as result  "Notes:";
dis as text " [1]- Computed  based on average expenditures of current consumers by population/groups." ;
dis " [2]- Estimated based on predicted expenditures of entrants by population/groups." ;
dis " [3]- Computed  based on average expenditures of current consumers and price change." ;
dis " [4]- Estimated based on estimated expenditures of entrants, price change and the probability of use." ; 
dis " [5]- [3]+[4]." ; 

cap ereturn matrix est2 = aaa;
 
 
/*****/
/* Saving results in the excel file */ 
if  ("`xfil'" ~= "") {;


/*
if  (`expmod'  == 2) {;
qui xml_tab modexp,  format(sclb0 ncrr3 ncrr3) stats(N r2) ///
save(`xfil') append  ///
cblanks(2) cwidth(0 220, 3 4) font("Cambria" 10)  ///
sheet(Table_03,  nogridlines)  ///
lines(_cons 2 LAST_ROW 13 COL_NAMES 2 EST_NAMES 2) ///
title("Table 03: Estimates of the expenditures model");
};
*/



local nc = colsof(`resmat4');
local nr = rowsof(`resmat4');
if `nr' == 2 local nr = 1;
tabtitmc 00; 
local tabtit = "`r(tabtit)'";
matrix colnames `resmat4' = 
"[1] Expenditures (current users)" 
"[2] Predicted expend. (new users)" 
"[3] Imp. on well. current users" 
"[4] Imp. on well. new users" 
"[5] Imp. on well. all users" 
;



 if (`ngr'>1) {;
 local rname  "";
 qui levelsof `disgr', local(gresu);
 local lbe : value label  `disgr' ;
 foreach x of local gresu { ;
 cap local f`x' : label `lbe' `x';
 local tmps =  subinstr("`f`x''", " ", "_", .);
if  "`tmps'"  ~= "" local  f`x' = "`tmps'" ;
 local rname `rname'  `f`x'';
 };
  local rname `rname' Population ; 
 matrix rownames `resmat4' = `rname' ; 
 };
  if (`ngr'==1) { ;
 matrix rownames `resmat4' = "Population" ;
 } ;
cap matrix drop aaa;
if `nr' != 1 matrix aaa= `resmat4'[1..`nr', 1..`nc'] ;
if `nr' == 1 matrix aaa= `resmat4'[2..2, 1..`nc'] ;
local dec = 2 ;
local lst1 = rowsof(aaa)-1;
if `lst1'==1 local lst1 =="";
qui xml_taba2 aaa,  format(sclb0 ncrr`dec' ncrr`dec'  ncrr`dec' ncrr`dec')  save(`xfil')    
save(`xfil')    cwidth(0 210,1 90, 2 90, 3 90, 4 90, 5 90, 6 90, 7 90, . 90) font("Cambria" 10)  ///
sheet(Table_05,  nogridlines)   
lines(-1 13 0 2  `lst1'  2  LAST_ROW 13)   
title("Table 05: Estimated impact on well-being")  newappend
notes(
0 Notes: ,
0 [1]- Computed  based on average expenditures of current consumers by population/groups. ,
0 [2]- Estimated based on predicted expenditures of entrants by population/groups. ,
0 [3]- Computed  based on average expenditures of current consumers and price change. ,
0 [4]- Estimated based on (a) estimated expenditures of entrants (b) price change (c) the probability of use.,
0 [5]- [3]+[4]..
)
;
};
ereturn matrix  est4 = `resmat4t';




/* Poverty change*/

tempvar wel1 wel2 benifa  benifa1  benifa2;
qui gen `wel1'    = `welfare' ;
qui gen `benifa'  = -`_fexpen'* `pchange'*(`type_consumer'==2)  -`2' * `pchange'*(`type_consumer'==1) ; 
qui gen `benifa1'  =  -`2' * `pchange'*(`type_consumer'==1) ; 
qui gen `benifa2'  = -`_fexpen'* `pchange'*(`type_consumer'==2) ; 

 forvalues g=1/$indicagm {;

qui  sum `benifa2' [aw=`sw']  if (`disgr'==`grm`g'')  ;  local m2 = r(mean) ;
qui replace `benifa2' = `benifa2'*el(aaa,`g',4)/r(mean) if (`disgr'==`grm`g'') ;
qui replace `benifa2' = 0 if (`type_consumer'!=2);
qui  sum  `benifa2' [aw=`sw'] if (`disgr'==`grm`g'')  ;
/*dis `g' " :: " `grm`g'' " "`r(mean)' " "  el(aaa,`g', 4 )  "uu " `m1'    "uu " `m2'; */
 };

qui mcjobpov `benifa1' `benifa2',    hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(total)  pcexp(`welfare') alpha(0)  pline(`pline') move(-1);
tempname mat1;
matrix `mat1' = e(est); 
matrix rownames `mat1' = "Initial/Concentrated Market" "With benefits of current users" "With benefits of new users" "Final" ;
local tabtit = "Table 06: Poverty headcount & market power"; 
distable `mat1', dec(4) atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
mk_xtab_mc `welfare' ,  matn(`mat1') dec(4) xfil(`xfil') xshe(Table_06) xtit(`tabtit') xlan(`lan') dste(0) 
;

qui mcjobpov `benifa1' `benifa2',    hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(total)  pcexp(`welfare') alpha(1)  pline(`pline') move(-1);
tempname mat1;
matrix `mat1' = e(est); 
matrix rownames `mat1' = "Initial/Concentrated Market" "With benefits of current users" "With benefits of new users" "Final" ;
local tabtit = "Table 07: Poverty gap & market power"; 
distable `mat1', dec(4) atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
mk_xtab_mc `welfare' ,  matn(`mat1') dec(4) xfil(`xfil') xshe(Table_07) xtit(`tabtit') xlan(`lan') dste(0) 
;



qui mcjobgini `benifa1' `benifa2',    hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(total)  pcexp(`welfare')  move(-1);
tempname mat1;
matrix `mat1' = e(est); 
matrix rownames `mat1' = "Initial/Concentrated Market" "With benefits of current users" "With benefits of new users" "Final" ;
local tabtit = "Table 08: Gini index & market power"; 
distable `mat1', dec(4) atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
mk_xtab_mc `welfare' ,  matn(`mat1') dec(4) xfil(`xfil') xshe(Table_08) xtit(`tabtit') xlan(`lan') dste(0) 
;


/* to display automatically the excel file */
if  ("`xfil'" ~= "") {;
di as txt `"(output written to {browse `xfil'})"' ; 
};
cap drop  _fgroup; 
cap drop _benefit ;


 
gen _benefit = `benifa1'*(`type_consumer'==1)+`benifa2'*(`type_consumer'==2);
cap drop _type_consumer ;
gen _type_consumer = `type_consumer';
tempname mydata;
qui keep _key _benefit _type_consumer;
qui save `mydata' , replace ;

restore;
cap drop _benefit;
cap drop _type_consumer ;
qui merge 1:1 _key using  `mydata' , nogen ;
cap drop _key;


end;

