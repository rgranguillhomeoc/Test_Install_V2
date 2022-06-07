/*************************************************************************/
/* mcema: Market	Competition	and	the	Extensive	Margin	Analysis	 */
/*************************************************************************/
/* Conceived  by :                                                       */
/*     Abdelkrim Araar                                                   */
/*     Eduardo Malasquez                                                 */
/*     Sergio Olivieri                                                   */
/*     Carlos Rodriguez-Castelan                                         */
/* email : aabd@ecn.ulaval.ca                                            */
/*   August/2019                                                        */
/*************************************************************************/
/* mcema.ado                                                             */
/*************************************************************************/
/* Description:                                                          */
/* The mcema module is designed to the impact of change in welfare or price*/ 
/* the proportion of consumers or users.                                 */
/* Intermediatelly, the estimation is based on a probit model            */
/*************************************************************************/


/* 
varlist (one dycotomic variable): 1 if the consumption of the good is higher than zero and 0 otherwise 
*/

#delimit ;
cap program drop mcema;
program define mcema, eclass ;
syntax varlist(min=2 max=2)[, 
welfare(varname)
hsize(varname)
pline(varname)
price(varname)
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

if ((`um'==2 | `um'==4 | `um'==6) & "`incpar'" == "" ) {;
        di in r "with the um(2), um(4) or um(6)  option, you must indicate the incpar(varname) option.";
	  exit 198;
exit;
};

if ((`um'==3 | `um'==5) & "`hgroup'" == "" ) {;
        di in r "with the um(3) or um(5) option, you must indicate the hgroup(varname) option.";
	  exit 198;
exit;
};



 if ("`inisave'" ~="") {;
  qui asdbsave_mcema `0' ;
 };
 
 if (`exnum' ==0) {;
   mcem1 `0' ;
 };
 
  if (`exnum' ==1) {;
   mcem2 `0' ;
 };
end;

