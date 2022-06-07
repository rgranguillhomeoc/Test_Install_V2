/*************************************************************************/
/* mcwel: Market Concentration and Welfare  (Version 2.20)               */
/*************************************************************************/
/* Conceived  by :                                                       */
/*     Abdelkrim Araar                                                   */
/*     Eduardo Malasquez                                                 */
/*     Sergio Olivieri                                                   */
/*     Carlos Rodriguez-Castelan                                         */
/* email : aabd@ecn.ulaval.ca                                            */
/* 14/Nov/2018 			                                         */
/*************************************************************************/
/* mcwel.ado                                                             */
/*************************************************************************/



#delim ;
set more off;

capture program drop lmcwel;
program define lmcwel , eclass sortpreserve;
version 9.2;
syntax varlist (min=1 max=1) [if] [in] [,  
HHID(varlist)
HSize(string)  
PLine(varname)
HGroup(string)
EPSILON(real 0.5)
THETA(real 0)
INISave(string) 
GVIMP(int 0)
CONF(string) 
LEVEL(real 95)
DEC(int 3)
INCOMES(string)
SECTORS(string)

XFIL(string)
TJOBS(string) 

GJOBS(string) 
FOLGR(string)

OPGR1(string) OPGR2(string)  OPGR3(string) 
];


local lan en;
 if ("`inisave'" ~="") {;
  asdbsave_lmc `0' ;
  };

if "`hgroup'"=="" local hgroup = 5;



tokenize `varlist';
local mylist min max ogr;
forvalues i=1/10 {;
if ("`opgr`i''"~="") {;
extend_opt_graph test , `opgr`i'' ;
foreach name of local mylist {;
local `name'`i' = r(`name');
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};
};


 
/****************************************************************/

/* Copying  the sampling weight */
local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear;

/* The household size        */
if ("`hsize'"=="" )         {;
tempvar hsize;
qui gen `hsize' = 1;
};

/* The final weight         */
tempvar fw;
qui gen `fw'=`hsize';
if ("`hweight'"~="")        qui replace `fw'=`fw'*`hweight';


if "`hgroup'"=="" local ngroup = "Quintiles";
if "`hgroup'"~="" local ngroup = `hgroup';

/* Generating the categorical variable (quintiles) */
if "`hgroup'"==""  {;
tempvar quint;
qui xtile  `quint'=`2'  [aw=`fw'],  nq(5);
cap label drop quint;
forvalues i=1/5 {;
  lab def quint `i' "Quintile_`i'", add;
};
lab val `quint' quint; 
local hgroup = "`quint'";
};

if "`hgroup'"~=""  {;
cap confirm integer number `hgroup' ;
if !_rc {;
tempvar dgr;
qui xtile  `dgr'=`1'  [aw=`fw'],  nq(`hgroup');
cap label drop dgr;
forvalues i=1/`hgroup' {;
  if `hgroup' == 4  lab def dgr `i' "Quartile_`i'", add;
  if `hgroup' == 5  lab def dgr `i' "Quintile_`i'", add;
  if `hgroup' == 10 lab def dgr `i' "Decile_`i'",   add;
  if `hgroup' != 10 &  `hgroup' != 5  & `hgroup' != 4 lab def dgr `i' "Group `i'",   add;
};
lab val `dgr' dgr; 
local hgroup = "`dgr'";

};
};



if ("`lan'" == "") local lan = "en";
if ("`tjobs'" == ""  & "`tjobs'"~="off")  local tjobs 11  21  31 32 33  41  42 43 51 52 53   61 62 63  64   ;
if ("`gjobs'" == ""  & "`gjobs'"~="off" ) local gjobs 1 2 3 4 5 6;






