
#delimit;
capture program drop mijobgr3;
program define mijobgr3, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) PCEXP(varname) OGR(string)  *];



migropt 3 en ;
local glegend legend(order( 1 "45° line"  2 "L(p): Lorenz" 3 "C(p): Concentration curve")); 


clore `pcexp' `varlist', rank (`pcexp') hsize(`hsize') 
title(`r(gtitle)')  
xtitle(`r(gxtitle)')
ytitle(`r(gytitle)') 
`glegend'
`r(gstyle)' 
`ogr'
  ;
cap drop `glist';

end;


