	ORG	$1000
START:	MOVE.B #1, $2000
	BRA GAME_LOOP
GAME_LOOP:
	MOVE.B $2000, D3
	CMP #1, D3
	BNE END_GAME
	BSR INPUT
	BSR UPDATE
	BSR DRAW
	BRA GAME_LOOP
		
INPUT:
	MOVE.B #4,D0
	TRAP #15
	MOVE.B D1, $2000    * Moves inputted value into memory address 2000
	
    RTS
UPDATE:

	RTS
END_GAME:

	SIMHALT

	END	START 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
