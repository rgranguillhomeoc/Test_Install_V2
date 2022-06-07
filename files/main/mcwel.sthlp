{smcl}
{* June 2017}{...}
{hline}
{hi:WELCOM : Market Concentration and WELl-being}
help for {hi:mcwel }{right:Dialog box:  {bf:{dialog mcwel}}}
{hline}
{title: Market Concentration and WELl-being, poverty and inequality} 
{p 8 10}{cmd:mcwel}  {it:varlist (1 varnames)}  {cmd:,} [ 
{cmd:HSize(}{it:varname}{cmd:)} 
{cmd:HGroup(}{it:varname}{cmd:)}
{cmd:PLine(}{it:real}{cmd:)}  
{cmd:NITEMS(}{it:int}{cmd:)} 
{cmd:XFIL(}{it:string}{cmd:)} 
{cmd:FOLGR(}{it:string}{cmd:)}
{cmd:INISAVE(}{it:string}{cmd:)}  
{cmd:MEAS(}{it:int}{cmd:)} 
{cmd:MODEL(}{it:int}{cmd:)} 
{cmd:SUBS(}{it:real}{cmd:)}
{cmd:THETA(}{it:real}{cmd:)}
{cmd:EPSILON(}{it:real}{cmd:)}
{cmd:MOVE(}{it:int}{cmd:)} 
{cmd:TJOBS(}{it:string}{cmd:)} 
{cmd:GJOBS(}{it:string}{cmd:)} 
{cmd:ITk:  k:1...10:(}{it:Syntax }{cmd:)} 
{cmd:SN(}{it:string}{cmd:)} 
{cmd:IT(}{it:varname}{cmd:)} 
{cmd:EL(}{it:varname}{cmd:)} 
{cmd:ST(}{it:real}{cmd:)}
{cmd:NF(}{it:real}{cmd:)}
{cmd:SI(}{it:real}{cmd:)}
{cmd:SCEN(}{it:real}{cmd:)}
{cmd:GSCEN(}{it:int}{cmd:)} 
{cmd:OPGRk: k:1...10:(}{it:Syntax }{cmd:)} 
{cmd:MIN(}{it:string}{cmd:)} 
{cmd:MAX(}{it:string}{cmd:)} 
{cmd:OGR(}{it:string}{cmd:)} 
{cmd:GVIMP(}{it:int}{cmd:)} 
{cmd:GVPC(}{it:int}{cmd:)} 
]
 
{p}where {p_end}
{p 8 8} {cmd:varlist} The total per capita expenditures.{p_end}

{title:Description}
 {p}{cmd: Market Concentration and WELl-being}  {p_end}
 {p}{cmd:mcwel} estimates the impact of market concentration on well-being poverty and inequality. {p_end}
 {title:Version} 11.0 and higher.
 {p} Users should set their surveys' sampling design before using this module 
 (and save their data files). If the sampling design is not set, simple-random sampling (SRS) will be automatically assigned 
by default. {p_end}
{p 8 8} {cmd: mcwel} module is belonging the package WELCOM. It is conceived to automate the estimation the results of the market power impacts on well-being.  By default, the results are reported by quinitiles, but the user can indicate any other partition of population.  The following lists shows the produces tables and graphs:{p_end}

{p 2 8}{cmd:List of tables:}{p_end}
{p 4 8}{inp:[01] Table 1.1: Model(s) and parameter(s)}{p_end} 
{p 4 8}{inp:[02] Table 1.2: Population and expenditures}{p_end} 

{p 4 8}{inp:[03] Table 2.1: Expenditures }{p_end}
{p 4 8}{inp:[04] Table 2.2: Expenditures per household}{p_end}
{p 4 8}{inp:[05] Table 2.3: Expenditures per capita}{p_end}

{p 4 8}{inp:[06] Table 3.1: Structure of expenditure on products}{p_end}
{p 4 8}{inp:[07] Table 3.2: Expenditure on products over the total expenditures}{p_end}
{p 4 8}{inp:[08] Table 3.3: Proportion of real consumers}{p_end}

{p 4 8}{inp:[09] Table 4.1: The total impact on the population well-being}{p_end}
{p 4 8}{inp:[10] Table 4.2: The impact on the per capita well-being}{p_end}
{p 4 8}{inp:[11] Table 4.3: The impact on well-being (in %)}{p_end}
{p 4 8}{inp:[12] Table 4.4: The impact on the per capita well-being (real consumers population)}{p_end}


