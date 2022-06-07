


#delimit;
capture program drop lmcjob42;
program define lmcjob42, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  WAPPR(int 1) MODEL(int 1) GVIMP(int 0) SUBS(real 0.4) MOVE(int 1) ];


lmcjobstat `varlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  stat(exp_pc) rtot(Population) ;
tempname mat42 ;
matrix `mat42'= e(est);
local rowsize = rowsof(`mat42');
local colsize = colsof(`mat42')-1 ;
matrix `mat42' = `mat42'[1..`rowsize', 1..`colsize'];
ereturn matrix est = `mat42';

cap sum _*;
end;



