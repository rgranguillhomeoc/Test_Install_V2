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
cap program drop mcem1;
program define mcem1, eclass ;
syntax varlist(min=2 max=2)[, 
welfare(varname)
hsize(varname)
price(varname)
pline(varname)
ICHANGE(varname)
PCHANGE(varname)
INCPAR(varname)
HGROUP(varname)
indcon(string) 
indcat(string) 
PSWP(real 1.0)
PSWE(real 1.0)
DEC(int  6)
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

tokenize `varlist' ;
if ("`expshare'" ~= "") {;
qui replace `expshare' = 1.0  if `1' == 0;
};

if ("`ichange'" == "" ) {;
if "`price'" == "" {;
      di in r "You must indicate the price variable.";
	  exit 198;
};
};

if ("`price'" == "" | "`ichange'" ~= "" ) {;
tempvar vchangea ;
qui gen double `vchangea' = `ichange' ;
if ("`expshare'" ~= "") {;
qui replace `expshare' = 1.0  if `1' == 0;
qui replace `vchangea' = `ichange'/`expshare' ;
};
};

if ("`price'" ~= "" & "`pchange'" ~= "" ) {;
tempvar vchangea ;
qui gen double `vchangea' = `pchange'*`price' ;
};



/* IN PROGRESS : Apdate the swe prob*/
 
/* To capture the name of the variable sampling weight if the user declare it with the command svyset */
local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear;



/* The final weight = sampling weight if declared or 1 (by default)   */

tempvar   sw;
qui gen double `sw'=1;
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
prop_change: The proportion of change in welfare (in %);
dif        : The estimated change in the probability of use -or consumption- of the good;
*/
tempvar elap;
qui gen `elap'  = 0;
tempvar prop_ch;
qui gen `prop_ch' = 0;
tempvar prop_change;
qui gen `prop_change' = 0;
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
			      };
			
            };			
			
};
};




/* All of the possible estimated probit models are reported in table 01 */
dis _n "Table 01: Estimates of probability of consumption model(s)" ;
esttab `mm', not pr2    mtitle(`mytitmod1' `mytitmod2' `mytitmod3' `mytitmod4')  nodepvars nonumbers b(`dec') varwidth(34) label;
if (`um' == 5 | `um' == 6) {;
dis _n "The rest of_Table 01: Estimates of probability of consumption model `um'" ;
esttab m_*, not pr2      nodepvars nonumbers b(`dec') varwidth(34) label;
};


 cap drop `pr1';
tempvar   pr1; 
cap drop `pr2';
tempvar   pr2; 


 if (`um'==1 ) {;
qui  `stp' probit `1'  `pLnInc' `subcom_m1' `lnindcat' `indcon' [pw=`sw'];
qui predict `pr1';
qui replace  Ln`Main'=log(exp(Ln`Main')+`vchangea');
qui predict `pr2' ;
qui replace Ln`Main'=log(exp(Ln`Main')-`vchangea');
qui margins [aw=`sw'] , dydx(Ln`Main') atmeans ;
local mar1 = el(r(table),1,1) ;
qui sum `1' [aw=`sw'];
local elap1 = `mar1' / r(mean) ;
qui replace `elap' = `elap1'; 
qui sum `vchangea'  [aw=`sw'], meanonly;      local mu1 = r(mean);
qui sum `welfare'   [aw=`sw'],   meanonly;      local mu2 = r(mean);
qui replace `prop_change' = `mu1'/`mu2'*100 ; 

qui sum `pr1'  [aw=`sw']  , meanonly;         local mu1 = r(mean);
qui sum `pr2'  [aw=`sw']  , meanonly;         local mu2 = r(mean);

