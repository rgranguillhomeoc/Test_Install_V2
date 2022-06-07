



#delim ;
set more off;
capture program drop wapwel;
program define wapwel , eclass sortpreserve;
version 9.2;
syntax varlist (min=1 max=1) [if] [in] [,  
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
ADSHOCK(int 1)
NADP(int 1)

NITEMS(int 1)
ITNAMES(string)
ITVNAMES(string)
MATCH(string)
IOMATRIX(string)

SECNAMES(string)

XFIL(string)
TJOBS(string) 

GJOBS(string) 
FOLGR(string)

OPGR1(string) OPGR2(string)  OPGR3(string) 
];


local lan en;
 if ("`inisave'" ~="") {;
  asdbsave_wap `0' ;
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

*set trace on;
local vlist;
local slist;
preserve;
qui  cap drop if `itvnames'=="";
//sort `vnitems';
qui count;

forvalues i=1/`nitems' {;
local tmp = ""+`itvnames'[`i'];
if `i' == 1 local tmp2 = " "+`itvnames'[`i'];
if `i' != 1 local tmp2 = " |"+`itvnames'[`i'];
local vlist `vlist' `tmp';
local slist `slist' `tmp2';
};
restore;


 
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
if ("`tjobs'" == ""  & "`tjobs'"~="off")  local tjobs 1  2  3 4 5 6 7;
if ("`gjobs'" == ""  & "`gjobs'"~="off" ) local gjobs 1  2  ;



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



qui pc_w_ind `varlist' , 
iom(`iomatrix')
match(`match')
nitems(`nitems')
adshock(`adshock')
nadp(`nadp')

;
*set trace on; 
qui count if _DP_SECTOR !=.;
tempname matseca;
qui replace _DP_SECTOR=_DP_SECTOR*100;
tempname numsec;
qui gen `numsec' = _n ;
mkmat  _DP_SECTOR in 1/`r(N)' , matrix(`matseca');
forvalues i=1/`r(N)' {;
                       local tmp = "Sector_`i'";
if ("`secnames'"~="")  local tmp = substr(`secnames'[`i'],1,32) ;
local rnames `"`rnames'  "`tmp'" "' ;
};

matrix rownames `matseca' = `rnames' ;
matrix colnames `matseca' =  "Price Change in %" ;
cap drop _DP_SECTOR;


cap drop _IMP;
qui gen _IMP = 0;
forvalues i=1/`nitems' {;
local var = `itvnames'[`i'] ;
tempvar imp_`i' ;
qui gen `imp_`i'' = - `var'*el(e(PRCG),`i',1) ;
qui replace _IMP = _IMP  -`var'*el(e(PRCG),`i',1) ;
local implist `implist' `imp_`i'';
};
local rnames ="";
tempname matgood;
matrix `matgood' = e(PRCG)*100;
forvalues i=1/`nitems' {;
local tmp = "Good_`i'";
if ("`itnames'"~="") local tmp = `itnames'[`i'] ;
local rnames `rnames' `"`tmp'"' ;
};
*dis `rnames' ;
matrix rownames `matgood' = `rnames' ;
matrix colnames `matgood' =  "Price Change in %" ;
*set trace on ;


*matrix list `matseca' ;


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




tokenize `varlist';
_nargs   `varlist';



if ( "`tjobs'"~="off" ){;
forvalues i=1/`ntables' {;

if (`tjob`i'' == 1) {;
tabtitwap 1 en;
local tabtit = "`r(tabtit)'";
distable `matseca' , dec1(3) atit(Sector) head1(`tabtit')  dsmidl(-1) longlab(`secnames');
mk_xtab_lmc `1' ,  matn(`matseca')  xfil(`xfil') xshe(table_1) xtit(`tabtit') xlan(`lan') dste(-1) dec1(3)  control(2);
};

if (`tjob`i'' == 2) {;
tabtitwap 2 en;
local  tabtit  = "`r(tabtit)'";
distable `matgood' , dec1(3)    atit(Good) head1(`tabtit')  dsmidl(-1) longlab(`itnames');
mk_xtab_lmc `1' ,  matn(`matgood')  xfil(`xfil') xshe(table_2) xtit(`tabtit') xlan(`lan') dste(-1) dec1(3)  control(2);
};

