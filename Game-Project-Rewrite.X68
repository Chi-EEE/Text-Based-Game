*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
	
	ORG $1000

START:
	BSR     INITIALIZE
	
	BSR     SPLASH
	BSR	 	INPUT_NAME
	BSR	 	WELCOME
	BSR     STORY
	BSR     GUIDE_1
	BRA	 	GAME_LOOP
	
END:
	SIMHALT

*-------------------------------------------------------
*------------------INITIALIZE SUBROUTINE----------------
*-------------------------------------------------------
INITIALIZE:
	MOVE.W  #STARTING_CASH,MONEY
	MOVE.W  #1,     DAY
	
	MOVE.W  #3,     DAY_COUNTER    
	
    MOVE.W  #15,    TEMPERATURE
    MOVE.W  #40,    CO2_LEVEL
    
    MOVE.B  #0,     VISITED_SHOP
	MOVE.B  #0,     HAS_ALARM
	
	MOVE.W  #0,     WATER_MILL_COUNT
	MOVE.W  #0,     SOLAR_PANEL_COUNT
    RTS

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

    BSR	 	ENDL
    BSR	 	SYSTEM_PAUSE
    
    BSR     CLEAR_SCREEN
    
    BSR	 	ENDL
    LEA	 	enterName,A1
	BSR	 	PRINT
	BSR	 	ENDL
	
	LEA	 	NAME, A1
	BSR     PRINT
	
    BSR	 	ENDL
    BSR	 	ENDL
    
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
	
	BSR	 	ENDL
	LEA     welcome_string_3,A1
	BSR     PRINT
	
	MOVE    #3, D4      *Loop for 3 seconds for dots
	BSR     PRINT_DOTS
	
	BSR	 	ENDL
	
	BSR	 	SYSTEM_PAUSE
	BSR	 	CLEAR_SCREEN
	
	RTS
*-------------------------------------------------------
*-------------------STORY SUBROUTINE--------------------
*-------------------------------------------------------
STORY:
    LEA     NAME, A2    *Load name for SPEAKING_ASCII
    LEA     YOU,  A4    *Load Ascii for You
    
    LEA     intro_story_string_1, A3
    BSR     SPEAKING_ASCII
    
    LEA     intro_story_string_2, A3
    BSR     SPEAKING_ASCII
    
    LEA     intro_story_string_3, A3
    BSR     SPEAKING_ASCII
    
    LEA     intro_story_string_4, A3
    BSR     SPEAKING_ASCII
    RTS

*-------------------------------------------------------
*-----------------GUIDE_1 SUBROUTINE--------------------
*-------------------------------------------------------
GUIDE_1:
    LEA     GUIDE_NAME, A2
    LEA     guide_1_string_1, A3
    LEA     GUIDE,      A4
    
    BSR     SPEAKING_ASCII
    
    * INTRODUCE
    BSR     SHOW_ASCII
    BSR	 	ENDL
    
    LEA     GUIDE_NAME, A1
    BSR     PRINT
    
    LEA     TALK_1, A1
    BSR     PRINT
    
    LEA     guide_1_string_2, A1
    BSR     PRINT
    
    LEA     GUIDE_NAME, A1
    BSR     PRINT
    
    LEA     guide_1_string_3, A1
    BSR     PRINT
    
    LEA     TALK_2, A1
    BSR     PRINT
    
    BSR	 	ENDL
    
    * NEXT
	BSR	 	SYSTEM_PAUSE

    RTS
END_DAY:
    BSR     CLEAR_SCREEN
    ADD.W   #1, DAY     *Increase day by 1
    
    MOVE.W  #DEFAULT_DAY_COUNTER,DAY_COUNTER  *Increase reset day counter
    
    MOVE.B  (HAS_ALARM), D1
    CMP     #1,     D1 * Has alarm
    BNE     DISPLAY_END_DAY * No = skip increase day counter
    ADD.W   #1, DAY_COUNTER
DISPLAY_END_DAY:
    LEA     YOU,  A4    *Load Ascii for Shop keeper
    BSR     SHOW_ASCII
    BSR	 	ENDL
    
    LEA     sleep_string,   A1
    BSR     PRINT
    
	MOVE.B  #5,     D4
	BSR     PRINT_DOTS
	
	BSR     ENDL
	
	BSR	 	SYSTEM_PAUSE
