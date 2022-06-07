{smcl}
{* October 2020}{...}
{hline}
{hi:WELCOM : Price Change(s), direct and indirect effects and WELl-being}
help for {hi:prcwel_ind }{right:Dialog box:  {bf:{dialog prcwel_ind}}}
{hline}
{title: Price Change(s) and WELl-being, poverty and inequality} 
{p 8 10}{cmd:prcwel_ind}  {it:varlist (1 varnames)}  {cmd:,} [ 
{cmd:HSize(}{it:varname}{cmd:)} 
{cmd:HGroup(}{it:varname}{cmd:)}
{cmd:PLine(}{it:real}{cmd:)}  
{cmd:NITEMS(}{it:int}{cmd:)} 
{cmd:XFIL(}{it:string}{cmd:)} 
{cmd:INISAVE(}{it:string}{cmd:)}  
{cmd:MEAS(}{it:int}{cmd:)} 
{cmd:MODEL(}{it:int}{cmd:)} 
{cmd:SUBS(}{it:real}{cmd:)}
{cmd:MATPEL(}{it:string}{cmd:)} 
{cmd:MATIEL(}{it:string}{cmd:)} 
{cmd:STOM(}{it:int}{cmd:)} 
{cmd:THETA(}{it:real}{cmd:)}
{cmd:EPSILON(}{it:real}{cmd:)}
{cmd:TJOBS(}{it:string}{cmd:)} 
{cmd:ITk:  k:1...10:(}{it:Syntax }{cmd:)} 
{cmd:SN(}{it:string}{cmd:)} 
{cmd:IT(}{it:varname}{cmd:)} 
{cmd:PRC(}{it:varname}{cmd:)} 
{cmd:ELAS(}{it:varname}{cmd:)} 
{cmd:ITNAMES(}{it:varname}{cmd:)} 
{cmd:SNAMES(}{it:varname}{cmd:)}
{cmd:GVIMP(}{it:int}{cmd:)} 
{cmd:IOMATRIX(}{it:filename}{cmd:)}
{cmd:IOMODEL(}{it:int}{cmd:)}
{cmd:ADSHOCK(}{it:int}{cmd:)}
{cmd:TYSHOCK(}{it:int}{cmd:)}
{cmd:NSHOCKS(}{it:int}{cmd:)}
{cmd:NADP(}{it:int}{cmd:)}
{cmd:INITEMS(}{it:int}{cmd:)}
{cmd:IITNAMES(}{it:varname}{cmd:)} 
{cmd:ISNAMES(}{it:varname}{cmd:)} 
{cmd:MATCH(}{it:varname}{cmd:)} 
{cmd:IELAS(}{it:varname}{cmd:)} 
]
 
{p}where {p_end}
{p 8 8} {cmd:varlist} The total per capita expenditures.{p_end}

{title:Description}
 {p}{cmd: Price Change(s), direct and indirect and WELl-being}  {p_end}
 {p}{cmd: prcwel_ind} estimates the direct and indirect of price change(s)  on well-being, poverty and inequality. {p_end}
 {title:Version} 11.0 and higher.
 {p} Users should set their surveys' sampling design before using this module 
 (and save their data files). If the sampling design is not set, simple-random sampling (SRS) will be automatically assigned 
by default. {p_end}
{p 8 8} {cmd: prcwel_ind} module is belonging the package WELCOM. It is conceived to automate the estimation the results of the direct and directs effects of price change(s)on well-being.  By default, the results are reported by quinitiles,  but the user can indicate any other partition of population.  The following list show the produces tables:{p_end}

{p 2 8}{cmd:List of tables:}{p_end}
{p 4 8}{inp:[01] Table 1.0: Estimaded price changes of consumption aggregates with the I/O model and the matching map}{p_end}
{p 4 8}{inp:[02] Table 1.1: Information on Variables}{p_end}
{p 4 8}{inp:[03] Table 1.2: Population and expenditures}{p_end} 

{p 4 8}{inp:[04] Table 2.1: Expenditures }{p_end}
{p 4 8}{inp:[05] Table 2.2: Expenditures per household}{p_end}
{p 4 8}{inp:[06] Table 2.3: Expenditures per capita}{p_end}

{p 4 8}{inp:[07] Table 3.1: Structure of expenditure on products}{p_end}
{p 4 8}{inp:[08] Table 3.2: Expenditure on products over the total expenditures}{p_end}
{p 4 8}{inp:[09] Table 3.3: Proportion of real consumers}{p_end}

{p 4 8}{inp:[10] Table 4.1: The total impact on the population well-being}{p_end}
{p 4 8}{inp:[11] Table 4.2: The impact on the per capita well-being}{p_end}
{p 4 8}{inp:[12] Table 4.3: The impact on well-being (in %)}{p_end}
{p 4 8}{inp:[13] Table 4.4: The impact on the per capita well-being (real consumers population)}{p_end}

