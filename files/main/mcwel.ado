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

capture program drop mcwel;
program define mcwel , eclass sortpreserve;
version 9.2;
syntax varlist (min=1 max=1) [if] [in] [,  
HSize(string)  
PLine(varname)
HGroup(string)
NITEMS(int 1)
MOVE(int 1)
MEAS(int 1)
MODEL(int 1)
SUBS(real 0.6)
EPSILON(real 0.5)
THETA(real 0)
INISave(string) 
GVIMP(int 0)
GVPC(int 0)
CONF(string) 
LEVEL(real 95)
DEC(int 3)
IT1(string) IT2(string)  IT3(string)  IT4(string) IT5(string)  
IT6(string) IT7(string)  IT8(string)  IT9(string) IT10(string)
GSCEN(int 0)
MPART(int 0)

XFIL(string)
TJOBS(string) 

GJOBS(string) 
FOLGR(string)

OPGR1(string) OPGR2(string)  OPGR3(string) 
];


local lan en;
 if ("`inisave'" ~="") {;
  asdbsave_mcw `0' ;
  };

if "`hgroup'"=="" local hgroup = 5;
local mylist sn vn el st nf si scen;
forvalues i=1/`nitems' {;
extend_opt_item_mcwel test , `it`i'' ;
foreach name of local mylist {;
local `name'`i'  `r(`name')';
/* dis " `name'`i' " "A" "  `r(`name')' " ; */

if  "`name'"~="sn"   &  "`name'"~="scen" & "`name'"~="it"   & "``name'`i''"=="" local `name'`i' = 0 ;
if  "`name'"=="scen" & "`name'`i'"=="" local `name'`i' = "" ;
/*
if  "``name'`i''"=="." local `name'`i' = "" ;
dis "`name'`i' = ``name'`i'' ";
*/
/* dis " `name'`i' " "B" "  `r(`name')' " ; */
};
};


tokenize "`xfil'" ,  parse(".");
local tname `1'.xml;

if "`xfil'" ~= ""  { ;
tokenize "`xfil'" ,  parse(".");
local xfil `1'.xml ;
cap erase `1'.xml ;
//cap winexec   taskkill /IM excel.exe ;

};

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

if "`hgroup'"=="" local orhgroup = `hgroup' ;
if "`hgroup'"=="" local ngroup = "Quintiles";
if "`hgroup'"~="" local ngroup = `hgroup';

/* Generating the categorical variable (quintiles) */
if "`hgroup'"==""  {;
tempvar quint;
qui xtile  `quint'=`2'  [aw=`fw'],  nq(5);
cap label drop quint;
forvalues i=1/5 {;
  lab def quint `i' "Quintile `i'", add;
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
  if `hgroup' == 4  lab def dgr `i' "Quartile `i'", add;
  if `hgroup' == 5  lab def dgr `i' "Quintile `i'", add;
  if `hgroup' == 10 lab def dgr `i' "Decile `i'",   add;
  if `hgroup' != 10 &  `hgroup' != 5  & `hgroup' != 4 lab def dgr `i' "Group `i'",   add;
};
lab val `dgr' dgr; 
local hgroup = "`dgr'";

};
};



if ("`lan'" == "") local lan = "en";
if ("`tjobs'" == ""  & "`tjobs'"~="off")  local tjobs 12 13  21 22 23  31 32 33 41  42 43 44 51 52 53   61 62 63  64   ;
if ("`gjobs'" == ""  & "`gjobs'"~="off" ) local gjobs 1 2 3 4 5 6;


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





cap drop __VNITEMS ; 
qui gen  __VNITEMS = "";

cap drop __SLITEMS ; 
qui gen __SLITEMS = "";


forvalues i=1/`nitems' {;



if ("`vn`i''" ~= "" ) qui replace __VNITEMS =  "`vn`i''"  in `i' ;
if ("`sn`i''" == "" ) local sn`i' = "`it`i''" ;
if ("`sn`i''" ~= "" ) qui replace __SLITEMS =  "`sn`i''"  in `i' ;

};

