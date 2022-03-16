*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
	
	ORG $1000

*-------------------------------------------------------
*VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*-------------------------------------------------------
EXIT		EQU 0	  USED TO EXIT ASSEMBLY PROGRAM
SALARY	  EQU 38500
MILLION	 EQU 1000000
HUNDREDTHOUSAND EQU 100000

START:
	MOVE.W  #SALARY,MONEY
	
	BSR	 	WELCOME
	BSR	 	INPUT_NAME
	BSR	 	INTRO
	BRA	 	GAMELOOP
	
END:
	SIMHALT


*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
*-------------------------------------------------------
WELCOME:
	BSR	 	ENDL
	LEA	 	welcome_string,A1
	MOVE.B  #14,D0
	TRAP	#15
	BSR	 	ENDL
	RTS

*-------------------------------------------------------
*-------------------INTRO SUBROUTINE--------------------
*-------------------------------------------------------
INTRO:
	BSR	 	ENDL
	LEA	 	intro_string,A1
	BSR	 	PRINT
	
	LEA	 	name,A1
	BSR	 	PRINT
	
	LEA	 	tripleDot,A1
	BSR	 	PRINT
	
    BSR	 	ENDL
	
	BSR	 	SYSTEM_PAUSE
	BSR	 	CLEAR_SCREEN

	LEA	 	story_string_1,A1
	BSR	 	PRINT
	
	BSR	 	ENDL
	
	BSR	 	SYSTEM_PAUSE
	BSR	 	CLEAR_SCREEN

	RTS

*-------------------------------------------------------
*-------------------NAME INPUT SUBROUTINE---------------
*-------------------------------------------------------
INPUT_NAME:
	BSR	 	ENDL
	LEA	 	enterName,A1
	BSR	 	PRINT
	
	BSR	 	ENDL		*NEW LINE
	
	MOVE.B  #2,D0
	LEA	 	NAME, A1	*LOAD NAME ADDRESS TO A1
	TRAP	#15		 *INPUT NAME
	
	BSR	 	CLEAR_SCREEN
	
	RTS

*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:
    LEA 	line, A1   *LOAD LINE
	BSR	 	PRINT

    MOVE.W  MONEY, D1
	BSR	 	PRINT_INT

    BSR	 	ENDL		*NEW LINE

	LEA 	mainChoice, A1   *LOAD MESSAGE
	BSR	 	PRINT
	BSR	 	ENDL		*NEW LINE
	
	MOVE.B  #4, D0
	TRAP	#15		 *ASK FOR INPUT
	
	CMP.W   #1,D1	   *SHOP IF (D2 == #1)
	BEQ	 	EVENT
	CMP.W   #2,D1	   *ACTION IF (D2 == #2)
	BEQ	 	CITY
	BRA	 	GAMELOOP	*LOOP FOREVER

*-------------------------------------------------------
*--------------------CITY SUBROUTINE--------------------
*-------------------------------------------------------
CITY:
	BSR	 	DISPLAY_DETAILS
	
	LEA 	cityChoice, A1   *LOAD MESSAGE
	BSR	 	PRINT
	
	BSR	 	ENDL		*NEW LINE
	
	MOVE.B  #4, D0
	TRAP	#15		 *ASK FOR INPUT
	
	CMP.W   #1,D1	   *LEAVE IF (D2 == #1)
	BEQ	 	GAMELOOP
	CMP.W   #2,D1	   *SHOP IF (D2 == #2)
	BEQ	 	SHOP
	CMP.W   #3,D1	   *EXPLORE IF (D2 == #3)
	BEQ	 	EXPLORE
	CMP.W   #4,D1	   *MANAGE IF (D2 == #4)
	BEQ	 	MANAGE
	BRA	 	CITY

*-------------------------------------------------------
*--------------------SHOP SUBROUTINE--------------------
*-------------------------------------------------------
SHOP:
	LEA 	shopChoice, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	BSR	 	ENDL
	BRA	 	CITY

*-------------------------------------------------------
*--------------------EXPLORE SUBROUTINE-----------------
*-------------------------------------------------------
EXPLORE:
	LEA 	exploreChoice, A1
	BSR		PRINT
	
	BSR	 	SYSTEM_PAUSE
	BRA		CITY
	
*-------------------------------------------------------
*--------------------MANAGE SUBROUTINE------------------
*-------------------------------------------------------
MANAGE:
	LEA 	manageChoice, A1
	BSR	 	PRINT
	
	BSR	 	SYSTEM_PAUSE
	BRA	 	CITY
	