{p 4 8}{inp:[14] Table 5.1: The market power and the poverty headcount}{p_end}
{p 4 8}{inp:[15] Table 5.2: The market power and the poverty gap}{p_end}
{p 4 8}{inp:[16] Table 5.3: The market power and the squared poverty gap}{p_end}

{p 4 8}{inp:[17] Table 6.1: The market power and the inequality: Gini index}{p_end}
{p 4 8}{inp:[18] Table 6.2: The market power and the inequality: Atkinson index}{p_end}
{p 4 8}{inp:[19] Table 6.3: The market power and the inequality: Entropy index}{p_end}
{p 4 8}{inp:[20] Table 6.4: The market power and the inequality: Ratio index}{p_end}


{title:Options}

{p 0 4}  {cmd: General Info.} {p_end}

{p 0 4} {cmdab:hsize}        Household size. For example, to compute poverty at the individual level, one will want to weight household-level observations by household size (in addition to sampling weights, best 
> set in survey design). {p_end}

{p 0 4} {cmdab:hgroup}       Variable that captures the socio-demographic group to be used in the decomposition. For example, for an urban-rural decomposition of poverty, this variable could equal 1 for rural hou
> seholds and 2 for urban ones. The associated varlist should contain only one variable. The user also can indicate the number of partition of the population (for instance, 10 for deciles) {p_end}

{p 0 4} {cmdab:pline}        To set the poverty line. {p_end}

{p 0 6} {cmd:epsilon}   To indicate the parameter for the estimation of the Atkinson index of inequality. {p_end}

{p 0 6} {cmd:theta}   To indicate the parameter for the estimation of the generalised entropy index of inequality. {p_end}

{p 0 6} {cmd:xfil}   To indicate the name of Excel file, that will be used to save the results (*.xml format). {p_end}

{p 0 6} {cmd:inisave:}    To save the subsim project information. Mainly, all inserted information in the dialogue box will be save in this file. In another session, the user can open the project using the command asubini followed by the name of project. This command will initialise all of the information of the asubsim dialog box. {p_end}

{p 0 6} {cmd:tjobs:}    You may want to produce only a subset of tables. In such case, you have to select the desired tables by indicating their codes with the option tjobs. 
For instance: tjops(11 21) . See also: {bf:{help jtables_mc}}. {p_end}



{p 0 4}  {cmd: Information on direct effect(s)} {p_end}

{p 0 6} {cmd:nitems}   To indicate the number of items used in the simulation. For instance, if we plan to estimate the two independant market powers of gasoline and electricity  (we assume that we have the two variables of expenditures on these two items) the number of items is then two. {p_end}

{p 0 6} {cmd:it{cmd:k}: and k:1...10:}    To insert information on the item k by using the following syntax: {p_end}

{p 6 12}  {cmd:sn:}      To indicate the short label of the item. {p_end}
{p 6 12}  {cmd:it:}      To indicate the varname of the item. {p_end}
{p 6 12}  {cmd:prc:}     To indicate the varname of the proptional price change of the item. {p_end}
{p 6 12}  {cmd:elas:}    To indicate the varname of own price elasticity of the item. {p_end}


{p 0 6} {cmd:oinf:}       To indicate the form to declare the information about items (name of variables of expenditues on items, prices/price shedules, etc). When variables are used to initialise the information the value must be set to 2. {p_end}

{p 0 6} {cmd:snames:}     To declare varname of short names of items (the option oinf must be set to 2). {p_end}
{p 0 6} {cmd:itnames:}    To declare the varname of items in one string variable (the option oinf must be set to 2). {p_end}
{p 0 6} {cmd:prc:}        To indicate the varname of initial price schedules of items before the reform  (the option oinf must be set to 2). {p_end}
{p 0 6} {cmd:elas{cmd:s}}   To indicate the varname of the non-compensated price elasicities for scenario s (the option oinf must be set to 2). {p_end}


{p 0 6} {cmd:meas}   To indicate the method used to estimate the impact on well-being. By default, the Lasperyres measurement (first order taylor approximation) is used.  For the second order Taylor approximation, we can also indicate the own price elasticities.  When the option is set to 3 (meas(3)), the measurement is the of the equivalent variation. Choose number 4 for the compensated variation measurement. {p_end}

{p 0 6} {cmd:stom}   For the second order Taylor approximation, the user can indicate the disared measurement to be approximated. {p_end}

{p 6 12}  {cmd:stom(1)}      To approximate the CS measurement. {p_end}
{p 6 12}  {cmd:stom(2)}      To approximate the EV measurement. {p_end}
{p 6 12}  {cmd:stom(3)}      To approximate the CV measurement. {p_end}

