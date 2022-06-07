/*************************************************************************/
/* WELCOM: Price change and well-being      (Version 1.0)                */
/*************************************************************************/
/* Conceived by Dr. Araar Abdelkrim                                      */
/* 									                                     */ 
/* [1] email : aabd@ecn.ulaval.ca                                        */
/* [1] Phone : 1 418 656 7507                                            */
/*************************************************************************/




#delimit ;
capture program drop prcwel_ind;
program define prcwel_ind, rclass sortpreserve;
version 9.2;
syntax varlist(min=1 max=1)[ ,   
HSize(varname) 
PLINE(varname)
ITNAMES(varname)
SNAMES(varname)
PRC(varname)
ELAS(varname)
OINF(int 1)
HGroup(varname) 
NITEMS(int 1)
XFIL(string)
LAN(string)
TAGGRegate(string)
MEAS(int 1)
MODEL(int 1)
SUBS(real 0.6)
MATPEL(string)
MATIEL(string)
SOTM(int 1)
EPSILON(real 0.5)
THETA(real 0)
INISave(string) 
TJOBS(string)
GVIMP(int 0) 
GTITLE(string)
IT1(string) IT2(string)  IT3(string)  IT4(string) IT5(string)  
IT6(string) IT7(string)  IT8(string)  IT9(string) IT10(string)

IOMATRIX(string)

IOMODEL(int 1)
TYSHOCK(int 1)
ADSHOCK(int 1)
NADP(int 1)

NSHOCKS(int 1)
SHOCK1(string)
SHOCK2(string)
SHOCK3(string)
SHOCK4(string)
SHOCK5(string)
SHOCK6(string)

INITEMS(int 10)
IITNAMES(varname)
ISNAMES(varname)
MATCH(varname)
IELAS(varname)

];

local all_vars `varlist' `hsize' `pline' `hgroup' ;

 if ("`inisave'" ~="") {;
  asdbsave_prw_ind `0' ;
  };

	qui svyset ;
	if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);

	if ("`inisave'" ~="" ) {;
	tokenize "`inisave'" ,  parse(".");
	local inisave = "`1'";
	};
 



local move = 1;
	
	tokenize `varlist';
	tempvar exp_pc;
	local varna = "`1'";
	qui gen `exp_pc'=`1';
	cap drop if `1'==.;
	local nexp_pc="`1'";
    if ("`lan'" =="") local lan = "en";


	
if ( `oinf' ==1 ) {;
local mylist sn it prc elas;
forvalues i=1/`nitems' {;
extend_opt_item_pr test , `it`i'' ;
foreach name of local mylist {;
local `name'`i'  `r(`name')';
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};	




cap drop __VNITEMS ; 
qui gen  __VNITEMS = "";

cap drop __SLITEMS ; 
qui gen  __SLITEMS = "";

cap drop __IPRC  ; 
qui  gen __IPRC = "";

cap drop __ELAS  ; 
qui  gen __ELAS = "";


