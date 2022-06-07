/*
/* Estimation of price and income elasicities with cross-section data (using the expenditutes and the quantities) */
/* Based on the Stata code reported in the Deaton's book (1997)  */
/* Updated by Araar Abdelkrim July-2017 */
/* Main contributions */
/* 1- Making the use of the code easier : one Stata command  to perform the different estimations*/
/* 2- Possibility of use of the weight  */
/* 3- Treating the case of null expenditires by using the IMR (Inverse Mills Ratio)to correct the selection bias */
*/
#delimit;

cap program drop _nmargs ;
program define _nmargs , rclass;
version 9.2;
syntax namelist ;
quietly {;
tokenize `namelist';
local k = 1;
mac shift;
while "``k''" ~= "" {; 
local k = `k'+1;
};
};
global indican=`k';
end;

/*
*This all has to go in a program to use it again later;
*Basically uses the b matrix to form price elasticity matrix;
*/
cap program drop mkels;
program define mkels;
        matrix cmx=bhat';
        matrix cmx=dxi*cmx;
        matrix cmx1=dxi*dwbar;
        matrix cmx=iden-cmx;
        matrix cmx=cmx+cmx1;
        matrix psi=inv(cmx);
        matrix theta=bhat'*psi;
        /*display("Theta matrix");
        matrix list theta; */
        matrix ep=bhat';
        matrix ep=idwbar*ep;
        matrix ep=ep-iden;
        matrix ep=ep*psi;
        /*display("Matrix of price elasticities");
        matrix list ep; */
end;


/*
**Completing the system by filling out the matrices;
*/
cap program drop complet;
program define complet;
        *First extending theta;
        matrix atm=theta*itm;
        matrix atm=-1*atm;
        matrix atm=atm-b0;
        matrix xtheta=theta,atm;
        matrix atm=xtheta';
        matrix atm=atm*itm;
        matrix atm=atm';
        matrix xtheta=xtheta\atm;
        *Extending the diagonal matrices;
        matrix wlast=wbar'*itm;
        matrix won=(1);
        matrix wlast=won-wlast;
        matrix xwbar=wbar\wlast;
        matrix dxwbar=diag(xwbar);
        matrix idxwbar=syminv(dxwbar);
        matrix b1last=(0.25);
        matrix xb1=b1\b1last;
        matrix b0last=b0'*itm;
        matrix b0last=-1*b0last;
        matrix xb0=b0\b0last;
        matrix xe=itm1-xb1;
        matrix tm=idxwbar*xb0;
        matrix xe=xe+tm;
        matrix tm=xe';
        /*display("extended outlay elasticities");
        matrix list tm;*/
        matrix xxi=itm1-xb1;
        matrix xxi=dxwbar*xxi;
        matrix xxi=xxi+xb0;
        matrix tm=diag(xb1);
        matrix tm=syminv(tm);
        matrix xxi=tm*xxi;
        matrix dxxi=diag(xxi);
        *Extending psi;
        matrix xpsi=dxxi*xtheta;

        matrix xpsi=xpsi+iden1;
        matrix atm=dxxi*dxwbar;
        matrix atm=atm+iden1;
        matrix atm=syminv(atm);
        matrix xpsi=atm*xpsi;
        matrix ixpsi=inv(xpsi);
        *Extending bhat & elasticity matrix;
        matrix xbhatp=xtheta*ixpsi;
        matrix xep=idxwbar*xbhatp;
        matrix xep=xep-iden1;
        matrix xep=xep*xpsi;
       /* display("extended matrix of elasticities");
        matrix list xep;*/
end;


/*
*Housekeeping matrices, including elasticities;
*/
cap program drop mormat;
program def mormat;
matrix def xi=J($ngds,1,0);
matrix def el=J($ngds,1,0);
local ig=1;
        while `ig' <= $ngds {;
        matrix xi[`ig',1]=b1[`ig',1]/(b0[`ig',1]+
                (1-b1[`ig',1]*wbar[`ig',1]));
        matrix el[`ig',1]=1-b1[`ig',1]+b0[`ig',1]/wbar[`ig',1];
        local ig=`ig'+1;
};
end;

cap program drop mkcov;
program def mkcov;
local ir=1;
while `ir' <= $ngds {;
        local ic=1;
        while `ic' <= $ngds {;
                qui corr y1c`ir' y1c`ic' , cov;
                matrix s[`ir',`ic']=_result(4);
                qui corr y1c`ir' y0c`ic' , cov;
                matrix r[`ir',`ic']=_result(4);
                local ic=`ic'+1;
        };
        local ir=`ir'+1;

};
end;


cap program drop vtodat;
program define vtodat;
local ic=1;
while `ic' <= $nels {;
        cap drop e`ic' ;
        qui gen e`ic'=vxep[`ic',1];
		cap drop e_inc`ic' ;
		qui gen  e_inc`ic'=ep[`ic',1];
		local   ic=`ic'+1;
};


end;



cap program drop mkwbar;
program def mkwbar;
syntax namelist  ,  hweight(varname);
local ig=1;
tokenize `namelist' ; 
while "`1'" ~= ""{;
qui summ w`1' [aw=`hweight'];
matrix wbar[`ig',1]=_result(3);
local ig=`ig'+1;
mac shift;
};
end;

#delimit cr
/*
program mkmats.do
calculates two matrices, the commutation matrix and
the lower diagonal selection matrix that are needed
in the main calculations; these are valid only for
square matrices
also a routine for taking the vec of a matrix
and a matching unvec routine

for calculating the commutation matrix k
the matrix is defined by K*vec(A)=vec(A')
*/

cap program drop commx
program define commx
local n2=`1'^2
matrix `2'=J(`n2',`n2',0)
local i=1
local ik=0
while `i' <= `1'{
        local j=1
        local ij=`i'
        while `j' <= `1'{
                local ir=`j'+`ik'
                matrix `2'[`ir',`ij']=1
                local ij=`ij'+`1'
                local j=`j'+1
        }
        local i=`i'+1
        local ik=`ik'+`1'
}
end
/*
**for vecing a matrix, i.e. stacking it into a column vector
*/
cap program drop vecmx
program def vecmx
local n=rowsof(`1')
local n2=`n'^2
matrix def `2'=J(`n2',1,0)
local j=1
while `j' <= `n' {
        local i=1
        while `i' <= `n' {
                local vcel=(`j'-1)*`n'+`i'
                matrix `2'[`vcel',1]=`1'[`i',`j']
                local i=`i'+1
        }
local j=`j'+1
}
end
/*
*program for calculating the matrix that extracts
*from vec(A) the lower left triangle of the matrix A
*/
cap program drop lmx
program define lmx
local ng2=`1'^2
local nr=0.5*`1'*(`1'-1)
matrix def `2'=J(`nr',`ng2',0)
local ia=2
local ij=1
while `ij' <= `nr'{
        local ik=0
        local klim=`1'-`ia'
        while `ik' <= `klim' {
                local ip=`ia'+(`ia'-2)*`1'+`ik'
                matrix `2'[`ij',`ip']=1
                local ij=`ij'+1
                local ik=`ik'+1
        }
local ia=`ia'+1
}
end
/*
**program for unvecing the vec of a square matrix;
*/
cap program drop unvecmx
program def unvecmx

local n2=rowsof(`1')
local n=sqrt(`n2')
matrix def `2'=J(`n',`n',0)
local i=1
while `i' <= `n' {
        local j=1
        while `j' <= `n' {
                local vcel=(`j'-1)*`n'+`i'
                matrix `2'[`i',`j']=`1'[`vcel',1]
                local j=`j'+1
        }
local i=`i'+1
}
end

#delimit ;

cap program drop st1reg;
program def st1reg;
syntax namelist , cluster(varname) lnexp(varname) lhhs(varname) hweight(varname) indepvars(string) csb(string) dregres(string) ;
local ig=1;
tokenize `namelist' ; 

while "`1'" ~= ""{;
/*
`cluster' fixed effect regression;
*/

qui xi: areg luv`1' `lnexp' `lhhs' `indepvars' [aw=`hweight'], absorb(`cluster');
eststo m_1_`1' ;
/*		
Measurement error variance;
*/
matrix ome[`ig',1]=$S_E_sse/$S_E_tdf;
/*
Quality elasticity;
*/
matrix b1[`ig',1]=_coef[`lnexp'];
/*
These residuals still have `cluster' effects in;
*/
qui predict ruv`1', resid;
qui predict xuv`1' , xb; 
/*
Purged y's for next stage;
*/
qui gen y1`1'=luv`1'-xuv`1';
drop luv`1';
drop xuv`1';
/*
Repeat for budget shares;
*/

lab var `lnexp' "Log of expenditures" ;
lab var `lhhs'  "Log of hhsize" ;



/******************************/
if (`csb'==1) {;
cap drop _1_`1';
gen      _1_`1' = (w`1'!=0);


capture {;
qui probit _1_`1'  `lnexp' `lhhs' `indepvars' [pw=`hweight'];
eststo m_p_`1' ;
cap drop _xb;
qui predict _xb, xb;
cap drop `lambda' ;
tempvar lambda;
qui gen `lambda' = normalden(_xb)/normal(_xb);
cap drop _1_`1' _xb;
};
};
/*****************************/

qui xi: areg w`1'  `lnexp' `lhhs' `indepvars' `lambda' [aw=`hweight'], absorb(`cluster');
eststo m_2_`1' ;
qui predict rw`1', resid;
qui predict xw`1' , xb; 
matrix sig[`ig',1]=$S_E_sse/$S_E_tdf;
matrix b0[`ig',1]=_coef[`lnexp'];
qui gen y0`1'=w`1'- xw`1';
/*		
This next regression is necessary to get covariance of residuals;
*/
qui xi: areg ruv`1' rw`1' `lnexp' `lhhs' `indepvars' [aw=`hweight'], absorb(`cluster');
matrix lam[`ig',1]=_coef[rw`1']*sig[`ig',1];
drop w`1' rw`1' xw`1' ruv`1' ;
local ig=`ig'+1;

mac shift;
};

if (`dregres'==1) {;

di _n "Being a consumer with none nil expenditutes";
capture esttab m_p_*, pr2 not label;

di    "The cluster fixed effect regression(s)";
esttab m_1_*, r2 not label; 

di _n "The budget shares regression(s)";
esttab m_2_*, r2 not label;
};
end;

