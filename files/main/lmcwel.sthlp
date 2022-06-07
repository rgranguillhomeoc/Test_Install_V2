{smcl}
{* June 2017}{...}
{hline}
{hi:WELCOM : Labor Market Concentration and WELl-being}
help for {hi:lmcwel }{right:Dialog box:  {bf:{dialog lmcwel}}}
{hline}
{title: Labor Market Concentration and WELl-being, poverty and inequality} 
{p 8 10}{cmd:lmcwel}  {it:varlist (1 varnames)}  {cmd:,} [ 
{cmd:HHID(}{it:varlist}{cmd:)}
{cmd:HSize(}{it:varname}{cmd:)} 
{cmd:HGroup(}{it:varname}{cmd:)}
{cmd:PLine(}{it:real}{cmd:)}  
{cmd:INCOMES(}{it:string}{cmd:)} 
{cmd:SECTORS(}{it:string}{cmd:)} 
{cmd:XFIL(}{it:string}{cmd:)} 
{cmd:FOLGR(}{it:string}{cmd:)}
{cmd:INISAVE(}{it:string}{cmd:)}  
{cmd:THETA(}{it:real}{cmd:)}
{cmd:EPSILON(}{it:real}{cmd:)}
{cmd:TJOBS(}{it:string}{cmd:)} 
{cmd:GJOBS(}{it:string}{cmd:)} 
{cmd:MIN(}{it:string}{cmd:)} 
{cmd:MAX(}{it:string}{cmd:)} 
{cmd:OGR(}{it:string}{cmd:)} 
{cmd:GVIMP(}{it:int}{cmd:)} 
]
 
{p}where {p_end}
{p 8 8} {cmd:varlist} The total per capita expenditures.{p_end}

{title:Description}
 {p}{cmd: Labor Market Concentration and WELl-being}  {p_end}
 {p}{cmd:lmcwel} estimates the impact of labor market concentration on well-being poverty and inequality. {p_end}
 {title:Version} 11.0 and higher.
 {p} Users should set their surveys' sampling design before using this module 
 (and save their data files). If the sampling design is not set, simple-random sampling (SRS) will be automatically assigned 
by default. {p_end}
{p 8 8} {cmd: lmcwel} module is belonging the package WELCOM. It is conceived to automate the estimation the results of the market power impacts on well-being.  By default, the results are reported by quinitiles, but the user can indicate any other partition of population.  The following lists shows the produces tables and graphs:{p_end}

{p 2 8}{cmd:List of tables:}{p_end}
{p 4 8}{inp:[01] Table 1.1: Population and expenditures}{p_end} 

{p 4 8}{inp:[02] Table 2.1: Proportion of workers by economic sectors (in %)}{p_end}

{p 4 8}{inp:[03] Table 3.1: Average household income by economic sectors}{p_end}
{p 4 8}{inp:[04] Table 3.2: Average per capita income by economic sectors}{p_end}
{p 4 8}{inp:[05] Table 3.3: Average personal income by economic sectors (workers population)}{p_end}

{p 4 8}{inp:[06] Table 4.1: The total impact on the population well-being}{p_end}
{p 4 8}{inp:[07] Table 4.2: The impact on the per capita well-being}{p_end}
{p 4 8}{inp:[08] Table 4.3: The impact on well-being (in %)}{p_end}

{p 4 8}{inp:[09] Table 5.1: The labor market power and the poverty headcount}{p_end}
{p 4 8}{inp:[10] Table 5.2: The labor market power and the poverty gap}{p_end}
{p 4 8}{inp:[12] Table 5.3: The labor market power and the squared poverty gap}{p_end}

{p 4 8}{inp:[13] Table 6.1: The labor market power and the inequality: Gini index}{p_end}
{p 4 8}{inp:[14] Table 6.2: The labor market power and the inequality: Atkinson index}{p_end}
{p 4 8}{inp:[15] Table 6.3: The labor market power and the inequality: Entropy index}{p_end}
{p 4 8}{inp:[16] Table 6.4: The labor market power and the inequality: Ratio index}{p_end}

