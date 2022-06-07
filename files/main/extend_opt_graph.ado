

#delimit ;
capture program drop extend_opt_graph;
program define extend_opt_graph, rclass;
version 9.2;
syntax anything  [ ,  MIN(string)  MAX(string) OGR(string)];
local mylist min max ogr;
foreach name of local mylist {;
local ret ``name'' ;
return local `name' `ret';
};
end;
