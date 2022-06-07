

#delimit;
capture program drop lmcjob33;
program define lmcjob33, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
tempname mat33 ;
lmcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(`pcexp')  stat(exp_pcgz)  rtot(Population) ;
matrix `mat33'= e(est);
local rowsize = rowsof(`mat33');
local colsize = colsof(`mat33')-1 ;
matrix `mat33' = `mat33'[1..`rowsize', 1..`colsize'];
ereturn matrix est = `mat33';
cap drop `drlist';

end;