*-------------------------------------------------------
*----------------GAME_LOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAME_LOOP:
    BSR     CLEAR_SCREEN
    BSR     DISPLAY	

	LEA 	mainChoice, A1   *LOAD MESSAGE
	BSR	 	PRINT
	
	MOVE.B  #4, D0
	TRAP	#15		 *ASK FOR INPUT
	
	CMP.W   #1,D1	   *SHOP IF (D2 == #1)
	BEQ	 	WORK
	CMP.W   #2,D1	   *ACTION IF (D2 == #2)
	BEQ	 	CITY
	CMP.W   #3,D1	   *SLEEP IF (D2 == #3)
	BEQ	 	END_DAY
	
	BRA	 	GAME_LOOP	*LOOP FOREVER

*-------------------------------------------------------
*-------------------DISPLAY SUBROUTINE------------------
*-------------------------------------------------------
DISPLAY:
    LEA 	GAME_LINES, A1
	BSR	 	PRINT
	
	MOVE.W  #$0201,  D1  *Move text cursor to pos
	MOVE    #11,    D0
	TRAP    #15
	
	* Display Name
	LEA     NAME_LABEL, A1
	BSR     PRINT
	LEA     NAME, A1
	BSR     PRINT
	* ----------
	BSR	 	ENDL
	
	MOVE.W  #$0202,  D1  *Move text cursor to pos
	MOVE    #11,    D0
	TRAP    #15

	* Display MONEY
	LEA     MONEY_LABEL, A1
	BSR     PRINT
	MOVE.W  (MONEY), D1
	BSR     PRINT_INT
	* ----------
	
	MOVE.W  #$3501,  D1  *Move text cursor to pos
	MOVE    #11,    D0
	TRAP    #15
	
	* Display Day
	LEA     DAY_LABEL, A1
	BSR     PRINT
	MOVE.W  (DAY), D1
	BSR     PRINT_INT
	* ----------
    BSR	 	ENDL

	MOVE.W  #$3502,  D1  *Move text cursor to pos
	MOVE    #11,    D0
	TRAP    #15
	
    * Display Temperature
	LEA     TEMPERATURE_LABEL, A1
	BSR     PRINT
	MOVE.W  (TEMPERATURE), D1
	BSR     PRINT_INT
	* ----------

    * Reset cursor pos back to normal
    MOVE.W  #$0004,  D1  *Move text cursor to pos
	MOVE    #11,    D0
	TRAP    #15

	RTS

*-------------------------------------------------------
*--------------------WORK SUBROUTINE--------------------
*-------------------------------------------------------
WORK:
    BSR     CLEAR_SCREEN
	
	*if (day_counter - 2 < 0) = tired
	MOVE.W  (DAY_COUNTER),  D1
	SUB     #2, D1
	BMI     TIRED_WORK

	CMP     #0, D1
    BLS     TIRED_WORK

	MOVE.W  D1, DAY_COUNTER
    BSR     PRINT_INT

    LEA 	eventText, A1
	BSR	 	PRINT
	
	ADD.W   #SALARY, MONEY
	MOVE.B  #3,     D4
	BSR     PRINT_DOTS
	
	BSR	 	SYSTEM_PAUSE
	
	
    BRA GAME_LOOP
TIRED_WORK:
    BSR     ENDL

    LEA 	work_tired_string, A1
	BSR	 	PRINT
	
	BSR     SYSTEM_PAUSE
    BRA     GAME_LOOP
*-------------------------------------------------------
*--------------------CITY SUBROUTINE--------------------
*-------------------------------------------------------
CITY:
    BSR     CLEAR_SCREEN
    BSR     DISPLAY	
	
	LEA 	cityChoice, A1   *LOAD MESSAGE
	BSR	 	PRINT
	
	MOVE.B  #4, D0
	TRAP	#15		 *ASK FOR INPUT
	
	CMP.W   #1,D1	   *SHOP IF (D2 == #1)
	BEQ	 	SHOP
	CMP.W   #2,D1	   *EXPLORE IF (D2 == #2)
	BEQ	 	EXPLORE
	CMP.W   #3,D1	   *MANAGE IF (D2 == #3)
	BEQ	 	MANAGE
	CMP.W   #4,D1	   *LEAVE IF (D2 == #4)
	BEQ	 	GAME_LOOP
	BRA	 	CITY