qui replace `prdif' = `pr2'-`pr1'            ; 
qui replace `dif' = `mu2'-`mu1'            ; 
qui replace `prop_ch' = `dif'/`mu1'*100    ; 
};


 if (`um'==2) {;
`disprobit'  `stp' probit `1'  `pLnInc'  `subcom_m2' `modp' `lnindcat' `indcon' [pw=`sw'];
qui predict `pr1';
forvalues j=1/`nigr' {;
if `j' <=  9  qui replace Ln`Main'_0`j'     =  log(exp(Ln`Main')+`vchangea')*(`incpar'==`j');
if `j' >= 10  qui replace Ln`Main'_`j'      =  log(exp(Ln`Main')+`vchangea')*(`incpar'==`j');
};
qui predict `pr2';
forvalues j=1/`nigr' {;
if `j' <=  9  qui replace Ln`Main'_0`j'     =  Ln`Main'*(`incpar'==`j');
if `j' >= 10  qui replace Ln`Main'_`j'      =  Ln`Main'*(`incpar'==`j');
};

forvalues j=1/`nigr' {;
if `j' <=  9  local myvar  Ln`Main'_0`j';
if `j' >= 10  local myvar  Ln`Main'_`j';  
cap qui margins [aw=`sw'], dydx(`myvar') atmeans ;
cap local mar`j' = el(r(table),1,1) ;
if "`mar`j''" == "" local mar`j' = 0;
qui sum `1' [aw=`sw'] if (`incpar'==`j') ;
local elap1 = `mar`j'' / r(mean)  ;
qui replace `elap' = `elap1' if (`incpar'==`j'); 
qui sum `vchangea'  [aw=`sw']   if (`incpar'==`j'), meanonly;      local mu1 = r(mean);
qui sum `welfare'   [aw=`sw']   if (`incpar'==`j'), meanonly;      local mu2 = r(mean);
qui replace `prop_change' = `mu1'/`mu2'*100 if (`incpar'==`j') ; 
qui sum `pr1'  [aw=`sw'] if (`incpar'==`j'),  meanonly;            local mu1 = r(mean);
qui sum `pr2'  [aw=`sw']  if (`incpar'==`j'), meanonly;            local mu2 = r(mean);
qui replace `prdif' = `pr2'-`pr1'            ; 
qui replace `dif' = `mu2'-`mu1'            if (`incpar'==`j') ; 
qui replace `prop_ch' = `dif'/`mu1'*100    if (`incpar'==`j') ; 
};
}; 


 if (`um'==3) {;
`disprobit'  `stp' probit `1'  `pLnInc' `subcom_m3'  `modp'  `lnindcat' `indcon' [pw = `sw'] ;
qui predict `pr1' ;
forvalues g=1/$indicag {;
local gr = gn1[`g'];
qui replace Ln`Main'_`sgrlab`gr''=log(exp(Ln`Main'_`sgrlab`gr'')+`vchangea')*(`g'==`hgroup');
};

qui predict `pr2';
forvalues g=1/$indicag {;
local gr = gn1[`g'];
qui replace Ln`Main'_`sgrlab`gr''=log(exp(Ln`Main'_`sgrlab`gr'')-`vchangea')*(`g'==`hgroup');
};


forvalues g=1/$indicag {;
local gr = gn1[`g'];
local myvar Ln`Main'_`sgrlab`gr'';
cap qui margins [aw=`sw'], dydx(`myvar') atmeans ;
cap local mar_`g' = el(r(table),1,1) ;
if "`mar_`g''" == "" local  local mar_`g' = 0;
qui sum `1' [aw=`sw'] if  (`hgroup'==`gr') ;
local elap1 = `mar_`g'' / r(mean)  ;
qui replace `elap' = `elap1' if  (`hgroup'==`gr') ;

qui sum `vchangea'  [aw=`sw'] if (`hgroup'==`gr'), meanonly;      local mu1 = r(mean);
qui sum `welfare' [aw=`sw'] if (`hgroup'==`gr'), meanonly; local mu2 = r(mean);
qui replace `prop_change' = `mu1'/`mu2'*100 if (`hgroup'==`gr') ; 
qui sum `pr1'  [aw=`sw'] if (`hgroup'==`gr'), meanonly;      local mu1 = r(mean);
qui sum `pr2' [aw=`sw']  if (`hgroup'==`gr'), meanonly;      local mu2 = r(mean);
qui replace `prdif' = `pr2'-`pr1'            ; 
qui replace `dif' = `mu2'-`mu1'            if (`hgroup'==`gr') ; 
qui replace `prop_ch' = `dif'/`mu1'*100    if (`hgroup'==`gr') ; 
};
};



 if (`um'==4) {;
`disprobit'  `stp' probit `1'  `pLnInc' `subcom_m4' `modp'  `lnindcat' `indcon' [pw = `sw'] ;
qui predict `pr1';
forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';
forvalues i=1/`nigr' {;
if `i' <  10 qui replace Ln`Main'_`iname'_0`i'_`sgrlab`gr''=log(exp(Ln`Main'_`iname'_0`i'_`sgrlab`gr'')+`vchangea')*(`incpar'==`i')*(`hgroup'==`gr');
if `i' >= 10 qui replace Ln`Main'_`iname'_`i'_`sgrlab`gr'' =log(exp(Ln`Main'_`iname'_`i'_`sgrlab`gr'') +`vchangea')*(`incpar'==`i')*(`hgroup'==`gr');
};
};
qui predict `pr2';
forvalues g=1/$indicag {;
local gr = gn1[`g'];
local lvgroup:value label `hgroup';
forvalues i=1/`nigr' {;
if `i' <  10 qui replace Ln`Main'_`iname'_0`i'_`sgrlab`gr''=Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
if `i' >= 10 qui replace Ln`Main'_`iname'_`i'_`sgrlab`gr'' =Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
};
};


forvalues g=1/$indicag {;
local gr = gn1[`g'];
forvalues j=1/`nigr' {;
if `j' <  10 local myvar Ln`Main'_`iname'_0`j'_`sgrlab`gr'';
if `j' >= 10 local myvar Ln`Main'_`iname'_`j'_`sgrlab`gr'' ;  
cap qui margins [aw=`sw'], dydx(`myvar') atmeans ;
cap local mar_`g'_`j' = el(r(table),1,1) ;
if "`mar_`g'_`j''" == ""  local mar_`g'_`j' = 0;
qui sum `1' [aw=`sw'] if (`j'==`incpar') & (`hgroup'==`gr') ;
local elap1 = `mar_`g'_`j'' / r(mean)  ;
qui replace `elap' = `elap1' if (`j'==`incpar') & (`hgroup'==`gr') ;

qui sum `vchangea'  [aw=`sw'] if (`j'==`incpar') & (`hgroup'==`gr'), meanonly;      local mu1 = r(mean);
qui sum `welfare'   [aw=`sw'] if (`j'==`incpar') & (`hgroup'==`gr'), meanonly; local mu2 = r(mean);
qui replace `prop_change' = `mu1'/`mu2'*100 if (`j'==`incpar') & (`hgroup'==`gr') ; 
qui sum `pr1'  [aw=`sw'] if (`j'==`incpar') & (`hgroup'==`gr'), meanonly;      local mu1 = r(mean);
qui sum `pr2' [aw=`sw']  if (`j'==`incpar') & (`hgroup'==`gr'), meanonly;      local mu2 = r(mean);
qui replace `prdif' = `pr2'-`pr1'            ; 
qui replace `dif' = `mu2'-`mu1'            if (`j'==`incpar') & (`hgroup'==`gr') ; 
qui replace `prop_ch' = `dif'/`mu1'*100    if (`j'==`incpar') & (`hgroup'==`gr') ; 
};
};

};




if (`um'==5) {;

gen `pr1' = 0;
gen `pr2' = 0;

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
local myvar Ln`Main'_`sgrlab`gr'';
cap qui margins [aw=`sw']  , dydx(`myvar') atmeans ;
cap local mar_`g' = el(r(table),1,1) ;
if "`mar_`g''" == ""  local mar_`g' = 0;
qui sum `1' [aw=`sw'] if  (`hgroup'==`gr') ;
local elap1 = `mar_`g'' / r(mean)  ;
qui replace `elap' = `elap1' if  (`hgroup'==`gr') ;
qui replace Ln`Main'_`sgrlab`gr''=log(exp(Ln`Main'_`sgrlab`gr'')+`vchangea')*(`hgroup'==`gr') if (`hgroup'==`gr');
cap drop `prg';
tempvar prg;
qui predict `prg' if (`hgroup'==`gr');
qui replace `pr2' = `prg'  if (`hgroup'==`gr');
qui replace Ln`Main'_`sgrlab`gr''=log(exp(Ln`Main'_`sgrlab`gr'')-`vchangea')*(`hgroup'==`gr') if (`hgroup'==`gr');
};



forvalues g=1/$indicag {;
local gr = gn1[`g'];
local myvar Ln`Main'_`sgrlab`gr'';
qui sum `vchangea'  [aw=`sw'] if (`hgroup'==`gr'), meanonly;         local mu1 = r(mean);
qui sum `welfare'   [aw=`sw'] if (`hgroup'==`gr'), meanonly;         local mu2 = r(mean);
qui replace `prop_change' = `mu1'/`mu2'*100 if (`hgroup'==`gr') ; 
qui sum `pr1'  [aw=`sw'] if (`hgroup'==`gr'), meanonly;              local mu1 = r(mean);
qui sum `pr2'  [aw=`sw'] if (`hgroup'==`gr'), meanonly;              local mu2 = r(mean);
qui replace `prdif' = `pr2'-`pr1'            ; 
qui replace `dif' = `mu2'-`mu1'            if (`hgroup'==`gr') ; 
qui replace `prop_ch' = `dif'/`mu1'*100    if (`hgroup'==`gr') ; 
};

};


//set trace on ;
set tracedepth 1;

if (`um'==6) {;
qui gen `pr1' = 0;
qui gen `pr2' = 0;


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
local models `models'   mod6_`grlab`gr'' ;
cap drop `prg' ;
tempvar prg;
qui predict `prg' if (`hgroup'==`gr');
forvalues i=1/`nigr' {;
qui replace `pr1' = `prg' if (`hgroup'==`gr');
if `i' <  10 qui replace Ln`Main'_`iname'_0`i'_`sgrlab`gr''=log(exp(Ln`Main'_`iname'_0`i'_`sgrlab`gr'')+`vchangea')*(`incpar'==`i')*(`hgroup'==`gr');
if `i' >= 10 qui replace Ln`Main'_`iname'_`i'_`sgrlab`gr'' =log(exp(Ln`Main'_`iname'_`i'_`sgrlab`gr'') +`vchangea')*(`incpar'==`i')*(`hgroup'==`gr');

if `i' <  10  qui replace   Ln`Main'_`iname'_0`i'_`sgrlab`gr'' = 0 if Ln`Main'_`iname'_0`i'_`sgrlab`gr'' ==.;
if `i' >= 10  qui replace   Ln`Main'_`iname'_`i'_`sgrlab`gr''  = 0 if Ln`Main'_`iname'_`i'_`sgrlab`gr'' ==.;

};
cap drop `prg' ;
tempvar prg;
qui predict  `prg' if (`hgroup'==`gr');
qui replace `pr2' = `prg' if (`hgroup'==`gr');
forvalues i=1/`nigr' {;
if `i' <  10 qui replace Ln`Main'_`iname'_0`i'_`sgrlab`gr''=Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
if `i' >= 10 qui replace Ln`Main'_`iname'_`i'_`sgrlab`gr'' =Ln`Main'*(`incpar'==`i')*(`hgroup'==`gr');
};

forvalues j=1/`nigr' {;
if `j' <  10 local myvar Ln`Main'_`iname'_0`j'_`sgrlab`gr'';
if `j' >= 10 local myvar Ln`Main'_`iname'_`j'_`sgrlab`gr'' ;  
cap qui margins [aw=`sw'], dydx(`myvar') atmeans ;
cap local mar_`g'_`j' = el(r(table),1,1) ;
if "`mar_`g'_`j''" == "" local mar_`g'_`j' = 0;
qui sum `1' [aw=`sw'] if (`incpar'==`j') & (`hgroup'==`gr') ;
local elap1 = `mar_`g'_`j'' / r(mean)  ;
qui replace `elap' = `elap1' if (`incpar'==`j') & (`hgroup'==`gr') ;

qui sum `vchangea'[aw=`sw'] if (`incpar'==`j') & (`hgroup'==`gr'), meanonly;      local mu1 = r(mean);
qui sum `price'  [aw=`sw'] if (`incpar'==`j') & (`hgroup'==`gr'), meanonly; local mu2 = r(mean);
qui replace `prop_change' = `mu1'/`mu2'*100 if (`incpar'==`j') & (`hgroup'==`gr') ; 

qui sum `pr1'  [aw=`sw'] if (`incpar'==`j') & (`hgroup'==`gr'), meanonly;      local mu1 = r(mean);
qui sum `pr2' [aw=`sw']  if (`incpar'==`j') & (`hgroup'==`gr'), meanonly;      local mu2 = r(mean);
qui replace `prdif' = `pr2'-`pr1'            ; 
qui replace `dif' = `mu2'-`mu1'            if (`incpar'==`j') & (`hgroup'==`gr') ; 
qui replace `prop_ch' = `dif'/`mu1'*100    if (`incpar'==`j') & (`hgroup'==`gr') ; 

};
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


forvalues i=1/$indicagm {;
local k = gm1[`i'];
if ( "`grlabm`i''" == "") local grlabm`i' = "Group_`k'";
qui sum `pr1'  [aw=`sw'] if  `disgr'==`k' , meanonly;      local mu1 = r(mean);
qui sum `pr2'  [aw=`sw']  if  `disgr'==`k' , meanonly;      local mu2 = r(mean);         
qui replace `dif' = `mu2'-`mu1'        if   `disgr'==`k' ; 
qui replace `prop_ch' = `dif'/`mu1'*100  if  `disgr'==`k'  ; 

qui sum `vchangea'  [aw=`sw']    if  `disgr'==`k' ,   meanonly;        local mu1 = r(mean);
if ("`price'" ~= "" & "`pchange'" ~= "" )  qui sum `pchange'  [aw=`sw']    if  `disgr'==`k' ,   meanonly;        local mu1 = r(mean);
qui sum `welfare'   [aw=`sw']    if  `disgr'==`k' ,   meanonly;        local mu2 = r(mean);
                                          qui replace `prop_change' = `mu1'/`mu2'*100  if  `disgr'==`k' ; 
if ("`price'" ~= "" & "`pchange'" ~= "" ) qui replace `prop_change' = `mu1'*100  if  `disgr'==`k' ;
};

qui sum `vchangea'  [aw=`sw']  ,   meanonly;        local mu1 = r(mean);
qui sum `welfare'   [aw=`sw']  ,   meanonly;        local mu2 = r(mean);
local prop_pop = `mu1'/`mu2'*100;
if ("`price'" ~= "" & "`pchange'" ~= "" ) local prop_pop = `mu1'*100;

/* mcjobstat command estimates the averages of the variables by groups (_fgroup) */
/* the rest of the code is to use the returned matrix of the mcjobstat command to display and save the results */
qui mcjobstat `prop_change' `elap' `1' `pr1' `pr2'  `dif' `prop_ch',   hsize(`hsize') hgroup(`disgr') lan(`lan')    stat(exp_pc) tpop(1) ;
tempname  mat00 ; 
matrix `mat00'= e(est);

local nc = colsof(`mat00') -1;
local nr = rowsof(`mat00');
matrix `mat00'[`nr', 1] = `prop_pop' ;
matrix `mat00'[`nr', 6] = `mat00'[`nr', 5]-`mat00'[`nr', 4]    ;
matrix `mat00'[`nr', 7] = `mat00'[`nr', 6]/`mat00'[`nr', 4]*100 ;


if `nr' == 2 local nr = 1;
tabtitmc 00; 
local tabtit = "`r(tabtit)'";
matrix aaa= `mat00'[1..`nr', 1..`nc'] ;

if `nr' == 1 matrix rownames aaa = "Population" ;

local compo welfare;
if "`price'" ~= ""   local compo price ;

local Compo welfare;
if "`price'" ~= ""   local Compo Price ;
if ("`expshare'"~="") & "`price'" == ""  local isinf  = "(adjusted by share)" ;

tempvar coltit1 coltit2 coltit3;
qui gen     `coltit1' = ""; qui gen     `coltit2' = ""; qui gen     `coltit3' = "";
qui replace `coltit1' = "[1] Proportion of  "  in 1 ; 
qui replace `coltit2' = "     change in `compo'    "           in 1 ;  
qui replace `coltit3' = "    `isinf' (in %)  "     in 1 ;

qui replace `coltit1' = "[2] `Compo'        "  in 2 ; qui replace `coltit2' = "      Elasticity  "           in 2 ; 

qui replace `coltit1' = "[3] Observed         " 			in 3 ; 
qui replace `coltit2' = "     proportion of   " 			in 3 ;
qui replace `coltit3' = "     consumers/users " 			in 3 ;

qui replace `coltit1' = "[4] Predicted          "      in 4 ;
qui replace `coltit2' = "     probability with  "      in 4 ;
qui replace `coltit3' = "     initial `compo'(s)"      in 4 ;

qui replace `coltit1' = "[5] Predicted           "      in 5 ;
qui replace `coltit2' = "     probability with   "      in 5 ;
qui replace `coltit3' = "     final `compo'(s)   "       in 5 ;


qui replace `coltit1' = "[6] Absolute change" 		        in 6 ;
qui replace `coltit2' = "    in probability " 		        in 6 ;
qui replace `coltit3' = "    ([5] - [4])    " 		         in 6 ;

qui replace `coltit1' = "[7] Relative change      " 		        in 7 ;
qui replace `coltit2' = "    in probability (in %)" 		in 7 ;
qui replace `coltit3' = "    ([6]/[4])*100        " 		in 7 ;

matrix colnames aaa = "[1] Prop. if change in `compo' (in %)" " [2] `Compo' Elasticity" "[3] Obs. prop. of consumers" " [4] Predicted  prob. (intial values)" " [5] Predicted  prob. (final values)" " [6] Absolute change" "[7] Relative change in (%)" ;
dis _n as result  "Table 02: Estimated impact on the proportions of consummers (Predictions with the model `um')" ;
if `nr' == 1  distable2 aaa, dec(`dec') atit(`langr')	head1(`r(tabtit)')  head2(`head2') coltit1(`coltit1')  coltit2(`coltit2')  coltit3(`coltit3');
if `nr' > 1   distable  aaa, dec(`dec') atit(`langr')	head1(`r(tabtit)')  head2(`head2') coltit1(`coltit1')  coltit2(`coltit2')  coltit3(`coltit3');
dis as result "Notes:";
dis as text  " [1]: Estimated based on averages of the population/groups." ;
dis " [2]: Estimated based on the reference individual (at means of X covariates)." ;
dis " [3]: Estimated based on population/groups." ;
dis " [4]: Based on predicted individual -househcurrent- probabilities with  initial  `compo's." ;
dis " [5]: Based on predicted individual -househcurrent- probabilities with  final  `compo's."  ;
dis " [6]: Based on [4] and [5] Statistics." ;
dis " [7]: Based on [4] and [6] Statistics." ; 



/*****/
/* Expenditure regression */
/*
set trace on ;
set tracedepth 1;
*/



if  ("`xfil'" ~= "") {;

xml_tab `models',  format(sclb0 ncrr3 nccr3) stats(N pr2) ///
save(`xfil') replace  ///
cblanks(2) cwidth(0 220, 3 4)  font("Cambria" 10)   ///
sheet(Table_01,  nogridlines)  ///
lines(_cons 2 LAST_ROW 13 COL_NAMES 2 EST_NAMES 2) ///
title("Table 01: Estimates of probability of consumption model(s)")
;

matrix taaa = aaa' ;

qui xml_tab taaa,  format(sclb0 nccr`dec' nccr`dec' nccr`dec' nccr`dec' nccr`dec' nccr`dec' nccr`dec' nccr`dec') save(`xfil')    cwidth(0 210,1 90, 2 90, 3 90, 4 90, 5 90, 6 90, 7 90, . 90) font("Cambria" 10)  ///
sheet(Table_02,  nogridlines)  ///
lines(0 2 COL_NAMES 2 LAST_ROW 13)  ///
title("Table 02: Estimated impact on the proportions of consummer")  
notes(
0 Notes: ,
0 [1]: Estimated based on averages of the population/groups. ,
0 [2]: Estimated based on the reference individual (at means of X covariates)., 
0 [3]: Estimated based on population/groups. ,
0 [4]: Based on predicted individual -househcurrent- probabilities with  initial  `compo's., 
0 [5]: Based on predicted individual -househcurrent- probabilities with  final  `compo's., 
0 [6]: Based on [4] and [5] Statistics., 
0 [7]: Based on [4] and [6] Statistics.
)
newappend;

};


tempvar type_consumer;	
/* Create the 3 types of consumers (Never consume / Already consume / New consumer) */
 qui   qui gen      `type_consumer'  = 0;
 qui   replace      `type_consumer'  = 1 if `1'==1;

 lab define l`type_consumer' 0 "No entrant" 1 "Current user" 2 "New user";
 lab val `type_consumer' l`type_consumer';
 qui sum `sw';
 local ss1 = r(sum);
 qui sum `sw' if  `type_consumer' ==1;
 local ss2 = r(sum); 
 local newprop =  el(aaa, `nr', 6); 
 set seed 6543456 ;
 tempvar random ;
 qui gen double `random' = uniform()*`pr1'*`sw' ;
 qui replace `random' = 0  if  `type_consumer' == 1 ;
 tempvar tkey ;
 qui gen `tkey' = _n ;
 forvalues g=1/$indicagm {;
local grm`g' = gm1[`g'];
 };
 tempvar negran ;
 qui gen `negran' = -`random';
 sort `type_consumer' `disgr'  `random' , stable ;
 tempvar   tpsum ;
 /*set trace on ;*/

 forvalues g=1/$indicagm {;
local gr = `grm`g'';
 qui sum `sw' if (`disgr'==`gr') ;
 local ss1 = r(sum); 
  local newprop =  el(aaa, `g', 6); 
  /*dis `g' " : " `gr' " : "`nr' "  : "`newprop' ; */
cap drop `tpsum' ;
tempvar tpsum ;
 qui gen   double   `tpsum' = sum(`sw'*(`type_consumer'!=1)*(`disgr'==`gr'))  if (`disgr'==`gr') ;
   qui       replace  `tpsum' = `ss1'*1.001 if  `type_consumer' ==1  & (`disgr'==`gr') ; 
   qui       replace  `type_consumer' =  2 if (`tpsum' <= `newprop'*`ss1'*1.001) & (`disgr'==`gr') ;
 
  /*dis `g' " : " `gr' " : "`nr' "  : "`newprop' ; */
};



 sort `tkey'  ;


tempvar pred_exp;

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
qui gen `pred_exp' =  `nomi'/`denomi' ;
qui gen  pred_exp  = `pred_exp' ;
qui replace pred_exp = `2' if `1' == 1 ;
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
qui gen `pred_exp' = _outcome_hd ;
qui gen  pred_exp  = `pred_exp' ;
qui replace pred_exp = `2' if `1' == 1;

};




/*
if (`expmod' == 2) {;
/*set trace on;*/ 
cap drop _orkey ;
sort `grmod1' `grmod2', stable;
by   `grmod1' `grmod2'  , sort : egen float _orkey = rank(_n);
stabsam hasmobile pc_exp_mob , grclus(`grmod1' `grmod2') ;
merge 1:1 `grmod1' `grmod2' _orkey using myInpd.dta, nogen;
qui gen        `pred_exp' =  _`2'  if `1' == 0 ;
qui replace    `pred_exp' =   `2'  if `1' == 1 ;
qui gen     pred_exp  = `pred_exp' ;
cap erase myInpd.dta;
cap drop _orkey ;
};

*/

if (`expmod'  == 3 | `expmod'  == 4) {;
qui gen `pred_exp' =  . ;
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
qui replace `pred_exp' = `mytmp'  if `grmod1' == `l' & `grmod2' == `m' ;
qui replace `res'      = `res'    if `grmod1' == `l' & `grmod2' == `m' ;

};
};

if `fex' == 2 qui replace `pred_exp' = exp(`pred_exp') ;
qui gen    pred_exp  = `pred_exp' ;
qui replace pred_exp = `2' if `1' == 1;

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
qui replace `pred_exp' = `mytmp'  if `grmod1' == `l' & `grmod2' == `m' ;
qui replace `res'      = `res'  if `grmod1' == `l' & `grmod2' == `m' ;
};
};
tempvar  pred_exp0 ;
qui gen `pred_exp0' =`pred_exp' ;
if `fex' == 2 qui replace `pred_exp' = exp(`pred_exp0') ;

cap drop _ID;
cap drop _merge;
cap drop _res* ;
qui gen _ID=_n ;
tempfile mydata;
qui gen _rsa = `res';
qui gen _prd = `pred_exp0' ;
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
qui replace `pred_exp0' = _prd + _rs_hd  if `1' == 0  ;
if `fex' == 2 qui replace `pred_exp' = exp(`pred_exp0') ;
qui gen pred_exp = `pred_exp';
qui gen tag1 = pred_exp<0 & `1' == 0;
//bysort `1':  sum pred_exp  ;
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
qui replace _rs_hd =  pred_exp if tag1 != 1 & `1'==1;
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
              qui replace `pred_exp0' = _prd + _rs_hd                  if tag1 == 1  ;
if `fex' == 1 qui replace  pred_exp    = `pred_exp0'                    if tag1 == 1  ;
if `fex' == 2 & `condi' == 0 qui replace pred_exp    = exp(`pred_exp0')               if tag1 == 1  ;

sum pred_exp if tag1 == 1;
qui replace tag1 = pred_exp<0 ;
cap drop _merge;
qui save `mydata', replace;
qui sum tag1 ;
local toma = r(sum);
};
//bysort `1':  sum pred_exp  ;

qui replace pred_exp = `2' if `1' == 1;

};


/*
dis _n "Table 03: Estimates of the expenditures model" ;
esttab modexp, not r2    mtitle("(Model 01)" ) nodepvars nonumbers b(`dec') varwidth(34) label;
*/
};



/** new **/


if (`expmod'  == 5 | `expmod'  == 6) {;
qui gen `pred_exp' =  . ;
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
if `nquantile'>= 2 qui xtile __grq = `welfare' [aw=`sw']  if  `grmod1' == `l' & `grmod2' == `m' , nquantiles(`nquantile');
if `nquantile'== 1 qui xtile __grq = 1;
forvalues q=1/`nquantile' {;
local tq = `q'/`nquantile'-0.5*1/`nquantile';
dis "Percentile " %8.5f `tq' ":";
gepwe `welfare'  if  `grmod1' == `l' & `grmod2' == `m' , nper(1) per1(`tq');
`disreg' xi:  `stpe' regress `model_expend' `cindcon'  [pw=_pcw] if `grmod1' == `l' & `grmod2' == `m'  , `oopt' ;
cap drop `mytmp' ;
tempvar mytmp ;
qui predict `mytmp' , xb;
qui replace `pred_exp' = `mytmp'  if `grmod1' == `l' & `grmod2' == `m' & __grq == `q' ;
qui replace `res'      = `res'    if `grmod1' == `l' & `grmod2' == `m'  & __grq == `q' ;
};
};
};

if `fex' == 2 qui replace `pred_exp' = exp(`pred_exp') ;
qui gen    pred_exp  = `pred_exp' ;
qui replace pred_exp = `2' if `1' == 1;

};

//set trace on ;
if (`expmod'  == 6 )   {;
foreach l of local gr1 {;
foreach m of local gr2 {;
cap drop __grq;
if `nquantile'>= 2  qui xtile __grq = `welfare' [aw=`sw'] , nquantiles(`nquantile');
if `nquantile'== 1  qui xtile __grq = 1; 
forvalues q=1/`nquantile' {;
local tq = `q'/`nquantile'-0.5*1/`nquantile';
dis "Percentile " %8.5f `tq' ":";
gepwe `welfare'  if `grmod1' == `l' & `grmod2' == `m' , nper(1) per1(`tq');
`disreg' xi:  `stpe' regress `model_expend' `cindcon'  [pw=_pcw] if `grmod1' == `l' & `grmod2' == `m'  , `oopt' ;
cap drop `mytmp' ;
tempvar mytmp ;
cap drop `res' ;
tempvar res ;
qui predict `res' , res;
qui predict `mytmp' , xb;
qui replace `pred_exp' = `mytmp'  if `grmod1' == `l' & `grmod2' == `m' & __grq == `q' ;
qui replace `res'      = `res'  if `grmod1' == `l' & `grmod2' == `m' & __grq == `q' ;
};
};
};
tempvar  pred_exp0 ;
qui gen `pred_exp0' =`pred_exp' ;
if `fex' == 2 qui replace `pred_exp' = exp(`pred_exp0') ;

cap drop _ID;
cap drop _merge;
cap drop _res* ;
qui gen _ID=_n ;
tempfile mydata;
qui gen _rsa = `res';
qui gen _prd = `pred_exp0' ;
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
qui replace `pred_exp0' = _prd + _rs_hd  if `1' == 0  ;
if `fex' == 2 qui replace `pred_exp' = exp(`pred_exp0') ;
qui gen pred_exp = `pred_exp';
qui gen tag1 = pred_exp<0 & `1' == 0;
//bysort `1':  sum pred_exp  ;
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
qui replace _rs_hd =  pred_exp if tag1 != 1 & `1'==1;
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
              qui replace `pred_exp0' = _prd + _rs_hd                  if tag1 == 1  ;
if `fex' == 1 qui replace pred_exp    = `pred_exp0'                    if tag1 == 1  ;
if `fex' == 2 & `condi' == 0 qui replace pred_exp    = exp(`pred_exp0')               if tag1 == 1  ;

sum pred_exp if tag1 == 1;
qui replace tag1 = pred_exp<0 ;
cap drop _merge;
qui save `mydata', replace;
qui sum tag1 ;
local toma = r(sum);
};
//bysort `1':  sum pred_exp  ;

qui replace pred_exp = `2' if `1' == 1;

};





/*
dis _n "Table 03: Estimates of the expenditures model" ;
esttab modexp, not r2    mtitle("(Model 01)" ) nodepvars nonumbers b(`dec') varwidth(34) label;
*/
};
/** new **/


cap drop __grq;
cap drop _pcw ;
qui replace `pred_exp' =  pred_exp ;

tempvar _fexpen benif tbenifo   ;
qui      gen `_fexpen' = `pred_exp' if `1' == 0; 
qui replace  `_fexpen' = `2'        if `1' == 1; 

qui gen `benif  ' = -`_fexpen' * `pchange'  ;
qui gen `tbenifo' = -`2' * `pchange'*(`1'==1)  ;

tempvar res0 ;
qui gen `res0' = "";
forvalues i=1/9 {;
tempvar res`i' ;
qui gen `res`i'' = 0;
};



/*
NEW
*/


 





if ("`disgr'" ~= "") {;
qui tabulate  `disgr', matrow(gm);
global indicagm=r(r);
cap drop gm1;
qui svmat int gm;

tempvar  munbenif;
qui gen `munbenif' = 0;

forvalues i=1/$indicagm {;
local k = gm1[`i'];

qui sum `prdif' [aw=`sw']   if  `disgr'==`k' ;
local prob = r(mean);

qui sum `benif' [aw=`sw']                  if  `disgr'==`k' & `1' == 0 ;
qui replace `munbenif' = r(mean)*`prob' if  `disgr'==`k'  ;
};

forvalues i=1/$indicagm {;

local k = gm1[`i'];
if ( "`grlabm`i''" == "") local grlabm`i' = "Group_`k'";
local sgrlabm`i' = "`hgroup'_`k'" ;
if "`grlabm`i''"  == "" local grlabm`i' = "`hgroup'_`k'" ;
local tmps =  subinstr("`grlabm`i''", " ", "_", .);
if  "`tmps'"  ~= "" local grlabm`i' = "`tmps'" ;
qui replace `res0' = "`grlabm`i''" in `i';

qui sum `2' [aw=`sw'] if  `disgr'==`k' & `1' == 1 ;
qui replace `res1' = r(mean) in `i';

qui sum `pred_exp' [aw=`sw'] if  `disgr'==`k' & `1' == 0 ;
qui replace `res2' = r(mean) in `i';

qui sum `1' [aw=`sw']  if `disgr'==`k'  ;
qui replace `res3' = r(mean)*100 in `i';


qui sum `prdif' [aw=`sw']   if  `disgr'==`k' ;
qui replace `res4' = r(mean)*100 in `i';


qui sum `benif' [aw=`sw'] if  `disgr'==`k' & `1' == 1 ;
qui replace `res5' = r(mean) in `i';

qui sum `benif' [aw=`sw'] if  `disgr'==`k' & `1' == 0 ;
qui replace `res6' = r(mean) in `i';

qui sum `tbenifo' [aw=`sw'] if  `disgr'==`k' ;
qui replace `res7' = r(mean) in `i';

qui sum `munbenif' [aw=`sw'] if  `disgr'==`k' ;
qui replace `res8' =   r(mean) in `i';

qui replace `res9' = `res7'[`i'] + `res8'[`i'] in `i';

};
};


if ("`disgr'" == "") global indicagm = 0;
global indicagm1 = $indicagm +1;
local i = $indicagm1 ;

qui replace `res0' = "Population" in `i';

qui sum `2' [aw=`sw'] if   `1' == 1 ;
qui replace `res1' = r(mean) in `i';

qui sum `pred_exp' [aw=`sw'] if   `1' == 0 ;
qui replace `res2' = r(mean) in `i';

qui sum `1' [aw=`sw'] ;
qui replace `res3' = r(mean)*100 in `i';

qui sum `prdif' [aw=`sw']    ;
qui replace `res4' = r(mean)*100 in `i';

qui sum `benif' [aw=`sw'] if  `1' == 1 ;
qui replace `res5' = r(mean) in `i';

qui sum `benif' [aw=`sw'] if  `1' == 0 ;
qui replace `res6' = r(mean) in `i';

qui sum `tbenifo' [aw=`sw']  ;
qui replace `res7' = r(mean) in `i';

qui sum `munbenif' [aw=`sw']  ;
qui replace `res8' =   r(mean) in `i';

qui replace `res9' = `res7'[`i'] + `res8'[`i'] in `i';