{p 0 6} {cmd:matpel}   To indicate the name of squared matrix of price elasticities (optional for stom(1) and required for stom(2) or stom(3)) . {p_end}

{p 0 6} {cmd:matiel}   To indicate the name of row matrix of income elasticities (required for stom(2) or stom(3)) . {p_end}

{p 0 6} {cmd:model}   To indicate the model of consumer preferences. ( (1) Cobb-Douglas (2) CES ). {p_end}

{p 0 6} {cmd:subs}   To indicate the level of the constant elasticity of substition of the CES function. {p_end}

{p 0 6} {cmd:gvimp}   Indicate 1 to generate a new variable(s) that will contain the per capita impact on wellbeing. This option will not function with the qualifiers if/in. {p_end}



{p 0 4}  {cmd: Information of direct effect(s)} {p_end}

{p 0 4} {cmdab:iomatrix}   To indicate the filename of datafile with (n+1) observations and (n) variables. Except the last observation, the rest forms the square I/O matrix on (n) sectors. The last line of this data file must contain the value added of each sector. {p_end}

{p 0 4} {cmdab:iomodel}   To indicate the IO proche change model. {p_end}

{p 0 4} {cmdab:nshocks}   To indicate the number of sectors affected by the exogenous price shocks (maximum is 6). {p_end}

{p 0 4} {cmdab:shock'i': and 'i' : 1-6}   To intialise the information of price shock i. Example: shock1( secp(2) pr(10)), which means we have an exogenious price shock (in crease of 10%) in the sector 2 (2 is the position of the sector in the IO matrix). {p_end}

{p 0 4} {cmdab:secp}    To indicate the line position of the sector with the exogenous proce shock. {p_end}

{p 0 4} {cmdab:pr}     To indicate the level of price shock (in %) . {p_end}

{p 0 4} {cmdab:nadp}    For the short term results, the user can indicate the number of the periods of price adjustments. {p_end}

{p 0 4} {cmdab:tyshock}    To indicate if the price shock is permenent -exogenous model- (1) or temporary -endogenous model- (2). {p_end}

{p 0 4} {cmdab:adshock}    To indicate this the price change is that of the short term or that of the long term. {p_end}

{p 0 6} {cmd:initems}      To indicate the number of consumption aggregate items. {p_end}
{p 0 6} {cmd:isnames}     To declare varname of short names of consumption aggregates . {p_end}
{p 0 6} {cmd:iitnames}    To declare the varname of  in one string variable (of of consumption aggregates). {p_end}
{p 0 6} {cmd:ielas{cmd:s}}   To indicate the price elasicities of consumption aggregates . {p_end}
{p 0 6} {cmd:match}  To indicate the varname of matching map. {p_end}




{title:Example(s):}

{p 4 8}{inp: sysuse mc_example.dta , clear}{p_end}
{p 4 8}{inp: prcwel communication, hsize(hsize) pline(pline) gvimp(1) typemc(3)}{p_end}


{title:Examples}

{p 4 10 2}
NOTE: All the examples illustrated in the present and in the following sections
      can be run by clicking on the blue hyperlinks.
          
          
{title:Example 1: Estimating the impact using one item}
{cmd}
#delimit ; 
sysuse IOM_EGY2015.dta, replace;
save   IOM_EGY2015.dta, replace;
sysuse "hh_data_egypt.dta", replace ;
prcwel_ind pcexp, hsize(hhsize) pline(pline) hgroup(Urbrur) inisave(Example_1) xfil(example_1) gvimp(1) 
it1( sn(Electricity and gas) it(pc_D0450) prc(dp_D0450) elas(elas) )  
it2( sn(Purchase of vehicles)  it(pc_G0710) prc(dp_G0710) elas(elas) ) nitems(2) 
iomatrix("IOM_EGY2015.dta") nshocks(5)  
iomodel(1) adshock(1) tyshock(1)  
shock1( secp(45) pr(-8) ) shock2( secp(36) pr(-10) ) shock3( secp(37) pr(-10) )  
shock4( secp(38) pr(-10) ) shock5( secp(39) pr(-10) ) 
isnames(label) iitnames(item) match(code) initems(39) 
;
{txt}      ({stata "welcom_examples ex_prc_ind_01    ":example 1: click to run in command window})
{txt}      ({stata "welcom_examples ex_prc_ind_db_01 ":example 1: click to run in dialog box})





{title:Author(s)}
Abdelkrim Araar, Carlos Rodriguez Castelan, Eduardo Alonso Malasquez Carbonel and Rogelio Granguillhome Ochoa

{title:Reference(s)}  


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}