forvalues i=1/`nitems' {;

if ("`it`i''" ~= "" ) qui replace __VNITEMS =  "`it`i''"  in `i' ;
if ("`ms`i''" ~= "" ) qui replace __MS =  "`ms`i''"  in `i' ;

if ("`sn`i''" == "" ) local sn`i' = "`it`i''" ;
if ("`sn`i''" ~= "" ) qui replace __SLITEMS =  "`sn`i''"  in `i' ;

if ("`prc`i''" ~= "" ) qui replace __IPRC = "`prc`i''" in `i' ;
if ("`prc`i''" == "" ) qui replace __IPRC = 0          in `i' ;

if ("`elas`i''" ~= "" ) qui replace __ELAS = "`elas`i''" in `i' ;
if ("`elas`i''" == "" ) qui replace __ELAS = ""           in `i' ;

cap drop _pr_`i';
qui gen  _pr_`i' = `prc`i'';

cap drop _elas`i';
qui gen  _elas`i' = 0 ;
if "`elas`i''"~="" qui replace  _elas`i' = `elas`i'';
local all_vars `all_vars' `it`i'' `prc`i'' `elas`i'' ;
};


	
tempvar ipsch fpsch;

di _n as text in white "{col 5}***************************General information on I/O matrix*************************";
forvalues i=1/6 {;
if "`pr`i''"=="" local pr`i' = 10;
if "`secp`i''"=="" local secp`i' = `i';
};
forvalues i=1/6 {;
local pr`i' = `pr`i''/100;
};

local mylist secp pr;
forvalues i=1/6 {;
if ("`shock`i''"~="") {;
extend_opt_shocks test , `shock`i'' ;
foreach name of local mylist {;
local `name'`i' = r(`name');
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};
};

pciomf_ind `varlist' , 
iom(`iomatrix')
vnmatch(`match')
secp1(`secp1')
pr1(`pr1')
secp2(`secp2')
pr2(`pr2')
secp3(`secp3')
pr3(`pr3')
secp4(`secp4')
pr4(`pr4')
secp5(`secp5')
pr5(`pr5')
secp6(`secp6')
pr6(`pr6')
nshocks(`nshocks')
nitems(`initems')
iomodel(`iomodel')
tyshock(`tyshock')
adshock(`adshock')
nadp(`nadp')
;



cap matrix drop RESA;
matrix RESA=e(PRCG);


                     local mylabel = "`isnames'" ;
if "`mylabel'" == "" local mylabel = "`iitnames'" ; 

qui svmat  RESA, names(_PRC_GOOD);
local tmp = rowsof(RESA);
qui mkmat _PRC_GOOD1 in 1/`tmp', matrix(RESATEM) rownames(`mylabel');
matrix RESA = RESATEM;
cap matrix drop RESATEM;
matrix colnames RESA = "Price changes (in %)" ;


cap drop __impwell_ind;
qui gen __impwell_ind = 0 ;
forvalues i=1/`initems' {;
local var = ""+`iitnames'[`i'] ; 
qui replace __impwell_ind = __impwell_ind - _PRC_GOOD1[`i']/100*`var' ;
};
/*
cap drop _PRC;
*/
cap drop __MS;


local nscen=1;
local vnitems = "__VNITEMS"  ; 
local slitems = "__SLITEMS" ;
local prc = "__PRC"; 
local elas = "__ELAS"; 
};


if (`oinf'==2) {;
local vnitems = "`itnames'"  ; 
local slitems = "`snames'"  ;
if "`snames'"=="" local  slitems = "`itnames'"  ;

forvalues i=1/`nitems' {;
cap drop  _pr_`i' ;
local tmp  = `prc'[`i'] ;
local tmpe  = `elas'[`i'] ;
local tmp2 = `itnames'[`i'] ;
qui gen   _pr_`i' = `tmp';
qui gen   _elas`i' = 0;
if "`tmpe'"~= "" qui replace _elas`i' = `tmpe';
local all_vars `all_vars' `tmp2' `tmp' `tmpe';
};
};

if ("`lan'" == "") local lan = "en";
if ("`tjobs'" == ""  & "`tjobs'"~="off")  local tjobs 10 11 12 21 22 23 31 32 33  41 42 43 44 51 52 53 61 62 63 64;
/*if ("`gjobs'" == ""  & "`gjobs'"~="off" ) local gjobs 1 3 4 8 9 10;*/



local vlist;
local slist;
preserve;
qui  cap drop if `vnitems'=="";
qui count;

forvalues i=1/`r(N)' {;
local tmp = ""+`vnitems'[`i'];
if `i' == 1 local tmp2 = "  "+`slitems'[`i'];
if `i' != 1 local tmp2 = " |"+`slitems'[`i'];
if ("`slitems'"~="") {;
local vlist `vlist' `tmp';
local impvlist `impvlist' __impwell_`tmp';
local slist `slist' `tmp2';
local impslist `impslist' `tmp2';
};

};
local impvlist1 `impvlist' __impwell_ind ;
local tmp2 = " |"+"Indirect Effect "; 
local impslist1 `impslist' `tmp2';
local tmp2 = " |"+"Indirect Effect | Total Effect"; 
local impvlist `impvlist' __impwell_ind __impwell_total;
local impslist `impslist' `tmp2' ;
restore;


tokenize "`tjobs'";
quietly {;
local k = -1;
if "`exp_pc'" ~= "" {;
local k = 1;
mac shift;
};
while "``k''" ~= "" {; 
local k = `k'+1;
};
};
if (`k'==-1) local k = 0;
tokenize "`tjobs'";
forvalues i=1/`k' {;
local tjob`i' = "``i''";
};
local ntables = `k';
tokenize "`gjobs'";
quietly {;
local k = -1;
if "`exp_pc'" ~= "" {;
local k = 1;
mac shift;
};
while "``k''" ~= "" {; 
local k = `k'+1;
};
};
if (`k'==-1) local k = 0;
tokenize "`gjobs'";
forvalues i=1/`k' {;
local gjob`i' = "``i''";

};
local ngraphs = `k';


tokenize `varlist';



local hweight=""; 
cap qui svy: total `exp_pc'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear;

if ("`hsize'"=="" )         {;
tempvar hsize;
qui gen `hsize' = 1;
};


tempvar fw;
qui gen `fw'=`hsize';
if ("`hweight'"~="")        qui replace `fw'=`fw'*`hweight';

tempvar quint;
xtile  `quint'=`exp_pc' [aw=`fw'],  nq(5);
cap label drop quint;
forvalues i=1/5 {;
  lab def quint `i' "Quintile `i'", add;
};
lab val `quint' quint; 

local ohgroup = "`hgroup'";

if "`hgroup'"==""  local hgroup = "`quint'";
                   local langr  = "Groups"; 

local dec10=4;
local dec11=0;
local dec12=0;
local dec21=0;
local dec22=2;
local dec23=2;
local dec24=0;
local dec25=2;
local dec31=2;
local dec32=2;
local dec33=2;
local dec41=0;
local dec42=2;
local dec43=2;
local dec44=2;
local dec51=4;
local dec52=4;
local dec53=4;
local dec61=4;
local dec62=4;
local dec63=4;
local dec64=4;

tokenize "`xfil'" ,  parse(".");
local tname `1'.xml;

if "`xfil'" ~= ""  { ;
tokenize "`xfil'" ,  parse(".");
local xfil `1'.xml ;
cap erase `1'.xml ;
//cap winexec   taskkill /IM excel.exe ;

};


//in test
_getfilename `1';
qui return list;
local _fname  `r(filename)';
*set trace on;

cap erase `1'.xml ;






set more off;
di _n as text in white "{col 5}***********************************General Information on Items***********************************";
       
	

	  if ("`cname'"!="")  local tnote   `" " - Country: `cname' " , "'   ;
	  
	  if ("`cname'"!="")   di as text     "{col 5}Country {col 30}: `cname'";
	  di as text     "{col 5}Data survey{col 30}:  $S_FN";

	  local tnote2   `" " - Data survey:   $S_FN  " , "'   ;
	    
	  
	   if ("`ysvy'"!="")   di as text      "{col 5}Year of survey  {col 30}:  `ysvy'";
	   if ("`ysvy'"!="")  local tnote3   `" " - Year of survey:   `ysvy' " , "'   ;
	   
	   
	   if ("`ysim'"!="")   di as text      "{col 5}Year of simulation{col 30}:  `ysim'";
	   if ("`ysim'"!="")  local tnote4   `" " - Year of simulation:  `ysim' " , "'   ;
	   
	   if ("`lcur'"!="")   di as text      "{col 5}Local curency{col 30}: `lcur'";
	    if ("`lcur'"!="")  local tnote5   `" " - Local curency:  `lcur' " , "'   ;
	   
	      di as text     "{col 5}Per capita expenditures{col 30}:  `nexp_pc'";
		  local tnote6   `" " - Per capita expenditures:  `nexp_pc' " , "'   ;
		  
       if ("`hsize'"!="")   di as text     "{col 5}Household size{col 30}:  `hsize'";
	   if ("`hsize'"!="")   local tnote7   `" " - Household size:  `hsize' " , "'   ;
	   
       if ("`hweight'"!="") di as text     "{col 5}Sampling weight{col 30}:  `hweight'";
	   if ("`hweight'"!="")   local tnote8   `" " - Sampling weight:  `hweight' " , "'   ;
	   
       if ("`ohgroup'"!="")   di as text     "{col 5}Group variable{col 30}:  `ohgroup'";
	   if ("`ohgroup'"!="")   local tnote9   `" " - Household group:  `ohgroup' " , "' ; 
	   
local titmodel = "" ;


	    if (`meas'==1| "`meas'"=="")     di as text        "{col 5}Impact on well-being{col 30}:  First order Taylor approximation";
		if (`meas'==2 & `sotm' == 1)                   di as text        "{col 5}Impact on well-being{col 30}:  Second order Taylor approximation of CS";
		if (`meas'==2 & `sotm' == 2)                   di as text        "{col 5}Impact on well-being{col 30}:  Second order Taylor approximation of EV";
		if (`meas'==2 & `sotm' == 3)                   di as text        "{col 5}Impact on well-being{col 30}:  Second order Taylor approximation of CV";
		if (`meas'==3)                   di as text      " {col 5}Impact on well-being{col 30}:  Equivalent variation";
		if (`meas'==4)                   di as text     " {col 5}Impact on well-being{col 30}:  Compensated variation";
		
	    if (`meas'==1| "`meas'"=="")  local tnote11     `" " - Impact on well-being{col 30}:  First order Taylor approximation " , "'   ;
		if (`meas'==2 & `sotm' == 1)  local tnote11     `" " - Impact on well-being{col 30}:  Second order Taylor approximation of CS " , "'   ;
		if (`meas'==2 & `sotm' == 2)  local tnote11     `" " - Impact on well-being{col 30}:  Second order Taylor approximation of EV " , "'   ;
		if (`meas'==2 & `sotm' == 3)  local tnote11     `" " - Impact on well-being{col 30}:  Second order Taylor approximation of CV " , "'   ;
		if (`meas'==3)                local tnote11     `" " - Impact on well-being{col 30}:  Equivalent variation" , "'    ;
		if (`meas'==4)                local tnote11     `" " - Impact on well-being{col 30}:  Compensated  variation" , "'    ;
		
		cap sum `pline';
		local maxpl =round(`r(max)',0.0001) ;
		local minpl =round(`r(min)',0.0001) ;
		
	    if ("`pline'"!="")  di as text     "{col 5}Poverty line {col 30}:  `pline'  {col 40}: Min = `minpl'   {col 60}: Max = `maxpl'";
	    if ("`pline'"!="")   local tnote12   `" " - Poverty line :  `pline'   | Min= `minpl' | Max=`maxpl'  " , "'   ;
	   
		
	    if ("`nitems'"!="0")  di as text     "{col 5}Number of items{col 30}:  `nitems'";
	    if ("`nitems'"!="0")   local tnote13   `" " - Number of items:  `nitems' " , "'   ;
		
		
	
di _n as text in white "{col 5}**************************************************************************************************";


matrix ma=(1); 

            local frm = "SCCB0 N2316 N2316";
           cap drop __compna;
        capture {;
            xml_taba2 ma , title("`xtit'")  /* lines(COL_NAMES 14 `lst1' 2 LAST_ROW 13) */  
            topnote( `tnote' `tnote2' `tnote3' `tnote4' `tnote5' `tnote6' `tnote7' `tnote8' `tnote9' `tnote10' `tnote11' `tnote12'  `tnote13'  ) 
                font("Courier New" 8) format((S2111) (`frm'))  dmat(0)
            lines(COL_NAMES 14 `nitems' 2 LAST_ROW 13) save(`xfil') sheet(General Info) replace;
        };




tokenize `varlist';
if `nitems' != 0 {;
 prjob41 `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(1)  ;
 qui replace __impwell_total = __impwell_total+ __impwell_ind ;
 };

 if `nitems' == 0 {;
 cap drop __impwell_total ;
 qui gen __impwell_total =  __impwell_ind ;
 };


if ("`tjobs'"~="off")   {;

forvalues i=1/`ntables' {;


if (`tjob`i'' == 10)    {;
local tabtit = "Table 1.0: Estimaded price changes of consumption aggregates with the I/O model and the matching map.";
distable  RESA, dec(`dec`tjob`i''') atit(Consumption aggregates) head1(`tabtit') rowtit(`mylabel') dsmidl(-1) ;
mk_xtab_mc `exp_pc' ,  matn(RESA) dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0)  midline(0);

};


if (`tjob`i'' == 11)    {;
qui prjob11 `all_vars' `pline' `hweight';
tempname mat11 ;
matrix `mat11'= e(est);
local tabtit = "Table 1.1: Information on used variables";
distable `mat11', dec1(0) dec2(0) dec3(0) dec4(0) dec5(0) dec6(0)   atit(Variables) head1(`tabtit')  head2(`head2') ;
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1]- Jointly checked  refers to the case of cross conditions. For instance, if all variables " ;
dis as text   _col(9)  " are with non-missing values, number in cell (Jointly checked | All items)  will be zero." ;


mk_xtab_mc `exp_pc' ,  matn(`mat11') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0)  midline(1) ceq1("Observations with")
note(
0 Notes: ,
0 [1]- Jointly checked  refers to the case of cross conditions. For instance`,' if all variables are with non-missing values`,' ,
0 "       the value in cell(Jointly checked | All items) will be zero". 
) ;
;



cap matrix drop `mat`tjob`i''';
tokenize `varlist' ;
};



if (`tjob`i'' == 12)    {;
mcjob12 `exp_pc'        , hs(`hsize') hgroup(`hgroup') lan(`lan') ;
tempname mat12 ;
matrix `mat12'= e(est);
tabtit 12 `lan';
local tabtit = "Table 1.2: Population and expenditures";
distable `mat12', dec1(0) dec2(0) dec3(2) dec4(0) dec5(2) dec6(2)   atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_mc `1' ,  matn(`mat12') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0) dec1(0) dec2(0) dec3(2) dec4(0) dec5(2) dec6(2) control(2);
cap matrix drop `mat`tjob`i''';
};



if (`tjob`i'' >= 21 & `tjob`i'' <= 23 & `nitems'!=0 ) {;
prijob2a `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') nt(`tjob`i'');
tempname  mat`tjob`i'' ; 
matrix `mat`tjob`i'''= e(est);
tabtit `tjob`i'' `lan'; local tabtit = "`r(tabtit)'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`r(tabtit)')  head2(`head2') ;
if (`tjob`i''!=21) {;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};

if (`tjob`i''==21) {;
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1]- Total expenditures at population -national- level is equal to the product of " ;
dis as text   _col(9)  " the total of sampling weights times the average of household expenditures." ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0)
note(
0 Notes: ,
0 [1]- Total expenditures at population -national- level is equal to the product of the total of sampling weights times the average of household expenditures. 
) ;
;
cap matrix drop `mat`tjob`i''';
};
};



if (`tjob`i'' >= 31 & `tjob`i'' <= 33  & `nitems'!=0 ) {;
tokenize `varlist';
prijob3a `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`1') nt(`tjob`i'');
tempname  mat`tjob`i'' ; 
matrix `mat`tjob`i'''= e(est);
tabtitmc `tjob`i''; 

if `tjob`i''==31  local tabtit Table 3.1: Structure of expenditure on products (in %) ; 
if `tjob`i''==32  local tabtit Table 3.2: Expenditure shares (in %) ;
if `tjob`i''==33  local tabtit Table 3.3: Proportion of consumers with non nil expenditures (in %) ;

distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;

if (`tjob`i''!=31) {;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};

if (`tjob`i''==31) {;
local temp1 = __SLITEMS[1];
local temp2 = `mat`tjob`i'''[rowsof(`mat`tjob`i'''),1] ;
local temp2 = substr("`temp2'", 1,5);
local temp3 = colsof(`mat`tjob`i''') -1 ;
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1]- Statistics of Table 3.1 indicate the proportions of expenditures on the studied items," ;
dis as text   _col(9)  " and this, relative to the total expenditures on studied items. For instance, at population level," ;
dis as text   _col(9)  " expenditures on the item `temp1' represents `temp2' percent of total expenditures on the `temp3' item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0)
note(
0 Notes: ,
0 [1] Statistics of Table 3.1 indicate the proportions of expenditures on the studied items`,' and this`,' relative to the total expenditures on studied items. , 
0 "     For instance`,' at population level`,' expenditures on the item `temp1' represents `temp2' percent of total expenditures on the `temp3' item(s)." ) 
;
};

};



if (`tjob`i'' == 41 ) {;
prijob4a `impvlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`impslist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(0) matpel(`matpel') matiel(`matiel') sotm(`sotm')  nt(41);
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
local tabtit = "Table 4.1: Total impact on well-being (at population level and in currency)";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};


if (`tjob`i'' == 42) {;
*set trace on;
prijob4a `impvlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`impslist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(0)  matpel(`matpel') matiel(`matiel') sotm(`sotm') nt(42);
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
local tabtit = "Table 4.2: Impact on per capita well-being (in currency)";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0)  ;
cap matrix drop `mat`tjob`i''';

};



if (`tjob`i'' == 43) {;
prijob4a `impvlist',   hs(`hsize') hgroup(`hgroup') lan(en) xrnames(`impslist') aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(0)  matpel(`matpel') matiel(`matiel') sotm(`sotm') nt(43);
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
local tabtit = "Table 4.3: The impact on per capita well-being (in %)";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_mc `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};

if (`tjob`i'' == 44) {;
*set trace on;
prijob4a `impvlist',  hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`impslist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model')	subs(`subs')	gvimp(0) matpel(`matpel') matiel(`matiel') sotm(`sotm')	nt(44);
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
local colsize = colsof(`mat`tjob`i''')-1;	
local rowsize = rowsof(`mat`tjob`i''');	
matrix `mat`tjob`i''' = `mat`tjob`i'''[1..`rowsize' , 1..`colsize'] ;
local tabtit = "Table 4.4: Impact on per capita well-being (consumers with non-nil expenditures)";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] Statistics of Table 4.4 only concern the population of consumers with non-nil expenditures on each of the studied items;" ;
dis as text   _col(4)  " [2] Statistics of column -All items- only concern the population of consumers with non-nil expenditures on at leats one of the studied items." ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0)	
note(
0 Notes: ,
0 " [1] Statistics of Table 4.4 only concern the population of consumers with non-nil expenditures  the proportions of expenditures on studied items;" ,
0 " [2] Statistics of column -All items- only concern the population of consumers with non-nil expenditures on at leats one of the studied items."
) 
;
cap matrix drop `mat`tjob`i'';
};



if (`tjob`i'' >= 51 & `tjob`i'' <= 53) {;
*set trace on;

prijob5a `impvlist1',   hs(`hsize') hgroup(`hgroup') lan(en) xrnames(`impslist1') aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp')  pline(`pline') matpel(`matpel') matiel(`matiel') sotm(`sotm') nt(`tjob`i'');
tempname  mat`tjob`i'' ;
matrix   `mat`tjob`i'''= e(est);
if `tjob`i'' == 51 local tabtit = "Table 5.1: Price changes and poverty headcount";
if `tjob`i'' == 52 local tabtit = "Table 5.2: Price changes power and poverty gap";
if `tjob`i'' == 53 local tabtit = "Table 5.3: Price changes and squared poverty gap";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - Initial          : Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - Final            : Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0) 
note(
0 Notes: ,
0 "[1] - Initial                     : Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - Final                       : Refers to the case with price changes of all item(s)."
 ) 
;

cap matrix drop `mat`tjob`i''';

};



if (`tjob`i'' == 61 ) {;
*set trace on;

 prijob6a `impvlist1',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`impslist1')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') matpel(`matpel') matiel(`matiel') sotm(`sotm') nt(61) ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitmc `tjob`i''; 
local tabtit = "Table 6.1: Price change(s) and inequality: Gini";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1) ;
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - Initial          : Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - Final            : Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0) 
note(
0 Notes: ,
0 "[1] - Initial                     : Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - Final                       : Refers to the case with price changes of all item(s)."
 ) ;

};

 
if (`tjob`i'' == 62 ) {;
*set trace on;

qui prijob6a `impvlist1',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`impslist1')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp')   epsilon(`epsilon') matpel(`matpel') matiel(`matiel') sotm(`sotm') nt(62) ; ;

tempname  mat`tjob`i'' ;
matrix   `mat`tjob`i'''= e(est);

tabtitmc `tjob`i''; 
local tabtit = "Table 6.2: Price change(s) and inequality: Atkinson";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1) ;
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - Initial          : Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - Final            : Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0) 
note(
0 Notes: ,
0 "[1] - Initial                     : Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - Final                       : Refers to the case with price changes of all item(s)."
 ) ;


};


if (`tjob`i'' == 63 ) {;

qui prijob6a `impvlist1',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`impslist1')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') theta(`theta') matpel(`matpel') matiel(`matiel') sotm(`sotm') nt(63) ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitmc `tjob`i''; 
local tabtit = "Table 6.3: Price change(s) and inequality: Entropy";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - Initial          : Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - Final            : Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0) 
note(
0 Notes: ,
0 "[1] - Initial                     : Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - Final                       : Refers to the case with price changes of all item(s)."
 ) ;


};

if (`tjob`i'' == 64 ) {;
qui prijob6a `impvlist1',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`impslist1')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp')  matpel(`matpel') matiel(`matiel') sotm(`sotm') nt(64) ;
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
tabtitmc `tjob`i''; 
local tabtit = "Table 6.4: Price change(s) and inequality: Ratio Q(p=0.1)/Q(p=0.9)";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - Initial          : Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - Final            : Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0) 
note(
0 Notes: ,
0 "[1] - Initial                     : Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - With_Pr_Ch_Item  : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - Final                       : Refers to the case with price changes of all item(s)."
 ) ;


};
};

}; 

cap macro drop indica ;
cap macro drop indig ;
cap macro drop rnam ;


cap drop __nevar*;
if  ("`xfil'" ~= "" &  "`tjobs'"~="off" ) | ("`xfil'" ~= "" ) {;
di as txt `"(output written to {browse `xfil'})"' ; 
};
  
cap drop __VNITEMS ; 
cap drop __SLITEMS ; 
cap drop _pr_*;
cap drop _prc*;
cap drop __IPRC;
cap drop _imp_*;

cap drop __ELAS;
cap drop _elas*;
if `gvimp' == 0 cap drop __impwell_*;

cap matrix drop  gn;
cap matrix drop  ma;
cap matrix drop  RESA;
cap matrix drop  __RES;
cap matrix drop  __RS;
end;

