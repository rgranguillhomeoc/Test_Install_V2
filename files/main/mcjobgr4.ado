
#delimit;
capture program drop mcjobgr4;
program define mcjobgr4, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string) AGGRegate(string) PCEXP(varname) OGR(string)  *];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist = r(slist);
local  flist = r(flist);
local drlist = r(drlist);





local glegend legend(order( ;
local glegend `"`glegend' 1 "ligne de 45°""';
local glegend `"`glegend' 2 "L(p): Lorenz""';
if ("`slist'"~="") {;
local xrna  "`slist'";
local xrna : subinstr local xrna " " ",", all ;
local xrna : subinstr local xrna "|" " ", all ;
local count : word count `xrna';
tokenize "`xrna'";
forvalues i = 1/`count' {;
local j = `i'+2;
	local `i': subinstr local `i' "," " ", all ;
	local glegend `"`glegend' `j' "C(p): ``i''""';
	
};

};

local glegend `"`glegend' ))"';

mcgropt 4 `lan' ;

clore `pcexp' `flist', rank (`pcexp') hsize(`hsize') 
title(`r(gtitle)')  
xtitle(`r(gxtitle)')
ytitle(`r(gytitle)') 
`glegend'
`r(gstyle)' 
`ogr'
  ;
cap drop `glist';

end;