*-------------------------------------------------------
*--------------------SHOP SUBROUTINE--------------------
*-------------------------------------------------------
SHOP:
    BSR     CLEAR_SCREEN
    
    CMP.B   #0,   VISITED_SHOP
    BEQ     FIRST_TIME_SHOP

    LEA     SHOP_KEEPER,      A4
    
    BSR     SHOW_ASCII
    BSR	 	ENDL
    
    LEA     SHOP_KEEPER_NAME, A1
    BSR     PRINT

    LEA     TALK_1, A1
    BSR     PRINT
    
    LEA     shop_string_1, A1
    BSR     PRINT
    
    LEA     NAME, A1
    BSR     PRINT
    
    LEA     TALK_2, A1
    BSR     PRINT
    
    LEA     shop_string_2,  A1
    BSR     PRINT
    
	MOVE.B  #4, D0
	TRAP	#15		 *ASK FOR INPUT
	
	CMP.W   #1,D1	   *BROWSE_SHOP IF (D1 == #1)
	BEQ	 	BROWSE_SHOP
	CMP.W   #2,D1	   *SELL_ITEM_SHOP IF (D1 == #2)
	BEQ	 	SELL_ITEM_SHOP
	CMP.W   #3,D1	   *CITY IF (D1 == #3)
	BEQ	 	CITY
	
	BRA	 	SHOP
FIRST_TIME_SHOP:
    MOVE.B    #1, VISITED_SHOP

    *INTRODUCE
    LEA     SHOP_KEEPER,  A4    *Load Ascii for Shop keeper
   
    BSR     SHOW_ASCII
    BSR	 	ENDL

    LEA     SHOP_KEEPER_NAME, A1
    BSR     PRINT

    LEA     TALK_1, A1
    BSR     PRINT
    
    LEA     shop_intro_string_1, A1
    BSR     PRINT
    
    LEA     SHOP_KEEPER_NAME, A1
    BSR     PRINT
    
    LEA     shop_intro_string_2,  A1
    BSR     PRINT
    
    LEA     TALK_2, A1
    BSR     PRINT
    
    BSR     ENDL
    
    BSR     SYSTEM_PAUSE
    *
    BRA     SHOP
*-------------------------------------------------------
*-------------------UNABLE_BUY SUBROUTINE---------------
*----------------------[D2: need_money]-----------------
UNABLE_BUY:
    LEA     shop_unable_buy_string_1, A1
    BSR     PRINT
    
    MOVE.W  (MONEY),    D1
    BSR     PRINT_INT
    
    LEA     shop_unable_buy_string_2, A1
    BSR     PRINT
    
    SUB     D1, D2
    MOVE    D2, D1
    BSR     PRINT_INT

    LEA     shop_unable_buy_string_3, A1
    BSR     PRINT
    
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN
BROWSE_SHOP:  
    BSR     CLEAR_SCREEN
    
    BSR     DISPLAY
    
    LEA     SHOP_KEEPER,  A4    *Load Ascii for Shop keeper
    BSR     SHOW_ASCII
    
    LEA     shop_browse_string, A1
    BSR     PRINT
    
	MOVE.B  #4, D0
	TRAP	#15		 *ASK FOR INPUT
	
	CMP.W   #1,D1	   *Alarm Clock IF (D1 == #1)
	BEQ	 	ALARM_CLOCK
	CMP.W   #2,D1	   *Small Water Mill IF (D1 == #2)
	BEQ	 	WATER_MILL
	CMP.W   #3,D1	   *Solar Panel IF (D1 == #3)
	BEQ	 	SOLAR_PANEL
	CMP.W   #4,D1	   *Sword IF (D1 == #1)
	BEQ	 	SWORD
	CMP.W   #5,D1	   *Coffee IF (D1 == #2)
	BEQ	 	COFFEE
	CMP.W   #6,D1	   *Exit Browse IF (D1 == #3)
	BEQ	 	SHOP
	
    BRA     BROWSE_SHOP
*-------------------------------------------------------
*---------------CONFIRM_SHOP SUBROUTINE-----------------
*   Check if player wants to actually buy the item
*                 [D0,D1,D2: cost]
CONFIRM_SHOP:       
    BSR CLEAR_SCREEN
    BSR DISPLAY

    LEA shop_confirm_string, A1
    BSR PRINT
    
    MOVE.W  D2, D1
    BSR PRINT_INT
    
    LEA YES_NO, A1
    BSR PRINT
    
    MOVE.B  #4, D0
	TRAP	#15		 *ASK FOR INPUT
	
	CMP.W   #2,D1	   *No Clock IF (D1 == #2)
	BEQ	 	BROWSE_SHOP
	CMP.W   #1,D1	   *Repeat choice IF (D1 != #1)
	BNE	 	CONFIRM_SHOP
	RTS
