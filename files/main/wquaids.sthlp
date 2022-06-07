{smcl}
{* January 2018}{...}
{hline}
{hi:WQUAIDS : Weigthed QUadratic Almost Ideal Demand System }{right:{bf: World Bank}}
{hline}


{title:WQUAIDS} 
{p 8 10}{cmd:wquaids}  {it:varlist} (min=2) {cmd:,} [ 
{cmd:ANOT(}{it:real}{cmd:)}
{cmd:EXPENDITURE(}{it:varname}{cmd:)} 
{cmd:HWEIGHT(}{it:varname}{cmd:)}
{cmd:PRICES(}{it:varlist}{cmd:)} 
{cmd:DEMOGRAPHICS(}{it:varlist}{cmd:)} 
{cmd:MODEL(}{it:int}{cmd:)} 
{cmd:XFIL(}{it:string}{cmd:)}
{cmd:DEC(}{it:int}{cmd:)} 
{cmd:SNAMES(}{it:string}{cmd:)} 
{cmd:DREGRES(}{it:int}{cmd:)} 
{cmd:DISLAS(}{it:int}{cmd:)} 
]


{p 8 8} {cmd:varlist} should contains the list of varnames of the expenditure shares (the sum of share at each unit level (the household for instance) must be equal to one). {p_end}

{title:Version} 14.0 and higher.

{title:Description}
 {p}{cmd:WQUAIDS}  This module is based on the Stata published QUAIDS. Some improvments are done, as the addition of sampling weight and the dialog box.{p_end}
 
{title:The WQUAIDS results}  

{p 2 8}{cmd: - List of tables:}{p_end}
{p 4 8}{inp:[01] Table 01: Expenditure elasticities. }{p_end}
{p 4 8}{inp:[02] Table 02: Uncompensated Price elasticities.}{p_end}


{title:Options ((*) required)}


{p 4 8} {cmd:inisave:} To save the wquaids dialog box information. Mainly, all inserted information in the dialogue box will be save in this file. In another session, the user can open the project using the command wquaids_db_ini followed by the name of project. {p_end}

{p 4 8} {cmd:*anot:}  Value to use for alpha_0 parameter. {p_end}

{p 4 8} {cmd:*prices:}  the list of the price variables. {p_end}

{p 4 8} {cmdab:*expenditures} the household expenditures. {p_end}

{p 4 8} {cmdab:*model} add the option model(2) to estimate the AIDS instead of the QUAIDS model. {p_end}

{p 4 8} {cmdab:demographics}      The list of the independent variables.  {p_end}

{p 4 8} {cmdab:hweight}  to indicate the sampling weight of the variable. {p_end}

{p 4 8} {cmd:xfil}   To indicate the name of Excel file, that will be used to save the results (*.xml format). {p_end}

{p 4 8} {cmd:dec}    To indicate number of decimals of the displayed results. {p_end}

{p 4 8} {cmd:snames}    To declare varname of short names of items (the option oinf must be set to 2). {p_end}

{p 4 8} {cmd:dregres}    To display the regressions results. {p_end}

{p 4 8} {cmd:dislas}     To display the elasicities  of the last item. {p_end}

{title:Examples}

{p 4 10 2}
NOTE: All the examples illustrated in the present and in the following sections
      can be run by clicking on the blue hyperlinks.

{title:Example 1: Estimating the cereal elasticities.}
{cmd}
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
wquaids wcorn wwheat wrice wother wcomp, anot(9.5) 
prices(pcorn pwheat price pother pcomp) 
snames(Corn Wheat Rice Other_cereal Rest) 
expend(hh_current_inc) hweight(sweight) 
model(1) inisave(ex1_wquaids_db.duvm) 
dregres(0) xfil(myfil) dislas(0); ;
{txt}      ({stata "welcom_examples ex_wquaids_01":example 1: click to run in command window})
{txt}      ({stata "welcom_examples ex_wquaids_db_01 ":example 1: click to run in dialog box})


{title:Example 2: Estimating the cereal elasticities by adding some demographic variables.}
{cmd}
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
set seed 1234;
bsample 2000;
wquaids wcorn wwheat wrice wother wcomp, anot(9.5) 
prices(pcorn pwheat price pother pcomp) 
snames(Corn Wheat Rice Other_cereal Rest) 
expend(hh_current_inc) hweight(sweight) 
model(1) inisave(ex2_wquaids_db.duvm) 
demographics(age isMale) dregres(1) xfil(myfil) dislas(0);
{txt}      ({stata "welcom_examples ex_wquaids_02":example 2: click to run in command window})
{txt}      ({stata "welcom_examples ex_wquaids_db_02 ":example 2: click to run in dialog box})



{title:Author(s)}
Abdelkrim Araar, Sergio Olivieri, Carlos Rodriguez Castelan


{title:Reference(s)}
{p 4 8} • Banks, J., R. Blundell, and A. Lewbel. 1997. Quadratic Engel curves and consumer demand. Review of Economics and Statistics 79: 527–539.{p_end}
{p 4 8} • Deaton, A. S., and J. Muellbauer. 1980a. Economics and Consumer Behaviour. Cambridge: Cambridge University Press.{p_end}
{p 4 8} • ———. 1980b. An almost ideal demand system. American Economic Review 70: 312–326.{p_end}
{p 4 8} • Poi, Brian P., (2012), Easy demand system estimation with quaids, Stata Journal, 12, issue 3, p. 433446.{p_end}


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}
