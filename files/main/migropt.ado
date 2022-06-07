
#delimit ;
capture program drop migropt;
program define migropt, rclass sortpreserve;
version 9.2;
args ngr lan;

 #delimit ;
/* FIGURE 01 */ 
 
 local style_gr1 
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(1) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ;
   


local  title_en_gr1 Figure 01: The expenditures on the product with concentration market to the total expenditures (%) ;
local xtitle_en_gr1 Percentiles (p);
local ytitle_en_gr1 The expenditure shares; 

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
   


local  title_en_gr2 Figure 02: The per capita impact on well-being;
local xtitle_en_gr2 Percentiles (p);
local ytitle_en_gr2 The total benefits per capita; 



/* FIGURE 03 */ 
 local style_gr3
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
 
   

local  title_en_gr3 Figure 03: The Lorenz and concentration curves;
local xtitle_en_gr3 The percentiles (p);
local ytitle_en_gr3 Lorenz and concentration curves;


return local gtitle `title_`lan'_gr`ngr'';
return local gxtitle `xtitle_`lan'_gr`ngr'';
return local gytitle `ytitle_`lan'_gr`ngr'';
return local gstyle `style_gr`ngr'';

end;