*-------------------------------------------------------
*--------------------EVENT SUBROUTINE-------------------
*-------------------------------------------------------
EVENT:
	LEA 	eventText, A1
	BSR	 	PRINT
	
	ADD.W   #SALARY, MONEY
	BSR	 	SYSTEM_PAUSE
	BRA	 	GAMELOOP
	

*-------------------------------------------------------
*--------------------DISPLAY DETAILS SUBROUTINE---------
*-------------------------------------------------------
DISPLAY_DETAILS:
	MOVE.B  #11,D0
	MOVE.W  #$FF00,D1
	TRAP	#15
	LEA	 	display,A1
	MOVE.B  #14,D0
	TRAP	#15
	RTS

*-------------------------------------------------------
*----------------CLEAR SCREEN SUBROUTINE----------------
*-------------------------------------------------------
CLEAR_SCREEN: 
	MOVE.B  #11,D0	  CLEAR SCREEN
	MOVE.W  #$FF00,D1
	TRAP	#15
	RTS
	
*-------------------------------------------------------
*----------------PRINT SUBROUTINE-----------------------
*-------------------------------------------------------
PRINT:
	MOVE.B  #14,D0
	TRAP	#15
	RTS
	
*-------------------------------------------------------
*----------------PRINT_INT SUBROUTINE-------------------
*-------------------------------------------------------
PRINT_INT:
	MOVE.B  #3,D0
	TRAP	#15
	RTS
	
*-------------------------------------------------------
*----------------SYSTEM PAUSE SUBROUTINE----------------
*-------------------------------------------------------
SYSTEM_PAUSE:
	BSR		 ENDL
	LEA		 PAUSE, A1   *DISPLAY PAUSE MESSAGE
	BSR		 PRINT		  
	MOVE.B  #5,D0	   *WAIT FOR SINGLE CHARACTER
	TRAP	#15
	BSR		ENDL
	RTS
	
*-------------------------------------------------------
*--------------------ENDL SUBROUTINE--------------------
*-------------------------------------------------------
ENDL:
	MOVEM.L D0/A1,-(A7)
	MOVE	#14,D0
	LEA	 	CRLF,A1
	TRAP	#15
	MOVEM.L (A7)+,D0/A1
	RTS
	
* D4 = LOOPCOUNTER

	
*-------------------------------------------------------
*-------------------DATA DELARATIONS--------------------
*-------------------------------------------------------

CRLF:		    DC.B	$0D,$0A,0

welcome_string: DC.B	'************************************************************'
				DC.B	$0D,$0A
				DC.B	'Save the Earth by defeating the CO2 Dragon!!!'
				DC.B	$0D,$0A
				DC.B	'************************************************************'
				DC.B	$0D,$0A,0
				
enterName		DC.B	'Please enter your name: ',0

intro_string:   DC.B	'Welcome to the Kingdom of Oxeris.',0
				
story_string_1:	DC.B	'The king of Oxeris has imposed a tax which forces individuals'
				DC.B	$0D,$0A
				DC.B	'of the kingdom to pay based on their C02 output.', 0

story_string_2:	DC.B	'You are not sure why he has imposed a tax on CO2'
				DC.B	$0D,$0A
				DC.B	'if it is what we breathe out!', 0
		
story_string_3:	DC.B	'Do you want to go and ask the King why he has imposed'
                DC.B    'a tax on CO2?'
				DC.B	$0D,$0A
				DC.B	$0D,$09'1) Yes!'
				DC.B	$0D,$09'2) No way!', 0

line            DC.B    '================================================================================'
				DC.B	$0D,$0A
				DC.B	$0D,$09, 0
				
Dot  		    DC.B	'.',0

mainChoice   	DC.B	'TODO: EVENT OR CITY', 0
cityChoice		DC.B	'TODO: CITY ||| 1 LEAVE; 2 SHOP; 3 EXPLORE;4 MANAGE',0
shopChoice	 	DC.B	'TODO: SHOP', 0
exploreChoice	DC.B    'TODO: EXPLORE', 0
manageChoice 	DC.B	'TODO: MANAGE', 0
eventText	   	DC.B	'TODO: EVENT', 0 
display	  		DC.B	'TODO: DISPLAY', 0
PAUSE		  	DC.B	'Press any key to continue . . .', 0

MONEY:			DS.W	1	 PLAYER MONEY
NAME:	 		DS.W	0


	END	START









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