*-------------------------------------------------------
*-----------PURCHASED_ITEM_SHOP SUBROUTINE--------------
*-------------------------------------------------------
PURCHASED_ITEM_SHOP:
    BSR     CLEAR_SCREEN
    
    LEA     SHOP_KEEPER_NAME, A2
    LEA     shop_thank_string, A3
    LEA     SHOP_KEEPER, A4

    BSR     SPEAKING_ASCII
    
    BSR     CLEAR_SCREEN
    RTS
ALARM_CLOCK:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    
    MOVE.W  #ALARM_COST, D2
    BSR     CONFIRM_SHOP
    
    * if (!hasAlarm) { return ATTEMPT_BUY_ALARM_CLOCK() }
    MOVE.B  (HAS_ALARM), D1
    CMP.B   #0, D1
    BEQ     ATTEMPT_BUY_ALARM_CLOCK
    
    LEA     shop_already_have_string,   A1
    BSR     PRINT
    
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN
    BRA     BROWSE_SHOP
ATTEMPT_BUY_ALARM_CLOCK:
    MOVE.W  (MONEY),  D1
    MOVE.W  #ALARM_COST, D2
	SUB.W   D2, D1
	BMI     UNABLE_BUY
	
    MOVE.W  D1, MONEY
    MOVE.B  #1, HAS_ALARM
   
    BSR     PURCHASED_ITEM_SHOP
    
    BRA     BROWSE_SHOP
WATER_MILL:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    
    MOVE.W  #WATER_MILL_COST, D2
    BSR     CONFIRM_SHOP
    
    MOVE.W  (MONEY),  D1
	SUB.W   D2, D1
	BMI     UNABLE_BUY
	
    MOVE.W  D1, MONEY
    ADD.W   #1, WATER_MILL_COUNT
   
    BSR     PURCHASED_ITEM_SHOP
    
    BRA     BROWSE_SHOP
SOLAR_PANEL:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    
    MOVE.W  #SOLAR_PANEL_COST, D2
    BSR     CONFIRM_SHOP
    
    MOVE.W  (MONEY),  D1
    MOVE.W  #SOLAR_PANEL_COST, D2
	SUB.W   D2, D1
	BMI     UNABLE_BUY
	
    MOVE.W  D1, MONEY
    ADD.W  #1,  SOLAR_PANEL_COUNT
    
    BSR     PURCHASED_ITEM_SHOP
    
    BRA     BROWSE_SHOP
SWORD:

COFFEE:

SELL_ITEM_SHOP:

    BRA     SELL_ITEM_SHOP
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
*----------------CLEAR SCREEN SUBROUTINE----------------
*-------------------------------------------------------
CLEAR_SCREEN: 
	MOVE.B  #11,D0	  CLEAR SCREEN
	MOVE.W  #$FF00,D1
	TRAP	#15
	RTS
	
*-------------------------------------------------------
*----------------PRINT SUBROUTINE-----------------------
*--------------------[D0, D1]---------------------------
PRINT:
	MOVE.B  #14,D0
	TRAP	#15
	RTS
	
*-------------------------------------------------------
*----------------PRINT_INT SUBROUTINE-------------------
*--------------------[D0,D1:input]----------------------
PRINT_INT:
	MOVE.B  #3,D0
	TRAP	#15
	RTS
	
*-------------------------------------------------------
*----------------INPUT_NUM SUBROUTINE-------------------
*-------------------[D0,D1:output]----------------------
INPUT_NUM:
    MOVE.B  #4,D0
	TRAP	#15
    RTS
*-------------------------------------------------------
*----------------SYSTEM PAUSE SUBROUTINE----------------
*-----------------------[D0,A1]-------------------------
SYSTEM_PAUSE:
	BSR		 ENDL
	LEA		 PAUSE, A1   *DISPLAY PAUSE MESSAGE
	BSR		 PRINT		  
	MOVE.B  #4, D0
	TRAP	#15		 *ASK FOR NUMBER
	BSR		ENDL
	RTS
	
*-------------------------------------------------------
*--------------------ENDL SUBROUTINE--------------------
*-----------------------[D0,A1]-------------------------
ENDL:
	MOVEM.L D0/A1,-(A7)
	MOVE	#14,D0
	LEA	 	CRLF,A1
	TRAP	#15
	MOVEM.L (A7)+,D0/A1
	RTS
	