local vnitems = "__VNITEMS"  ; 
local slitems = "__SLITEMS" ;




local vlist;
local slist;
preserve;
qui  cap drop if `vnitems'=="";
//sort `vnitems';
qui count;


forvalues i=1/`r(N)' {;
local tmp = ""+`vnitems'[`i'];
if `i' == 1 local tmp2 = " "+`slitems'[`i'];
if `i' != 1 local tmp2 = " |"+`slitems'[`i'];
if ("`slitems'"~="") {;
local vlist `vlist' `tmp';
local slist `slist' `tmp2';
};
};
restore;


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
local mdirec "Competitive to concentrated market" ;
if `move' == -1 local mdirec "Concentrated to competitive market" ;
local hweight=""; 
cap qui svy: total `exp_pc'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear;

marksample touse;
qui sum `touse';
if (r(min)!=r(max)) preserve; 
qui keep if `touse' ;

tokenize "`xfil'" ,  parse(".");
local tname `1'.xml;

tokenize `varlist' ;

set more off;
di _n as text in white "{col 5}***********************************General Information********************************************";
       
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
	   
	      di as text     "{col 5}Per capita well-being{col 30}:  `1'";
		  local tnote6   `" " - Per capita well-being:  `1' " , "'   ;
		  
       if ("`hsize'"!="")   di as text     "{col 5}Household size{col 30}:  `hsize'";
	   if ("`hsize'"!="")   local tnote7   `" " - Household size:  `hsize' " , "'   ;
	   
       if ("`hweight'"!="") di as text     "{col 5}Sampling weight{col 30}:  `hweight'";
	   if ("`hweight'"!="")   local tnote8   `" " - Sampling weight:  `hweight' " , "'   ;
	   
       if ("`orgroup'"!="")   di as text     "{col 5}Group variable{col 30}:  `orgroup'";
	   if ("`orgroup'"!="")   local tnote9   `" " - Household group:  `orgroup' " , "' ; 
	   
