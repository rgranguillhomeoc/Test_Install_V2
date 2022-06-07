{smcl}
{* January 2021}{...}
{hline}
{hi:mcema : Market Competition and the Extensive Margin Analysis}
help for {hi:mcema }{right:Dialog box:  {bf:{dialog mcema}}}
{hline}
{title:Syntax} 
{p 2 10}{cmd:mcema}  {it:varlist (2 varnames)}  {cmd:,} [ 
{cmd:PRICE(}{it:varname}{cmd:)}  
{cmd:welfare(}{it:varname}{cmd:)}
{cmd:hszie(}{it:varname}{cmd:)}
{cmd:pline(}{it:varname}{cmd:)}
{cmd:ICHANGE(}{it:varname}{cmd:)} 
{cmd:PCHANGE(}{it:varname}{cmd:)}  
{cmd:INCPAR(}{it:varname}{cmd:)}  
{cmd:HGROUP(}{it:varname}{cmd:)}
{cmd:INDCAT(}{it:varlist}{cmd:)} 
{cmd:INDCON(}{it:varlist}{cmd:)} 
{cmd:PSWP(}{it:real}{cmd:)} 
{cmd:PSWE(}{it:real}{cmd:)} 
{cmd:UM(}{it:int}{cmd:)} 
{cmd:DREG(}{it:int}{cmd:)} 
{cmd:DEC(}{it:int}{cmd:)} 
{cmd:XFIL(}{it:string}{cmd:)} 
{cmd:EXPSHARE(}{it:varname}{cmd:)}
{cmd:DISGR(}{it:varname}{cmd:)}
{cmd:EXPMOD(}{it:int}{cmd:)} 
{cmd:SEED(}{it:int}{cmd:)} 
{cmd:NQUANTILE(}{it:int}{cmd:)
{cmd:GRMOD1(}{it:varname}{cmd:)
{cmd:GRMOD2(}{it:varname}{cmd:)
{cmd:FEX(}{it:int}{cmd:)} 
{cmd:FPR(}{it:int}{cmd:)} 
{cmd:FIN(}{it:int}{cmd:)} 
{cmd:CINDCAT(}{it:varlist}{cmd:)} 
{cmd:CINDCON(}{it:varlist}{cmd:)} 
{cmd:OOPT(}{it:string}{cmd:)} 
{cmd:INISAVE(}{it:string}{cmd:)} 
{cmd:EXNUM(}{it:int}{cmd:)}
{cmd:GRMAC(}{it:varname}{cmd:)}
{cmd:TOTENTR(}{it:varname}{cmd:)}
{cmd:TOTUSER(}{it:varname}{cmd:)}
]
{p_end}
 {p} where the first component of the {cmd:varlist (min=2 max=2)} is a dummy variable of the househcurrent's consumption of the item of interest. The second is the househcurrent/individual expenditures on the item of interest.  
{p_end}
{title:Description}
{p} The {cmd:mcema} module is conceived to estimate the change in proportion of users or consumers implied by price or income changes. Also, it estimates the impact on well-being of current and new consumers.  
{p_end}

{title:The MCEMA results}  
{p 2 8}{cmd: - List of tables:}{p_end}
{p 4 8}{inp:[01] Table 01: Estimates of the probability of consumption model(s).}{p_end}
{p 4 8}{inp:[02] Table 02: Estimated impact on the proportions of consumers.}{p_end}
{p 4 8}{inp:[03] Table 03: Estimated impact on well-being.}{p_end}
{p 4 8}{inp:[04] Table 04: Poverty headcount & market power.}{p_end}
{p 4 8}{inp:[05] Table 05: Poverty gap & market power.}{p_end}
{p 4 8}{inp:[06] Table 06: Gini index & market power.}{p_end}
 
{title:Sampling design} 
{p} Users should set their surveys' sampling design before using this module(and save their data files). If the sampling design is not set, simple-random sampling (SRS) will be automatically assigned  by default. {p_end}

{title:Version} 14.0 and higher.

{title:Options}

{title:- Probilistic model options:}
{p 3 4} {cmdab:welfare}  welfare variable as the per capita income or the per capita total expenditures. {p_end}
{p 3 4} {cmdab:hsize}   Househcurrent size or the number of househcurrent members. {p_end}
{p 3 4} {cmdab:pline}   To indicate poverty line variable. {p_end}
{p 3 4} {cmdab:incpar}      Variable that captures the group welfare partition, as the decile, the quintile,etc.  {p_end}
{p 3 4} {cmdab:hgroup}      To indicate  group variable (ex.: rural/urban).  {p_end}
{p 3 4} {cmdab:incint}      Select the option incint(1) to indicate the interaction between the househcurrent group dummies and the log_welfare variable in the probabilistic model.  {p_end}
{p 3 4} {cmdab:indcat}      The list of the independent variables that are categorical.  {p_end}
{p 3 4} {cmdab:indcon}      The list of the independent variables that are continues.  {p_end} 
{p 3 4} {cmdab:pswp}        To indicate the significance level criteria for the {it:{help stepwise}} selection of explanatory variables.{p_end} 
{p 3 4} {cmdab:um}          To indicate the desired model in prediction of the probabilities. If we denote I#P, the model where the price or the income interacts with the income partition (quintile for instance), G#P the model where the price or the income interacts with the population groups (rural/urban for instance) and  I.G#P  the model where the price or the income interacts with the cross variable Income partition times population groups, we have that:  {p_end} 

{p 6 4} [1] - The option um(1) precit the probability with the population model (simple model).){p_end}
{p 6 4} [2] - The option um(2) precit the probability with the population model and the interactions I#P.){p_end}
{p 6 4} [3] - The option um(3) precit the probability with the population model and the interactions G#P.){p_end}
{p 6 4} [4] - The option um(4) precit the probability with the population model and the interactions I.G#P.){p_end}
{p 6 4} [5] - The option um(5) precit the probability with the population groups models.){p_end}
{p 6 4} [6] - The option um(6) precit the probability with the population groups models and the interactions I#P.){p_end}


{title:- Expenditure model options: }
{p 3 4} {cmd:expmod :} to indicate the model to estimate the expenditures of the potential new users.  {p_end}
{p 6 4} [1] - Add the option expmod(1) if you would like to perform an imputation of expenditures with the averages of population groups, as deciles, PSUs, etc. Note that the user can indicate one or two population group variables (see the options grmod1 and grmod2){p_end}

{p 6 4} [2] - Add the option expmod(2) if you would like to perform a random imputation of expenditures.  The random imputation can be performed by population groups (see the options grmod1 and grmod2){p_end}

{p 6 4} [3] - Add the option expmod(3) if you would like to perform an imputation of expenditures  based on the predicted values of linear regression model(s).  Linear regressions can be done by population groups (see the options grmod1 and grmod2){p_end}

{p 6 4} [4] - Add the option expmod(4) if you would like to perform the imputation of expenditures as a sum of two components. The first is the predicted values with the linear regression. The second is based in a random imputation of residuals.  The process can be done by population groups (see the options grmod1 and grmod2). Also, the random imputation will be replicated until having positive expenditures for each househcurrent. {p_end}

{p 6 4} [5] - Add the option expmod(5) if you would like to perform an imputation of expenditures  based on the predicted values of quantile regression model(s).  The regressions can be done by population groups (see the options grmod1 and grmod2){p_end}

{p 6 4} [6] - Add the option expmod(6) if you would like to perform the imputation of expenditures as a sum of two components. The first is the predicted values with the quantile regression. The second is based in a random imputation of residuals.  The process can be done by population groups (see the options grmod1 and grmod2). Also, the random imputation will be replicated until having positive expenditures for each househcurrent. {p_end}

{p 3 4} {cmdab:grmod1}      To indicate the first variable of population group used with the selected model expenditures. If not initialized, the estimation of expenditures is done at population level .{p_end} 
{p 3 4} {cmdab:grmod2}      To indicate the second variable of population group with selected model expenditures). By initializing variables grmod1 and grmod2, the estimation of expenditures is made for each of the combination of modalilities of the group  variables (ex: decile1_rural, decile1_urban, decile2_rural, decile2_urban, ....). {p_end} 
{p 3 4} {cmdab:nquantile}   To indicate the number of quantile regressions (integer number).  {p_end} 
{p 3 4} {cmdab:seed}      To indicate the seed for random imputation models (integer number).  {p_end} 
{p 3 4} {cmdab:fex}      To indicate the functional form of expenditures (dependent variable).  {p_end} 
{p 6 4} [1] - Expenditures {p_end}
{p 6 4} [2] - Log of expenditures.{p_end}
{p 3 4} {cmdab:fpr}      To indicate the functional form of price (dependent variable).  {p_end} 
{p 6 4} [1] - Price {p_end}
{p 6 4} [2] - Log of price.{p_end}
{p 6 4} [3] - Do not use the price variable.{p_end}
{p 3 4} {cmdab:fin}      To indicate the functional for of welfare (dependent variable).  {p_end} 
{p 6 4} [1] - welfare {p_end}
{p 6 4} [2] - Log of welfare.{p_end}
{p 3 4} {cmdab:cindcat}      The list of the independent variables that are categorical.  {p_end}
{p 3 4} {cmdab:cindcon}      The list of the independent variables that are continues.  {p_end} 
{p 3 4} {cmdab:oopt}      To indicate the other(s) options of the regression (ex. oopt(nocons robust) ).    {p_end} 
{p 3 4} {cmdab:pswe}      To indicate the significance level criteria for the {it:{help stepwise}} selection of explanatory variables.{p_end} 
{p 3 4} {cmdab:disgr}      To  display the results by population groups. By default, results are displayed by quintile groups.{p_end} 

