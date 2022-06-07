

#delimit;
capture program drop lmcjob61;
program define lmcjob61, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname)  HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname) IPSCH(varname)  FPSCH(varname) PLINE(varname) WAPPR(int 1)];

aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
lmcjobgini `flist',   hs(`hsize')   lan(`lan')   xrnames(`slist')  pcexp(`pcexp')   ;
cap drop `drlist';
tempname mat61 ;
matrix `mat61'= e(est);
ereturn matrix est = `mat61';

end;







