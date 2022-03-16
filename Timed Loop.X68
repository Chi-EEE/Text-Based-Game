  ORG    $1000
START: 
    MOVE.B  #10, D4
LOOP:
    LEA     Dot,A1
NEXT_PRINT:
    BSR     PRINT
    BSR     GET_MILLISECONDS
    MOVE.L  D1,D2
NEXT: 
    BSR     GET_MILLISECONDS
    
    MOVE    D2,D3
    SUB     D3,D1
    
    CMP     #100,D1
    BLS     NEXT
    
    SUB     #1, D4
    CMP     #0, D4
    BNE     NEXT_PRINT
    
    BRA     COMPLETE
PRINT:
	MOVE.B  #14,D0
	TRAP	#15
	RTS
GET_MILLISECONDS:
    MOVE.B #8, D0 # Load
    TRAP #15  #Time in D1
    RTS
    
COMPLETE:
    SIMHALT  
    
Dot  		    DC.B	'.',0
          
    END    START
    
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
