

#delimit;
capture program drop lmcjob51;
program define lmcjob51, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) AEHS(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname) IPSCH(varname)  FPSCH(varname) PLINE(varname) WAPPR(int 1)];

aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
lmcjobpov `flist',   hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp')  pline(`pline') ;
cap drop `drlist';
tempname mat51 ;
matrix `mat51'= e(est);
ereturn matrix est = `mat51';

end;







