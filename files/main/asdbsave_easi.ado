

#delimit ;

capture program drop asdbsave_easi;
program define asdbsave_easi, rclass sortpreserve;
version 9.2;
version 9.2;
syntax namelist (min=1) [,  
EXPenditure(varlist min=1 max=1 numeric) 		
PRices(varlist numeric)								
demographics(varlist numeric)						  
RTool(string)
power(int 5)
INPY(int 0)
INPZ(int 0)
INZY(int 0)
DEC(int 4)
SNames(string)
INISave(string) 
xfil(string) 
dislas(int 1) 
dregres(int 0) 
];


tokenize "`inisave'" ,  parse(".");
local inisave = "`1'";
    

local mylist secp pr;

   tokenize `namelist';
   cap file close myfile;
   tempfile  myfile;
   cap erase "`inisave'.sr_easi" ;
   file open myfile   using "`inisave'.easi", write replace ;
   if ("`inisave'"~="")  file write myfile `".sr_easi_dlg.main.dbsamex.setvalue "`inisave'""' _n;
   file write myfile `".sr_easi_dlg.main.name_items.setvalue "`namelist'""' _n;
   
    if ("`snames'"~="")           file write myfile `".sr_easi_dlg.main.name_snames.setvalue "`snames'""' _n;
    if ("`expenditure'"~="")      file write myfile `".sr_easi_dlg.main.vn_hhexp.setvalue "`expenditure'""' _n;
	if ("`demographics'"~="")     file write myfile `".sr_easi_dlg.main.vl_inddemo.setvalue  "`demographics'""' _n;
	if ("`prices'"~="")           file write myfile `".sr_easi_dlg.main.name_prices.setvalue  "`prices'""' _n;
	if ("`power'"~="")            file write myfile `".sr_easi_dlg.main.sp_pow.setvalue  `power'"' _n;
	if ("`dregres'"=="1")         file write myfile `".sr_easi_dlg.resop.ck_dregres.seton "' _n; 
	 if ("`dislas'"=="1")         file write myfile `".sr_easi_dlg.resop.ck_dislas.seton "' _n; 
    if ("`inpy'"=="1")            file write myfile `".sr_easi_dlg.main.ck_inpy.seton "' _n;
	if ("`inpz'"=="1")            file write myfile `".sr_easi_dlg.main.ck_inpz.seton "' _n;
	if ("`inzy'"=="1")            file write myfile `".sr_easi_dlg.main.ck_inzy.seton "' _n;
   

   
   
   if ("`rtool'"~="") {;
   file write myfile `".sr_easi_dlg.main.drtool.setvalue "`rtool'""' _n;
   };
   
  if ("`dec'"   ~="")             file write myfile `".sr_easi_dlg.resop.sp_dec.setvalue "`dec'""' _n;
 
   if ("`xfil'"~="") {;
   file write myfile `".sr_easi_dlg.resop.eldecfile.setvalue "`xfil'""' _n;
   };

 /* file write myfile `"cap use `nfile' , replace"'  _n; */
 

 file close myfile;







end;

