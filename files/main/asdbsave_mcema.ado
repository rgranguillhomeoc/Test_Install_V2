

#delimit ;

capture program drop asdbsave_mcema;
program define asdbsave_mcema, rclass sortpreserve;
version 9.2;
syntax varlist(min=2 max=2)[, 
welfare(varname)
hsize(varname)
price(varname)
pline(varname)
ICHANGE(varname)
PCHANGE(varname)
INCPAR(varname)
HGROUP(varname)
indcon(string) 
indcat(string) 
PSWP(real 1.0)
PSWE(real 1.0)
DEC(int  4)
DREG(int 0)
EXPSHARE(varname)
XFIL(string)
DGRA(int 0)   
UM(int 1)
DISGR(varname)
expmod(int 1)
NQUANTile(int 20)
GRMOD1(varname)
GRMOD2(varname)
FEX(int 1)
FPR(int 1)
FIN(int 1)
OOPT(string)
CINDCAT(string)
CINDCON(string) 
INISAVE(string)
EXNUM(int 0)
GRMAC(varname)
TOTENTR(varname)
TOTUSER(varname)
ELIGIBLE(varname)
SEED(int 123456)
*];


tokenize "`inisave'" ,  parse(".");
local inisave = "`1'";
    

   tokenize `varlist';
   cap file close myfile;
   tempfile  myfile;
   cap erase "`inisave'.mcema" ;
   file open myfile   using "`inisave'.mcema", write replace ;
   if ("`inisave'"~="")  file write myfile `".mcema_dlg.main.dbsamex.setvalue "`inisave'""' _n; 
    
file write myfile  `".mcema_dlg.main.vn_d_cons.setvalue `1'"' _n;
file write myfile  `".mcema_dlg.main.vn_d_consc.setvalue `2'"' _n;

file write myfile `".mcema_dlg.main.vn_pr.setvalue `price'"' _n;
file write myfile `".mcema_dlg.main.vn_inc.setvalue `welfare'"' _n;
file write myfile `".mcema_dlg.main.vn_pline.setvalue `pline'"' _n;
file write myfile `".mcema_dlg.main.vn_hhs.setvalue `hsize'"' _n;

file write myfile `".mcema_dlg.main.vn_hg.setvalue `hgroup'"' _n;
file write myfile `".mcema_dlg.main.vn_incpar.setvalue `incpar'"' _n;
file write myfile `".mcema_dlg.main.vl_indcat.setvalue `indcat'"' _n;
file write myfile `".mcema_dlg.main.vl_indcon.setvalue `indcon'"' _n;
file write myfile `".mcema_dlg.resop.var_disgr.setvalue `disgr'"' _n;

if "`pswp'" ~= ""         file write myfile `".mcema_dlg.main.fl_pswp.setvalue `pswp'"' _n;
if `pswp'!=1.0            file write myfile `".mcema_dlg.main.ck_swp.seton"' _n;
                          file write myfile `".mcema_dlg.main.com_um.setvalue `um'"' _n;
if "`expshare'"~=""       file write myfile `".mcema_dlg.main.ck_adj.seton"' _n;
                          file write myfile `".mcema_dlg.main.vn_share.setvalue `expshare'"' _n;
if "`totuser'"~=""        file write myfile `".mcema_dlg.main.cb_mac.setvalue 2 "' _n;

file write myfile `".mcema_dlg.main.cb_moda.setvalue `expmod' "' _n;
file write myfile `".mcema_dlg.main.ed_modaq1.setvalue `ed_modaq1' "' _n;
file write myfile `".mcema_dlg.main.ed_seed.setvalue `seed' "' _n;
file write myfile `".mcema_dlg.main.gr_moda1.setvalue `grmod1'"' _n;
file write myfile `".mcema_dlg.main.gr_moda2.setvalue `grmod2'"' _n;

file write myfile `".mcema_dlg.main.cb_cpri.setvalue `fpr'"' _n;
file write myfile `".mcema_dlg.main.cb_cons.setvalue `fex'"' _n;
file write myfile `".mcema_dlg.main.cb_cinc.setvalue `fin'"' _n;
file write myfile `".mcema_dlg.main.ed_oopt.setvalue `oopt'"' _n;

file write myfile `".mcema_dlg.main.ed_modaq1.setvalue `nquantile'"' _n;

file write myfile `".mcema_dlg.main.vl_indcatc.setvalue `cindcat'"' _n;
file write myfile `".mcema_dlg.main.vl_indconc.setvalue `cindcon'"' _n;

file write myfile `".mcema_dlg.main.vn_pchange.setvalue `pchange'"' _n;
file write myfile `".mcema_dlg.main.vn_ichange.setvalue `ichange'"' _n;

if "`pswe'" ~= ""    file write myfile `".mcema_dlg.main.fl_pswe.setvalue `pswe'"' _n;
if   `pswe'!=1.0          file write myfile `".mcema_dlg.main.ck_swe.seton"' _n;
 
   if ("`xfil'"~="") {;
   file write myfile `".mcema_dlg.resop.ck_excel.seton"' _n;
   file write myfile `".mcema_dlg.resop.fnamex.setvalue "`xfil'""' _n;
   };
   

 if `dreg' == 1  file write myfile `".mcema_dlg.resop.ck_dregres.seton"' _n;
 file write myfile `".mcema_dlg.resop.sp_dec.setvalue `dec'"' _n;



if `exnum' == 1 {;
 file write myfile `".mcema_dlg.main.ck_mac.seton"' _n;
 file write myfile `".mcema_dlg.main.gr_mac.setvalue `grmac'"' _n;
  file write myfile `".mcema_dlg.main.var_tent.setvalue `totentr'"' _n;
  file write myfile `".mcema_dlg.main.var_tuse.setvalue `totuser'"' _n;
  file write myfile `".mcema_dlg.main.eli_mac.setvalue `eligible'"' _n;
};
 
 
 file close myfile; 
end;




