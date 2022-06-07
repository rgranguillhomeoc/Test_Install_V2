


#delimit;
capture program drop prijob5a;
program define prijob5a, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  WAPPR(int 1) MODEL(int 1) GVIMP(int 0) SUBS(real 0.4)  PLINE(string) MATPEL(string) MATIEL(string) SOTM(int 1) NT(int 51)];

aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
if `nt' == 51 prjobpov `flist',    hs(`hsize') aehs(`aehs')  lan(`lan')    xrnames(`slist')   pcexp(`pcexp') alpha(0)  pline(`pline') ;
if `nt' == 52 prjobpov `flist',    hs(`hsize') aehs(`aehs')  lan(`lan')    xrnames(`slist')   pcexp(`pcexp') alpha(1)  pline(`pline') ;
if `nt' == 53 prjobpov `flist',    hs(`hsize') aehs(`aehs')  lan(`lan')    xrnames(`slist')   pcexp(`pcexp') alpha(2)  pline(`pline') ;
tempname mat ;
matrix `mat'= e(est);
ereturn matrix est = `mat';
end;