cap program drop mwegen;
program def mwegen; 
args  nv va we cl;
cap drop `tem1' ; 
cap drop `tem2' ; 
tempvar tem1 tem2;
qui egen `tem1'=mean(`va'*`we'), by(`cl'); 
qui egen `tem2'=mean(`we'), by(`cl'); 
qui gen `nv' = `tem1' / `tem2' ;
end;
/*
*Averaging by `cluster';
*Counting numbers of obs in each `cluster' for n and n+;
*/
cap program drop clustit;
program def clustit;
syntax namelist  , cluster(varname) hweight(varname);
local ig=1;
tokenize `namelist' ; 
while "`1'" ~= ""{;
        
        qui mwegen y0c`ig' y0`1' `hweight' `cluster' ;
		cap drop `tmp0'; tempvar tmp0; 
		qui gen  `tmp0'=(y0`1' !=.)*`hweight';
        qui egen n0c`ig'=total(`tmp0'), by(`cluster');
        qui mwegen  y1c`ig' y1`1' `hweight' `cluster';
	    cap drop `tmp1'; tempvar tmp1; 
		qui gen  `tmp1'=(y1`1' !=.)*`hweight';
        qui egen n1c`ig'=total(`tmp1'), by(`cluster');
        drop y0`1' y1`1';
        local ig=`ig'+1;
mac shift ;
};
end;
/*
*Averaging (harmonically) numbers of obs over `cluster's;
*/
cap program drop mkns;
program define mkns;
        local ig=1;
        while `ig' <= $ngds {;
               qui replace n0c`ig'=1/n0c`ig';
               qui replace n1c`ig'=1/n1c`ig';
                qui summ n0c`ig';
                matrix n0[`ig',1]=(_result(3))^(-1);
                qui summ n1c`ig';
                matrix n1[`ig',1]=(_result(3))^(-1);
                drop n0c`ig' n1c`ig';
                local ig=`ig'+1;
        };
end;


cap program drop purge;
program define purge;
        local ig=1;
        while `ig' <= $ngds {;
                qui regress y0c`ig' quard* regiond*  ;
                qui predict tm, resid;
                qui replace y0c`ig'=tm;
                drop tm;
                qui regress y1c`ig' quard* regiond*  ;
                qui predict tm, resid;
                qui replace y1c`ig'=tm;
                drop tm;
                local ig=`ig'+1;
        };
end;

/*
*Corrections for measurement error;
*/
cap program drop fixmat;
program def fixmat;
matrix def sf=s;
matrix def rf=r;
local ig=1;
        while `ig' <= $ngds {;
        matrix sf[`ig',`ig']=sf[`ig',`ig']-ome[`ig',1]/n1[`ig',1];
        matrix rf[`ig',`ig']=rf[`ig',`ig']-lam[`ig',1]/n0[`ig',1];
        local ig=`ig'+1;
};
end;


cap program drop bootindi;
program define   bootindi;
version 11;
args region subround ;
local expno=1;



while `expno' <= $nmc {;
display("Experiment number `expno'");
quietly {;
use tempclus;
bsample _N;

tempvar reg1 ;
if "`region'"~="" {;
qui gen `reg1' = `region'; 
};

if "`region'"=="" {;
qui gen `reg1' = 1; 
};

tempvar  subr1 ;
if "`subround'"~="" {;
qui gen `subr1' = `subround'; 
};
if "`subround'"=="" {;
qui gen `subr1' = 1; 
};

qui tab `reg1' , gen(regiond);
qui tab `subr1', gen(quard);
/*drop regiond6 quard4; */
purge;
drop regiond* quard*;
matrix define n0=J($ngds,1,0);
matrix define n1=J($ngds,1,0);
*Averaging (harmonically) numbers of obs over `cluster's;
mkns;
*Making the inter`cluster' variance and covariance matrices;
*This is done in pairs because of the missing values;
matrix s=J($ngds,$ngds,0);
matrix r=J($ngds,$ngds,0);
mkcov;
*We don't need the data any more;
drop _all;
*Making OLS estimates;
matrix bols=syminv(s);
matrix bols=bols*r;
*Corrections for measurement error;
fixmat;
matrix invs=syminv(sf);
matrix bhat=invs*rf;
global ng1=$ngds+1;
matrix iden=I($ngds);
matrix iden1=I($ng1);
matrix itm=J($ngds,1,1);
matrix itm1=J($ng1,1,1);
matrix dxi=diag(xi);
matrix dwbar=diag(wbar);

matrix idwbar=syminv(dwbar);
mkels;
**Completing the system by filling out the matrices;
complet;
**Calculating symmetry restricted estimators;
vecmx bhat vbhat;
** R matrix for restrictions;
lmx $ngds llx;
commx $ngds k;
global ng2=$ngds*$ngds;
matrix bigi=I($ng2);
matrix k=bigi-k;
matrix r=llx*k;
matrix drop k;
matrix drop bigi;
matrix drop llx;
** r vector for restrictions, called rh;
matrix rh=b0#wbar;
matrix rh=r*rh;
matrix rh=-1*rh;
**doing the constrained estimation;
matrix iss=iden#invs;
matrix rp=r';
matrix iss=iss*rp;
matrix inn=r*iss;
matrix inn=syminv(inn);
matrix inn=iss*inn;
matrix dis=r*vbhat;
matrix dis=rh-dis;
matrix dis=inn*dis;
matrix vbtild=vbhat+dis;
unvecmx vbtild btild;
**going back to get elasticities and complete sytem;
matrix bhat=btild;
mkels;
complet;
vecmx xep vxep;
set obs 1;
qui gen reps=`expno';
vtodat;
append using bootall;
save bootall, replace;
drop _all;
local expno=`expno'+1;
};};
end;

/*
set trace on;
set tracedepth 1; 
*/



#delimit ;






cap program drop duvm;
program define duvm, eclass ;
syntax namelist(min=1)[ ,   
hweight(varname) 
hhsize(varname) 
expend(varname) 
cluster(varname)
indcon(string) 
indcat(string) 
region(varname) subround(varname)
quard4(varname)  csb(int 0) boot(int 0)
dregres(int 0)
dgra(int 0)
dec(int 3)
INISave(string)
xfil(string)
gmodifier(int 0)
hgroup(varname)
];
matrix drop _all;
cap drop gn1;
eststo clear;

if (`gmodifier' == 0) {;
if ("`hgroup'"!="") {;

preserve;
capture {;
local lvgroup:value label `hgroup';
if ("`lvgroup'"!="") {;
uselabel `lvgroup' , clear;
qui count;
forvalues i=1/`r(N)' {;
local tem=value[`i'];
local grlab`tem' = label[`i'];
};
};
};
restore;
qui tabulate `hgroup', matrow(gn);
svmat int gn;
global indicag=r(r);
};
};


preserve;
 if ("`inisave'" ~="") {;
  asdbsave_duvm `0' ;
  };

if ("`indcat'"~="")	 {;
tokenize `indcat';
_nargs `indcat';
forvalues i=1/$indica {;
local catindep `catindep' i.``i'' ;
};
};

if (`gmodifier' == 0) {;
tokenize "`xfil'" ,  parse(".");
local tname "`1'.xml";
if "`xfil'" ~= ""  { ;
tokenize "`xfil'" ,  parse(".");
local xfil "`1'.xml" ;
cap erase  "`1'.xml" ;
cap winexec   taskkill /IM excel.exe ;
};
};


local indepvars `indcon' `catindep' ;

tokenize `namelist' ;
set more off;
local mylist `varlist' ;
foreach name of local mylist {;
local wmylist `wmylist' w`name';
}   ;


tempvar lnexp lhhs ;
qui gen `lnexp' = log(`expend');
qui gen `lhhs'  = log(`hhsize') ;



if "`region'"=="" {;
tempvar region ;
qui gen `region' = 1; 
};

if "`hweight'"=="" {;
tempvar hweight ;
qui gen `hweight' = 1; 
};

if "`subround'"=="" {;
tempvar subround ;
qui gen `subround' = 1; 
};

if "`quard4'"=="" {;
tempvar quard4 ;
qui gen `quard4' = 1; 
};




/*
These are the commodity identifiers: used as three letter prefixes;
*/
global goods "`namelist'" ;
_nmargs `namelist' ;

/*
Number of goods in the system;
*/
global ngds=$indican;

matrix define sig=J($ngds,1,0);
matrix define ome=J($ngds,1,0);
matrix define lam=J($ngds,1,0);
matrix define wbar=J($ngds,1,0);
matrix define b1=J($ngds,1,0);
matrix define b0=J($ngds,1,0);
/*
Average budget shares;
*/

mkwbar $goods , hweight(`hweight');

/*
First stage regressions: within village;
*/
lab var `lnexp' "Log of expenditures" ;
lab var `lhhs'  "Log of hhsize" ;

st1reg $goods , lnexp(`lnexp') lhhs(`lhhs') indepvars(`indepvars') cluster(`cluster') hweight(`hweight') csb(`csb') dregres("`dregres'") ;
/*
matrix list sig;
matrix list ome;
matrix list lam;
matrix list b0;
matrix list b1;
*/
qui save tempa, replace;



clustit $goods , cluster(`cluster') hweight(`hweight') ;
sort `cluster';
*keeping one obs per `cluster';

*NB subround and region are constant within `cluster';
qui by `cluster': keep if _n==1;

*Saving `cluster' level information;
*Use this for shortcut bootstrapping;
qui save tempclus, replace;

*Removing province and quarter effects;
cap drop regiond ;
cap drop quard ;

qui tab `region', gen(regiond);
qui tab `subround', gen(quard);
/*drop regiond6 quard4; */


purge;
/*drop regiond* quard*;*/

matrix define n0=J($ngds,1,0);
matrix define n1=J($ngds,1,0);



mkns;

*Making the inter`cluster' variance and covariance matrices;
*This is done in pairs because of the missing values;

matrix s=J($ngds,$ngds,0);
matrix r=J($ngds,$ngds,0);


mkcov ;

*We don't need the data any more;
drop _all;
/*
matrix list s;
matrix list r;
*/
*Making OLS estimates;
matrix bols=syminv(s);
matrix bols=bols*r;

/*
display("Second-stage OLS estimates: B-matrix");
matrix list bols;
*/
/*
display("Column 1 is coefficients from 1st regression, etc");
*/


fixmat;

matrix invs=syminv(sf);
matrix bhat=invs*rf;
*Estimated B matrix without restrictions;
/*
matrix list bhat;
*/

mormat;

global ng1=$ngds+1;
matrix iden=I($ngds);
matrix iden1=I($ng1);
matrix itm=J($ngds,1,1);
matrix itm1=J($ng1,1,1);
matrix dxi=diag(xi);
matrix dwbar=diag(wbar);
matrix idwbar=syminv(dwbar);
/*
display("Average budget shares");
*/
matrix tm=wbar';
/*
matrix list tm;
*/
matrix  AV_SHA = tm*100 ; 

/*
display("Expenditure elasticities");
*/
matrix tm=el';
matrix EXP_NS_E = tm; 
/*
matrix list tm;
*/
/*
display("Quality elasticities");
*/
matrix tm=b1';
/*
matrix list tm;
*/
matrix QUAL_NS_E = tm; 



mkels;
complet;



vecmx bhat vbhat;

matrix B_NS_ep = ep;
matrix C_NS_ep = xep;



** R matrix for restrictions;
lmx $ngds llx;
commx $ngds k;
global ng2=$ngds*$ngds;
matrix bigi=I($ng2);
matrix k=bigi-k;
matrix r=llx*k;
matrix drop k;
matrix drop bigi;
matrix drop llx;
** r vector for restrictions, called rh;
matrix rh=b0#wbar;
matrix rh=r*rh;
matrix rh=-1*rh;
**doing the constrained estimation;
matrix iss=iden#invs;
matrix rp=r';
matrix iss=iss*rp;
matrix inn=r*iss;
matrix inn=syminv(inn);
matrix inn=iss*inn;
matrix dis=r*vbhat;
matrix dis=rh-dis;
matrix dis=inn*dis;
matrix vbtild=vbhat+dis;
unvecmx vbtild btild;

**the following matrix should be symmetric;
matrix atm=b0';
matrix atm=wbar*atm;
matrix atm=btild+atm;
/*
matrix list atm;
*/
**going back to get elasticities and complete sytem;
matrix bhat=btild;

mkels;
complet;

matrix B_SY_ep = ep;
matrix C_SY_ep = xep;


if (`boot'> 0) {;
drop _all;
vecmx xep vxep;
set obs 1;
qui gen reps=0;
global nels=$ng1*$ng1;
global nmc=`boot';

vtodat;
save bootall, replace;
drop _all;

bootindi `region' `subround' ;
use bootall;
display("Monte Carlo results");

matrix def MSTE=J($ngds,$ngds,0);
matrix def MSTEINC=J(1,$ngds,0);
local pos=1;
forvalues i=1/$ngds {;
forvalues j=1/$ngds {;
qui mean e`pos' ;
        matrix  MSTE[`i',`j']=sqrt(el(e(V),1,1)) ;
local pos = `pos'+1;		
};
qui mean e_inc`i' ;
matrix  MSTEINC[1,`i']=sqrt(el(e(V),1,1)) ;
};




/*calpol;*/
};
restore; 

/* display("Average budget shares"); */
matrix tm=wbar';
/* matrix list tm; */
/* display("Expenditure elasticities");  */
matrix tm=el'; 
matrix toma = el'; 
matrix EXP_SY_E = tm; 
/* matrix list tm; */
/* display("Quality elasticities"); */
matrix tm=b1';
/* matrix list tm; */
matrix QUAL_SY_E = tm; 


/*
  display("extended outlay elasticities");
        matrix list tm;
       
        display("extended matrix of elasticities");
        matrix list xep;
		*/
	/*	
display("Average budget shares");
matrix tm=wbar';
matrix list tm;
matrix AV_SHA = tm; 
display("Expenditure elasticities");
matrix tm=el';
matrix B_EXP_E = tm; 
matrix list tm;
display("Quality elasticities");
matrix tm=b1';
matrix list tm;
matrix B_QUAL_E = tm; 
	*/	
	
forvalues i=1/$indican {;
local tmp =  substr("``i''",1,5) ;
local mynames 	`mynames' `tmp' ;
};
local cwidth = `dec'+4;

matrix colnames AV_SHA = `mynames' ;
matrix rownames AV_SHA = "AV_share" ;

matrix colnames EXP_SY_E = `mynames' ;
matrix rownames EXP_SY_E = "Elasticity" ;

matrix colnames QUAL_SY_E = `mynames' ;
matrix rownames QUAL_SY_E = "Elasticity" ;

matrix colnames  B_NS_ep = `mynames' ;
matrix rownames  B_NS_ep = `mynames' ;


matrix colnames  B_SY_ep = `mynames' ;
matrix rownames  B_SY_ep = `mynames' ;

matrix colnames  C_NS_ep = `mynames' ;
matrix rownames  C_NS_ep = `mynames' ;


matrix colnames  C_SY_ep = `mynames' ;
matrix rownames  C_SY_ep = `mynames' ;

matrix rC_NS_ep = C_NS_ep[1..$indican, 1..$indican];
matrix rC_SY_ep = C_SY_ep[1..$indican, 1..$indican];

if (`gmodifier' == 0) {;

matlist AV_SHA[., 1..$indican] , border(all)   format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2) title( "Table 01: Average expenditures shares (in %)");
mk_xtab_tr `1' ,  matn(AV_SHA) dec(`dec') xfil(`xfil') xshe(Table_01) xtit("Table 01: Average expenditures shares (in %)") xlan(en) dste(0) ;


matlist EXP_SY_E[., 1..$indican] , border(all)   format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2)  title( "Table 02: Expenditure elasticities ");
mk_xtab_tr `1' ,  matn(EXP_SY_E) dec(`dec') xfil(`xfil') xshe(Table_02) xtit("Table 02: Expenditure elasticities ") xlan(en) dste(0) ;

matlist QUAL_SY_E[., 1..$indican] , border(all)   format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2) title( "Table 03: Quality elasticities     ");
mk_xtab_tr `1' ,  matn(QUAL_SY_E) dec(`dec') xfil(`xfil') xshe(Table_03) xtit("Table 03: Quality elasticities ") xlan(en) dste(0) ;
		 
matlist B_NS_ep[1..$indican, 1..$indican], border(all)   format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2) title( "Table 04: Price elasticities: without quality correction | without symmetry restricted estimators");
mk_xtab_tr `1' ,  matn(B_NS_ep) dec(`dec') xfil(`xfil') xshe(Table_04) xtit("Table 04: Price elasticities: without quality correction | without symmetry restricted estimators ") xlan(en) dste(0) ;

matlist B_SY_ep[1..$indican, 1..$indican], border(all)   format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2) title( "Table 05: Price elasticities: without quality correction | with symmetry restricted estimators");
mk_xtab_tr `1' ,  matn(B_SY_ep) dec(`dec') xfil(`xfil') xshe(Table_05) xtit("Table 05: Price elasticities: without quality correction | with symmetry restricted estimators ") xlan(en) dste(0) ;

matlist C_NS_ep[1..$indican, 1..$indican], border(all)   format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2) title( "Table 06: Price elasticities: with quality correction | without symmetry restricted estimators");
mk_xtab_tr `1' ,  matn(rC_NS_ep) dec(`dec') xfil(`xfil') xshe(Table_06) xtit("Table 06: Price elasticities: with quality correction | without symmetry restricted estimators") xlan(en) dste(0) ;


matlist C_SY_ep[1..$indican, 1..$indican], border(all)   format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2) title( "Table 07: Price elasticities: with quality correction | with symmetry restricted estimators");
mk_xtab_tr `1' ,  matn(rC_SY_ep) dec(`dec') xfil(`xfil') xshe(Table_07) xtit("Table 07: Price elasticities: with quality correction | with symmetry restricted estimators ") xlan(en) dste(0) ;
};
if (`boot'>0){;
matrix colnames  MSTEINC = `mynames' ;
matrix rownames   MSTEINC = "STE_INC_ELAS";
matrix rMSTEINC=MSTEINC[.,1..$indican] ;

matlist rMSTEINC[., 1..$indican] , border(all)   format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2)  title( "Table 08: Standard errors of expenditure elasticities: with the bootstrap method  ");
mk_xtab_tr `1' ,  matn(MSTEINC) dec(`dec') xfil(`xfil') xshe(Table_08) xtit("Table 08: Standard errors of expenditure elasticities: with the bootstrap method  ") xlan(en) dste(0) ;


matrix colnames  MSTE = `mynames' ;
matrix rownames  MSTE = `mynames' ;
matrix rMSTE=MSTE[1..$indican, 1..$indican];

if (`gmodifier' == 0) {;
mk_xtab_tr `1' ,  matn(rMSTE) dec(`dec') xfil(`xfil') xshe(Table_09) xtit("Table 09: Standard errors of price elasticities: with the bootstrap method ") xlan(en) dste(0) ;
matlist MSTE[1..$indican, 1..$indican], border(all)   format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2) title( "Table 09: Standard errors of price elasticities: with the bootstrap method ");
};
};





*set trace on;
if ("`hgroup'" ~= "") {;


dis " Treatment of hgroups : "_continue; 
if (`gmodifier' == 0) {;
forvalues d=1/$indicag  {;
preserve;
qui keep if `hgroup'==`d';
local mycmd = "`0'" ;
local mycmd = subinstr("`mycmd'" , "gmodifier(1)", "",.);
local mycmd = subinstr("`mycmd'" , "gmodifier(0)", "",.);
*set trace on ;
qui duvm `mycmd' gmodifier(1);
dis "`d':" _continue ;
forvalues j=1/$indican {;
                local  elas_`j'_`d' = el(rC_SY_ep,`j',`j');
if (`boot'>0 )  local selas_`j'_`d' = el(rMSTE,`j',`j');
};
restore; 
};
};


if (`gmodifier' == 0) {;
forvalues d=1/$indicag  {;
forvalues j=1/$indican {;
};
};


if (`gmodifier' == 0) {;

cap drop  __elas*;
cap drop __selas*;

forvalues j=1/$indican {;
qui gen  __elas_`j'=.;
local des_elas `des_elas'   __elas_`j' ;
local dcnames `dcnames' ``j'' ; 
if (`boot'>0 )  {;
 qui gen __selas_`j'=. ;
 local des_elas `des_elas'   __selas_`j' ;
 local dcnames `dcnames' "STE" ; 
 }; 
};

forvalues d = 1/$indicag {;
local kk = gn1[`d'];
if ( "`grlab`kk''" == "") local grlab`kk' = "Group_`kk'";
local drnames `drnames' `grlab`kk'' ; 
};


forvalues j = 1/$indican {;
forvalues d = 1/$indicag {;
                qui replace  __elas_`j' = `elas_`j'_`d'' in `d';
if (`boot'>0 )  qui replace __selas_`j'=  `selas_`j'_`d'' in `d';

};
};

};

mkmat `des_elas' in 1/$indicag , matrix(DEC_ELAS);
matrix rownames  DEC_ELAS = `drnames' ;
matrix colnames  DEC_ELAS = `dcnames' ;
mk_xtab_tr `1' ,  matn(DEC_ELAS) dec(`dec') xfil(`xfil') xshe(Table_10) xtit("Table 10: Own Price Elasiticies by hgroups ") xlan(en) dste(0) ;

matlist DEC_ELAS, border(all)  format(%`cwidth'.`dec'f)  twidth(`cwidth') left(2) title( "Table 09: Own Price Elasiticies by hgroups ");
  
};
};

if (`gmodifier' == 0) {;
cap drop __nevar*;
if  ("`xfil'" ~= "" &  "`tjobs'"~="off" ) | ("`xfil'" ~= "") {;
cap !start "" /min "`xfil'" ; 
};
};

cap drop gn1;
ereturn clear;
matrix mat1 = C_SY_ep[1..$indican, 1..$indican] ;
matrix mat2 = EXP_SY_E[., 1..$indican] ;
ereturn matrix elprice  = mat1 ;
ereturn matrix elincome = mat2;

end;