*-------------------------------------------------------
*--------------SPEAKING_ASCII SUBROUTINE----------------
*---------[A1,name: A2, text: A3, ascii: A4]------------
SPEAKING_ASCII:
    BSR     SHOW_ASCII
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
*---------------SHOW_ASCII SUBROUTINE-------------------
*------------------[A1, ascii: A4]----------------------
SHOW_ASCII:
    BSR	 	ENDL
    MOVE    A4, A1
    BSR     PRINT
    BSR     ENDL
    LEA 	LINE, A1
	BSR	 	PRINT
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
*-------------------[D1,D2,D3,number: D4]---------------
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

guide_1_string_1        DC.B    'Welcome to the Kingdom of Oxeris, fellow adventurer.',0
guide_1_string_2        DC.B    'I am ',0
guide_1_string_3        DC.B    ' and I am going to help you begin your adventure!',0

LINE            DC.B    '================================================================================',0

GAME_LINES      DC.B    '================================================================================'
				DC.B	$0D,$0A
				DC.B	$0D,$0A
				DC.B	$0D,$0A
				DC.B	'================================================================================', 0

NAME_LABEL          DC.B    'Name: ',0
MONEY_LABEL          DC.B    'Money: ',0
DAY_LABEL           DC.B    'Day: ',0
TEMPERATURE_LABEL   DC.B    'Temperature: ',0
	    
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

SHOP_KEEPER_NAME DC.B   'Shop Keeper Sam',0
SHOP_KEEPER      DC.B    '             .^JG&@@@@@@@@&BJ.               '
                 DC.B	$0D,$0A
                 DC.B    '         .7G&@@@@#PYJ??JYG#@@@7              '
                 DC.B	$0D,$0A
                 DC.B    '        J@@@&P!.  .YY??JJ?J#&&&B^            '
                 DC.B	$0D,$0A
                 DC.B    '       .@@@7     :##?^^:^^~:^^5&#            '
                 DC.B	$0D,$0A
                 DC.B    '        P@@5     G&5^..    ..:~#&7           '
                 DC.B	$0D,$0A
                 DC.B    '        ^@@&     !&B!:..   ...:Y&#           '
                 DC.B	$0D,$0A
                 DC.B    '         @@@.     #&?^:: ..    ^#&7          '
                 DC.B	$0D,$0A
                 DC.B    '         &@@.     Y&P???J?!::::^P&B          '
                 DC.B	$0D,$0A
                 DC.B    '         #@@?!YPB#@@@@@@@@@@@@@@@@@&B57:     '
                 DC.B	$0D,$0A
                 DC.B    '      .7P@@@@@@&BG55YJ?77~~^^~~~7JYPB&@@@P.  '
                 DC.B	$0D,$0A
                 DC.B    '   .Y&@@@&G7: .^JG#&&@@@@&@&&B5!:      ^@@&  '
                 DC.B	$0D,$0A
                 DC.B    '  !@@@G^.    Y&@@&BJ!~:::^~75#@@@@B~   .@@@  '
                 DC.B	$0D,$0A
                 DC.B    ' ~@@@~     .&@@Y.              .?#@@&7!@@@!  '
                 DC.B	$0D,$0A
                 DC.B    ' ~@@@G!.  .&@@:        .:~7?55YYY5&@@@@@#:   '
                 DC.B	$0D,$0A
                 DC.B    '  .?#@@@@&&@@!       7B&@&&&&########&&@&B7  '
                 DC.B	$0D,$0A
                 DC.B    '      .^7B@@#      .#@@#J~^^^^^^.     .^5@@B.'
                 DC.B	$0D,$0A
                 DC.B    '    .:~7?#@@7      B@&B5^::^^^^^:...    .5@@G'
                 DC.B	$0D,$0A
                 DC.B    '  Y&@@@@@@@@.      &@&PPY!^^::::^^^^^::::J@@&'
                 DC.B	$0D,$0A
                 DC.B    ' ?@&^.  .@@#       B@&GPPPPY?7!!~~~~!!7?YG&@&'
                 DC.B	$0D,$0A
                 DC.B    ' &@~    .@@P       ~@@&BGPPPPPPPPPPPPPGG#&@&~'
                 DC.B	$0D,$0A
                 DC.B    '^@@.    .@@?        !#@@&&##BBBBBB##&&&@@@P. '
                 DC.B	$0D,$0A
                 DC.B    'J@@.    ^@@!          ^?PB#&&&&&&&&#BPJY@@7  '
                 DC.B	$0D,$0A
                 DC.B    'B@@     ^@@!                           .@@?  '
                 DC.B	$0D,$0A
                 DC.B    '&@@     ^@@!                            @@Y  ', 0
    
