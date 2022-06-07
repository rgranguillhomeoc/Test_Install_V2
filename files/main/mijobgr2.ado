
#delimit;
capture program drop mijobgr2;
program define mijobgr2, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname)  PCEXP(varname) MIN(real 0) MAX(real 1000) OGR(string) ];
migropt 2 en ;
curvnpe `varlist', xvar(`pcexp') hsize(`hsize') 
title(`r(gtitle)')  
xtitle(`r(gxtitle)')
ytitle(`r(gytitle)') 
`r(gstyle)' 
rtype(prc)
min(`min')
max(`max')
`ogr'
  ;

end;


