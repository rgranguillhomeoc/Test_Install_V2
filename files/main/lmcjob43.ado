


#delimit;
capture program drop lmcjob43;
program define lmcjob43, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  WAPPR(int 1) MODEL(int 1) GVIMP(int 0) SUBS(real 0.4) MOVE(int 1) ];


lmcjobstat `varlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  pcexp(`pcexp') stat(share_tot_exp) rtot(Population) ;
tempname mat43 ;
matrix `mat43'= e(est);
local rowsize = rowsof(`mat43');
local colsize = colsof(`mat43')-1 ;
matrix `mat43' = `mat43'[1..`rowsize', 1..`colsize'];
ereturn matrix est = `mat43';

cap sum _*;
end;