tempname resmat4t resmat4 ;
qui mkmat `res1' `res2' `res3' `res4' `res5' `res6' `res7' `res8' `res9' in 1/$indicagm1 , matrix(`resmat4t') rownames(`res0');
matrix `resmat4' = `resmat4t'';


matrix rownames `resmat4' = 
"[1] Expenditures (current users)" 
"[2] Predicted expend. (new users)" 
"[3] Proportion of current users"
"[4] Proportion of new users"
"[5] Imp. on well. current_users" 
"[6] Imp. on well. new_users" 
"[7] Imp. on well. with current" 
"[8] Imp. on well. with new" 
"[9] Imp. on well. with all" 
;



dis _n as result "Table 03: Estimated impact on well-being" ;
   tempname table;
        .`table'  = ._tab.new, col(10);
        .`table'.width |30|16 16 | 16 16 | 16 16 || 20 20 | 23|;
        .`table'.strcolor . . .  yellow . . . . . .;
        .`table'.numcolor yellow yellow yellow . yellow yellow yellow yellow  yellow yellow ;
        .`table'.numfmt %16.0g  %16.`dec'f  %16.`dec'f  %16.`dec'f %16.`dec'f %16.`dec'f  %16.`dec'f %20.`dec'f %20.`dec'f %23.`dec'f;
        .`table'.sep, top;
        .`table'.titles "Group  " "[1] Expenditures " "[2] Predicted "   "[3] Proportion "   "[4] Proportion "  "[5] Impact on "  "[6] Impact on  "     "[7] Impact on        "   "[8] Impact on  "    "[9] Impact on  "     ;
	    .`table'.titles "      " "(current users)" "expenditures" "of current users"   "of new users"  "well-being"  "well-being"   "well-being with"          "well-being with"   "    well-being with  "  ;
        .`table'.titles "  " "  " "(new users)" "in (%)"   "in (%)"  "(current users)"  "(new users) "  "current users"   "new users"  "all users"  ;
        .`table'.sep, mid;
        local nalt = "ddd";
       if $indicagm !=1 {;
	   forvalues i=1/$indicagm {;
		.`table'.row `res0'[`i']  `res1'[`i']  `res2'[`i']  `res3'[`i']  `res4'[`i']  `res5'[`i']  `res6'[`i']  `res7'[`i'] `res8'[`i'] `res9'[`i'];
		 };
local i = $indicagm1;		 
if $indicagm!=0 .`table'.sep, mid;
	   };
.`table'.row `res0'[`i']  `res1'[`i']  `res2'[`i']  `res3'[`i']  `res4'[`i']  `res5'[`i']  `res6'[`i']  `res7'[`i'] `res8'[`i'] `res9'[`i'];
.`table'.sep,bot;

dis as result "Notes:";
dis as text  " [1]: Estimated based on average expenditures of current consumers by population/groups." ;
dis " [2]: Estimated based on average usage (expenditures>0) by population/groups." ;
dis " [3]: Estimated based on average predicted expenditures of the new consumers by population/groups." ;
dis " [4]: Estimated based on the predicted expected change in proportion of consumers by population/groups." ;
dis " [5]: Estimated average impact on well-being of the current consumers by population/groups." ;
dis " [6]: Estimated average impact on well-being of the new consumers by population/groups." ;
dis " [7]: ([3]/100)*[5]." ;
dis " [8]: ([4]/100)*[6] // For the population, the statistic is based on the case where we assign the expected group's benefit to each entrant." ; 
dis " [9]: [7] + [8]." ; 

cap ereturn matrix est2 = aaa;


/*****/
/* Saving results in the excel file */ 
if  ("`xfil'" ~= "") {;
/*
if  (`expmod'  == 2) {;
qui xml_tab modexp,  format(sclb0 ncrr3 nccr3) stats(N r2) ///
save(`xfil') append  ///
cblanks(2) cwidth(0 220, 3 4) font("Cambria" 10)  ///
sheet(Table_03,  nogridlines)  ///
lines(_cons 2 LAST_ROW 13 COL_NAMES 2 EST_NAMES 2) ///
title("Table 03: Estimates of the expenditures model");
};
*/



