

#delimit;
capture program drop lmcjob64;
program define lmcjob64, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname)  HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  ];

aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
lmcjobratio `flist',   hs(`hsize')   lan(`lan')   xrnames(`slist')  pcexp(`pcexp')    ;
cap drop `drlist';
tempname mat64 ;
matrix `mat64'= e(est);
ereturn matrix est = `mat64';

end;







