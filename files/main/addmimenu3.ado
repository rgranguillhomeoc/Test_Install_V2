cap program drop  addmimenu3
program  addmimenu3
                version 11.0
                args nfile lcom
                tempname fh
                local linenum = 0
				local stopa = 0
				cap findfile `nfile' 
                local dire `r(fn)'
                file open `fh' using `"`dire'"', read write
                file read `fh' line
                while r(eof)==0 & `stopa' != 1 {
                        local linenum = `linenum' + 1
                        if (`"`macval(line)'"'=="`lcom'") {
						local stopa = 1
						dis "The Stata command line _welcom_menu aready exists in the profile.do file."
						}
						
                        file read `fh' line
                }
			    if `stopa' == 0 {
				file write `fh' `"`lcom'"' _n
				dis "The Stata command line _welcom_menu was added in the profile.do file."
				}
                file close `fh'
end
