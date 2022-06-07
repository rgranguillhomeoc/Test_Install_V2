{smcl}
{* January 2018}{...}
{hline}
{hi:SR_EASI : Stata & R for the EASI model}{right:{bf: World Bank}}
{hline}

{title:Stata-R EASI} 
{p 8 10}{cmd:sr_easi}  {it:varlist} (min=1) {cmd:,} [ 
{cmd:EXPENDITURE(}{it:varname}{cmd:)} 
{cmd:HWEIGHT(}{it:varname}{cmd:)}
{cmd:PRICES(}{it:varlist}{cmd:)} 
{cmd:DEMOGRAPHICS(}{it:varlist}{cmd:)} 
{cmd:XFIL(}{it:string}{cmd:)}
{cmd:DEC(}{it:int}{cmd:)} 
{cmd:SNAMES(}{it:string}{cmd:)} 
{cmd:RTOOL(}{it:string}{cmd:)} 
{cmd:DREGRES(}{it:int}{cmd:)} 
{cmd:DISLAS(}{it:int}{cmd:)} 
{cmd:POWER(}{it:int}{cmd:)} 
{cmd:INPY(}{it:int}{cmd:)} 
{cmd:INPZ(}{it:int}{cmd:)} 
{cmd:INYZ(}{it:int}{cmd:)} 
]


{p 8 8} {cmd:varlist} should contains the list of varnames of the expenditure shares (the sum of share at each unit level (the household for instance) must be equal to one). {p_end}

{title:Version} 14.0 and higher.

{title:Description}
 {p}{cmd:SR_EASI}  This module can be used to estimate the income and price elasticities with the EASI demand system model. 
 It task is to prepare the data, to produce the R script, and then, to use intermediatelly the easi R package to estimate the model. In addition, this module 
 displays the following results. {p_end}
 
{title:The SR_EASI results}  
{p 2 8}{cmd: - List of tables:}{p_end}
{p 4 8}{inp:[01] Table 01: Estimated coefficients. }{p_end}
{p 4 8}{inp:[02] Table 02: Expenditure elasticities. }{p_end}
{p 4 8}{inp:[03] Table 03: Uncompensated Price elasticities.}{p_end}


{title:Options ((*) required)}

{p 4 8} {cmd:inisave:} To save the easi dialog box information. Mainly, all inserted information in the dialogue box will be save in this file. In another session, the user can open the project using the command easi_db_ini followed by the name of project. {p_end}

{p 4 8} {cmd:*prices:}  the list of the price variables. {p_end}

{p 4 8} {cmdab:*expenditures} the household expenditures. {p_end}

{p 4 8} {cmdab:*demographics}      The list of the independent variables (at least two demographic variables are required).  {p_end}

{p 4 8} {cmd:xfil}   To indicate the name of Excel file, that will be used to save the results (*.xml format). {p_end}

{p 4 8} {cmd:snames}    To declare varname of short names of items (the option oinf must be set to 2). {p_end}

{p 4 8} {cmd:dregres}    To display the regressions results. {p_end}

{p 4 8} {cmd:dislas}     To display the elasicities  of the last item. {p_end}

{p 4 8} {cmdab:rtool}   The user can indicate the path where the binary R tool is installed (ex: rtool(C:\Program Files\R\R-3.4.4\bin\x64\R.exe)). If not indicated, the module seeks autonmtically the path and the name of the R tool.  {p_end}

{p 4 8} {cmdab:power}   To set the power of the easi model (by defaut the power is 5). {p_end}

{p 4 8} {cmdab:inpy}    To add the interaction variables between the price variables and that of income. {p_end}

{p 4 8} {cmdab:inpz}    To add the interaction variables between the demographic variables and those of prices. {p_end}

{p 4 8} {cmdab:inyz}    To add the interaction variables between the demographic variables and that of income. {p_end}

{p 4 8} {cmdab:dec}     To set the number of decimals used in the display of results. {p_end}

{title:Examples}

{p 4 10 2}
NOTE: All the examples illustrated in the present and in the following sections
      can be run by clicking on the blue hyperlinks.

{title:Example 1: Estimating the cereal elasticities : easi with power 3.}
{cmd}
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
set seed 1234;
bsample 4000;
sr_easi wcorn wwheat wrice wother wcomp, 
prices(pcorn pwheat price pother pcomp) 
snames(corn wheat rice other comp) 
expenditure(hh_current_inc) inisave( ex1_easi_db.easi) 
demographics(age isMale educa2 educa3 educa4 educa5 educa6 educa7) 
dec(4) dregres(1) dislas(0) 
xfil(myres) 
power(3) 
inpy(1) inpz(0) inzy(0);
{txt}      ({stata "welcom_examples ex_easi_01":example 1: click to run in command window})
{txt}      ({stata "welcom_examples ex_easi_db_01 ":example 1: click to run in dialog box})


{title:Example 2: Estimating the cereal elasticities : easi with power 5.}
{cmd}
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
set seed 1234;
bsample 4000;
sr_easi wcorn wwheat wrice wother wcomp, 
prices(pcorn pwheat price pother pcomp) 
snames(corn wheat rice other comp) 
expenditure(hh_current_inc) inisave( ex2_easi_db.easi)  
demographics(age isMale educa2 educa3 educa4 educa5 educa6 educa7) 
dec(4) dregres(1) dislas(0) 
xfil(myres) 
power(5) 
inpy(1) inpz(1) inzy(0);
{txt}      ({stata "welcom_examples ex_easi_02":example 2: click to run in command window})
{txt}      ({stata "welcom_examples ex_easi_db_02 ":example 2: click to run in dialog box})



{title:Author(s)}
Abdelkrim Araar, Sergio Olivieri, Carlos Rodriguez Castelan


{title:Reference(s)}
{p 4 8} • Lewbel A (2009). \Demand Systems with and without Errors." The American Economic Review, 91.{p_end}
{p 4 8} • Lewbel A, Pendakur K (2009). \Tricks with Hicks : The EASI Demand System." The American Economic Review, 99.{p_end}
{p 4 8} • Pendakur K (2008). \EASI made Easier." In EASI made Easier. URL www.sfu.ca/pendakur/ EASImadeEasier.pdf.{p_end}
{p 4 8} • Stephane Hoareau, Guy Lacroix, Mirella Hoareau. Luca Tiberti (2012) , Exact Affine Stone Index Demand System in R: The easi Package http://www2.uaem.mx/r-mirror/web/packages/easi/vignettes/easi.pdf.{p_end}


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}
