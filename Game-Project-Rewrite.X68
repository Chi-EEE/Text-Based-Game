*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
	
	ORG $1000

START:
	MOVE.W  #SALARY,MONEY
	
	BSR     SPLASH
	BSR	 	INPUT_NAME
	BSR	 	WELCOME
	BSR     STORY
	BSR     GUIDE_1
	BRA	 	GAMELOOP
	
END:
	SIMHALT


*-------------------------------------------------------
*-------------------SPLASH SUBROUTINE------------------
*-------------------------------------------------------
SPLASH:
	BSR	 	ENDL
	LEA	 	TITLE,A1    *Load Splash string
	BSR     PRINT
    
    BSR	 	SYSTEM_PAUSE
    
	BSR	 	CLEAR_SCREEN
	RTS

*-------------------------------------------------------
*-------------------NAME INPUT SUBROUTINE---------------
*-------------------------------------------------------
CLEAR_INPUT_NAME:
    BSR     CLEAR_SCREEN

INPUT_NAME:
	BSR	 	ENDL
	LEA	 	enterName,A1
	BSR	 	PRINT
	BSR	 	ENDL
	
	MOVE.B  #2,D0
	LEA	 	NAME, A1	*Load Name address to A1 to be able to store name
	TRAP	#15		    *Input Name
	BSR	 	ENDL

    * Check if name is between length 3 and 30
    CMP.W     #2,    D1
    BLS     INPUT_NAME_LENGTH_ERROR
	CMP.W     #30,    D1
	BHI     INPUT_NAME_LENGTH_ERROR
	
INPUT_NAME_LOOP:
	LEA	 	name_confirmation_1, A1
	BSR     PRINT
	
	LEA	 	NAME, A1
	BSR     PRINT
	
	LEA	 	name_confirmation_2, A1
	BSR     PRINT
	
    BSR     INPUT_NUM

    CMP     #2,D1       *No
	BEQ     CLEAR_INPUT_NAME
	
	CMP     #1,D1       *Yes
	BNE     INPUT_NAME_MENU_ERROR    *Since number is not 1 or 2

	BSR	 	CLEAR_SCREEN
    RTS
INPUT_NAME_LENGTH_ERROR:
    LEA     name_length_fail,   A1
    BSR     PRINT
    
    BSR     ENDL
    
    BSR	 	SYSTEM_PAUSE
    BSR	 	CLEAR_SCREEN
	BRA     INPUT_NAME

INPUT_NAME_MENU_ERROR:
    BSR     ENDL
    
    LEA     name_confirmation_fail, A1
    BSR     PRINT

    BSR	 	SYSTEM_PAUSE
    
    BRA     INPUT_NAME_LOOP

*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
*-------------------------------------------------------
WELCOME:
	BSR	 	ENDL
	LEA	 	welcome_string_1,A1
	BSR     PRINT
	
	LEA	 	NAME,A1
	BSR     PRINT
	
	LEA	 	Dot, A1
	BSR     PRINT
	
    BSR     ENDL
    BSR     ENDL
    
	LEA     welcome_string_2,A1
	BSR     PRINT
	
	BSR	 	ENDL
	
	BSR	 	SYSTEM_PAUSE
	BSR	 	CLEAR_SCREEN
	
	LEA     welcome_string_3,A1
	BSR     PRINT
	
	MOVE    #3, D4      *Loop for 3 seconds for dots
	BSR     PRINT_DOTS
	
	BSR	 	CLEAR_SCREEN
	
	RTS
*-------------------------------------------------------
*-------------------STORY SUBROUTINE--------------------
*-------------------------------------------------------
STORY:
    LEA     NAME, A2    *Load name for SPEAKING_ASCII
    
    LEA     intro_story_string_1, A3
    BSR     YOU_SPEAKING_ASCII
    
    LEA     intro_story_string_2, A3
    BSR     YOU_SPEAKING_ASCII
    
    LEA     intro_story_string_3, A3
    BSR     YOU_SPEAKING_ASCII
    
    LEA     intro_story_string_4, A3
    BSR     YOU_SPEAKING_ASCII
    RTS

*-------------------------------------------------------
*-----------------GUIDE_1 SUBROUTINE--------------------
*-------------------------------------------------------
GUIDE_1:
    LEA     GUIDE_NAME, A2
    
    * SHOW ASCII OF SELF
    BSR	 	ENDL
    LEA     YOU, A1
    BSR     PRINT
    BSR     ENDL
    LEA 	LINE, A1
	BSR	 	PRINT
	*
    
    * TALK ABOUT STORY
    BSR     ENDL
    BSR     SPEAK
    BSR	 	ENDL
    *
    
    * NEXT
	BSR	 	SYSTEM_PAUSE
    BSR	 	CLEAR_SCREEN
    *

    
    RTS
