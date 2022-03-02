*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    
    ORG $1000

*-------------------------------------------------------
*VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*-------------------------------------------------------
EXIT        EQU 0      USED TO EXIT ASSEMBLY PROGRAM
SALARY      EQU 38500
MILLION     EQU 1000000
HUNDREDTHOUSAND EQU 100000

START:
    MOVE.W  #38500,MONEY
    
    BSR     WELCOME
    BSR     INPUT_NAME
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
*-------------------NAME INPUT SUBROUTINE---------------
*-------------------------------------------------------
INPUT_NAME:
    BSR     ENDL
    LEA     enterName,A1
    MOVE.B  #14,D0
	
    TRAP    #15
    BSR     ENDL        *NEW LINE
    
    MOVE.B  #2,D0
    LEA     NAME, A1    *LOAD NAME ADDRESS TO A1
    TRAP    #15         *INPUT NAME
    
    RTS

*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:
    LEA mainChoice, A1   *LOAD MESSAGE
    MOVE.B #14, D0
    TRAP #15            *DISPLAY MESSAGE
    BSR     ENDL        *NEW LINE
    
    MOVE.B  #4, D0
    TRAP    #15         *ASK FOR INPUT
    
    CMP.W   #1,D1       *SHOP IF (D2 == #1)
    BEQ     EVENT
    CMP.W   #2,D1       *ACTION IF (D2 == #2)
    BEQ     CITY
    BRA     GAMELOOP    *LOOP FOREVER

*-------------------------------------------------------
*--------------------CITY SUBROUTINE--------------------
*-------------------------------------------------------
CITY:
    BSR     DISPLAY_DETAILS
    LEA 	cityChoice, A1   *LOAD MESSAGE
    MOVE.B #14, D0
    TRAP #15            *DISPLAY MESSAGE
    BSR     ENDL        *NEW LINE
    
    MOVE.B  #4, D0
    TRAP    #15         *ASK FOR INPUT
    
    CMP.W   #1,D1       *LEAVE IF (D2 == #1)
    BEQ     GAMELOOP
    CMP.W   #2,D1       *SHOP IF (D2 == #2)
    BEQ     SHOP
    CMP.W   #3,D1       *EXPLORE IF (D2 == #3)
    BEQ     EXPLORE
    CMP.W   #4,D1       *MANAGE IF (D2 == #4)
    BEQ     MANAGE
    BRA     CITY

*-------------------------------------------------------
*--------------------SHOP SUBROUTINE--------------------
*-------------------------------------------------------
SHOP:
    LEA shopChoice, A1
    MOVE.B #14, D0
    TRAP #15
    BSR     ENDL
    BRA     CITY

*-------------------------------------------------------
*--------------------EXPLORE SUBROUTINE-----------------
*-------------------------------------------------------
EXPLORE:
    LEA exploreChoice, A1
    MOVE.B #14, D0
    TRAP #15
    BSR     SYSTEM_PAUSE
    BRA     CITY
    
*-------------------------------------------------------
*--------------------MANAGE SUBROUTINE------------------
*-------------------------------------------------------
MANAGE:
    LEA manageChoice, A1
    MOVE.B #14, D0
    TRAP #15
    BSR     SYSTEM_PAUSE
    BRA     CITY
    
*-------------------------------------------------------
*--------------------EVENT SUBROUTINE-------------------
*-------------------------------------------------------
EVENT:
    LEA eventText, A1
    MOVE.B #14, D0
    TRAP #15
    ADD.W   #SALARY, MONEY
    ADD.W   #1,AGE
    BSR     SYSTEM_PAUSE
    BRA     GAMELOOP
    

*-------------------------------------------------------
*--------------------ENDL SUBROUTINE--------------------
*-------------------------------------------------------
DISPLAY_DETAILS:
    MOVE.B  #11,D0
    MOVE.W  #$FF00,D1
    TRAP    #15
    LEA     display,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
      
*-------------------------------------------------------
*----------------SYSTEM PAUSE SUBROUTINE----------------
*-------------------------------------------------------
SYSTEM_PAUSE:
    BSR     ENDL
    LEA PAUSE, A1   *DISPLAY PAUSE MESSAGE
    MOVE.B #14, D0
    TRAP #15            
    MOVE.B  #5,D0       *WAIT FOR SINGLE CHARACTER
    TRAP    #15
    BSR     ENDL
    RTS
    
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
                DC.B    'Life with Carbon Tax!'
                DC.B    $0D,$0A
                DC.B    '************************************************************'
                DC.B    $0D,$0A,0
enterName		DC.B    'Please enter your name: ',0
mainChoice   	DC.B    'TODO: EVENT OR CITY', 0
cityChoice	    DC.B    'TODO: CITY ||| 1 LEAVE; 2 SHOP; 3 EXPLORE;4 MANAGE',0
shopChoice      DC.B    'TODO: SHOP', 0
exploreChoice	DC.B   'TODO: EXPLORE', 0
manageChoice 	DC.B    'TODO: MANAGE', 0
eventText       DC.B    'TODO: EVENT', 0 
display      DC.B    'TODO: DISPLAY', 0
PAUSE          DC.B    'Press any key to continue . . .', 0

NAME:     DS.W    1
MONEY:    DS.W    1     PLAYER MONEY
AGE:      DS.W    1     PLAYER AGE || START AT 0 TO 52

	END	START




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
