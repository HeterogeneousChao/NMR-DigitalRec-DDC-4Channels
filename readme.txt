 FPGA Proj:  4 Channels DDC
 Device:     Altera 5cgxfc6e6f27c7n

 each channel:  
	
										            -> DataOutI
   	    -> X  -> CIC1->CICC1           						  | -> DataOutCLK
          |    | (cos)           |						          | 
   IF  -> |   NCO                | -> MUX(PS) -> CIC2 -> CICC2 -> MHBF -> DFIR -> MUX(SP) |            
          |    | (sin)           |  					                  |
    	    -> X  -> CIC1->CICC1 						          | -> DataOutQ
   	  										    -> DataOutClkQ




									  ZHAOCHAO
									  	20180517
