

#delimit;
capture program drop lmcjob52;
program define lmcjob52, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) AEHS(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname) IPSCH(varname)  FPSCH(varname) PLINE(varname) WAPPR(int 1)];

aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
lmcjobpov `flist',   hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp')  pline(`pline') alpha(1) ;
cap drop `drlist';
tempname mat52 ;
matrix `mat52'= e(est);
ereturn matrix est = `mat52';

end;