{title:- Results options: }
{p 3 4} {cmd:xfil :}        To indicate  the path and the name of the  excel (*.xml) file to save the results. {p_end}
{p 3 4} {cmd:dec:}          To indicate number of decimals of the displayed results. {p_end}
{p 3 4} {cmd:dreg:}         Add the option dregres(1) to display full results of the estimations. {p_end}

{p 4 8} {cmd:inisave:} To save the mcema dialog box information. Mainly, all inserted information in the dialog box will be saved in this file. In another session, the user can open the project using the command mcema_db_ini followed by the name of project. {p_end}

{p 4 8} {cmd:exnum:} Add the option exnum(1) to use the exogenous information on the number of entrants or total users at national level or by region (group) {p_end}
{p 4 8} {cmd:grmac:} To indicate the variable of population group according to the availability of exogenous information on the number of entrants or total users. {p_end}
{p 4 8} {cmd:totentr:} To indicate the -exogenous- information on the number of total users. {p_end}
{p 4 8} {cmd:totuser:} To indicate the -exogenous- information on the number of total entrants. {p_end}
{title:Examples}

{p 4 10 2}
NOTE: All the examples illustrated in the present and in the following sections
      can be run by clicking on the blue hyperlinks.


{title:Example 1:  Using average expenditures in PSU's for the prediction of expenditures on mobile communications. }
{cmd}
#delimit ; 
sysuse Mexico_2014_Cellphones.dta , replace; 
mcema d_cell pc_exp_cell, expmod(1) grmod1(psu) welfare(pc_income) hsize(hhsize) hgroup(tam_loc) pline(pline) 
indcat(socio educ) indcon(hhsize) pswp(.05) pchange(price_change) ichange(income_change) expshare(eshare) 
um(1) dec(3) inisave(example1) xfil(myres1);

{txt}      ({stata "welcom_examples ex_mcema_01":example 1: click to run in command window})
{txt}      ({stata "welcom_examples ex_mcema_db_01 ":example 1: click to run in dialog box})


{title:Example 2:  Using a regression model for the prediction of expenditures on mobile communications. }
{cmd}
#delimit ; 
sysuse Mexico_2014_Cellphones.dta , replace; 
mcema d_cell pc_exp_cell, expmod(3) welfare(pc_income) hsize(hhsize) hgroup(tam_loc) ///
indcat(socio educ) indcon(hhsize) pswp(.05) pchange(price_change) ichange(income_change) ///
expshare(eshare) ewgr(quintile) um(3) dec(3) fex(2) fpr(3) fin(2) cindcat(socio educ) ///
cindcon(age) inisave(example2) xfil(myres2) pline(pline) disgr(tam_loc);

{txt}      ({stata "welcom_examples ex_mcema_02":example 2: click to run in command window})
{txt}      ({stata "welcom_examples ex_mcema_db_02 ":example 2: click to run in dialog box})



{title:Example 3:  Using exogenous information on total entrants -new cellphone users- in Mexico between 2014 and 2018. }
{cmd}
#delimit ; 
sysuse Mexico_2014_Cellphones.dta , replace; 
mcema d_cell pc_exp_cell, expmod(3) grmod1(decile) grmod2(tam_loc) welfare(pc_income) hsize(hhsize) hgroup(tam_loc) pline(pline) 
incpar(quintile) indcat(socio educ) indcon(hhsize) pswp(.05) pswe(.05) pchange(pchange) um(5) dec(3) fex(2) fpr(3) fin(2) 
exnum(1) grmac(entity) totentr(new_users) cindcat(sex) cindcon(age) inisave(example3) xfil(myres3);

{txt}      ({stata "welcom_examples ex_mcema_03":example 3: click to run in command window})
{txt}      ({stata "welcom_examples ex_mcema_db_03 ":example 3: click to run in dialog box})


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}