{p 2 8}{cmd:List of graphs:}{p_end}
{p 4 8}{inp:[01] Figure 01: The per capita impact on well-being}{p_end}
{p 4 8}{inp:[02] Figure 02: The Lorenz and concentration curves}{p_end}



{title:Options}

{p 0 4} {cmdab:hhid}        Household identifier. One or more of the identifier variables of households. {p_end}

{p 0 4} {cmdab:hsize}        Household size. For example, to compute poverty at the individual level, one will want to weight household-level observations by household size (in addition to sampling weights, best set in survey design). {p_end}

{p 0 4} {cmdab:hgroup}       Variable that captures the socio-demographic group to be used in the decomposition. For example, for an urban-rural decomposition of poverty, this variable could equal 1 for rural households and 2 for urban ones. The associated varlist should contain only one variable. The user also can indicate the number of partition of the population (for instance, 10 for deciles) {p_end}

{p 0 4} {cmdab:pline}        To set the poverty line. {p_end}

{p 0 6} {cmd:epsilon}   To indicate the parameter for the estimation of the Atkinson index of inequality. {p_end}

{p 0 6} {cmd:theta}   To indicate the parameter for the estimation of the generalised entropy index of inequality. {p_end}

{p 0 6} {cmd:incomes}   To indicate the path and filename of the personal incomes data file. {p_end}

{p 0 6} {cmd:incomes}   To indicate the path and filename of the sectors data file. {p_end}

{p 0 6} {cmd:opgr{cmd:g} and g:1...6::}    Inserting options of graph g by using the following syntax: {p_end}
{p 6 12} {cmd:min:}    To indicate the minimum of the range of x-Axis of figure k. {p_end}
{p 6 12} {cmd:max:}    To indicate the maximum of the range of x-Axis of figure k. {p_end}
{p 6 12} {cmd:opt:}    To indicate additional twoway graph options of figure k. {p_end}
{phang}
{it:twoway_options} are any of the options documented in 
{it:{help twoway_options}}.  These include options for titling the graph 
(see {it:{help title_options}}), options for saving the graph to disk (see 
{it:{help saving_option}}), and the {opt by()} option (see 
{it:{help by_option}}).

{p 0 6} {cmd:xfil}   To indicate the name of Excel file, that will be used to save the results (*.xml format). {p_end}
{p 0 6} {cmd:folgr}   To indicate the name the folder in which the graph results will be saved. {p_end}
{p 0 6} {cmd:inisave:}    To save the subsim project information. Mainly, all inserted information in the dialogue box will be save in this file. In another session, the user can open the project using the command asubini followed by the name of project. This command will initialise all of the information of the asubsim dialog box. {p_end}


{p 0 6} {cmd:tjobs:}    You may want to produce only a subset of tables. In such case, you have to select the desired tables by indicating their codes with the option tjobs. 
For instance: tjops(11 21) . See also: {bf:{help jtables_mc}}. {p_end}

{p 0 6} {cmd:gjobs:}    You may want to produce only a subset of graphs. In such case, you have to select the desired graphs by indicating their codes with the option gjobs. 
For instance: gjops(1 2) . See also: {bf:{help jgraphs_mc}}. {p_end}



{title:Example(s)}

{p 4 10 2}
NOTE: All the examples illustrated in the present and in the following sections
      can be run by clicking on the blue hyperlinks.
	  
	  
{title:Example 1: Estimating the impact of labor market concentration (Mexico 2014)}
{cmd}
#delimit ; 
sysuse sectors.dta, replace;
save sectors.dta, replace;
sysuse incomes.dta, replace;
save incomes.dta, replace;
sysuse Mexico_2014.dta , replace; 
lmcwel pc_income, hhid(folioviv foliohog) hsize(hhhsize) pline(pline) 
inisave(myexp) 
incomes(incomes.dta) 
sectors(sectors.dta) 
epsilon(.5) xfil(myexcel) folgr(mygraphs)
;
{txt}      ({stata "welcom_examples ex_lmc_01":example 1: click to run in command window})
{txt}      ({stata "welcom_examples ex_lmc_db_01 ":example 1: click to run in dialog box})




{title:Author(s)}
Abdelkrim Araar, Sergio Olivieri and Carlos Rodriguez Castelan 

{title:Reference(s)}  


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}











