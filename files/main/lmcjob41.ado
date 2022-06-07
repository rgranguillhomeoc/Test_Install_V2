


#delimit;
capture program drop lmcjob41;
program define lmcjob41, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  WAPPR(int 1) MODEL(int 1) GVIMP(int 0) SUBS(real 0.4) MOVE(int 1) ];


lmcjobstat `varlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  stat(exp_tt) rtot(Population) ;
tempname mat41 ;
matrix `mat41'= e(est);
local rowsize = rowsof(`mat41');
local colsize = colsof(`mat41')-1 ;
matrix `mat41' = `mat41'[1..`rowsize', 1..`colsize'];
ereturn matrix est = `mat41';

cap sum _*;
end;



