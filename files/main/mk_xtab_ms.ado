
#delim ;
capture program drop mk_xtab_ms;
program define mk_xtab_ms, rclass;
version 9.2;
syntax anything [,  matn(string) dste(int 1) dec(int 3) dec1(int 6) dec2(int 6) dec3(int 6) dec4(int 6) dec5(int 6) dec6(int 6)
 xfil(string) xshe(string) xtit(string)  xlan(string) hsep(int 0) topnote(string)  topnote(string) note(string) add(string) options(string) ];

tokenize `matn';
local ncol = colsof(`1');
local nrow = rowsof(`1');

tempname mym ;
if `ncol'  > 13   matrix `mym' = `1'';
if `ncol' <= 13   matrix `mym' = `1';





forvalues i=1/30 {;
if (`dste' ==  1)    local frm =  "`frm'"+" SCCB0 N231`dec' N232`dec' ";
if (`dste' !=  1)    local frm =  "`frm'"+" (N231`dec')  ";
};

if (`dste' ==  1)  local lst1 = rowsof(`mym')-2 ;
if (`dste' ==  0)  local lst1 = rowsof(`mym')-1;
/*
local frm = "";
forvalues i=1/`nrow' {;
if ("`dec`i''"~="") local frm = "`frm'"+" N231`dec`i'' "; 
if ("`dec`i''"=="") local frm = "`frm'"+" N231`dec' "; 
};
*/

local lst1 `lst1' 2 ;

if (`dste' == -1)  {;
 local lst1 = "";
 };


if ("`add'"=="")       local op1= "newappend";
if ("`add'"=="append") local op1= "append";
xml_tabas 
`matn',
title("`xtit'")  
lines(COL_NAMES 30  LAST_ROW 13)  
topnote(`topnote')
notes( "`note1'" ,  "`note'")
font("Courier New" 8)
format((S2111) `frm') 
 `op1' `options' save(`xfil') sheet(`xshe')
;
end;

