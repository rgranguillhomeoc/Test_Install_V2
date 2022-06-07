



#delimit ;
capture program drop tabtitlmc;
program define tabtitlmc, rclass sortpreserve;
version 9.2;
args ntab ;

local	tabtit_11	=	"Table 1.1: Population and expenditures	"	;

local	tabtit_21	=	"Table 2.1: Proportion of workers by economic sectors (in %)"	;

local	tabtit_31	=	"Table 3.1: Average household  income by economic sectors"	;
local	tabtit_32	=	"Table 3.2: Average per capita income by economic sectors"	;
local	tabtit_33	=	"Table 3.3: Average personal income by economic sectors (workers population) "	;


local	tabtit_41	=	"Table 4.1: The total impact on the population well-being ";		
local	tabtit_42	=	"Table 4.2: The impact on the per capita well-being ";	
local	tabtit_43	=	"Table 4.3: The impact on  well-being (in %)";	
local	tabtit_44	=	"Table 4.4: The impact on the per capita well-being  (real consumers population)";                              

local	tabtit_51	=	"Table 5.1: The labor market power and the poverty headcount";		
local	tabtit_52	=	"Table 5.2: The labor market power and the poverty gap";
local	tabtit_53	=	"Table 5.3: The labor market power and the poverty squared gap";


local	tabtit_61	=	"Table 6.1: The labor market power and the inequality: Gini";		
local	tabtit_62	=	"Table 6.2: The labor market power and the inequality: Atkinson";
local	tabtit_63	=	"Table 6.3: The labor market power and the inequality: Entropy";
local	tabtit_64	=	"Table 6.4: The labor market power and the inequality: Ratio Q(p=0.1)/Q(p=0.9)";

return local tabtit `tabtit_`ntab'' ;
end;