local titmodel = "" ;


	    if (`meas'==1| "`meas'"=="")     di as text        "{col 5}Impact on well-being{col 30}:  First order Taylor approximation";
		if (`meas'==2)                   di as text      " {col 5}Impact on well-being{col 30}:  Equivalent variation";
		if (`meas'==3)                   di as text     " {col 5}Impact on well-being{col 30}:  Compensated variation";
		
	    if (`meas'==1| "`meas'"=="")  local tnote11     `" " - Impact on well-being{col 30}:  First order Taylor approximation " , "'   ;
		if (`meas'==2)                local tnote11     `" " - Impact on well-being{col 30}:  Equivalent variation" , "'    ;
		if (`meas'==3)                local tnote11     `" " - Impact on well-being{col 30}:  Compensated  variation" , "'    ;
		
		cap sum `pline';
		local maxpl =round(`r(max)',0.0001) ;
		local minpl =round(`r(min)',0.0001) ;
		
	    if ("`pline'"!="")  di as text     "{col 5}Poverty line {col 30}:  `pline'  {col 40}: Min = `minpl'   {col 60}: Max = `maxpl'";
	    if ("`pline'"!="")   local tnote12   `" " - Poverty line :  `pline'   | Min= `minpl' | Max=`maxpl'  " , "'   ;
	   
		
	    if ("`nitems'"!="")  di as text     "{col 5}Number of items{col 30}:  `nitems'";
	    if ("`nitems'"!="")   local tnote13   `" " - Number of items:  `nitems' " , "'   ;
		
	    di as text     "{col 5}Market direction{col 30}:  `mdirec'";
	    local tnote14   `" " - Number of items:  `mdirec' " , "'   ;
	
di _n as text in white "{col 5}**************************************************************************************************";


matrix ma=(1); 

            local frm = "SCCB0 N2316 N2316";
           cap drop __compna;
        capture {;
            xml_taba2 ma , title("`xtit'")  /* lines(COL_NAMES 14 `lst1' 2 LAST_ROW 13) */  
            topnote( `tnote' `tnote2' `tnote3' `tnote4' `tnote5' `tnote6' `tnote7' `tnote8' `tnote9' `tnote10' `tnote11' `tnote12'  `tnote13'  ) 
                font("Courier New" 8) format((S2111) (`frm'))  dmat(0)
            lines(COL_NAMES 14 `nitems' 2 LAST_ROW 13)  newappend save(`xfil') sheet(General Info) replace;
        };


/*
/* Computing the price changes */
tokenize `varlist';
if ("`scen1'"=="" ) {;
if ( "`tjobs'"=="off" ) local prefix "qui" ;
`prefix' mcprc `1', 
it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10')
nitems(`nitems') mpart(`mpart') move(`move');
;
};
*/


/* Computing the price changes */
tokenize `varlist';
if ( "`tjobs'"=="off" ) local prefix "qui" ;
`prefix' mcprcne `1', 
it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10') 
nitems(`nitems') mpart(`mpart') move(`move') gscen(`gscen');
;

matrix tab1_1 = e(tab1_1);



local simula = rowsof(tab1_1) -1;
                  local maindir = "Competitive to concentrated";
if `move' == -1   local maindir = "Concentrated to competitive";
forvalues s=1/`simula' {;
if `s'==`simula' local secdir = "Full adjustement" ;
if `s' <`simula' local secdir = "Step `s'";
local  tita`s'="`maindir': `secdir'";
local stita`s'="_`secdir'";
};



forvalues i=1/`nitems' {;
matrix tab1_`i' = e(tab1_`i');
local matrices " "`matrices' "tab1_`i'" ;
};
*set trace on;

tabtitmc 11 en;
local tabtit = "`r(tabtit)'";
matrix mymat=tab1_1;
forvalues i=1/`nitems' {;
matrix  coleq tab1_`i' =  "`sn`i''" ;
local matn `matn' tab1_`i' ;
if `i'>1 matrix mymat=mymat,tab1_`i';
};


if ( "`tjobs'"~="off" )  mk_xtab_ms mymat ,     matn(`matn')  dec(4) xfil(`xfil') xshe(table_11) xtit(`tabtit') xlan(`lan')  options(showeq) dste(0);

cap matrix drop `mat`tjob`i''';

local dec11=4;
local dec12=0;
local dec13=0;

local dec21=0;
local dec22=2;
local dec23=2;

local dec31=2;
local dec32=2;
local dec33=2;


local dec41=0;
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

if `move'== 1 {;
local inlab = "Competitive  Market" ;
local filab = "Concentrated Market" ;
};
if `move'==-1 {;
local filab = "Competitive  Market" ;
local inlab = "Concentrated Market" ;
};

if ( "`tjobs'"~="off" ){;

forvalues s=1/`simula' {;
if (`gvimp' == 1) | (`gvpc' == 1)   mcjob41 `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp')  gvpc(`gvpc') move(`move') step(`s');
};
if (`move' == -1) {;
local mcolname Concentrated ;
if `mpart' >= 1 {;
forvalues i=1/`mpart' {;
local mcolname `mcolname' Step_`i' ;
}; 
};
local mcolname `mcolname' Competitive ;
};

if (`move' ==  1) {;
local mcolname Competitive  ;
if `mpart' >= 1 {;
forvalues i=1/`mpart' {;
local mcolname `mcolname'  Step_`i' ;
}; 
};
local mcolname `mcolname'  Concentrated;
};
forvalues i=1/`nitems' {;
mcjob110 _pr_`i'_*,   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1');
tempname  mat110 ; 
matrix `mat110'= e(est);
matrix colnames `mat110' = `mcolname';
local mytit = "Average prices : Item `sn`i'' ";
distable `mat110', dec(2) atit(`langr') head1(Table 1.2.`i': `mytit')  head2(`head2') ;
mk_xtab_mc `1' ,  matn(`mat110') dec(2) xfil(`xfil') xshe(table_12_`i') xtit(12_`i': `mytit') xlan(`lan') dste(0);
cap matrix drop `mat110';
};


forvalues i=1/`ntables' {;

if (`tjob`i'' == 13) {;
mcjob13 `1'        , hs(`hsize') hgroup(`hgroup') lan(en) ;
tempname mat13 ;
matrix `mat13'= e(est);
tabtitmc 13 en;
local tabtit = "`r(tabtit)'";
distable `mat13', dec1(0) dec2(0) dec3(2) dec4(0) dec5(2) dec6(2)   atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_mc `1' ,  matn(`mat13') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0) dec1(0) dec2(0) dec3(2) dec4(0) dec5(2) dec6(2) control(2);
cap matrix drop `mat`tjob`i''';
};


if (`tjob`i'' >= 21 & `tjob`i'' <= 23) {;
mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc');
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
dis as text   _col(9)  " the total of sampling weights times the average household expenditures." ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0)
note(
0 Notes: ,
0 [1]- Total expenditures at population -national- level is equal to the product of the total of sampling weights times the average of household expenditures. 
) ;
;
cap matrix drop `mat`tjob`i''';
};
};


if (`tjob`i'' >= 31 & `tjob`i'' <= 33) {;
tokenize `varlist';
mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`1');
tempname  mat`tjob`i'' ; 
matrix `mat`tjob`i'''= e(est);
tabtitmc `tjob`i''; 

if `tjob`i''==31  local tabtit Table 3.1: Structure of expenditure on products (in %) ; 
if `tjob`i''==32  local tabtit Table 3.2: Expenditure shares (in %) ;
if `tjob`i''==33  local tabtit Table 3.3: Proportion of consumers with non-nil expenditures (in %) ;

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




forvalues s=1/`simula' {;

if (`tjob`i'' == 41 ) {;
*set trace on;
mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(0) move(`move') step(`s');

tempname  mat`tjob`i''_`s' ;
matrix `mat`tjob`i''_`s''= e(est);

tabtitmc `tjob`i''; 
local tabtit = "`r(tabtit)'"+"`scena'"+" || `tita`s''";
distable `mat`tjob`i''_`s'', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''_`s'') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''_`s'';

};

if (`tjob`i'' == 42) {;
*set trace on;
mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(0) move(`move') step(`s');

tempname  mat`tjob`i''_`s' ;
matrix `mat`tjob`i''_`s''= e(est);
tabtitmc `tjob`i''; 
local tabtit = "`r(tabtit)'"+"`scena'"+" || `tita`s''";
distable2 `mat`tjob`i''_`s'', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''_`s'') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0) midline(2) ;
cap matrix drop `mat`tjob`i''_`s'';
};



if (`tjob`i'' == 43) {;
mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')  wappr(`meas') model(`model')  move(`move') step(`s');
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitmc `tjob`i''; 
local tabtit = "`r(tabtit)'"+"`scena'"+" || `tita`s''";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';
};



if (`tjob`i'' == 44) {;
*set trace on;
mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(0) move(`move') step(`s');


tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
local tabtit = "Table 4.4: Impact on per capita well-being (consumers with non-nil expenditures)";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] Statistics of Table 4.4 only concern the population of consumers with non-nil expenditures on each of the studied items;" ;
dis as text   _col(4)  " [2] Statistics of column -All items- only concern the population of consumers with non-nil expenditures on at leats one of the studied items." ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0)	midline(2) 
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
qui mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') move(`move') pline(`pline') step(`s') ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

if `tjob`i'' == 51 local tabtit = "Table 5.1: Price changes and poverty headcount";
if `tjob`i'' == 52 local tabtit = "Table 5.2: Price changes power and poverty gap";
if `tjob`i'' == 53 local tabtit = "Table 5.3: Price changes and squared poverty gap";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - `inlab'  " _col(33) ": Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - Item name" _col(33) ": Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - `filab'  " _col(33) ": Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0) 
note(
0 Notes: ,
0 "[1] - `inlab': Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - Item name                   : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - `filab': Refers to the case with price changes of all item(s)."
 ) 
;
cap matrix drop `mat`tjob`i''';

};







if (`tjob`i'' == 61 ) {;
*set trace on;

qui mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') move(`move')  step(`s');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitmc `tjob`i''; 
local tabtit = "`r(tabtit)'"+"`scena'"+" || `tita`s''";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1) ;
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - `inlab'  " _col(33) ": Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - Item name" _col(33) ": Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - `filab'  " _col(33) ": Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0)
note(
0 Notes: ,
0 "[1] - `inlab': Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - Item name                   : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - `filab': Refers to the case with price changes of all item(s)."
 ) 
 ;

cap matrix drop `mat`tjob`i''';

};


if (`tjob`i'' == 62 ) {;
*set trace on;

qui mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') move(`move')  epsilon(`epsilon')  step(`s');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitmc `tjob`i''; 
local tabtit = "`r(tabtit)'"+"`scena'"+" || `tita`s''";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1) ;
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - `inlab'  " _col(33) ": Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - Item name" _col(33) ": Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - `filab'  " _col(33) ": Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0)
note(
0 Notes: ,
0 "[1] - `inlab': Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - Item name                   : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - `filab': Refers to the case with price changes of all item(s)."
 ) 
;


cap matrix drop `mat`tjob`i''';

};


if (`tjob`i'' == 63 ) {;
*set trace on;

qui mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') move(`move')  theta(`theta')  step(`s');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitmc `tjob`i''; 
local tabtit = "`r(tabtit)'"+"`scena'"+" || `tita`s''";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - `inlab'  " _col(33) ": Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - Item name" _col(33) ": Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - `filab'  " _col(33) ": Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0)
note(
0 Notes: ,
0 "[1] - `inlab': Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - Item name                   : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - `filab': Refers to the case with price changes of all item(s)."
 ) 
;

cap matrix drop `mat`tjob`i''';

};

if (`tjob`i'' == 64 ) {;
*set trace on;

qui mcjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') move(`move')  step(`s');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtitmc `tjob`i''; 
local tabtit = "`r(tabtit)'"+"`scena'"+" || `tita`s''";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(Step) head1(`tabtit')  head2(`head2') dsmidl(1);
dis as result _col(4) " Notes:";
dis as text   _col(4)  " [1] - `inlab'  " _col(33) ": Refers to the base line case (the case before price changes);" ;
dis as text   _col(4)  " [2] - Item name" _col(33) ": Refers to the case with only the price change of the item of interest;  " ;
dis as text   _col(4)  " [3] - `filab'  " _col(33) ": Refers to the case with price changes of all item(s)."  ;
mk_xtab_mc `1' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''`stita`s'') xtit(`tabtit') xlan(`lan') dste(0)
note(
0 Notes: ,
0 "[1] - `inlab': Refers to the base line case `('the case before price changes`)';"  , 
0 "[2] - Item name                   : Refers to the case with only the price change of the item of interest;" ,
0 "[3] - `filab': Refers to the case with price changes of all item(s)."
 ) 
;

cap matrix drop `mat`tjob`i''';

};
};

};
};

*set trace on;

/********* The graphs *********************/

cap rmdir Graphs;
cap mkdir Graphs;
local mygrdir Graphs\ ;

if ( "`gjobs'"~="off" ){;
forvalues i=1/`ngraphs' {;
set matsize 800;
if ("`gjob`i''" == "1" ) {;
*set trace on;
set tracedepth 1;
tokenize `varlist';

qui  mcprcne `1', 
it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10') 
nitems(`nitems') mpart(100) move(`move') gscen(0);
;
;
;



if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;

 qui mcjobgr`gjob`i'' `1',   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''') nitems(`nitems') 
 it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10')
 ;

 qui graph save           "`mygrdir'Fig_`gjob`i''.gph" , replace ;
 qui graph export         "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
 qui cap graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
 
 qui mcprcne `1', 
it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10') 
nitems(`nitems') mpart(`mpart') move(`move') gscen(`gscen');
;
;

forvalues j=1/`nitems' {;
matrix tab1_`j' = e(tab1_`j');
};
};