mainChoice   	DC.B	'What would you like to do?'
                DC.B	$0D,$0A
                DC.B	'1) Go to work to earn money'
                DC.B	$0D,$0A
                DC.B	'2) Enter the Town'
                DC.B	$0D,$0A
                DC.B	'3) Sleep and end the day'
                DC.B	$0D,$0A
                DC.B	'Enter your choice) ',0

sleep_string    DC.B    'ZzZzZzZzZz',0

cityChoice		DC.B	'What would you like to do in the town?'
                DC.B	$0D,$0A
                DC.B	'1) Visit the Building Shop'
                DC.B	$0D,$0A
                DC.B	'2) Explore the Town'
                DC.B	$0D,$0A
                DC.B	'3) Manage your Buildings'
                DC.B	$0D,$0A
                DC.B	'4) Exit the Town'
                DC.B	$0D,$0A
                DC.B	'Enter your choice) ',0


shop_string_1           DC.B    'Welcome back ',0
shop_string_2           DC.B	$0D,$0A
                        DC.B	'1) Browse around the shop'
                        DC.B	$0D,$0A
                        DC.B	'2) Sell items to the shop'
                        DC.B	$0D,$0A
                        DC.B	'3) Exit the Shop'
                        DC.B	$0D,$0A
                        DC.B	'Enter your choice) ',0

                        
shop_browse_string      DC.B    'There is a selection of items that caught your interest:'
                        DC.B	$0D,$0A
                        DC.B    '1) Alarm Clock : €20'
                        DC.B	$0D,$0A
                        DC.B    '2) Water Mill : €50'
                        DC.B	$0D,$0A
                        DC.B    '3) Solar Panel : €100'
                        DC.B	$0D,$0A
                        DC.B    '4) Sword : €50'
                        DC.B	$0D,$0A
                        DC.B    '5) Coffee : €10'
                        DC.B	$0D,$0A
                        DC.B    '6) Exit Browse'
                        DC.B	$0D,$0A
                        DC.B	'Enter your choice) ',0


shop_unable_buy_string_1: DC.B    'You have ',0
shop_unable_buy_string_2: DC.B    ' cash. You need ',0
shop_unable_buy_string_3: DC.B    ' more cash to purchase this item.',0

shop_already_have_string:  DC.B    'You already have this item.',0

shop_intro_string_1           DC.B    'Welcome to my Shop, my name is ',0
shop_intro_string_2           DC.B    '!' 
                              DC.B    $0D,$0A
                              DC.B    'I sell items that could be used to reduce your CO2 output.',0

shop_confirm_string DC.B    'Are you sure that you want to buy this item for ',0
YES_NO              DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'1) Yes'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'2) No'
                    DC.B	$0D,$0A
                    DC.B	'Enter your choice) ',0
shop_thank_string   DC.B    'Thank you for buying this item!',0

exploreChoice	DC.B    'TODO: EXPLORE', 0
manageChoice 	DC.B	'TODO: MANAGE', 0
eventText	   	DC.B	'Working', 0 
work_tired_string   DC.B    'You are too tired to work right now',0
PAUSE		  	DC.B	'Press enter to continue . . .', 0

NAME	 		DS.W	30  *Max length of name can be 30
MONEY 			DS.W	1	*PLAYER MONEY in hundreds
DAY             DS.W    1   *DAYS PASSED

DAY_COUNTER     DS.W    1   *INCREASED FROM 3 TO 4 IF ALARM

TEMPERATURE     DS.W    1
CO2_LEVEL       DS.W    1

* Amount
WATER_MILL_COUNT    DS.W    1
SOLAR_PANEL_COUNT   DS.W    1
* Booleans
VISITED_SHOP    DS.B    1   *Check if you visited shop before
HAS_ALARM       DS.B    1
*

JOB_TYPE        DS.B    1
JOB_LEVEL       DS.B    1



*-------------------------------------------------------
*VALIDATION VALUES TO BE USED
*-------------------------------------------------------
SALARY	  EQU 2
STARTING_CASH	  EQU 200
MILLION	 EQU 10000
HUNDREDTHOUSAND EQU 1000
SECOND  EQU 100
DEFAULT_DAY_COUNTER EQU 3

* ITEMS
ALARM_COST          EQU 20
WATER_MILL_COST     EQU 50
SOLAR_PANEL_COST    EQU 100

	END	START

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
