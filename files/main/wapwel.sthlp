{smcl}
{* Mayo 2019}{...}
{hline}
{hi:WELCOM : Wages Adjustments, Prices and WELl-being}
help for {hi:wapwel }{right:Dialog box:  {bf:{dialog wapwel}}}
{hline}
{title: Wages adjustments, prices, well-being, poverty and inequality} 
{p 8 10}{cmd:lmcwel}  {it:varlist (1 varnames)}  {cmd:,} [ 
{cmd:HSize(}{it:varname}{cmd:)} 
{cmd:HGroup(}{it:varname}{cmd:)}
{cmd:PLine(}{it:real}{cmd:)} 
{cmd:IOMATRIX(}{it:filename}{cmd:)}
{cmd:IOMODEL(}{it:int}{cmd:)}
{cmd:ADSHOCK(}{it:int}{cmd:)}
{cmd:NADP(}{it:int}{cmd:)}
{cmd:NITEMS(}{it:varname}{cmd:)} 
{cmd:ITVNAMES(}{it:varname}{cmd:)}
{cmd:ITNAMES(}{it:varname}{cmd:)} 
{cmd:SECNAMES(}{it:varname}{cmd:)} 
{cmd:MATCH(}{it:varname}{cmd:)} 
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
{p 8 8} {cmd:varlist}  Wages Adjustments, Prices and WELl-being.{p_end}

{title:Description}
 {p}{cmd:  Wages Adjustments, Prices and WELl-being}  {p_end}
 {p}{cmd:wapwel} estimates the impact of wages adjustments on prices of final goods, and then, on well-being, poverty and inequality. {p_end}
 {title:Version} 14.0 and higher.
 {p} Users should set their surveys' sampling design before using this module 
 (and save their data files). If the sampling design is not set, simple-random sampling (SRS) will be automatically assigned 
by default. {p_end}
{p 8 8} {cmd: wapwel} module is belonging the package WELCOM. It is conceived to automate the estimation the wages adjustments on well-being, and this, using the I/O model.  By default, the results are reported by quinitiles, but the user can indicate any other partition of population.  The following lists shows the produces tables and graphs:{p_end}
{p 2 8}{cmd:List of tables:}{p_end}

{p 4 8}{inp:[01] Table 1: Sectoral Price Changes (in %)} {p_end}
{p 4 8}{inp:[02] Table 2: Good Price Changes (in %)}     {p_end}
{p 4 8}{inp:[03] Table 3: Population and Expenditures}  {p_end}
{p 4 8}{inp:[04] Table 4: The  Impact on Well-being}     {p_end}
{p 4 8}{inp:[05] Table 5: The Structure of the Impact on Well-being} {p_end}
{p 4 8}{inp:[06] Table 6: The Impact on Poverty }        {p_end}
{p 4 8}{inp:[07] Table 7: The Impact on Inequality}     {p_end}



{title:Options}


{p 0 4} {cmdab:hsize}        Household size. For example, to compute poverty at the individual level, one will want to weight household-level observations by household size (in addition to sampling weights, best set in survey design). {p_end}

{p 0 4} {cmdab:hgroup}       Variable that captures the socio-demographic group to be used in the decomposition. For example, for an urban-rural decomposition of poverty, this variable could equal 1 for rural households and 2 for urban ones. The associated varlist should contain only one variable. The user also can indicate the number of partition of the population (for instance, 10 for deciles) {p_end}

{p 0 4} {cmdab:pline}        To set the poverty line. {p_end}

{p 0 6} {cmd:epsilon}   To indicate the parameter for the estimation of the Atkinson index of inequality. {p_end}

{p 0 6} {cmd:theta}   To indicate the parameter for the estimation of the generalised entropy index of inequality. {p_end}

{p 0 12} {cmd:itnames:}     To declare varname of short names of items . {p_end}

{p 0 12} {cmd:itvnames:}    To declare the varname of items in one string variable . {p_end}

{p 0 12} {cmd:secnames:}     To declare varname of short names of sectors . {p_end}


{p 0 12} {cmd:match}  To indicate the varname of matching sectors(the option oinf must be set to 2). {p_end}

{p 0 12} {cmd:iomatrix}   To indicate the filename of datafile with (n+3) observations and (n) variables. Except the three last observations, the rest forms the square I/O matrix on (n) sectors. The three last lines of this data file must contain {p_end}
{p 6 12} 1- The value added of the sector; {p_end}
{p 6 12} 2- The cost of labor of the sector; {p_end}
{p 6 12} 3- The proportional changes in wage of the sector. {p_end}

{p 0 12} {cmdab:adshock}    To indicate if the price change is that of the short term adshock(1) or that of the long term adshock(2). {p_end}


{p 0 12} {cmd:opgr{cmd:g} and g:1...6::}    Inserting options of graph g by using the following syntax: {p_end}
{p 6 12} {cmd:min:}    To indicate the minimum of the range of x-Axis of figure k. {p_end}
{p 6 12} {cmd:max:}    To indicate the maximum of the range of x-Axis of figure k. {p_end}
{p 6 12} {cmd:opt:}    To indicate additional twoway graph options of figure k. {p_end}
{phang}{it:twoway_options} are any of the options documented in {it:{help twoway_options}}.  These include options for titling the graph  (see {it:{help title_options}}), options for saving the graph to disk (see  {it:{help saving_option}}), and the {opt by()} option (see {it:{help by_option}}).

{p 0 12} {cmd:xfil}   To indicate the name of Excel file, that will be used to save the results (.xml format). {p_end}


{p 0 12} {cmd:folgr}   To indicate the name the folder in which the graph results will be saved. {p_end}

{p 0 6} {cmd:inisave:}    To save the subsim project information. Mainly, all inserted information in the dialogue box will be save in this file. In another session, the user can open the project using the command asubini followed by  the name of project. This command will initialise all of the information of the asubsim dialog box. {p_end}

{p 0 6} {cmd:tjobs:}    You may want to produce only a subset of tables. In such case, you have to select the desired tables by indicating their codes with the option tjobs. 
For instance: tjops(1 2) . See also: {bf:{help jtables_mc}}. {p_end}

{p 0 6} {cmd:gjobs:}    You may want to produce only a subset of graphs. In such case, you have to select the desired graphs by indicating their codes with the option gjobs. 
For instance: gjops(1) . See also: {bf:{help jgraphs_mc}}. {p_end}


{title:Example(s)}

{p 4 10 2}
NOTE: All the examples illustrated in the present and in the following sections
      can be run by clicking on the blue hyperlinks.
          
          
{title:Example 1: Estimating the impact of labor market concentration (Mexico 2014)}
{cmd}
#delimit ; 
sysuse SAM_MEX_2003.dta, replace;
save   SAM_MEX_2003.dta, replace;
sysuse Mexico_2014_WAP.dta , replace; 
wapwel pc_income, hsize(hhsize) pline(pline) inisave(myexp) nitems(11) itnames(itnames) 
itvnames(vnnames) match(match_sec) iomatrix(SAM_MEX_2003.dta) 
secnames(secnames) opgr1( max(0.95) ) xfil(myfile)
;
{txt}      ({stata "welcom_examples ex_wap_01":example 1: click to run in command window})
{txt}      ({stata "welcom_examples ex_wap_db_01 ":example 1: click to run in dialog box})




{title:Author(s)}
Abdelkrim Araar, Sergio Olivieri and Carlos Rodriguez Castelan 

{title:Reference(s)}  


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}