if (`tjob`i'' == 3) {;
lmcjob11 `1'        , hs(`hsize') hgroup(`hgroup') lan(en) ;
tempname mat11 ;
matrix `mat11'= e(est);
tabtitwap 3 en;
local tabtit = "`r(tabtit)'";
distable `mat11', dec1(0) dec2(0) dec3(2) dec4(0) dec5(2) dec6(2)    atit(Group) head1(`tabtit')  head2(`head2') ;
mk_xtab_lmc `1' ,  matn(`mat11') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0) dec1(0) dec2(0) dec3(2) dec4(0) dec5(2) dec6(2) control(2);
cap matrix drop `mat`tjob`i''';
};


if (`tjob`i'' == 4 ) {;
tempname fmat;
forvalues j=41/43  {;

lmcjob`j' _IMP,   hs(`hsize') hgroup(`hgroup') lan(en)   xrnames(`mslist')  aggr(`taggregate') pcexp(`1')   gvimp(0) ;

tempname  mat`j' ;
matrix `mat`j''= e(est);
if `j' == 41 matrix `fmat'= `mat`j'';
if `j' != 41 matrix `fmat'= `fmat',`mat`j'';
cap matrix drop `mat`j'_`s'';

};
matrix colnames `fmat'  = "Impact on Population" "Impact Per Capita" "Proportion Impact (in %)" ;
tabtitwap `tjob`i''; 
local tabtit = "`r(tabtit)'";
distable `fmat', dec1(0) dec2(1) dec3(2)  atit(Group) head1(`tabtit')  head2(`head2') ;
mk_xtab_lmc `1' ,  matn(`fmat')  xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0) dec1(0) dec2(1) dec3(2) control(2);
cap matrix drop `fmat';
};


if (`tjob`i'' == 5 ) {;
mcjobstat `implist' ,   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(_IMP)  stat(share_tot_pro) ;
tempname mat5 ;
matrix `mat5'= e(est)';
tabtitwap `tjob`i''; 
local tabtit = "`r(tabtit)'";
local h=`nitems'+1;
qui replace `itnames' = "All " in `h' ;
distable `mat5' , dec1(3)    atit(Good) head1(`tabtit')  dsmidl(1) longlab(`itnames');
mk_xtab_lmc `1' ,  matn(`mat5')  xfil(`xfil') xshe(table_5) xtit(`tabtit') xlan(`lan') dste(0) dec1(3)  control(2);
qui replace `itnames' = "" in `h' ;
};


if (`tjob`i'' == 6 ) {;
tempname fmat;
forvalues j=51/53  {;
*set trace on;

qui lmcjob`j' _IMP,   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')    pline(`pline')  ;

tempname  mat`j' ;
matrix `mat`j''= e(est);
tempname aa`j';
matrix `aa`j'' = (el(`mat`j'',1,1)\el(`mat`j'',2,1)\el(`mat`j'',2,2)\el(`mat`j'',2,3)\el(`mat`j'',2,4)) ;
if `j' == 51 matrix `fmat'= `aa`j'';
if `j' != 51 matrix `fmat'= `fmat',`aa`j'';
cap matrix drop `mat`tjob`i''';

};

matrix colnames `fmat'  = "Headcount" "Poverty Gap" "Squared Poverty Gap" ;
matrix rownames `fmat'  = "Initial" "Final" "Change" "Standard Errors" "P-Value" ;
tabtitwap `tjob`i''; 
local tabtit = "`r(tabtit)'";
distable `fmat', dec1(2) dec2(2) dec3(2)  atit(Component) head1(`tabtit')  head2(`head2') dsmidl(-1) ;
mk_xtab_lmc `1' ,  matn(`fmat')  xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(-1) dec1(2) dec2(2) dec3(2) control(2);
cap matrix drop `fmat';

};



if (`tjob`i'' == 7 ) {;

tempname fmat;
forvalues j=61/64  {;
*set trace on;

qui lmcjob`j' _IMP,   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')    ;

tempname  mat`j' ;
matrix `mat`j''= e(est);
tempname aa`j';
matrix `aa`j'' = (el(`mat`j'',1,1)\el(`mat`j'',2,1)\el(`mat`j'',2,2)\el(`mat`j'',2,3)\el(`mat`j'',2,4)) ;
if `j' == 61 matrix `fmat'= `aa`j'';
if `j' != 61 matrix `fmat'= `fmat',`aa`j'';
cap matrix drop `mat`tjob`i''';

};

matrix colnames `fmat'  = "Gini" "Atkinson" "Entropy" "Quantiles Ratio";
matrix rownames `fmat'  = "Initial" "Final" "Change" "Standard Errors" "P-Value" ;
tabtitwap `tjob`i''; 
local tabtit = "`r(tabtit)'";
distable `fmat', dec1(2) dec2(4) dec3(4) dec4(4)  atit(Component) head1(`tabtit')  head2(`head2') dsmidl(-1) ;
mk_xtab_lmc `1' ,  matn(`fmat')  xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(-1) dec1(2) dec2(4) dec3(4) dec4(4)  control(2);
cap matrix drop `fmat';
};


};

};



*set trace on;

/********* The graphs *********************/


if ("`folgr'"!=""){;
cap rmdir cap rmdir Graphs;
cap mkdir `folgr'/Graphs;
cap mkdir `folgr'/Graphs;
local mygrdir `folgr'\Graphs\ ;
};

if ("`folgr'"==""){;
cap rmdir Graphs;
cap mkdir Graphs;
local mygrdir Graphs\ ;

};


if ( "`gjobs'"~="off" ){;

forvalues i=1/`ngraphs' {;


if ("`gjob`i''" == "1" ) {;
*set trace on;

set more off;
set tracedepth 2;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;
lmcjobgr`gjob`i'' _IMP,   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''')  min(`min`gjob`i''') max(`max`gjob`i''')   ;
qui graph save       "`mygrdir'Fig_`gjob`i''.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;

};


if ("`gjob`i''" == "2" ) {;
*set trace on;
qui lmcjobgr`gjob`i'' _IMP,   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''')  min(`min`gjob`i''') max(`max`gjob`i''')  ;
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

/*
wapwel pc_income, hsize(hhsize) pline(pline) inisave(myexp) nitems(11) itvnames(vnnames) match(match_sec) 
iomatrix(C:\Users\abara\Desktop\Direct&Indirect\example\SAM_MEX_2003.dta) /* xfil(myfile) */ itnames(itnames) secnames(secnames)
tjobs() gjobs(off)
;
*/
