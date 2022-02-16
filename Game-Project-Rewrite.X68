*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    
    ORG $1000

*-------------------------------------------------------
*VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*-------------------------------------------------------
EXIT        EQU 0      USED TO EXIT ASSEMBLY PROGRAM
SALARY      EQU 3208
MILLION     EQU 1000000

START:
    MOVE.W  #38500,MONEY
    
    BSR     WELCOME
    BRA     GAMELOOP
    
END:
    SIMHALT

*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
*-------------------------------------------------------
WELCOME:
    BSR     ENDL
    LEA     WELCOME_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    RTS

*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:
    LEA EVENT_OR_CITY, A1   LOAD MESSAGE
    MOVE.B #14, D0
    TRAP #15            DISPLAY MESSAGE
    BSR     ENDL        NEW LINE
    
    MOVE.B  #4, D0
    TRAP    #15         ASK FOR INPUT
    
    CMP.W   #0,D1       SHOP IF (D2 == #1)
    BEQ     EVENT
    CMP.W   #1,D1       ACTION IF (D2 == #1)
    BEQ     CITY
    BRA     GAMELOOP    LOOP FOREVER

*-------------------------------------------------------
*--------------------CITY SUBROUTINE--------------------
*-------------------------------------------------------
CITY:
    LEA CITY_MESSAGE, A1   LOAD MESSAGE
    MOVE.B #14, D0
    TRAP #15            DISPLAY MESSAGE
    BSR     ENDL        NEW LINE
    
    MOVE.B  #4, D0
    TRAP    #15         ASK FOR INPUT
    
    CMP.W   #0,D1       LEAVE IF (D2 == #0)
    BEQ     GAMELOOP
    CMP.W   #1,D1       SHOP IF (D2 == #1)
    BEQ     SHOP
    CMP.W   #2,D1       ACTION IF (D2 == #2)
    BEQ     ACTION
    RTS

*-------------------------------------------------------
*--------------------SHOP SUBROUTINE--------------------
*-------------------------------------------------------
SHOP:
    LEA SHOP_S, A1
    MOVE.B #14, D0
    TRAP #15
    BSR     ENDL
    BRA     CITY

*-------------------------------------------------------
*--------------------ACTION SUBROUTINE------------------
*-------------------------------------------------------
ACTION:
    LEA ACTION_S, A1
    MOVE.B #14, D0
    TRAP #15
    BSR     ENDL
    BRA     CITY
    
*-------------------------------------------------------
*--------------------EVENT SUBROUTINE-------------------
*-------------------------------------------------------
EVENT:
    LEA EVENT_S, A1
    MOVE.B #14, D0
    TRAP #15
    ADD.W   #SALARY, MONEY
    BRA     GAMELOOP
    
*-------------------------------------------------------
*--------------------ENDL SUBROUTINE--------------------
*-------------------------------------------------------
ENDL:
    MOVEM.L D0/A1,-(A7)
    MOVE    #14,D0
    LEA     CRLF,A1
    TRAP    #15
    MOVEM.L (A7)+,D0/A1
    RTS
    
*-------------------------------------------------------
*-------------------DATA DELARATIONS--------------------
*-------------------------------------------------------
CRLF:           DC.B    $0D,$0A,0
WELCOME_MSG:    DC.B    '************************************************************'
                DC.B    $0D,$0A
                DC.B    'STRATEGY GAMES SUCH AS ZORK, AVALON, OR RABBITS VS PLUMBERS'
                DC.B    $0D,$0A
                DC.B    '************************************************************'
                DC.B    $0D,$0A,0
        
INPUT_S         DC.B    'What would you like to do?'
                DC.B    $0D,$0A
                DC.B    '[0] = Shop' 
                DC.B    $0D,$0A
                DC.B    '[1] = Exit Shop.'
                DC.B    $0D,$0A, 0
EVENT_OR_CITY   DC.B    'TODO: EVENT OR CITY', 0
CITY_MESSAGE    DC.B    'TODO: CITY : 0 LEAVE; 1 SHOP; 2 ACTION',0
SHOP_S          DC.B    'TODO: SHOP', 0
ACTION_S        DC.B    'TODO: ACTION', 0
EVENT_S       DC.B    'TODO: EVENT', 0 

MONEY:    DS.W    1     PLAYER MONEY

	END	START



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
