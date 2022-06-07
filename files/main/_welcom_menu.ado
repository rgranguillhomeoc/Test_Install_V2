/*************************************************************************/
/* mcwel: Market Concentration and Welfare  (Version 2.20)               */
/*************************************************************************/
/* Conceived  by :                                                       */
/*     Abdelkrim Araar                                                   */
/*     Eduardo Malasquez                                                 */
/*     Sergio Olivieri                                                   */
/*     Carlos Rodriguez-Castelan                                         */
/* email : aabd@ecn.ulaval.ca                                            */
/* 14/Nov/2018 			                                         */
/*************************************************************************/


cap program drop _welcom_menu 
program define _welcom_menu
qui { 
/*window menu clear*/
window menu append submenu "stUser" "&WELCOM"
window menu append submenu "WELCOM"   "&Goods Market Concentration" 
window menu append submenu "WELCOM"   "&Labor Market Concentration" 
window menu append submenu "WELCOM"   "&Demand System Models"
window menu append submenu "WELCOM"   "&Price(s) and Well-being"
                
window menu append item "Goods Market Concentration" /* 
        */   "Market concentration and well-being"        "db mcwel" 

window menu append item "Goods Market Concentration" /* 
        */   "Market Competition and the Extensive Margin Analysis"        "db mcema" 
        
window menu append item "Labor Market Concentration" /* 
        */   "Labor market concentration and well-being"        "db lmcwel"             
        
window menu append item "Labor Market Concentration" /* 
                */   "Wages Adjustments, Prices and Well-being"        "db wapwel"    
				
window menu append item "Price(s) and Well-being" /* 
                */   "Price(s) Change(s) and Well-being"        "db prcwel" 

				
window menu append separator "WELCOM"   

window menu append item "Demand System Models" /* 
        */   "The DUVM model"        "db duvm" 
window menu append item "Demand System Models" /* 
        */   "The AIDS/QUAIDS model(s)"        "db wquaids" 
window menu append item "Demand System Models" /* 
        */   "The EASI model"        "db sr_easi" 

window menu append item "Demand System Models" /* 
        */   "The Single Item Demand System"   "db sids" 

window menu append item "WELCOM" /* 
        */   "WELCOM Package Manager "  "db welcom" 
  
window menu refresh
}
end
