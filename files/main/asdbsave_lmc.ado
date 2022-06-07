



#delimit ;



capture program drop asdbsave_lmc;
program define asdbsave_lmc, rclass sortpreserve;
version 9.2;
syntax varlist (min=1 max=1) [if] [in] [,  
HHID(varlist)
HSize(string)  
PLine(varname)
HGroup(string)
EPSILON(real 0.5)
THETA(real 0)
INISave(string) 
GVIMP(int 0)
CONF(string) 
LEVEL(real 95)
DEC(int 3)
INCOMES(string)
SECTORS(string)
MPART(int 0)

XFIL(string)
TJOBS(string) 

GJOBS(string) 
FOLGR(string)

OPGR1(string) OPGR2(string)  OPGR3(string)
];

tokenize "`inisave'" ,  parse(".");
local inisave = "`1'";
    

local mylist min max ogr;
forvalues i=1/3 {;
if ("`opgr`i''"~="") {;
extend_opt_graph test , `opgr`i'' ;
foreach name of local mylist {;
local `name'`i' = r(`name');
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};
};

local mylist secp pr;

   tokenize `varlist';
   cap file close myfile;
   tempfile  myfile;
   cap erase "`inisave'.mcw" ;
   file open myfile   using "`inisave'.lmc", write replace ;
   if ("`inisave'"~="")  file write myfile `".lmcwel_dlg.main.dbsamex.setvalue "`inisave'""' _n;
   if ("`sectors'"~="")  file write myfile `".lmcwel_dlg.labor_info_lmcwel.sectors.setvalue "`sectors'""' _n;
   if ("`incomes'"~="")  file write myfile `".lmcwel_dlg.labor_info_lmcwel.incomes.setvalue "`incomes'""' _n;
   file write myfile `".lmcwel_dlg.main.vn_pcexp.setvalue "`1'""' _n;
   file write myfile `".lmcwel_dlg.main.vl_hhid.setvalue "`hhid'""' _n;
   file write myfile `".lmcwel_dlg.main.vn_hhs.setvalue "`hsize'""' _n;
   file write myfile `".lmcwel_dlg.main.vn_pl1.setvalue "`pline'""' _n;
   file write myfile `".lmcwel_dlg.main.vn_hhg.setvalue "`hgroup'""' _n;
   

   
   file write myfile `".lmcwel_dlg.main.ed_epsilon.setvalue "`epsilon'""' _n; 
   file write myfile `".lmcwel_dlg.main.ed_theta.setvalue "`theta'""' _n; 
    
     if ("`folgr'"~="")  {;
   file write myfile `".lmcwel_dlg.gr_options_lmc.ck_folgr.seton"' _n;
   file write myfile `".lmcwel_dlg.gr_options_lmc.ed_folgr.setvalue "`folgr'""' _n;
   };

   
    if ("`tjobs'"~="") {;
   file write myfile `".lmcwel_dlg.tb_options_lmc.ck_tables.seton"' _n;
   file write myfile `".lmcwel_dlg.tb_options_lmc.ed_tab.setvalue "`tjobs'""' _n;
   };
   
   if ("`gjobs'"~="") {;
   file write myfile `".lmcwel_dlg.gr_options_lmc.ck_graphs.seton"' _n;
   file write myfile `".lmcwel_dlg.gr_options_lmc.ed_gra.setvalue "`gjobs'""' _n;
   };
   
   if ("`xfil'"~="") {;
   file write myfile `".lmcwel_dlg.tb_options_lmc.ck_excel.seton"' _n;
   file write myfile `".lmcwel_dlg.tb_options_lmc.fnamex.setvalue "`xfil'""' _n;
   };
   
  if (`gvimp'==1)     file write myfile `".lmcwel_dlg.main.chk_gvimp.seton "' _n; 
   

   forvalues i=1/10 {;
   if ("`min`i''"~="")  file write myfile `".lmcwel_dlg.gr_options_lmc.en_min`i'.setvalue "`min`i''""' _n;
   if ("`max`i''"~="")  file write myfile `".lmcwel_dlg.gr_options_lmc.en_max`i'.setvalue "`max`i''""' _n;
   if ("`ogr`i''"~="")  file write myfile `".lmcwel_dlg.gr_options_lmc.en_opt`i'.setvalue `"`ogr`i''"' "' _n;
   };
   
   file close myfile;  
   
  
  
  

  
 


   cap file close myfile;
   tempfile  myfile;
   file open myfile   using "`inisave'.lmc", write append;


 
 local nfile = "$S_FN" ;
 /* file write myfile `"cap use `nfile' , replace"'  _n; */
 file close myfile;







end;