*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:
    LEA 	GAME_LINES, A1   *LOAD LINES
	BSR	 	PRINT

    MOVE.W  (MONEY), D1
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
*----------------DISPLAY DETAILS SUBROUTINE-------------
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
	
	LEA     hundred_text, A1
	BSR     PRINT
	RTS

*-------------------------------------------------------
*----------------INPUT_NUM SUBROUTINE-------------------
*-------------------------------------------------------
INPUT_NUM:
    MOVE.B  #4,D0
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
	
*-------------------------------------------------------
*---------------YOU_SPEAKING_ASCII SUBROUTINE-----------
*----------------[A1,name: A2, text: A3]----------------
YOU_SPEAKING_ASCII:
* SHOW ASCII OF SELF
    BSR	 	ENDL
    LEA     YOU, A1
    BSR     PRINT
    BSR     ENDL
    LEA 	LINE, A1
	BSR	 	PRINT
	*
    
    * TALK ABOUT STORY
    BSR     ENDL
    BSR     SPEAK
    BSR	 	ENDL
    *
    
    * NEXT
	BSR	 	SYSTEM_PAUSE
    BSR	 	CLEAR_SCREEN
    *
    RTS

*-------------------------------------------------------
*---------------------SPEAK SUBROUTINE------------------
*----------------[A1,name: A2, text: A3]----------------
SPEAK:
    MOVE     A2, A1
    BSR     PRINT

    LEA     TALK_1, A1
    BSR     PRINT
    
    MOVE    A3, A1
    BSR     PRINT
    
    LEA     TALK_2, A1
    BSR     PRINT
    
    RTS

*-------------------------------------------------------
*----------------TIMED PRINT DOT SUBROUTINE-------------
*-------------------[D1,D2,D3,input: D4]----------------
PRINT_DOTS:
    LEA     Dot,A1
DOT_NEXT_PRINT:
    BSR     PRINT
    BSR     GET_MILLISECONDS
    MOVE.L  D1,D2
DOT_NEXT: 
    BSR     GET_MILLISECONDS
    
    MOVE    D2,D3
    SUB     D3,D1
    
    CMP     #SECOND,D1
    BLS     DOT_NEXT
    
    SUB     #1, D4
    CMP     #0, D4
    BNE     DOT_NEXT_PRINT
    RTS
	
GET_MILLISECONDS:
    MOVE.B #8, D0 # Load
    TRAP #15  #Time in D1
    RTS



*-------------------------------------------------------
*-------------------DATA DELARATIONS--------------------
*-------------------------------------------------------

CRLF		     DC.B	$0D,$0A,0

TITLE            DC.B    '================================================================================'
                 DC.B	$0D,$0A
                 DC.B    ' _  ___                 _                   ___   __    ___                _    '
                 DC.B	$0D,$0A
                 DC.B    '| |/ (_)_ __   __ _  __| | ___  _ __ ___   / _ \ / _| / _ \__  _____ _ __(_)___ '
                 DC.B	$0D,$0A
                 DC.B    '| ^ /| | ^_ \ / _` |/ _` |/ _ \| ^_ ` _ \ | | | | |_ | | | \ \/ / _ \ ^__| / __|'
                 DC.B	$0D,$0A
                 DC.B    '| . \| | | | | (_| | (_| | (_) | | | | | || |_| |  _|| |_| |>  <  __/ |  | \__ \'
                 DC.B	$0D,$0A
                 DC.B    '|_|\_\_|_| |_|\__, |\__,_|\___/|_| |_| |_| \___/|_|   \___//_/\_\___|_|  |_|___/'
                 DC.B	$0D,$0A
                 DC.B    '              |___/                                                             '
                 DC.B	$0D,$0A
				 DC.B    '================================================================================',0
enterName		DC.B	'Please enter your name: ',0

name_confirmation_1 DC.B    'Your name is "',0
name_confirmation_2 DC.B    '" correct?'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'1) Yes'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'2) No'
                    DC.B	$0D,$0A
                    DC.B	'Enter your choice) ',0

name_length_fail        DC.B    'Please type a name between 3 - 30 length.',0
name_confirmation_fail  DC.B    'Please type a valid menu option.',0