{p 4 8}{inp:[13] Table 5.1: The market power and the poverty headcount}{p_end}
{p 4 8}{inp:[14] Table 5.2: The market power and the poverty gap}{p_end}
{p 4 8}{inp:[15] Table 5.3: The market power and the squared poverty gap}{p_end}

{p 4 8}{inp:[16] Table 6.1: The market power and the inequality: Gini index}{p_end}
{p 4 8}{inp:[17] Table 6.2: The market power and the inequality: Atkinson index}{p_end}
{p 4 8}{inp:[18] Table 6.3: The market power and the inequality: Entropy index}{p_end}
{p 4 8}{inp:[19] Table 6.4: The market power and the inequality: Ratio index}{p_end}

{p 2 8}{cmd:List of graphs:}{p_end}
{p 4 8}{inp:[01] Figure 01: Market power and prices}{p_end}
{p 4 8}{inp:[02] Figure 02: The expenditures on the product(s) with concentration market to the total expenditures (in %)}{p_end}
{p 4 8}{inp:[03] Figure 03: The per capita impact on well-being}{p_end}
{p 4 8}{inp:[04] Figure 04: The Lorenz and concentration curves}{p_end}
{p 4 8}{inp:[05] Figure 05: Market power and poverty level (heacount)}{p_end}
{p 4 8}{inp:[06] Figure 06: Market power and inequality level (Gini)}{p_end}



{title:Options}

{p 0 4} {cmdab:hsize}        Household size. For example, to compute poverty at the individual level, one will want to weight household-level observations by household size (in addition to sampling weights, best set in survey design). {p_end}

{p 0 4} {cmdab:hgroup}       Variable that captures the socio-demographic group to be used in the decomposition. For example, for an urban-rural decomposition of poverty, this variable could equal 1 for rural households and 2 for urban ones. The associated varlist should contain only one variable. The user also can indicate the number of partition of the population (for instance, 10 for deciles) {p_end}

{p 0 4} {cmdab:pline}        To set the poverty line. {p_end}

{p 0 6} {cmd:nitems}   To indicate the number of items used in the simulation. For instance, if we plan to estimate the two independant market powers of gasoline and electricity  (we assume that we have the two variables of expenditures on these two items) the number of items is then two. {p_end}

{p 0 6} {cmd:it{cmd:k}: and k:1...10:}    To insert information on the item k by using the following syntax: {p_end}

{p 6 12}  {cmd:sn:}      To indicate the short label of the item. {p_end}
{p 6 12}  {cmd:it:}      To indicate the varname of the item. {p_end}
{p 6 12}  {cmd:el:}      To indicate the varname of the non-compensated own elasticity. {p_end}
{p 6 12}  {cmd:st:}      To indicate the struture of the market concentration. {p_end}
{p 12 3}  {cmd:1:}        Monopoly market structure. {p_end}
{p 12 3}  {cmd:2:}        Olipoly market structure with a Nash equilibrium. {p_end}
{p 12 3}  {cmd:3:}        Partial Collusive Olipoly market structure (PCO). {p_end}
{p 6 12}  {cmd:nf:}      To indicate the number of firms (Nash equilibrium).  {p_end}
{p 6 12}  {cmd:si:}      To indicate the market size of the oligolopy group (PCO model). {p_end}
{p 6 12}  {cmd:scen:}    To indicate the market size or number of firms at each step of adjustment. This must be done for all of the items. {p_end}

{p 0 6 }  {cmd:gscen:}    Add the option gscen(1) to use the indicated market size and number of firms. {p_end}

{p 0 12} {cmd:Example:} it3( sn(Electricity) it(pc_elec)  el(-1.5) st(1) ). {p_end}

{p 0 6} {cmd:meas}   To indicate the method used to estimate the impact on well-being. By default, the Lasperyres measurement is used. When this option is set to 2 (appr(2)), the measurement is that of the equivalent variation. Choose number 3 for the compensated variation measurement. {p_end}

{p 0 6} {cmd:model}   To indicate the model of consumer preferences. ( (1) Cobb-Douglas (2) CES ). {p_end}

{p 0 6} {cmd:subs}   To indicate the level of the constant elasticity of substition of the CES function. {p_end}

