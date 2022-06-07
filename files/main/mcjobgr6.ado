
#delimit;
capture program drop mcjobgr6;
program define mcjobgr6, eclass;
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

local nitems1 = `nitems';

cap drop __xx*;
forvalues v=1/`nitems' {;
qui svmat tab1_`v' , names(__xx_`v'_) ;
};

cap drop __yy*;
qui svmat gmat , names(__yy) ;




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
local glegend2 `"`glegend' ) region(fcolor(none)  margin(zero))  bmargin(zero)  bexpand position(0) )"';
local glegend `"`glegend' ))"';

 
forvalues it=1/`nitems' {;
local n__xxx `n__xxx' __xxx ;

if `st`it'' != 2 local list1 `list1' __xx_`it'_1 ;
if `st`it'' == 2 local list2 `list2' __xx_`it'_1 ;
}; 
forvalues it=1/`nitems' {;
mcgropt 1 en ;
set graphics off;
qui line __yy`it' __xx_`it'_1 , 
title(`tita_`it'')  
ytitle(Inequality level (Gini))

`glegend'
`r(gstyle)' 
 ylabel(, angle(horizontal) labsize(2.1))
`ogr'

xtitle(`ytit_`it'') 
;
qui gr save mygr_`it' , replace;
local graphs `graphs' mygr_`it'.gph;
};
if `nitems'>1 {;
local pall = `nitems'+1; 
cap drop _steps;
gen _steps = _n-1;
mcgropt 1 en ;
set graphics off;
local nrows = rowsof(tab1_1);
qui line __yy`pall' _steps  	in 1/`nrows', 
title("All items")  
ytitle(Poverty level (Headcount))

`glegend'
`r(gstyle)' 
 ylabel(, angle(horizontal) labsize(2.1))
`ogr'

xtitle(Steps) 
;
qui gr save mygr_`pall' , replace;

local graphs `graphs' mygr_`pall'.gph;


mcgropt 1 en ;
set graphics off;

if "`list1'" ~="" & "`list2'" ~="" {;
qui twoway 
(line `list1' _steps  	in 1/`nrows', 
title("Steps and market power")  
ytitle(Market size (in%))

legend(off)
`r(gstyle)' 
`ogr'
xtitle(Steps) 
)||
(line `list2' _steps  	in 1/`nrows', yaxis(2)
title("Steps and market power")  
ytitle(Number of firms, axis(2)) 
 legend(pos(1) ring(0) col(1) size(2.4) symxsize(8))
)
;
};


if "`list1'" ~="" & "`list2'" =="" {;
qui twoway 
(line `list1' _steps  	in 1/`nrows', 
title("Steps and market power")  
ytitle(Market size (in%))

legend(off)
`r(gstyle)' 
`ogr'
xtitle(Steps) 
)
;
};


if "`list1'" =="" & "`list2'" ~="" {;
qui twoway 
(line `list2' _steps  	in 1/`nrows', yaxis(2)
title("Steps and market power")  
ytitle(Number of firms, axis(2)) 
 legend(pos(1) ring(0) col(1) size(2.4) symxsize(8))
 legend(off)
`r(gstyle)' 
`ogr'
xtitle(Steps) 
)
;
};


qui gr save mygr_`step' , replace;


cap drop __xxx;
qui gen __xxx=.;
twoway 
(line	`n__xxx' __xxx) 
 in 1/2, 
 yscale(off) 
 ylabel(none) 
 xscale(off)	

legend(cols(1))
`glegend2'
scheme(s2mono)
graphregion(fcolor(white) ifcolor(white))
;


qui gr save leg_`step' , replace;
cap drop __xxx;
 
local graphs mygr_`step'.gph leg_`step'.gph `graphs' ;



};

cap drop _steps;
set graphics on;
mcgropt 6 en;
graph combine `graphs', col(2)  title(`r(gtitle)') `r(gstyle)' 
;

cap drop `glist';

forvalues i=1/`nitems' {;
cap drop __xx* __yy*;
};


end;