tokenize "`tjobs'";
quietly {;
local k = -1;
if "`1'" ~= "" {;
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
if "`1'" ~= "" {;
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


local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear;

/*
local incomes "C:\Users\abara\Desktop\welcom_3\example\income.dta";
local sectors "C:\Users\abara\Desktop\welcom_3\example\sector.dta";
*/
qui preserve;
qui use `sectors', replace;
foreach var of varlist _all {;
if "`var'" != "sector" local listscen `listscen' `var';
};

qui restore;
qui preserve;
qui use `incomes', replace;
qui merge m:1 sector using `sectors';
cap drop _merge;
foreach name of local listscen {;
qui gen Imp_`name' = income*`name';
};
qui tabulate sector, matrow(gn);
svmat int gn;
global indi1=r(r);
forvalues i=1/$indi1 {;
local code = gn[`i'];
local code`i' = gn[`i'];
gen S_`code' = sector==`code';
gen I_`code' = S_`code'*income;
local seclist `seclist' S_`code';
local inclist `inclist' I_`code';
local pcinclist `pcinclist' pc_I_`code';
};
gen S_All = 1;
cap drop gn1;
qui collapse (sum) Imp_*  S_* I_* , by(`hhid');
qui tempfile aa;
qui save `aa' , replace;
qui restore;
cap drop impactinc;
qui merge 1:1 `hhid' using `aa';
cap drop _merge;
foreach name of local listscen {;
qui replace Imp_`name'=0 if Imp_`name'==.;
qui replace Imp_`name'= Imp_`name'/`hsize';
};
foreach var of varlist I_* S_*  {;
qui replace `var' = 0 if `var'==.;
cap drop pc_`var' ;
qui gen pc_`var' = `var'/`hsize'; 
};

forvalues i=1/$indi1 {;
local code = `code`i'';
cap drop lpci_`code';
qui gen     lpci_`code' = I_`code'/S_`code'; 
qui replace lpci_`code' = 0 if lpci_`code' ==. ;
local lpcinclist `lpcinclist' lpci_`code';
};


if ("`hsize'"=="" )         {;
tempvar hsize;
qui gen `hsize' = 1;
};
tempvar fw;
qui gen `fw'=`hsize';
if ("`hweight'"~="")        qui replace `fw'=`fw'*`hweight';



local ohgroup = "`hgroup'";
local langr   = "Groups"; 



/************************/

/* Capturing the modalities and the label values of the group variable */
preserve;
capture {;
cap local lvgroup:value label `hgroup';
if ("`lvgroup'"!="") {;
uselabel `lvgroup' , replace;
qui count;
local indica = `r(N)';
forvalues i=1/`r(N)' {;
local tem_`i'=value[`i'];
local grlab`tem_`i'' = label[`i'];
};
};
};

restore;

if ("`lvgroup'"=="") {;
cap matrix drop _aa;
qui tab `hgroup' , matrow(_aa);
local indica = `r(r)';
forvalues i=1/`r(r)' {; 
local tem_`i'=el(_aa, `i' ,1);
dis "****************" el(_aa, `i' ,1 );
local grlab`tem_`i'' = "Group_mod_`tem_`i''";
};
};


*preserve;


marksample touse;
qui sum `touse';
if (r(min)!=r(max)) preserve; 
qui keep if `touse' ;

tokenize "`xfil'" ,  parse(".");
local tname `1'.xml;

if "`xfil'" ~= ""  { ;
tokenize "`xfil'" ,  parse(".");
local xfil `1'.xml ;
cap erase  `1'.xml ;
cap winexec   taskkill /IM excel.exe ;
};

/* Computing the price changes */
tokenize `varlist';







local i = 1;
foreach name of local seclist {;
if `i' == 1 local tmp = " "+"`name'";
if `i' != 1 local tmp = " |"+"`name'";
if ("`name'"~="") {;
local mslist `mslist' `tmp';
};
local i = `i'+1;
};


local dec11=4;


local dec21=2;
local dec22=2;
local dec23=2;

local dec31=2;
local dec32=2;
local dec33=2;


local dec41=2;
local dec42=2;
local dec43=2;
local dec44=2;

local dec51=3;
local dec52=3;
local dec53=3;



local dec61=4;
local dec62=4;
local dec63=4;
local dec64=4;



tokenize `varlist';
_nargs   `varlist';

if (`gvimp' == 1)   lmcjob41 `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   ;
 

forvalues i=1/`ntables' {;

if (`tjob`i'' == 11) {;
lmcjob11 `1'        , hs(`hsize') hgroup(`hgroup') lan(en) ;
tempname mat11 ;
matrix `mat11'= e(est);
tabtitmc 11 en;
local tabtit = "`r(tabtit)'";
distable `mat11', dec1(0) dec2(0) dec3(2) dec4(0) dec5(2) dec6(2)   atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_lmc `1' ,  matn(`mat11') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0) dec1(0) dec2(0) dec3(2) dec4(0) dec5(2) dec6(2) control(2);
cap matrix drop `mat`tjob`i''';
};


if (`tjob`i'' == 21) {;


local vlist `seclist' ;
*set trace on;
lmcjob`tjob`i'' `vlist',    hgroup(`hgroup') lan(`lan')  xrnames(`mslist')  aggr(`taggregate') pcexp(S_All);
tempname  mat`tjob`i'' ; 
matrix `mat`tjob`i'''= e(est);
tabtitmc `tjob`i''; 

if `tjob`i''==21  local tabtit Table 2.1: Proportion of workers by economic sectors (in %) ; 

distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Sectors) head1(`tabtit')  head2(`head2') ;
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};

