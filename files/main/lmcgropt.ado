
#delimit ;
capture program drop lmcgropt;
program define lmcgropt, rclass sortpreserve;
version 9.2;
args ngr lan;

/* FIGURE 01 */ 
 local style_gr1
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(11) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ;
   


local  title_en_gr1 Figure 01: The per capita impact on well-being;
local xtitle_en_gr1 Percentiles (p);
local ytitle_en_gr1 The impact(s) per capita; 



/* FIGURE 02 */ 
 local style_gr2
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(11) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ; 
 
   

local  title_en_gr2 Figure 02: The Lorenz and concentration curves;
local xtitle_en_gr2 The percentiles (p);
local ytitle_en_gr2 Lorenz and concentration curves;

/*
 /* FIGURE 05 */ 
 
 local style_gr5 
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  title(,size(small))
  scheme(s2mono)
  subtitle("")
   ;
   
local  title_en_gr5 Figure 05: Market power and poverty headcount ;


 /* FIGURE 06 */ 
 
 local style_gr6 
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  title(,size(small))
  scheme(s2mono)
  subtitle("")
   ;
   
local  title_en_gr6 Figure 06: Market power and inequality ;
*/
return local gtitle `title_`lan'_gr`ngr'';
return local gxtitle `xtitle_`lan'_gr`ngr'';
return local gytitle `ytitle_`lan'_gr`ngr'';
return local gstyle `style_gr`ngr'';

end;