if ("`gjob`i''" == "2" ) {;
*set trace on;
set tracedepth 1;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;

qui mcjobgr`gjob`i'' `vlist',   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''') min(`min`gjob`i''') max(`max`gjob`i''')   ;

 qui graph save           "`mygrdir'Fig_`gjob`i''.gph" , replace ;
 qui graph export         "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
 qui cap graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
};

if ("`gjob`i''" == "3" ) {;
*set trace on;
set more off;
set tracedepth 2;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;
 mcjobgr`gjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''')  min(`min`gjob`i''') max(`max`gjob`i''')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') move(`move');
qui graph save       "`mygrdir'Fig_`gjob`i''.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
};

if ("`gjob`i''" == "4" ) {;
*set trace on;
qui mcjobgr`gjob`i'' `vlist',   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''')  min(`min`gjob`i''') max(`max`gjob`i''')  ;
qui graph save       "`mygrdir'Fig_`gjob`i''.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;

};



if ("`gjob`i''" == "5" ) {;
*set trace on;
set tracedepth 3;
tokenize `varlist';

qui  mcprcne `1', 
it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10') 
nitems(`nitems') mpart(20) move(`move') gscen(0);
;
;
;

forvalues j=1/`nitems' {;
matrix tab1_`j' = e(tab1_`j');
};

