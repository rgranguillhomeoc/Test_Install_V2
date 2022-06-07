

#delimit ;

capture program drop asdbsave_duvm;
program define asdbsave_duvm, rclass sortpreserve;
version 9.2;
syntax namelist(min=1)[,   
hweight(varname) 
hhsize(varname) 
expend(varname) 
cluster(varname)
indcon(string) 
indcat(string) 
region(varname) 
subround(varname)
quard4(varname) 
 
csb(int 0) 
boot(int 0)
dregres(int 0)
dgra(int 0)
dec(int 3)
INISave(string)
xfil(string)
gmodifier(int 0)
hgroup(varname)
];


tokenize "`inisave'" ,  parse(".");
local inisave = "`1'";
    

local mylist secp pr;

   tokenize `varlist';
   cap file close myfile;
   tempfile  myfile;
   cap erase "`inisave'.duvm" ;
   file open myfile   using "`inisave'.duvm", write replace ;
   if ("`inisave'"~="")  file write myfile `".duvm_dlg.main.dbsamex.setvalue "`inisave'""' _n;
   file write myfile `".duvm_dlg.main.name_items.setvalue "`namelist'""' _n;
   
    if ("`hhsize'"~="")  file write myfile  `".duvm_dlg.main.vn_hhsize.setvalue "`hhsize'""' _n;
    if ("`expend'"~="")   file write myfile  `".duvm_dlg.main.vn_hhexp.setvalue "`expend'""' _n;
	if ("`hweight'"~="") file write myfile  `".duvm_dlg.main.vn_hhwe.setvalue  "`hweight'""' _n;
	if ("`hgroup'"~="")  file write myfile  `".duvm_dlg.resop.vn_dec.setvalue "`hgroup'""' _n;
	if ("`indcat'"~="")  file write myfile  `".duvm_dlg.main.vl_indcat.setvalue  "`indcat'""' _n;
	if ("`indcon'"~="")  file write myfile  `".duvm_dlg.main.vl_indcon.setvalue  "`indcon'""' _n; 
	
	if ("`cluster'"~="")  file write myfile  `".duvm_dlg.main.vn_cluster.setvalue "`cluster'""' _n;
	if ("`region'"~="")  file write myfile  `".duvm_dlg.main.vn_region.setvalue "`region'""' _n;
	if ("`subround'"~="")  file write myfile  `".duvm_dlg.main.vn_round.setvalue "`subround'""' _n;
	if ("`dregres'"=="1")         file write myfile `".duvm_dlg.resop.ck_dregres.seton "' _n; 
	 
    
   
   if ("`xfile'"~="") {;
   file write myfile `".duvm_dlg.resop.eldecfile.setvalue "`xfile'""' _n;
   };
   
  if ("`dec'"~="")         file write myfile `".duvm_dlg.resop.sp_dec.setvalue "`dec'""' _n;
  if ("`boot'"~="")        file write myfile `".duvm_dlg.resop.n_boot.setvalue "`boot'""' _n;


 /* file write myfile `"cap use `nfile' , replace"'  _n; */
 
 if ("`csb'"=="1")             file write myfile `".duvm_dlg.main.ck_csb.seton "' _n; 
 file close myfile;







end;