welcome_string_1       DC.B	'Welcome to the Kingdom of Oxeris, ',0

welcome_string_2        DC.B	'You have immigrated to the Kingdom of Oxeris as your hometown'
                        DC.B	$0D,$0A
                        DC.B	'has been burned down from a conflict',0

welcome_string_3        DC.B	'3 years later', 0

intro_story_string_1 	DC.B	'It has been 3 years since I immigrated to'
				DC.B	$0D,$0A
				DC.B	'the Kingdom of Oxeris', 0
				
intro_story_string_2 	DC.B	'The king of Oxeris has imposed a tax which forces individuals'
				DC.B	$0D,$0A
				DC.B	'of the kingdom to pay based on their C02 output.', 0

intro_story_string_3 	DC.B	'I am unsure why he has imposed a tax on CO2'
				DC.B	$0D,$0A
				DC.B	'if it is what everybody breaths out!', 0

intro_story_string_4 	DC.B	'I should make a plan to solve this problem.',0

story_string_3 	DC.B	'Do you want to go and ask the King why he has imposed'
                DC.B    'a tax on CO2?'
				DC.B	$0D,$0A
				DC.B	$0D,$09
                DC.B	'1) Yes!'
				DC.B	$0D,$09
                DC.B	'2) No way!', 0

guide_1_string_1        DC.B    'Welcome to the Kingdom of Oxeris, ',0
guide_1_string_2        DC.B    'Theres was a lot ',0


LINE            DC.B    '================================================================================',0

GAME_LINES      DC.B    '================================================================================'
				DC.B	$0D,$0A
				DC.B	$0D,$0A
				DC.B	$0D,$0A
				DC.B	'================================================================================', 0
				    
Dot  		        DC.B	'.',0
TALK_1              DC.B    ': "',0
TALK_2              DC.B    '"',0

YOU              DC.B    '             ^JB&@@@@@&&&&BY~.          '
                 DC.B	$0D,$0A
                 DC.B    '           7&@&P7^:.....^75#@@#?.       '
                 DC.B	$0D,$0A
                 DC.B    '          G@&:               !#@@5      '
                 DC.B	$0D,$0A
                 DC.B    '         5@&        :7YPPGBGPP#@@@#Y~.  '
                 DC.B	$0D,$0A
                 DC.B    '        :@@~      7#&B5YJJ???~^~~7YB@&? '
                 DC.B	$0D,$0A
                 DC.B    '     .:^B@&      ?@&5~:::::::       J&@J'
                 DC.B	$0D,$0A
                 DC.B    ' .5#&@@@@@J      B@GYJ!^^::::^^:::::~&&&'
                 DC.B	$0D,$0A
                 DC.B    ' G@G:. !@@:      Y@BYYYY?7!!!~~~!!7?5&@B'
                 DC.B	$0D,$0A
                 DC.B    '.@&    .@@.      :&@#G55YYYYYYY55PGB&&B.'
                 DC.B	$0D,$0A
                 DC.B    '7@B    ^@&        .?B#&&#######&&#B&@P  '
                 DC.B	$0D,$0A
                 DC.B    'G@B    ~@#            .::^~~~^::.  J@P  '
                 DC.B	$0D,$0A
                 DC.B    '&@G    ~@&                         ^@B  '
                 DC.B	$0D,$0A
                 DC.B    '@@G    .@&                         7@B  ', 0  

GUIDE_NAME          DC.B    'Guide Gary',   0
GUIDE            DC.B    '                .!5B&&&@&&#B5?!^             '
                 DC.B	$0D,$0A
                 DC.B    '            !5G#&#G?^.....^~?PB&&7           '
                 DC.B	$0D,$0A
                 DC.B    '           P@G!^.              ^@&:          '
                 DC.B	$0D,$0A
                 DC.B    '          .@@^                  B@@&##P?:    '
                 DC.B	$0D,$0A
                 DC.B    '     .~?PG#@@.                   B@#~!5#&&5. '
                 DC.B	$0D,$0A
                 DC.B    '  ^P&&#G?P@@P                  :~P@@5   .!&@7'
                 DC.B	$0D,$0A
                 DC.B    ' P@#~.   .P#&&#BP55J???JJY5GB#&&&BJ~      ?@@'
                 DC.B	$0D,$0A
                 DC.B    '#@G          .^~7JY5PPPPP5J?!^.        .!G@#7'
                 DC.B	$0D,$0A
                 DC.B    'G@#~.          ...:::^~!777???JY555PPB#&&5^  '
                 DC.B	$0D,$0A
                 DC.B    ' !P#&##BBB##&####B&@@&#BBBBGG5YYYJJJ#@&:     '
                 DC.B	$0D,$0A
                 DC.B    '    :J#&@@@@7     &@#P!:::::::...   !&@J     '
                 DC.B	$0D,$0A
                 DC.B    '   7@#YJ?B@&      &@BPPY7~~^^^^^^^~~J&@!     '
                 DC.B	$0D,$0A
                 DC.B    '   &&    J@B      P@&GPPPPP5555555PG#@@^     '
                 DC.B	$0D,$0A
                 DC.B    '  ^@P    P@5       5&@&&########&&&@@B:      '
                 DC.B	$0D,$0A
                 DC.B    '  J@Y    B@?        .~?5GGBBBBGPY?~B@Y       '
                 DC.B	$0D,$0A
                 DC.B    '  B@?    B@?                       Y@Y       '
                 DC.B	$0D,$0A
                 DC.B    '  &@?    P@J                       J@Y       ', 0
           
