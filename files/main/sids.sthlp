{smcl}
{* June 2018}{...}
{hline}
{hi:SIDS : Single Item Demand System}
help for {hi:sids }{right:Dialog box:  {bf:{dialog sids}}}
{hline}
{title:Syntax} 
{p 8 10}{cmd:sids}  {it:varlist (3 varnames)}  {cmd:,} [ 
{cmd:INCPAR(}{it:varname}{cmd:)}  
{cmd:HGROUP(}{it:varname}{cmd:)}
{cmd:INCINT(}{it:int}{cmd:)} 
{cmd:INC(}{it:int}{cmd:)}
{cmd:INDCAT(}{it:varlist}{cmd:)} 
{cmd:INDCON(}{it:varlist}{cmd:)} 
{cmd:DREGRES(}{it:int}{cmd:)} 
{cmd:DGRA(}{it:int}{cmd:)} 
{cmd:DEC(}{it:int}{cmd:)} 
{cmd:XFIL(}{it:string}{cmd:)} 
]
{p_end}
 {p} where  {p_end}
{p 8 8} {cmd:varlist (min=3 max=3)} The household' purchased quantity of the item of interest, the household' price -or unit value- and the household disposable income (or total expenditures).{p_end}
{title:Description}
{p} The {cmd:sids} module is conceived to estimate the price elasticity by deciles.  
{p_end}
 
{title:Sampling design} 
 {p} Users should set their surveys' sampling design before using this module 
 (and save their data files). If the sampling design is not set, simple-random sampling (SRS) will be automatically assigned 
by default. {p_end}

{title:Version} 14.0 and higher.
{title:Options}

{p 0 4} {cmdab:incpar}      Variable that captures the groups income partition, as the decile, the quintile,etc.  {p_end}
{p 0 4} {cmdab:hgroup}      To indicate  groups variable.  {p_end}
{p 0 4} {cmdab:incint}      Select the option incint(1) to indicate the interaction between the household group dummies and the log_income variable.  {p_end}
{p 0 4} {cmdab:inc}         Select the option incint(0) to do not use the variable: log_income.  {p_end}
{p 0 4} {cmdab:indcat}      The list of the independent variables that are categorical.  {p_end}
{p 0 4} {cmdab:indcon}     The list of the independent variables that are continues.  {p_end}  
{it:twoway_options} are any of the options documented in 
{it:{help twoway_options}}.  These include options for titling the graph 
(see {it:{help title_options}}), options for saving the graph to disk (see 
{it:{help saving_option}}), and the {opt by()} option (see 
{it:{help by_option}}).
{p 6 12} {cmd:xfil :}    To indicate  the path and the name of the  excel (*.xml) file to save the results. {p_end}
{p 6 12} {cmd:dec:}         To indicate number of decimals of the displayed results. {p_end}
{p 6 12} {cmd:dgra:}        Add the option dgra(1) to display graph of elasticities by deciles. {p_end}
{p 6 12} {cmd:dregres:}     Add the option dregres(1) to display full results of the estimations. {p_end}



{title:Examples}

{p 4 10 2}
NOTE: All the examples illustrated in the present and in the following sections
      can be run by clicking on the blue hyperlinks.

{title:Example 1: Estimating the cereal elasticities}
{cmd}
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
sids hh_q_corn pcorn hh_current_inc, hgroup(quintile)  indcon(age)  ;
{txt}      ({stata "welcom_examples ex_sids_01":example 1: click to run in command window})



{title:Example 2: Estimating the cereal elasticities and the standard errors (with the bootstrap approach)}
{cmd}
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
sids hh_q_corn pcorn hh_current_inc, hgroup(sex) incpar(decile) indcon(age) incint(1)  xfil(myres)  dgra(1)   ;
{txt}      ({stata "welcom_examples ex_sids_02":example 2: click to run in command window})




{title:Reference(s)}
{p 4 8} • Angus Deaton. The Analysis of Household Surveys: A Microeconometric Approach to Development Policy. Johns Hopkins University Press, 1997.{p_end}


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}
