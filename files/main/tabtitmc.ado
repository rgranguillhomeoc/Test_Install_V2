



#delimit ;
capture program drop tabtitmc;
program define tabtitmc, rclass sortpreserve;
version 9.2;
args ntab ;

local	tabtit_11	=	"Table 1.1: Models and parameters"	;
local	tabtit_13	=	"Table 1.3: Population and expenditures	(in currency)"	;

local	tabtit_21	=	"Table 2.1: Expenditures (in currency)	"	;
local	tabtit_22	=	"Table 2.2: Expenditures per household (in currency)	"	;
local	tabtit_23	=	"Table 2.3: Expenditures per capita (in currency)	"	;



local	tabtit_31	=	"Table 3.1: Structure of expenditure on subsidized products (in %)"	;
local	tabtit_32	=	"Table 3.2: Expenditure on subsidized products over the total expenditures (in %)	"	;
local	tabtit_33	=	"Table 3.3: The total benefits through subsidies (in currency)"	;


local	tabtit_41	=	"Table 4.1: The total impact on the population well-being (in currency)";		
local	tabtit_42	=	"Table 4.2: The impact on the per capita well-being (in currency)";	
local	tabtit_43	=	"Table 4.3: The impact on  well-being (in %)";	
local	tabtit_44	=	"Table 4.4: The impact on per capita well-being (consumers with non-nil expenditures)";                              

local	tabtit_51	=	"Table 5.1: The market power and the poverty headcount";		
local	tabtit_52	=	"Table 5.2: The market power and the poverty gap";
local	tabtit_53	=	"Table 5.3: The market power and the poverty squared gap";


local	tabtit_61	=	"Table 6.1: The market power and the inequality: Gini";		
local	tabtit_62	=	"Table 6.2: The market power and the inequality: Atkinson";
local	tabtit_63	=	"Table 6.3: The market power and the inequality: Entropy";
local	tabtit_64	=	"Table 6.4: The market power and the inequality: Ratio Q(p=0.1)/Q(p=0.9)";

return local tabtit `tabtit_`ntab'' ;
end;


