



#delimit ;
cap program drop extend_opt_item_pr;
program define extend_opt_item_pr, rclass;
version 9.2;
syntax anything  [ ,  SN(string)  IT(string)    PRC(string)  ELAS(string) ];
local mylist sn it prc elas;
foreach name of local mylist {;
local ret ``name'' ;
return local `name' `ret';
};
end;


