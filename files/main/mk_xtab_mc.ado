
#delim ;
capture program drop mk_xtab_mc;
program define mk_xtab_mc, rclass;
version 9.2;
syntax anything [,  matn(string) dste(int 1) dec(int 6) dec1(int 6) dec2(int 6) dec3(int 6) dec4(int 6) dec5(int 6) dec6(int 6) control(int 1) midline(int 1)
 xfil(string) xshe(string) xtit(string)  xlan(string) hsep(int 0)  topnote(string) note(string) add(string) options(string) ceq1(string)];


local ncol = colsof(`matn');
tempname mym ;
if `ncol'  > 13   matrix `mym' = `matn'';
if `ncol' <= 13   matrix `mym' = `matn';

if (`dste' == 1)                  local note1 = "[-] Standard errors are in italics.";
if (`dste' == 1 & "`xlan'"=="fr") local note1 = "[-] Les erreurs types sont en format italique.";
if (`dste' == 1 & "`xlan'"=="fr") local note1 = "[-] Les erreurs types sont en format italique.";

local ncols  = colsof(`mym');
forvalues i=1/`ncols' {;
if (`dste' ==  1)    local frm =  "`frm'"+" SCCB0 n220`dec' n222`dec' ";
if (`dste' !=  1)    local frm =  "`frm'"+" (n220`dec')  ";
};


if (`dste' ==  1)     local lst1 = rowsof(`mym')-2 ;
if (`dste' ==  0)     local lst1 = rowsof(`mym')-1;
if (`midline' ==  2)  local lst1 = rowsof(`mym')-2;
if (`midline' ==  0)  local lst1 = 0;

if (`control' == 2) {;
local frm = "";
forvalues i=1/6 {;
if ("`dec`i''"~="") local frm = "`frm'"+"  ncrr`dec`i'' "; 
if ("`dec`i''"=="") local frm = "`frm'"+"  ncrr`dec`i'' "; 
};
};


local lst1 `lst1' 2 ;

if (`dste' == -1)  {;
 local lst1 = "";
 };


if ("`add'"=="")       local op1= "newappend";
if ("`add'"=="append") local op1= "append";
if ("`add'"=="replace") local op1= "replace";
if ("`ceq1'"=="") local cn1  COL_NAMES 14 ;
if ("`ceq1'"~="") local cn1 SCOL_NAMES 13 ;
xml_taba2 
`mym',
title("`xtit'")  
lines(`cn1' `lst1' LAST_ROW 13)  
topnote(`topnote')
notes(`note')
font("Cambria" 10) 
format((S2111)  `frm') 
 `op1' `options' save(`xfil') sheet(`xshe') ceq1(`ceq1');



end;

