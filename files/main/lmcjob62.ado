

#delimit;
capture program drop lmcjob62;
program define lmcjob62, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname)  HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname) EPSILON(real 0.5)  ];

aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
lmcjobatk `flist',   hs(`hsize')   lan(`lan')   xrnames(`slist')  pcexp(`pcexp')  epsilon(`epsilon')  ;
cap drop `drlist';
tempname mat62 ;
matrix `mat62'= e(est);
ereturn matrix est = `mat62';

end;