if (`tjob`i'' == 31) {;
local vlist `inclist' ;
lmcjob`tjob`i'' `vlist',    hgroup(`hgroup') lan(`lan')   xrnames(`mslist')  aggr(`taggregate') pcexp(S_All);
tempname  mat`tjob`i'' ; 
matrix `mat`tjob`i'''= e(est);
tabtitmc `tjob`i''; 

if `tjob`i''==31  local tabtit Table 3.1: Average household income by economic sectors  ;
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Sectors) head1(`tabtit')  head2(`head2') ;
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};


if (`tjob`i'' == 32) {;
local vlist `pcinclist' ;
lmcjob`tjob`i'' `vlist',    hsize(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`mslist')  aggr(`taggregate') pcexp(S_All);
tempname  mat`tjob`i'' ; 
matrix `mat`tjob`i'''= e(est);
tabtitmc `tjob`i''; 

if `tjob`i''==32  local tabtit Table 3.2: Average per capita income by economic sectors  ;
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Sectors) head1(`tabtit')  head2(`head2') ;
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};



if (`tjob`i'' == 33) {;
local vlist `lpcinclist' ;
lmcjob`tjob`i'' `vlist',    hgroup(`hgroup') lan(`lan')  xrnames(`mslist')  aggr(`taggregate') pcexp(S_All);
tempname  mat`tjob`i'' ; 
matrix `mat`tjob`i'''= e(est);
tabtitmc `tjob`i''; 

if `tjob`i''==33  local tabtit Table 3.3: Average personal income by economic sectors (workers population)  ;
distable0 `mat`tjob`i''', dec(`dec`tjob`i''') atit(Sectors) head1(`tabtit')  head2(`head2') ;
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') midline(0);
cap matrix drop `mat`tjob`i''';
};





if (`tjob`i'' >= 41 & `tjob`i'' <= 43) {;

lmcjob`tjob`i'' Imp_*,   hs(`hsize') hgroup(`hgroup') lan(en)   xrnames(`mslist')  aggr(`taggregate') pcexp(`1')   gvimp(0) ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
tabtitmc `tjob`i''; 
local tabtit = "`r(tabtit)'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Sectors) head1(`tabtit')  head2(`head2') ;
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''_`s'';

};


if (`tjob`i'' >= 51 & `tjob`i'' <= 53) {;
*set trace on;

qui lmcjob`tjob`i'' Imp_*,   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')    pline(`pline')  ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitlmc `tjob`i''; 
local tabtit = "`r(tabtit)'"+"`scena'"+"";
distable0 `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0) ;

cap matrix drop `mat`tjob`i''';

};







if (`tjob`i'' == 61 ) {;
*set trace on;

qui lmcjob`tjob`i'' Imp_*,   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')    ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitlmc `tjob`i''; 
local tabtit = "`r(tabtit)'";
distable0 `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1) ;
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};


if (`tjob`i'' == 62 ) {;
*set trace on;

qui lmcjob`tjob`i'' Imp_*,   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')  epsilon(`epsilon')   ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitlmc `tjob`i''; 
local tabtit = "`r(tabtit)'";
distable0 `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1) ;
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};

if (`tjob`i'' == 63 ) {;
*set trace on;

qui lmcjob`tjob`i'' Imp_*,   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')  theta(`theta')   ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitlmc `tjob`i''; 
local tabtit = "`r(tabtit)'";
distable0 `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1) ;
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};


if (`tjob`i'' == 64 ) {;
*set trace on;

qui lmcjob`tjob`i'' Imp_*,   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')     ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitlmc `tjob`i''; 
local tabtit = "`r(tabtit)'";
distable0 `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1) ;
mk_xtab_lmc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};

};


*set trace on;

/********* The graphs *********************/

cap rmdir Graphs;
cap mkdir Graphs;
local mygrdir Graphs\ ;

if ( "`gjobs'"~="off" ){;

forvalues i=1/`ngraphs' {;


if ("`gjob`i''" == "1" ) {;
*set trace on;

set more off;
set tracedepth 2;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;
 lmcjobgr`gjob`i'' Imp_SCN*,   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''')  min(`min`gjob`i''') max(`max`gjob`i''')   ;
qui graph save       "`mygrdir'Fig_`gjob`i''.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;

};


if ("`gjob`i''" == "2" ) {;
*set trace on;
qui lmcjobgr`gjob`i'' Imp_SCN*,   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''')  min(`min`gjob`i''') max(`max`gjob`i''')  ;
qui graph save       "`mygrdir'Fig_`gjob`i''.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;

};


};


};



cap drop __nevar*;
if  ("`xfil'" ~= "" &  "`tjobs'"~="off" ) | ("`xfil'" ~= "") {;
cap !start "" /min "`xfil'" ; 
};





end;

