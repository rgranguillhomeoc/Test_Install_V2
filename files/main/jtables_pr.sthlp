{smcl}
{title:Specifying the codes of tables to be produced} 

You may want to produce only a subset of tables. In such case, you have to select the desired tables by indicating their codes with the option tjobs. 

Code: The title of table

11  :   Table 1.1: Information on Variables  
12  :   Table 1.2: Population and expenditures

21  :   Table 2.1: Expenditures  
22  :   Table 2.2: Expenditures per household  
23  :   Table 2.3: Expenditures per capita       

31  :   Table 3.1: Structure of expenditure on products
32  :   Table 3.2: Expenditure on products over the total expenditures
33  :   Table 3.3: Proportion of real consumers

41  :   Table 4.1: The total impact on the population well-being
42  :   Table 4.2: The impact on the per capita well-being
43  :   Table 4.3: The impact on well-being (in %)
44  :   Table 4.4: The impact on the per capita well-being (real consumers population)

51  :   Table 5.1: The market power and the poverty headcount
52  :   Table 5.2: The market power and the poverty gap
53  :   Table 5.3: The market power and the squared poverty gap

61  :   Table 6.1: The market power and the inequality: Gini index
62  :   Table 6.2: The market power and the inequality: Atkinson index
63  :   Table 6.3: The market power and the inequality: Entropy index
64  :   Table 6.4:  The market power and the inequality: Ratio index


{title:Example}
tjobs(11 23)

