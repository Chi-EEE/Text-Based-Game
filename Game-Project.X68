    ORG	$1000
SALARY      EQU 3208 * Cash every month
MILLION     EQU 1000000
START:
    * Ask User for name
    LEA NAME, A1
    MOVE.B #14, D0
    TRAP #15
    
    * Input name
    MOVE.B #2, D0
    TRAP #15
    
    * Moves the address location of the inputted name into PLAYER_NAME
    MOVE  A1,  PLAYER_NAME
    
	BRA GAME_LOOP
GAME_LOOP:
    MOVE.L  MONEY,  D2
    ADD.L   #SALARY, D2
    MOVE.L  D2,     MONEY
	
	MOVE.L  #MILLION, D4
	
    CMP.L     MONEY, D4
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
MONEY:          DS.L    1 * Reserve 1 LONG
PLAYER_NAME:    DS.W    1 * Reserve 1 WORD

WIN:    DC.B   'Congrats, your wealthy!', 0

NAME:           DC.B    'Enter the player name: ',0

* Later
WELCOME_MSG:    DC.B    '************************************************************'
                DC.B    $0D,$0A
                DC.B    'STRATEGY GAMES SUCH AS ZORK, AVALON, OR RABBITS VS PLUMBERS'
                DC.B    $0D,$0A
                DC.B    '************************************************************'
                DC.B    $0D,$0A,0
	END	START 

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
