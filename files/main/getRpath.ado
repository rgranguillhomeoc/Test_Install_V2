
cap prog drop getRpath
program define getRpath , rclass
	
	     
	macro drop RcallError								
	
	// -------------------------------------------------------------------------
	// Search R path, if not specified
	// =========================================================================
	capture prog drop Rpath
	capture Rpath
	tokenize `"`macval(0)'"'
	
	if `"`macval(1)'"' != "setpath" & `"`macval(1)'"' != "setpath:" {
		if missing("$Rpath") {
			
			if "`c(os)'" == "Windows" {
				local wd : pwd
				capture quietly cd "C:\Program Files\R"
				if _rc != 0 {
					capture quietly cd "C:\Program Files (x86)\R"
					if _rc != 0 {
						display as err "R was not found on your system. Setup R path manually"
						exit 198
					}
				}
				local folder : pwd
				local Rdir : dir "`folder'" dirs "R-*", respectcase
				tokenize `"`Rdir'"'
				while `"`1'"' != "" {
					local newest_R `"`1'"'
					macro shift
				}
				quietly cd `"`newest_R'\bin"'
				local path : pwd
				local path : display "`path'\R.exe"	
				*global Rpath : display "`path'"  
				quietly cd "`wd'"
			}
			
			// for linux and Mac try 2 possible default paths
			else {
				local path "/usr/bin/r"
				capture confirm file "`path'"
				if _rc != 0 {
					local path "/usr/local/bin/R"
					global Rpath : display "`path'"
				}	
			}
			if !missing("`debug'") {
				di _n "{title:Path to R}" _n								///
				"The path to R was {err:guessed} to be:"  _n
				display `"{err:`path'}"'
			}
		}
		else {
			local path = "$Rpath"
			if !missing("`debug'") {
				di _n "{title:Path to R}" _n								///
				"The path to R was obtained from {err:Rpath.ado} to be:"  _n
				display `"{err:`path'}"'
			}
		}	

		capture confirm file "`path'"
		if _rc != 0 {
			di as txt "{p}R was expected in:    `path'"
			display as err "{bf:rcall} could not find R on your system"
			err 198
		}
	}
	return local rpath  "`path'"
	
end