KING             DC.B    '            P&G:          ..            '
                 DC.B	$0D,$0A
                 DC.B    '           :&#&&5.     .!P#G            '
                 DC.B	$0D,$0A
                 DC.B    '           ?&#JP&#?.:?G#&&&7            '
                 DC.B	$0D,$0A
                 DC.B    '           B&G..7B&&&#5!P&#.            '
                 DC.B	$0D,$0A
                 DC.B    '  :GGPPYY?5&&?...:~?!...P&B             '
                 DC.B	$0D,$0A
                 DC.B    '   ~G&&&###BG:...      .G&B             '
                 DC.B	$0D,$0A
                 DC.B    '     ?#&B55J^....::..:::G&#^.           '
                 DC.B	$0D,$0A
                 DC.B    '      :B&#P555PBB#BBBBB##&&@@#Y:        '
                 DC.B	$0D,$0A
                 DC.B    '       .B&#B&#5!^.     .::.:J&@@#^      '
                 DC.B	$0D,$0A
                 DC.B    '        .B&&5.      .^7JY555YP&@@@5^    '
                 DC.B	$0D,$0A
                 DC.B    '        .&@#      !#&&##BGGGGP55PB&@&G: '
                 DC.B	$0D,$0A
                 DC.B    '        Y@@!     P@@#7::::::.      :G@&^'
                 DC.B	$0D,$0A
                 DC.B    '  :?G#&@@@@     .@@#P?^:::^^^:::....~&@#'
                 DC.B	$0D,$0A
                 DC.B    ' ?@&J77J@@B     .&@#PP5J7~~^^^^^^^~!Y&@&'
                 DC.B	$0D,$0A
                 DC.B    ' &@.    @@?      B@&BPPPPPP555555PPG#@@7'
                 DC.B	$0D,$0A
                 DC.B    '~@#    .@@~      .G@@&&#BBBBBB##&&&&@#^ '
                 DC.B	$0D,$0A
                 DC.B    '5@B    .@@~        .75G##&&&&&#BG5?&@5  '
                 DC.B	$0D,$0A
                 DC.B    '#@P    .@@~                        B@G  '
                 DC.B	$0D,$0A
                 DC.B    '@@P    .@@~                        G@B  ', 0
                 
mainChoice   	DC.B	'TODO: EVENT OR CITY', 0
cityChoice		DC.B	'TODO: CITY ||| 1 LEAVE; 2 SHOP; 3 EXPLORE;4 MANAGE',0
shopChoice	 	DC.B	'TODO: SHOP', 0
exploreChoice	DC.B    'TODO: EXPLORE', 0
manageChoice 	DC.B	'TODO: MANAGE', 0
eventText	   	DC.B	'TODO: EVENT', 0 
display	  		DC.B	'TODO: DISPLAY', 0
PAUSE		  	DC.B	'Press any key to continue . . .', 0

hundred_text	DC.B	'00', 0

MONEY:			DS.W	1	 PLAYER MONEY in hundreds
NAME:	 		DS.W	1
DAY:            DS.B    1   DAYS PASSED

*-------------------------------------------------------
*VALIDATION VALUES TO BE USED
*-------------------------------------------------------
EXIT		EQU 0	  USED TO EXIT ASSEMBLY PROGRAM
SALARY	  EQU 385
MILLION	 EQU 10000
HUNDREDTHOUSAND EQU 1000
SECOND  EQU 100

	END	START












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
