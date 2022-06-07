
#delimit;
capture program drop lmcjobgr1;
program define lmcjobgr1, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string) AGGRegate(string) PCEXP(varname) MIN(real 0) MAX(real 1000) OGR(string)   *];
tokenize  `varlist';
_nargs    `varlist';

lmcgropt 1 `lan' ;
curvnpe `varlist', xvar(`pcexp') hsize(`hsize') 
title(`r(gtitle)')  
xtitle(`r(gxtitle)')
ytitle(`r(gytitle)') 
`glegend'
`r(gstyle)' 
min(`min')
max(`max')
`ogr'

  ;
  
 
cap drop `glist';
end;


