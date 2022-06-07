
#delimit;
capture program drop mcjobgr2;
program define mcjobgr2, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string) AGGRegate(string) PCEXP(varname) MIN(real 0) MAX(real 1000) OGR(string)  *];
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
	
};

};

local glegend `"`glegend' ))"';



mcgropt 2 `lan' ;
curvnpe `glist', xvar(`pcexp') hsize(`hsize') 
title(`r(gtitle)')  
xtitle(`r(gxtitle)')
ytitle(`r(gytitle)') 
`glegend'
`r(gstyle)' 
min(`min')
max(`max')
`ogr'
mult(100)

  ;
  
 
cap drop `glist';
end;


