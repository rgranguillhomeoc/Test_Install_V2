

#delimit;
capture program drop lmcjob63;
program define lmcjob63, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname)  HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname) THETA(real 0.5)  ];

aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
lmcjobentropy `flist',   hs(`hsize')   lan(`lan')   xrnames(`slist')  pcexp(`pcexp') theta(`theta')    ;
cap drop `drlist';
tempname mat63 ;
matrix `mat63'= e(est);
ereturn matrix est = `mat63';

end;







