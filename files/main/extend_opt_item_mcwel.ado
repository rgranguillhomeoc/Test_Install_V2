

#delimit ;
capture program drop extend_opt_item_mcwel;
program define extend_opt_item_mcwel, rclass;
version 9.2;
syntax anything  [ ,  SN(string)  VN(string)    EL(string)  ST(string)  NF(string) SI(string) SCEN(string)];
local mylist sn vn el st nf si scen;
foreach name of local mylist {;
local ret ``name'' ;
return local `name' `ret';
};
end;

