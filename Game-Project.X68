    ORG	$1000
SALARY      EQU 3603 * Cash every month
START:	
	BRA GAME_LOOP
GAME_LOOP:
    MOVE.W  MONEY,  D2
    ADD.W   #SALARY, D2
    MOVE.W  D2,     MONEY
	
    CMP     #1000000, MONEY
    BGE     RICH
    BRA     GAME_LOOP
INPUT:
	
    RTS
UPDATE:

	RTS
RICH:
    LEA WIN, A1
    MOVE.B #14, D0
    TRAP #15
END_GAME:
    


	SIMHALT

* Starting Cash
MONEY:  DS.W    43240
WIN     'Congrats, your wealthy', 0

	END	START 

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
