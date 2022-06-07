
#delimit;
capture program drop mcjobgr1;
program define mcjobgr1, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string) AGGRegate(string) PCEXP(varname) MIN(real 0) MAX(real 1000) OGR(string) 
IT1(string) IT2(string)  IT3(string)  IT4(string) IT5(string)  
IT6(string) IT7(string)  IT8(string)  IT9(string) IT10(string)
NITEMS(int 1)  *];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist = r(slist);
local  flist = r(flist);
local drlist = r(drlist);
tokenize `flist';
_nargs   `flist';

forvalues i=1/$indica {;
tempvar s_`i';
gen `s_`i''  = ``i'' / `pcexp';
local glist `glist' `s_`i'' ;
};


local mylist sn vn el st nf si;
forvalues i=1/`nitems' {;
extend_opt_item_mcwel test , `it`i'' ;
foreach name of local mylist {;
local `name'`i'  `r(`name')';

if  "`name'"~="sn" & "`name'"~="it"  & "``name'`i''"=="" local `name'`i' = 0 ;
/*
if  "``name'`i''"=="." local `name'`i' = "" ;
dis "`name'`i' = ``name'`i'' ";
*/
                   
			   
if "`name'"=="st" {;
                   local ytit_`i' = "Market power  (market size in %)";
if `st`i'' == 2    local ytit_`i' = "Market power  (Number of firms)";
 };
};
};


forvalues i=1/`nitems' {;
matrix tab1_`i' = e(tab1_`i');
cap drop __xx_`i'_*;
qui svmat tab1_`i' , names(__xx_`i'_) ;
};



local glegend legend(order( ;
if ("`slist'"~="") {;
local xrna  "`slist'";
local xrna : subinstr local xrna " " ",", all ;
local xrna : subinstr local xrna "|" " ", all ;
local count : word count `xrna';
tokenize "`xrna'";
forvalues i = 1/`count' {;
	local `i': subinstr local `i' "," " ", all ;
	local glegend `"`glegend' `i' "``i''""';
	local tita_`i' = "``i''";
	
};

};

local glegend `"`glegend' ))"';


forvalues it=1/`nitems' {;
mcgropt 1 en ;
set graphics off;
qui line __xx_`it'_3 __xx_`it'_1 , 
title(`tita_`it'')  
ytitle(Price (competitive market = 1))

`glegend'
`r(gstyle)' 
`ogr'

xtitle(`ytit_`it'') 
;
qui gr save mygr_`it' , replace;
local graphs `graphs' mygr_`it'.gph;
};
set graphics on;
mcgropt 1 en;
graph combine `graphs', col(2)  title(`r(gtitle)') `r(gstyle)' 
;

cap drop `glist';

forvalues i=1/`nitems' {;
cap drop __xx_`i'_*;
};


end;