{p 0 6} {cmd:move}   To indicate the direction of the change in the market structure. By default, change is that from the competitive market to the concentrated market. Indicate move(-1) to inverse the direction of the change. {p_end}

{p 0 6} {cmd:gvimp}   Indicate 1 to generate a new variable(s) that will contain the per capita impact on wellbeing. This option will not function with the qualifiers if/in. {p_end}

{p 0 6} {cmd:gvpc}   Indicate 1 to generate the price change variable(s). {p_end}

{p 0 6} {cmd:epsilon}   To indicate the parameter for the estimation of the Atkinson index of inequality. {p_end}

{p 0 6} {cmd:theta}   To indicate the parameter for the estimation of the generalised entropy index of inequality. {p_end}


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

{title:Example(s):}

{p 4 8}{inp: use http://dasp.ecn.ulaval.ca/welcom/examples/mc_example.dta , clear}{p_end}
{p 4 8}{inp: mcwel communication, hsize(hsize) pline(pline) gvimp(1) typemc(3)}{p_end}


{title:Examples}

{p 4 10 2}
NOTE: All the examples illustrated in the present and in the following sections
      can be run by clicking on the blue hyperlinks.
	  
	  
{title:Example 1: Estimating the impact using one item}
{cmd}
#delimit ; 
sysuse Mexico_2014.dta, replace; 
mcwel pc_income, hsize(hhhsize) pline(pline) gvimp(1) 
inisave(mcwel_example_01) nitems(1) 
it1( sn(Combustible) vn(pcexp_comb) el(-0.904) st(3) si(0.4231) ) 
move(-1) epsilon(.5) 
opgr2( min(0) max(0.9) )
opgr3( min(0) max(0.9) ) 
xfil(myexample2)  folgr(Graphs)
;
{txt}      ({stata "welcom_examples ex_mc_01":example 1: click to run in command window})
{txt}      ({stata "welcom_examples ex_mc_db_01 ":example 1: click to run in dialog box})

{title:Example 2: Estimating the impact using three items and intermediate periods of adjustements}
{cmd}
#delimit ; 
sysuse Mexico_2014.dta, replace; 
mcwel pc_income, hsize(hhhsize) pline(pline) gvimp(1) 
inisave(mcwel_example_01) nitems(3) 
it1( sn(Combustible) vn(pcexp_comb) el(-0.904) st(3) si(0.4231) ) 
it2( sn(Communication) vn(pcexp_comu) el(-0.643) st(2) nf(8) ) 
it3( sn(Cereals) vn(pcexp_cereal) el(-.92700186) st(3) si(0.3471) ) 
mpart(6) move(-1) epsilon(.5) 
opgr2( min(0) max(0.9) )
opgr3( min(0) max(0.9) ) 
xfil(myexample2)  folgr(Graphs)
;
{txt}      ({stata "welcom_examples ex_mc_02":example 2: click to run in command window})
{txt}      ({stata "welcom_examples ex_mc_db_02 ":example 2: click to run in dialog box})


{title:Example 3: Similar to example 2, but by specifiying the size of firms at each step of adjustment. }
{cmd}
#delimit ; 
sysuse Mexico_2014.dta, replace; 
mcwel pc_income, hsize(hhsize) pline(pline) gvimp(1) 
inisave(mcwel_example_03) nitems(3)  
it1( sn(Combustible) vn(pcexp_comb)   el(elas1) st(3) si(0.4231) scen(0.3 0.2) ) 
it2( sn(Communication) vn(pcexp_comu) el(elas2) st(2) nf(8)      scen(12   30)  ) 
it3( sn(Cereals) vn(pcexp_cereal)     el(elas3) st(3) si(0.3471) scen(0.2 0.1) ) 
mpart(2) gscen(1) move(-1) epsilon(.5) 
opgr2( min(0) max(0.9) )
opgr3( min(0) max(0.9) ) 
xfil(myexample1)  folgr(Graphs)
;
{txt}      ({stata "welcom_examples ex_mc_03":example 3: click to run in command window})
{txt}      ({stata "welcom_examples ex_mc_db_03 ":example 3: click to run in dialog box})





{title:Author(s)}
Abdelkrim Araar, Sergio Olivieri and Carlos Rodriguez Castelan 

{title:Reference(s)}  


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}











