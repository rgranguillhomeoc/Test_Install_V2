


#delim ;
cap program drop fractwo;
program define fractwo, rclass;
syntax anything, [ nlist(string) clen(int 16)];
quietly {;
local k = 1;
mac shift;
while "``k''" ~= "" {; 
local k = `k'+1;
};
};
tokenize `nlist';
local part2 = "";
local tmp = length("`1'");
local pos=1;
while (`tmp'<`clen' & `pos'<=`k')  {;
local tt = length("``pos''");
local tmp = `tmp' + `tt' ;
local part1 = "`part1'"+" ``pos''";
local pos=`pos'+1;

};

if (`pos'<=`k' & `k'!=1) {;
forvalues i=`pos'/`k' {;
local part2 = "`part2'"+" ``i''";
};
};
return local part1  "`part1'" ;
return local part2  "`part2'" ;
end;



cap program drop distable2;
program define distable2;
version 9.2;
syntax namelist(min=1 max=1) [, MATRIX(string) DEC(int 3) DEC1(string) DEC2(string) DEC3(string) DEC4(string) DEC5(string) DEC6(string) 
FCLEN(int 16) CLEN(int 16) ATIT(string) HEAD1(string) HEAD2(string) dsmidl(int 0)
 COLTIT1(varname) 
 COLTIT2(varname) 
 COLTIT3(varname) 
 ROWTIT(varname) ];
tempname table;
tokenize `namelist';	
local ncol = colsof(`1');

tempname mym ;
if `ncol'  > 13   matrix `mym' = `1'';
if `ncol' <= 13   matrix `mym' = `1';
local ncol = colsof(`mym');
local nrow = rowsof(`mym');
local ncol1 = `ncol'+1;	
.`table'  = ._tab.new, col(`ncol1');


forvalues i = 1/`nrow' {;
tempname TEMPORARY;
matrix `TEMPORARY'=`mym'[`i'..`i',1..1];
local rnam`i': rownames `TEMPORARY';
local tt = length("`rnam`i''");
local fclen = max(`tt',`fclen');
};

local line3 .`table'.strcolor  yellow ;
local luna1 .`table'.strcolor  yellow ;
local luna2 .`table'.strcolor  green ;
local line5   ;
forvalues i = 1/`ncol' {;
local line3 `line3' yellow;
local luna1 `luna1' yellow ;
local luna2 `luna2' green  ;
};	
local line5   ".`table'";
local line5 `line5'.titles;
local line55   ".`table'";
local line55 `line55'.titles;
if "`coltit3'" ~="" {;
local line555   ".`table'";
local line555 `line555'.titles;
};
local temp = "`atit' ";
local line5  `"`line5'  "`temp'" "' ;
local temp = "";
local line55  `"`line55'  "`temp'" "' ;
if "`coltit3'" ~="" {;
local temp = "";
local line555  `"`line555'  "`temp'" "' ;
};
tempname mymat;
local ll=10;
forvalues i = 1/`ncol' {;
tokenize `namelist';
tempname TEMPORARY;
matrix `TEMPORARY'=`mym'[1..1,`i'..`i'];
local cnam`i': colnames `TEMPORARY';
local rnam`i': rownames `TEMPORARY';

fractwo 16, nlist(`cnam`i'');
local spart1 = "`r(part1)'" ;
local spart2 = "`r(part2)'" ;
if "`coltit1'" == "" {;
local line5  `"`line5'   "`spart1'" "' ;
local line55 `"`line55'  "`spart2'" "' ;
};

if "`coltit1'" ~= "" {;
local spart1 = `coltit1'[`i'];
local spart2 = `coltit2'[`i'];
if "`coltit3'" ~="" local spart3 = `coltit3'[`i'];
local line5  `"`line5'   "`spart1'" "' ;
local line55 `"`line55'  "`spart2'" "' ;
if "`coltit3'" ~="" local line555 `"`line555'  "`spart3'" "' ;
};

local l1= length("`spart1'");
local l2= length("`spart2'");
local l3=0 ;
if "`coltit3'" ~="" local l3= length("`spart3'");

local hd2=`hd2'+`l2';
local clen`i' = max(16,max(`l1',`l2',`l3'));
};
local line4  .`table'.numfmt %-`fclen'.0g  ;
local line44 .`table'.strfmt %-16s  ;
forvalues i = 1/`ncol' {;
if "`dec`i''" ~="" local decef=`dec`i'';
if "`dec`i''" =="" local decef=`dec';
local line4 `line4' %16.`decef'f;
local line44 `line44' %-16s;
};

local line2 .`table'.width  | `fclen';
local line2 `line2' |;
forvalues i = 1/`ncol' {;
local line2 `line2'  `clen`i'' |;
};	


tokenize `namelist' ;
`line2'; 
`line3'; 
`line4'; 
`line44'; 	
if ("`head1'" ~= "" ) di _n as text "{col 4} `head1'";
if ("`head2'" ~= "" ) di _n as text "{col 4} `head2'";
.`table'.sep, top;
`line5'; 
if (`hd2'!=0) `line55'; 
if "`coltit3'" ~="" {;
`line555'; 
};
.`table'.sep, mid;
forvalues i = 1/`nrow' {;
tempname TEMPORARY;
matrix `TEMPORARY'=`mym'[`i'..`i',1..1];
local rnam`i': rownames `TEMPORARY';
local line6 .`table'.row "`rnam`i''" ;
if (`i'== 2 & `dsmidl' == 1) .`table'.sep, mid;
forvalues j = 1/`ncol' {;
local line6 `line6' el(`mym',`i',`j');
};
local zz= `nrow'-1;
if (`i'==`zz') .`table'.sep, mid;

if  (`i'/2!=round(`i'/2)) `luna1';
if !(`i'/2!=round(`i'/2)) `luna2';

`line6'; 
};
.`table'.sep,bot;
 end;
 

