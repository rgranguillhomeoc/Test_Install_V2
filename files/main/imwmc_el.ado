



#delimit ;
capture program drop imwmc_el;
program define imwmc_el, sortpreserve;
version 9.2;
syntax varlist(min=1)[ ,   PRC(varname) ELAS(varname) HSIZE(varname)  MATPEL(string) MATIEL(string) SOTM(int 1) 
PRC1(varname)  PRC2(varname)     PRC3(varname)   PRC4(varname)   PRC5(varname) 
PRC6(varname)  PRC7(varname)     PRC8(varname)   PRC9(varname)   PRC10(varname) POSA(int 1) pcexp(varname) itexp(varname)
];

tokenize `varlist';
tempname wvar;
if (`sotm'==1)   {;
if ("`matpel'" == "") {;
qui gen `wvar' = -`itexp'*`prc'  -0.5*`itexp'*`elas'*`prc'^2 ; 
};

if ("`matpel'" ~= "") {;
qui gen `wvar' =  -`itexp'*`prc' ;
forvalues i=1/$indica {;
qui replace `wvar' = `wvar'  -0.5*`itexp'*el(`matpel',`posa',`i')*`prc'*`prc`i'' ; 
};
};

};



if (`sotm'==2)      {;

if ("`matpel'" == "") {;
        di in r "You should indicate the price elasticity matrix for the approximation of the EV measurement.";
	  exit 198;
exit;
};

if ("`matiel'" == "") {;
        di in r "You should indicate the income elasticity matrix for the approximation of the EV measurement.";
	  exit 198;
exit;
};
qui gen `wvar' =  -`itexp'*`prc' ;
forvalues i=1/$indica {;
tempvar share`i';
qui gen `share`i'' = ``i'' / `pcexp' ;
qui replace `share`i'' = 0 if `share`i'' ==. ;
qui replace `wvar' = `wvar'  -0.5*`itexp'*(el(`matpel',`posa',`i') - `share`i''*el(`matiel',1,`i'))*`prc'*`prc`i'' ; 
};

};


if (`sotm'==3)      {;

if ("`matpel'" == "") {;
        di in r "You should indicate the price elasticity matrix for the approximation of the CV measurement.";
	  exit 198;
exit;
};

if ("`matiel'" == "") {;
        di in r "You should indicate the income elasticity matrix for the approximation of the CV measurement.";
	  exit 198;
exit;
};

qui gen `wvar' =  -`itexp'*`prc' ;
forvalues i=1/$indica {;
tempvar share`i';
qui gen `share`i'' = ``i'' / `pcexp' ;
qui replace `share`i'' = 0 if `share`i'' ==. ;
qui replace `wvar' = `wvar'  -0.5*`itexp'*(el(`matpel',`posa',`i') + `share`i''*el(`matiel',1,`i'))*`prc'*`prc`i'' ; 
};
};

                                                      
cap drop __imwmc;
qui gen  __imwmc=`wvar';
end;