if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;

qui mcjob51b `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') move(`move') pline(`pline') nitems(`nitems');
matrix gmat = e(gmat);

 

  mcjobgr`gjob`i'' `1',   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''') nitems(`nitems') 
 it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10')
 ;
 

 qui graph save           "`mygrdir'Fig_`gjob`i''.gph" , replace ;
 qui graph export         "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
 qui cap graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
 
 
 
 qui  mcprcne `1', 
it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10') 
nitems(`nitems') mpart(`mpart') move(`move') gscen(`gscen');
;
;


};



if ("`gjob`i''" == "6" ) {;
*set trace on;
set tracedepth 3;
tokenize `varlist';
qui mcprcne `1', 
it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10') 
nitems(`nitems') mpart(20) move(`move') gscen(0);
;


forvalues j=1/`nitems' {;
matrix tab1_`j' = e(tab1_`j');
};

if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;

qui mcjob61b `vlist',   hs(`hsize') hgroup(`hgroup') lan(en)  xrnames(`slist')  aggr(`taggregate') pcexp(`1')   wappr(`meas') model(`model') subs(`subs')  gvimp(`gvimp') move(`move') nitems(`nitems');
matrix gmat = e(gmat);


 mcjobgr`gjob`i'' `1',   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`1') ogr(`ogr`gjob`i''') nitems(`nitems') 
 it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10')
 ;
 
 
 qui graph save           "`mygrdir'Fig_`gjob`i''.gph" , replace ;
 qui graph export         "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
 qui cap graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
 
 
 
 qui  mcprcne `1', 
it1(`it1')  it2(`it2')  it3(`it3')  it4(`it4')  it5(`it5')
it6(`it6')  it7(`it7')  it8(`it8')  it9(`it9')  it10(`it10') 
nitems(`nitems') mpart(`mpart') move(`move') gscen(`gscen');
;


forvalues j=1/`nitems' {;
matrix tab1_`j' = e(tab1_`j');
};
};


};

};


if ( "`tjobs'"~="off" ) {;

cap drop __nevar*;
if  ("`xfil'" ~= "" &  "`tjobs'"~="off" ) | ("`xfil'" ~= "" ) {;
di as txt `"(output written to {browse `xfil'})"' ; 
};

};
  

cap drop __VNITEMS ; 
cap drop __SLITEMS ; 
cap drop __imp_well ;
cap drop _pr_*;

end;