local ngr = colsof(`resmat4') ;
tempname resmat4t;
matrix `resmat4t' = `resmat4'';

cap matrix drop aaa;
if `nr' != 1 matrix aaa= `resmat4t'[1..`nr', 1..9] ;
if `nr' == 1 matrix aaa= `resmat4t'[2..2, 1..9] ;
local dec = 2 ;
local lst1 = rowsof(aaa)-1;
if `lst1'==1 local lst1 =="";

qui xml_taba2 aaa,  format(sclb0 nccr`dec' nccr`dec' nccr`dec' nccr`dec' nccr`dec' nccr`dec' nccr`dec' nccr`dec' nccr`dec') ///
save(`xfil')    cwidth(0 220, . 60) font("Cambria" 10) ///
sheet(Table_03,  nogridlines)  ///
lines(-1 13 0 2  `lst1'  2  LAST_ROW 13)     ///
title("Table 03: Estimated impact on well-being")  
notes(
0 Notes: ,
0 [1]: Estimated based on average expenditures of current consumers by population/groups. ,
0 [2]: Estimated based on average usage (expenditures>0) by population/groups. ,
0 [3]: Estimated based on average predicted expenditures of the new consumers by population/groups. ,
0 [4]: Estimated based on the predicted expected change in proportion of consumers by population/groups. ,
0 [5]: Estimated average impact on well-being of the current consumers by population/groups. ,
0 [6]: Estimated average impact on well-being of the new consumers by population/groups. ,
0 [7]: ([3]/100)*[5]. ,
0 [8]: ([4]/100)*[6] - For the population, the statistic is based on the case where we assign the expected group's benefit to each entrant. ,
0 [9]: [7] + [8].
)
newappend;

};
ereturn matrix  est3 = `resmat4t';


/* Poverty change*/

tempvar wel1 wel2 benifa  benifa1  benifa2;
qui gen `wel1'    = `welfare' ;
qui gen `benifa'  = -`_fexpen'* `pchange'*(`type_consumer'==2)  -`2' * `pchange'*(`type_consumer'==1) ; 
qui gen `benifa1'  =  `ichange'*(`type_consumer'==1) ; 
qui gen `benifa2'  =  -`_fexpen'* `pchange'*(`type_consumer'==2) ; 

 forvalues g=1/$indicagm {;
qui  sum `benifa2' [aw=`sw'] if (`disgr'==`grm`g'');
if `r(mean)'!=0   qui  replace `benifa2' = `benifa2'*el(aaa,`g', 8 )/`r(mean)' if (`disgr'==`grm`g'') ;
if `r(mean)'==0   qui  replace `benifa2' = 0                                   if (`disgr'==`grm`g'') ;
/*dis `g' " " `grm`g'' " "`r(mean)' " "  el(aaa,`g', 8 ); */
 };
qui replace `benifa1' = 0 if `benifa1' ==. ; 
qui replace `benifa2' = 0 if `benifa2' ==. ; 
qui mcjobpov `benifa1' `benifa2',    hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(total)  pcexp(`welfare') alpha(0)  pline(`pline') move(-1);
tempname mat1;
matrix `mat1' = e(est); 
matrix rownames `mat1' = "Initial/Concentrated Market" "With benefits of current users" "With benefits of new users" "Final" ;
local tabtit = "Table 04: Poverty headcount & market power"; 
distable `mat1', dec(4) atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
mk_xtab_mc `welfare' ,  matn(`mat1') dec(4) xfil(`xfil') xshe(Table_04) xtit(`tabtit') xlan(`lan') dste(0) 
;

qui mcjobpov `benifa1' `benifa2',    hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(total)  pcexp(`welfare') alpha(1)  pline(`pline') move(-1);
tempname mat1;
matrix `mat1' = e(est); 
matrix rownames `mat1' = "Initial/Concentrated Market" "With benefits of current users" "With benefits of new users" "Final" ;
local tabtit = "Table 05: Poverty gap & market power"; 
distable `mat1', dec(4) atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
mk_xtab_mc `welfare' ,  matn(`mat1') dec(4) xfil(`xfil') xshe(Table_05) xtit(`tabtit') xlan(`lan') dste(0) 
;



qui mcjobgini `benifa1' `benifa2',    hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(total)  pcexp(`welfare')  move(-1);
tempname mat1;
matrix `mat1' = e(est); 
matrix rownames `mat1' = "Initial/Concentrated Market" "With benefits of current users" "With benefits of new users" "Final" ;
local tabtit = "Table 06: Gini index & market power"; 
distable `mat1', dec(4) atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
mk_xtab_mc `welfare' ,  matn(`mat1') dec(4) xfil(`xfil') xshe(Table_06) xtit(`tabtit') xlan(`lan') dste(0) 
;


/* to display automatically the excel file */
if  ("`xfil'" ~= "") {;
di as txt `"(output written to {browse `xfil'})"' ; 
};
cap drop  _fgroup; 

cap drop _benefit ;
gen _benefit = `benifa1'+`benifa2';
cap drop _type_consumer ;
gen _type_consumer = `type_consumer';
tempname mydata;
qui keep _key _benefit _type_consumer;
qui save `mydata' , replace ;
restore;
cap drop _benefit;
cap drop _type_consumer ;
qui merge 1:1 _key using  `mydata' , nogen ;
cap drop _key ;
end;

