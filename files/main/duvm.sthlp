{smcl}
{* January 2018}{...}
{hline}
{hi:DUVM : Deaton Unit Value Model}{right:{bf: World Bank}}
{hline}


{title:DUVM} 
{p 8 10}{cmd:duvm}  {it:namelist} (min=2) {cmd:,} [ {cmd:EXPEND(}{it:varname}{cmd:)} 
{cmd:HHSIZE(}{it:varname}{cmd:)} 
{cmd:HGROUP(}{it:varname}{cmd:)} 
{cmd:INDCAT(}{it:varlist}{cmd:)} 
{cmd:INDCON(}{it:varlist}{cmd:)} 
{cmd:CLUSTER(}{it:varname}{cmd:)}
{cmd:HWEIGHT(}{it:varname}{cmd:)}
{cmd:REGION(}{it:varname}{cmd:)}
{cmd:SUBROUND(}{it:varname}{cmd:)}
{cmd:CBS(}{it:string}{cmd:)} 
{cmd:BOOT(}{it:int}{cmd:)} 
{cmd:XFIL(}{it:string}{cmd:)}
{cmd:DEC(}{it:int}{cmd:)} 
{cmd:SNAMES(}{it:string}{cmd:)} 
{cmd:DREGRES(}{it:string}{cmd:)} 
]

{p 8 8} {cmd:namelist} should contains the names for the items of expenditres. 
Note that the data must contain the two variables for each item. 
The name of the first variable is composed of the letter w and the name of the item.  
The name of second variable is composed of the word luv and the name  of the item. 
For instance, if the name is: food, we must have the two variables wfood and luvfood, 
which refers to the expenditure share and the log of the unit value of the food item respectivelly. {p_end}

{title:Version} 14.0 and higher.

{title:Description}
 {p}{cmd:DUVM}  This module can be used to estimate the income and price elasticities with the Deaton Unit Value Model. {p_end}
 
{title:The DUVM results}  

{p 2 8}{cmd: - List of tables:}{p_end}

{p 4 8}{inp:[01] Table 01: Average expenditures shares (in \%)).}{p_end}
{p 4 8}{inp:[02] Table 02: Expenditure elasticities. }{p_end}
{p 4 8}{inp:[03] Table 03: Quality elasticities. }{p_end}
{p 4 8}{inp:[04] Table 04: Price elasticities: without quality correction | without symmetry restricted estimators.}{p_end}
{p 4 8}{inp:[05] Table 05: Price elasticities: without quality correction | with symmetry restricted estimators.}{p_end}
{p 4 8}{inp:[06] Table 06: Price elasticities: with quality correction | without symmetry restricted estimators.}{p_end}
{p 4 8}{inp:[07] Table 07: Price elasticities: with quality correction | with symmetry restricted estimators}{p_end}
{p 4 8}{inp:[08] Table 08: Standard errors: with the bootstrap method (Results of Table (07)).}{p_end}
{p 4 8}{inp:[09] Table 09: Own-price elasticities by deciles(Method of Table (07)).}{p_end}


{title:Options ((*) required)}

{p 4 8} {cmd:inisave:} To save the duvm dialog box information. Mainly, all inserted information in the dialogue box will be save in this file. In another session, the user can open the project using the command duvm_db_ini followed by the name of project. {p_end}

{p 4 8} {cmdab:*hsize} The household size. {p_end}

{p 4 8} {cmdab:*expend} the household expenditures. {p_end}

{p 4 8} {cmdab:hgroup}   Variable that captures a socio-demographic group. For example, this variable could equal 1 for rural households and 2 for urban ones. When this option is used, the associated varlist should contain only one variable. {p_end}

{p 4 8} {cmdab:indcat}      The list of the independent variables that are categorical.  {p_end}

{p 4 8} {cmdab:indcont}     The list of the independent variables that are continues.  {p_end}  

{p 4 8} {cmdab:*cluster} the cluster is required in an inetrmediate step to estimate the derrivative of the log(exp_share) with regards to the log(unit value).  {p_end}

{p 4 8} {cmdab:region} the region area. {p_end}

{p 4 8} {cmdab:subround} the round of the surveyed household. {p_end}

{p 4 8} {cmdab:csb} Correction of Selection Bias. In the case of csb(1), for each item, the routine estimates the beforehand IML ratio based on the binary model (Consumption is not nil ), and then, it uses the IMR variable in models of the first stage (For more details, see Deanton (1997)). {p_end}

{p 4 8} {cmdab:hweight}  to indicate the sampling weight of the variable. {p_end}

{p 4 8} {cmdab:boot}(number of replications) : to estimate the standard errors of the price elasticities. {p_end}

{p 4 8} {cmd:xfil}   To indicate the name of Excel file, that will be used to save the results (*.xml format). {p_end}

{p 4 8} {cmd:dec}    To indicate number of decimals of the displayed results. {p_end}

{p 4 8} {cmd:snames}    To declare varname of short names of items (the option oinf must be set to 2). {p_end}

{p 4 8} {cmd:dregres}    To display the regressions results. {p_end}



{title:Examples}

{p 4 10 2}
NOTE: All the examples illustrated in the present and in the following sections
      can be run by clicking on the blue hyperlinks.

{title:Example 1: Estimating the cereal elasticities}
{cmd}
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
duvm corn wheat rice other,  hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) 
inisave(ex1_duvm_db))  indcat(sex educ)  indcon(age)   xfil(myfile) ;
{txt}      ({stata "welcom_examples ex_duvm_01":example 1: click to run in command window})
{txt}      ({stata "welcom_examples ex_duvm_db_01 ":example 1: click to run in dialog box})


{title:Example 2: Estimating the cereal elasticities and the standard errors (with the bootstrap approach)}
{cmd}
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
duvm corn wheat rice other,  hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) 
inisave(ex2_duvm_db))  indcat(sex educ)  indcon(age)   xfil(myfile) boot(50);
{txt}      ({stata "welcom_examples ex_duvm_02":example 2: click to run in command window})
{txt}      ({stata "welcom_examples ex_duvm_db_02 ":example 2: click to run in dialog box})


{title:Example 3: Estimating the own-price elasticities by deciles}
{cmd}
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
duvm corn wheat rice other,  hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) 
inisave(ex3_duvm_db))  indcat(sex educ)  indcon(age)   xfil(myfile) hgroup(decile);
{txt}      ({stata "welcom_examples ex_duvm_03":example 3: click to run in command window})
{txt}      ({stata "welcom_examples ex_duvm_db_03 ":example 3: click to run in dialog box})




{title:Author(s)}
Abdelkrim Araar, Sergio Olivieri, Carlos Rodriguez Castelan


{title:Reference(s)}
{p 4 8} • Angus Deaton. Quality, quantity, and spatial variation of price. American Economic Review, 78(3), Jun 1988.{p_end}
{p 4 8} • Angus Deaton. Price elasticities from survey data: Extensions and Indonesian results. Journal of Econometrics, 44:281–309, 1990.{p_end}
{p 4 8} • Angus Deaton. The Analysis of Household Surveys: A Microeconometric Approach to Development Policy. Johns Hopkins University Press, 1997.{p_end}


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}
