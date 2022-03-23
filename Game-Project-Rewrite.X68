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
	
*-------------------------------------------------------
*------------------INITIALIZE SUBROUTINE----------------
*-------------------------------------------------------
INITIALIZE:
	MOVE.W  #STARTING_CASH,money
	MOVE.W  #1,     day
	
	MOVE.W  #DAY_COUNTER_INCREMENT,     dayCounter  
	
	* Initalize game
    MOVE.W  #15,    temperature
    MOVE.W  #400,   CO2_level
    MOVE.W  #3,     CO2_daily
    
    * Initalize booleans
    MOVE.B  #0,     visitedShop
	MOVE.B  #0,     hasAlarm
	MOVE.B  #0,     hasSword
	MOVE.B  #0,     hasCoffee
	MOVE.B  #0,     temperatureFirstWarning
	MOVE.B  #0,     temperatureSecondWarning
	
	* Initalize counts
	MOVE.W  #0,     waterMillCount
	MOVE.W  #0,     solarPanelCount  
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
*-------------------name INPUT SUBROUTINE---------------
*-------------------------------------------------------
CLEAR_INPUT_NAME:
    BSR     CLEAR_SCREEN

INPUT_NAME:
	BSR	 	ENDL
	LEA	 	enterName,A1
	BSR	 	PRINT
	BSR	 	ENDL
	
	MOVE.B  #2,D0
	LEA	 	name, A1	*Load Name address to A1 to be able to store name
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
	
	LEA	 	name, A1
	BSR     PRINT
	
	LEA	 	name_confirmation_2, A1
	BSR     PRINT
	
    BSR     INPUT_INT

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

* Give error if input to menu wrong
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
	
	LEA	 	name, A1
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
	
	LEA	 	name,A1
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
    LEA     name, A2    *Load name for SPEAKING_ASCII
    LEA     YOU,  A4    *Load Ascii for You
    
    * Intro sequence of messages
    LEA     intro_story_string_1, A3
    BSR     SPEAKING_ASCII
    
    LEA     intro_story_string_2, A3
    BSR     SPEAKING_ASCII
    
    LEA     intro_story_string_3, A3
    BSR     SPEAKING_ASCII
    
    LEA     intro_story_string_4, A3
    BSR     SPEAKING_ASCII
    *

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
*-------------------------------------------------------
*--------------------ADD_DAY_COUNTER--------------------
*------------[A1: message,D1: boolean, D2:buff]--------- 
*Checks if D1 is true and add day counter buff to day counter
ADD_DAY_COUNTER:
    CMP     #1,     D1
    BNE     ADD_DAY_COUNTER_END
    ADD.W   D2, dayCounter
    BSR     PRINT
    BSR     ENDL
    BSR     ENDL
ADD_DAY_COUNTER_END:
    RTS
*----------------------------------------------------------------
*------------------------CO2_REDUCER-----------------------------
*[A2: message, D1,D2: count, D3:money, D4: CO2, , D6: total CO2 reduction, D5: totalCO2Made, D7]
*  Checks if D1 is true and add day counter buff to day counter
CO2_REDUCER:
    MOVE.W  D2, D1 * Move count into D1
    CMP.W   #0, D1
    BLS     CO2_REDUCER_END
    
    LEA     your,A1
    BSR     PRINT
        
    BSR     PRINT_INT * Print count of wind mill
    
    MOVE    A2, A1
    BSR     PRINT
    
    MOVE.W  D2,D1 * Move count into D1
    MULU.W  D4,D1 * Multiply count by CO2 reduced
    SUB.W   D1,D5 * Subtract CO2 produced
    BPL     NOT_SET_0_D5 * Prevent overflow
    MOVE.W  #0,D5 
NOT_SET_0_D5:
    MOVE.W  D2,D1 * Move count into D1
    MULU.W  D6,D1 * Multiply count by CO2 reduced
    MOVE.W  (CO2_level), D7
    SUB.W   D1, D7 * Subtract CO2 produced
    BPL     NOT_SET_0_D7 * Prevent overflow
    MOVE.W  #0,D7
NOT_SET_0_D7:
    MOVE.W  D7, (CO2_level)
    MULU.W  D3,D1 * Multiply count by money to get total money produced
    ADD.W   D1, money

    BSR     PRINT_INT * Print money earned
    
    LEA     and,A1
    BSR     PRINT
    
    MOVE.W  D2, D1 * Move count into D1
    MULU.W  D4,D1 * Multiply count by CO2 to get total co2 reduced

    BSR     PRINT_INT * Print CO2
    
    LEA     from_air,A1
    BSR     PRINT
    
    BSR     ENDL
    BSR     ENDL
CO2_REDUCER_END:
    RTS
*-------------------------------------------------------
*--------------------GET_TEMPERATURE--------------------
*------------------------------------------------------- 
GET_TEMPERATURE:
    * Equation to get temp : co2 * 0.0375
    MOVE.L  #375, D1
    MULU.W  (CO2_level), D1

    DIVU.W  #10000, D1
    DIVU.W  #10, D1
    MOVE.W  D1, temperature
    RTS
END_DAY:    
    BSR     CLEAR_SCREEN
    ADD.W   #1, day     *Increase day by 1
    
    MOVE.W  (temperature),D1 * If temperature is greater than 44 at end of day
    CMP     #44,    D1
    BHI     END_GAME_LOSE * Lose
    
    BSR     RANDOM_NUMBER_100   * Get rng num between 0 - 100
    MOVE.W  D1, D5          * add random number to total CO2 produced    
    
    ADD.W   (CO2_daily), D5 * add CO2 daily to total CO2 produced
    
    BSR     RANDOM_NUMBER_10 * Get random number between 0 - 10
    ADD.W   D1, CO2_daily  * Increase CO2 daily
DISPLAY_END_DAY:
    LEA     YOU,  A4    *Load Ascii for Shop keeper
    BSR     SHOW_ASCII
    BSR	 	ENDL
    
    LEA     sleep_string,   A1
    BSR     PRINT
    
	MOVE.B  #3,     D4
	BSR     PRINT_DOTS
	
	BSR     ENDL
	BSR	 	SYSTEM_PAUSE
	
    MOVE.W  #DAY_COUNTER_INCREMENT,dayCounter  *Increase reset day counter
    
    LEA     sleep_alarm_day, A1
    MOVE.B  (hasAlarm), D1
    MOVE.W  #ALARM_DAY_COUNTER_BUFF, D2
    BSR     ADD_DAY_COUNTER
    
    LEA     sleep_coffee_day, A1
    MOVE.B  (hasCoffee), D1
    MOVE.W  #COFFEE_DAY_COUNTER_BUFF, D2
    BSR     ADD_DAY_COUNTER
    
    MOVE.B  #0, hasCoffee * Reset coffee to 0 as it is consumed
    
    LEA       sleep_watermill_produce, A2
    MOVE.W    (waterMillCount), D2
    MOVE.W    #WATER_MILL_MONEY, D3
    MOVE.W    #WATER_MILL_REDUCTION, D4
    MOVE.W    #WATER_MILL_REDUCTION_OVERALL, D6
    BSR       CO2_REDUCER

    LEA       sleep_solarpanel_produce, A2
    MOVE.W    (solarPanelCount), D2
    MOVE.W    #SOLAR_PANEL_MONEY, D3
    MOVE.W    #SOLAR_PANEL_REDUCTION, D4
    MOVE.W    #WATER_MILL_REDUCTION_OVERALL, D6
    BSR       CO2_REDUCER
    
	LEA     sleep_increment_co2_string_1, A1
	BSR     PRINT
	
    MOVE.W  D5, D1
	BSR     PRINT_INT
	
	LEA     sleep_increment_co2_string_2, A1
	BSR     PRINT
	
    ADD.W     D5,   CO2_level
    BSR       GET_TEMPERATURE
    
    BSR     ENDL

	BSR     WAIT
	BSR     WAIT
	BSR	 	SYSTEM_PAUSE
*-------------------------------------------------------
*----------------GAME_LOOP (MAIN LOOP)------------------
*------------------------------------------------------- 
GAME_LOOP:
    BSR     CLEAR_SCREEN
    BSR     DISPLAY	

    MOVE.W  (temperature),  D1

    MOVE.W  #TEMP_THRESHOLD_THIRD, D2
    LEA     temperature_warning_third, A1
    BSR     TEMPERATURE_WARNING

    MOVE.W  #TEMP_THRESHOLD_SECOND, D2
    LEA     temperature_warning_second, A1
    BSR     TEMPERATURE_WARNING

    MOVE.W  #TEMP_THRESHOLD_FIRST, D2
    LEA     temperature_warning_first, A1
    BSR     TEMPERATURE_WARNING
    
    TEMPERATURE_WARNING_END:
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
*----------------TEMPERATURE_WARNING--------------------
*-----[D1: temperature, D2: threshold, A1: Message]----- 
*Check if temperature is above threshold and send message
TEMPERATURE_WARNING:
    CMP.W   D2,    D1
    BHI     TEMPERATURE_WARNING_CONTINUE
    RTS
    TEMPERATURE_WARNING_CONTINUE:
    BSR     PRINT
    BSR     ENDL
    LEA     LINE,   A1
    BSR     PRINT
    
    BRA     TEMPERATURE_WARNING_END
*-------------------------------------------------------
*-------------------DISPLAY SUBROUTINE------------------
*-------------------------------------------------------
DISPLAY:
    LEA 	GAME_LINES, A1
	BSR	 	PRINT
	
	MOVE.W  #$0201,  D1  *Move text cursor to text position
	MOVE    #11,    D0
	TRAP    #15
	
	* Display Name
	LEA     NAME_LABEL, A1
	BSR     PRINT
	LEA     name, A1
	BSR     PRINT
	* ----------
	BSR	 	ENDL
	
	MOVE.W  #$0202,  D1  *Move text cursor to text position
	MOVE    #11,    D0
	TRAP    #15

	* Display money
	LEA     MONEY_LABEL, A1
	BSR     PRINT
	MOVE.W  (money), D1
	BSR     PRINT_INT
	* ----------
	
	MOVE.W  #$3501,  D1  *Move text cursor to text position
	MOVE    #11,    D0
	TRAP    #15
	
	* Display Day
	LEA     DAY_LABEL, A1
	BSR     PRINT
	MOVE.W  (day), D1
	BSR     PRINT_INT
	* ----------
    BSR	 	ENDL

	MOVE.W  #$3502,  D1  *Move text cursor to text position
	MOVE    #11,    D0
	TRAP    #15
	
    * Display temperature
	LEA     temperature_LABEL, A1
	BSR     PRINT
	MOVE.W  (temperature), D1
	BSR     PRINT_INT
	* ----------

    * Reset cursor pos back to normal
    MOVE.W  #$0004,  D1
	MOVE    #11,    D0
	TRAP    #15

	RTS

*-------------------------------------------------------
*--------------------WORK SUBROUTINE--------------------
*-------------------------------------------------------
WORK:
    BSR     CLEAR_SCREEN
	
	*if (dayCounter - 2 < 0) = tired
	MOVE.W  (dayCounter),  D1
	SUB     #2, D1
	BMI     TIRED_WORK  * Prevent day counter from going into -1
    
    MOVE.W  D1,  dayCounter * Set day counter to subtracted day counter

    BSR     ENDL

    LEA 	work_string, A1
	BSR	 	PRINT
	
	ADD.W   #SALARY, money
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
    
    CMP.B   #0,   visitedShop
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
    
    LEA     name, A1
    BSR     PRINT
     
    LEA     shop_string_2,  A1
    BSR     PRINT
    
    LEA     TALK_2, A1
    BSR     PRINT
    
    LEA     shop_string_3,  A1
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
    MOVE.B    #1, visitedShop

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
*----------------PRINT_SHOP SUBROUTINE------------------
*-------------------------------------------------------
PRINT_SHOP:
    LEA     shop_browse_1, A1
    BSR     PRINT
    MOVE.W  #ALARM_COST, D1
    BSR     PRINT_INT

    LEA     shop_browse_2, A1
    BSR     PRINT
    MOVE.W  #WATER_MILL_COST, D1
    BSR     PRINT_INT

    LEA     shop_browse_3, A1
    BSR     PRINT
    MOVE.W  #SOLAR_PANEL_COST, D1
    BSR     PRINT_INT

    LEA     shop_browse_4, A1
    BSR     PRINT
    MOVE.W  #SWORD_COST, D1
    BSR     PRINT_INT

    LEA     shop_browse_5, A1
    BSR     PRINT
    MOVE.W  #COFFEE_COST, D1
    BSR     PRINT_INT
    
    LEA     shop_browse_6, A1
    BSR     PRINT
    
    RTS
*-------------------------------------------------------
*-------------------UNABLE_BUY SUBROUTINE---------------
*----------------------[D2: need_money]-----------------
UNABLE_BUY:
    LEA     shop_unable_buy_string_1, A1
    BSR     PRINT
    
    MOVE.W  (money),    D1
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
    
    LEA     SHOP_KEEPER,  A4    *Load Ascii for Shop keeper
    BSR     SHOW_ASCII
    
    BSR     ENDL
    
    BSR     PRINT_SHOP

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
    
    * Ask
    LEA shop_confirm_string, A1
    BSR PRINT
    
    * Cost
    MOVE.W  D2, D1
    BSR PRINT_INT
    
    * Yes or No
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
    LEA     SHOP_KEEPER_NAME, A2
    LEA     shop_thank_string, A3
    LEA     SHOP_KEEPER, A4

    BSR     SPEAKING_ASCII
    
    BSR     CLEAR_SCREEN
    RTS
*-------------------------------------------------------
*---------ATTEMPT_BUY_SINGLE_ITEM SUBROUTINE------------
*----------------[D2:cost, A1: boolean]-----------------
*           Used for purchasing boolean items
ATTEMPT_BUY_SINGLE_ITEM:
    * If (!boolean) { return already_have_item(); }
    MOVE.B  (A1), D1
    CMP.B   #0, D1
    BNE     ALREADY_HAVE_ITEM
    
    * Check if able to afford
    MOVE.W  (money),  D1
	SUB.W   D2, D1
	BMI     UNABLE_BUY
	
	* Remove money and set boolean to true
    MOVE.W  D1, money
    MOVE.B  #1, (A1)
   
    BSR     PURCHASED_ITEM_SHOP
    
    BRA     BROWSE_SHOP
ALREADY_HAVE_ITEM:
    LEA     shop_already_have_string,   A1
    BSR     PRINT
    
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN
    BRA     BROWSE_SHOP
ALARM_CLOCK:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    
    * Ask for confirmation
    MOVE.W  #ALARM_COST, D2
    BSR     CONFIRM_SHOP
    
    LEA     hasAlarm, A1
    BRA     ATTEMPT_BUY_SINGLE_ITEM
WATER_MILL:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    
    * Ask for confirmation
    MOVE.W  #WATER_MILL_COST, D2
    BSR     CONFIRM_SHOP
    
    * Check if able to afford item
    MOVE.W  (money),  D1
	SUB.W   D2, D1
	BMI     UNABLE_BUY
	
	* Remove money and increment count
    MOVE.W  D1, money
    ADD.W   #1, waterMillCount
   
    BSR     PURCHASED_ITEM_SHOP
    
    BRA     BROWSE_SHOP
SOLAR_PANEL:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    
    * Ask for confirmation
    MOVE.W  #SOLAR_PANEL_COST, D2
    BSR     CONFIRM_SHOP
    
    * Check if able to afford item
    MOVE.W  (money),  D1
    MOVE.W  #SOLAR_PANEL_COST, D2
	SUB.W   D2, D1
	BMI     UNABLE_BUY
	
	* Remove money and increment count
    MOVE.W  D1, money
    ADD.W  #1,  solarPanelCount
    
    BSR     PURCHASED_ITEM_SHOP
    
    BRA     BROWSE_SHOP
SWORD:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    
    * Confirm if player wants to buy sword
    MOVE.W  #hasSword, D2
    BSR     CONFIRM_SHOP
    
    LEA     hasSword, A1
    BRA     ATTEMPT_BUY_SINGLE_ITEM
COFFEE:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    
    * Confirm if player wants to buy coffee
    MOVE.W  #COFFEE_COST, D2
    BSR     CONFIRM_SHOP
    
    LEA     hasCoffee, A1
    BRA     ATTEMPT_BUY_SINGLE_ITEM
SELL_ITEM_SHOP:
    LEA     SHOP_KEEPER_NAME, A2
    LEA     shop_unable_string, A3
    LEA     SHOP_KEEPER, A4

    BSR     SPEAKING_ASCII
    BRA     SHOP
*-------------------------------------------------------
*--------------------EXPLORE SUBROUTINE-----------------
*-------------------------------------------------------
EXPLORE:
    BSR     CLEAR_SCREEN
    
    BSR     ENDL

	LEA 	exploreChoice, A1
	BSR		PRINT
	
    BSR     ENDL
    
	BSR	 	SYSTEM_PAUSE
	BRA		CITY

EXPLORE_CASTLE_OUT:
    BSR     CLEAR_SCREEN

    LEA     CASTLE, A1
    BSR     PRINT
    
    BSR     ENDL
    
    LEA     explore_castle_out, A1
    BSR     PRINT
    
    LEA     explore_option_out, A1
    BSR     PRINT
    
    BSR     INPUT_INT
    
    CMP     #1,     D1
    BEQ     GAME_LOOP
    CMP     #2,     D1
    BEQ     EXPLORE_CASTLE_IN

    BRA     EXPLORE_CASTLE_OUT
EXPLORE_CASTLE_IN:
    BSR     CLEAR_SCREEN
    LEA     explore_story_message_1,A1
    BSR     PRINT
    
    BSR     WAIT

    LEA     name, A2
    LEA     explore_you_message_1,A3
    LEA     YOU, A4
    BSR     SPEAKING_ASCII

    BSR     WAIT
    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN

    LEA     explore_story_message_2,A1
    BSR     PRINT
    
    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN
    
    LEA     explore_story_message_3,A1
    BSR     PRINT

    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN

    LEA     KING_NAME, A2
    LEA     explore_king_message_1, A3
    LEA     KING, A4
    BSR     SPEAKING_ASCII

    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN
    
    LEA     explore_king_message_2, A3
    BSR     SPEAKING_ASCII

    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN

    LEA     name, A2
    LEA     explore_you_message_2,A3
    LEA     YOU, A4
    BSR     SPEAKING_ASCII

    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN

    LEA     KING_NAME, A2
    LEA     explore_king_message_2, A3
    LEA     KING, A4
    BSR     SPEAKING_ASCII

    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN

    LEA     explore_king_message_3, A3
    BSR     SPEAKING_ASCII
    
    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN
    
    LEA     name, A2
    LEA     explore_you_message_3,A3
    LEA     YOU, A4
    BSR     SPEAKING_ASCII

    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN

    LEA     KING_NAME, A2
    LEA     explore_king_message_4, A3
    LEA     KING, A4
    BSR     SPEAKING_ASCII
    
    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN
    
    LEA     name, A2
    LEA     explore_you_message_4,A3
    LEA     YOU, A4
    BSR     SPEAKING_ASCII

    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN

    LEA     KING_NAME, A2
    LEA     explore_king_message_5, A3
    LEA     KING, A4
    BSR     SPEAKING_ASCII

    BSR     WAIT
    BSR     SYSTEM_PAUSE
    BSR     CLEAR_SCREEN

    LEA     explore_option_in, A1
    BSR     PRINT

    BSR     INPUT_INT

    CMP     #1,     D1
    CMP     #2,     D1
   DC.B    'Should I go slay the king?'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'1) Yes'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'2) No'
                    DC.B	$0D,$0A
                    DC.B	'Enter your choice) ',0
explore_story_message_4 DC.B    'You have slayed the King of Oxeris',0
explore_story_message_5 DC.B    'However the guards have arrested you and put you into prison',0
*-------------------------------------------------------
*--------------------MANAGE SUBROUTINE------------------
*-------------------------------------------------------
MANAGE:
	BSR     CLEAR_SCREEN
    LEA     YOU, A4
    BSR     SHOW_ASCII
    BSR     ENDL
    
    LEA     manage_browse, A1
    BSR     PRINT
    * if (hasAlarm) 2
    MOVE.B  (hasAlarm), D1
    CMP.B   #1, D1
    BNE     MANAGE_ALARM_END
    BSR     ENDL
    BSR     ENDL
    LEA     manage_browse_alarm, A1
    BSR     PRINT
MANAGE_ALARM_END:
    * if (waterMillCount > 0) 3
    MOVE.W  (waterMillCount), D1
    CMP.W   #0, D1
    BLS     MANAGE_WATER_END
    BSR     ENDL
    BSR     ENDL
    LEA     manage_browse_water, A1
    BSR     PRINT
MANAGE_WATER_END:
    * if (solarPanelCount > 0) 4
    MOVE.W  (solarPanelCount), D1
    CMP.W   #0, D1
    BLS     MANAGE_SOLAR_END
    BSR     ENDL
    BSR     ENDL
    LEA     manage_browse_solar, A1
    BSR     PRINT
MANAGE_SOLAR_END:
    * if (hasSword) 5
    MOVE.B  (hasSword), D1
    CMP.B   #1, D1
    BNE     MANAGE_SWORD_END
    BSR     ENDL
    BSR     ENDL
    LEA     manage_browse_sword, A1
    BSR     PRINT
MANAGE_SWORD_END:
    * if (hasCoffee) 6
    MOVE.B  (hasCoffee), D1
    CMP.B   #1, D1
    BNE     MANAGE_COFFEE_END
    BSR     ENDL
    BSR     ENDL
    LEA     manage_browse_coffee, A1
    BSR     PRINT
MANAGE_COFFEE_END:
    BSR     ENDL
    LEA     manage_browse_choice, A1
    BSR     PRINT

    BSR     INPUT_INT * D1
    
    CMP     #1, D1
    BEQ     CITY
    CMP     #2, D1
    BEQ     MANAGE_ALARM_INPUT
    CMP     #3, D1
    BEQ     MANAGE_WATER_INPUT
    CMP     #4, D1
    BEQ     MANAGE_SOLAR_INPUT
    CMP     #5, D1
    BEQ     MANAGE_SWORD_INPUT
    CMP     #6, D1
    BEQ     MANAGE_COFFEE_INPUT

	BRA	 	MANAGE

MANAGE_ALARM_INPUT:
    * if (!hasAlarm) { return; }
    MOVE.B  (hasAlarm), D1
    CMP.B   #1, D1
    BNE     MANAGE

    BSR     CLEAR_SCREEN
    
    * Info about item
    LEA     manage_info_string_alarm, A1
    BSR     PRINT

    BSR     ENDL
    BSR     SYSTEM_PAUSE

    BRA     MANAGE

MANAGE_WATER_INPUT:
    * if (waterMillCount < 0) { return; }
    MOVE.W  (waterMillCount), D1
    CMP.W   #0, D1
    BLS     MANAGE

    BSR     CLEAR_SCREEN
    
    * Info about item
    LEA     manage_info_string_water, A1
    BSR     PRINT

    BSR     ENDL

    LEA     manage_default_amount_string, A1
    BSR     PRINT

    MOVE.W  waterMillCount, D1
    BSR     PRINT_INT

    LEA     manage_default_amount_waterMill, A1
    BSR     PRINT

    BSR     ENDL
    BSR     SYSTEM_PAUSE
    
    BRA     MANAGE
MANAGE_SOLAR_INPUT:
    * if (solarPanelCount < 0) { return; }
    MOVE.W  (solarPanelCount), D1
    CMP.W   #0, D1
    BLS     MANAGE

    BSR     CLEAR_SCREEN
    
    * Info about item
    LEA     manage_info_string_solar, A1
    BSR     PRINT

    BSR     ENDL

    LEA     manage_default_amount_string, A1
    BSR     PRINT

    MOVE.W  solarPanelCount, D1
    BSR     PRINT_INT

    LEA     manage_default_amount_solarPanel, A1
    BSR     PRINT

    BSR     ENDL
    BSR     SYSTEM_PAUSE
    
    BRA     MANAGE
MANAGE_SWORD_INPUT:
    * if (!hasSword) { return; }
    MOVE.B  (hasSword), D1
    CMP.B   #1, D1
    BNE     MANAGE

    BSR     CLEAR_SCREEN
    
    * Info about item
    LEA     manage_info_string_sword, A1
    BSR     PRINT

    BSR     ENDL
    BSR     SYSTEM_PAUSE

    BRA     MANAGE

MANAGE_COFFEE_INPUT:
    * if (!hasCoffee) { return; }
    MOVE.B  (hasCoffee), D1
    CMP.B   #1, D1
    BNE     MANAGE

    BSR     CLEAR_SCREEN
    
    * Info about item
    LEA     manage_info_string_coffee, A1
    BSR     PRINT

    BSR     ENDL
    BSR     SYSTEM_PAUSE

    BRA     MANAGE

END_GAME_LOSE:
    LEA     end_game_lose_1, A1
    BSR     PRINT
    
    MOVE.W  (day),D1
    BSR     PRINT_INT

    LEA     end_game_lose_2, A1
    BSR     PRINT
    
    MOVE.W  (money),D1
    BSR     PRINT_INT
    
    BSR     ENDL
    
    LEA     end_game_lose_3, A1
    BSR     PRINT
    
    MOVE.W  (solarPanelCount),D1
    BSR     PRINT_INT

    BSR     ENDL
    LEA     end_game_lose_4, A1
    BSR     PRINT
    
    MOVE.W  (waterMillCount),D1
    BSR     PRINT_INT
    BRA     END
END_GAME_NEUTRAL:
    LEA     end_game_lose_1, A1
    BSR     PRINT
    
    MOVE.W  (day),D1
    BSR     PRINT_INT

    LEA     end_game_lose_2, A1
    BSR     PRINT
    
    MOVE.W  (money),D1
    BSR     PRINT_INT
    
    BSR     ENDL
    
    LEA     end_game_lose_3, A1
    BSR     PRINT
    
    MOVE.W  (solarPanelCount),D1
    BSR     PRINT_INT

    BSR     ENDL
    LEA     end_game_lose_4, A1
    BSR     PRINT
    
    MOVE.W  (waterMillCount),D1
    BSR     PRINT_INT
    BRA     END

*-------------------------------------------------------------------------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------UTILITY FUNCTIONS-------------------------------------------------------------*
*-------------------------------------------------------------------------------------------------------------------------------------------------------*
*-------------------------------------------------------------------------------------------------------------------------------------------------------*

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
*----------------INPUT_INT SUBROUTINE-------------------
*-------------------[D0,D1:output]----------------------
INPUT_INT:
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
	TRAP	#15		 *ASK FOR NUMBER but dont use number
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
*    Used when a character is speaking a dialogue
SPEAKING_ASCII:
    BSR     CLEAR_SCREEN
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
*-------------------WAIT SUBROUTINE---------------------
*----------------[D1,D2,D3,number: D4]------------------
*                   Waits 1 second
WAIT: *Get start time
    BSR     GET_MILLISECONDS
    MOVE.L  D1,D2
WAIT_LOOP:
    BSR     GET_MILLISECONDS
    
    MOVE    D2,D3
    SUB     D3,D1
    
    CMP     #SECOND,D1
    BLS     WAIT_LOOP

    RTS

*-------------------------------------------------------
*----------------TIMED PRINT DOT SUBROUTINE-------------
*-------------------[D1,D2,D3,number: D4]---------------
PRINT_DOTS:
    LEA     Dot,A1
DOT_NEXT_PRINT: * while (D4 != 0)
    BSR     PRINT
    
    BSR     WAIT
    
    SUB     #1, D4
    CMP     #0, D4
    BNE     DOT_NEXT_PRINT
    RTS
	
GET_MILLISECONDS:
    MOVE.B #8, D0 # Load
    TRAP #15  #Time in D1
    RTS
*-------------------------------------------------------
*--------------RANDOM_NUMBER_100 SUBROUTINE-------------
*-------------------------------------------------------
*         Gets a random number between 0 - 100
RANDOM_NUMBER_100:     
    BSR GET_MILLISECONDS

    AND.L #$5FFFFF, D1 # AND 6 Bits to prevent any overflow

    DIVU #100, D1 #Divide by 100, 1000, 10000 depending on Number range required

    SWAP D1 #SWAP Higher Order Word and Lower Order Word in D1

    ADDQ.W #1, D1 #Add 1 to D1.W so number is at least 1

    MOVE.W D1, D2 #Extract the number from D1.W

    CLR.L D1 # Clear contents of D1

    MOVE.W D2, D1 #Move the generated number to D1
    RTS
*-------------------------------------------------------
*---------------RANDOM_NUMBER_10 SUBROUTINE-------------
*-------------------------------------------------------
*         Gets a random number between 0 - 10
RANDOM_NUMBER_10:     
    BSR GET_MILLISECONDS

    AND.L #$7FFFF, D1 # AND 5 Bits to prevent any overflow

    DIVU #10, D1 #Divide by 10

    SWAP D1 #SWAP Higher Order Word and Lower Order Word in D1

    ADDQ.W #1, D1 #Add 1 to D1.W so number is at least 1

    MOVE.W D1, D2 #Extract the number from D1.W

    CLR.L D1 # Clear contents of D1

    MOVE.W D2, D1 #Move the generated number to D1
    RTS

	
END:
	SIMHALT
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
temperature_LABEL   DC.B    'temperature: ',0
	    
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

GUIDE_NAME       DC.B    'Guide Gary',   0
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

KING_NAME        DC.B   'King',0
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

CASTLE           DC.B    '                                  |>>>'
                 DC.B	$0D,$0A
                 DC.B    '                                  |'
                 DC.B	$0D,$0A
                 DC.B    '                    |>>>      _  _|_  _         |>>>'
                 DC.B	$0D,$0A
                 DC.B    '                    |        |;| |;| |;|        |'
                 DC.B	$0D,$0A
                 DC.B    '                _  _|_  _    \\.    .  /    _  _|_  _'
                 DC.B	$0D,$0A
                 DC.B    '               |;|_|;|_|;|    \\:. ,  /    |;|_|;|_|;|'
                 DC.B	$0D,$0A
                 DC.B    '               \\..      /    ||;   . |    \\.    .  /'
                 DC.B	$0D,$0A
                 DC.B    '                \\.  ,  /     ||:  .  |     \\:  .  /'
                 DC.B	$0D,$0A
                 DC.B    '                 ||:   |_   _ ||_ . _ | _   _||:   |'
                 DC.B	$0D,$0A
                 DC.B    '                 ||:  .|||_|;|_|;|_|;|_|;|_|;||:.  |'
                 DC.B	$0D,$0A
                 DC.B    '                 ||:   ||.    .     .      . ||:  .|'
                 DC.B	$0D,$0A
                 DC.B    '                 ||: . || .     . .   .  ,   ||:   |       \,/'
                 DC.B	$0D,$0A
                 DC.B    '                 ||:   ||:  ,  _______   .   ||: , |            /`\'
                 DC.B	$0D,$0A
                 DC.B    '                 ||:   || .   /+++++++\    . ||:   |'
                 DC.B	$0D,$0A
                 DC.B    '                 ||:   ||.    |+++++++| .    ||: . |'
                 DC.B	$0D,$0A
                 DC.B    '              __ ||: . ||: ,  |+++++++|.  . _||_   |'
                 DC.B	$0D,$0A
                 DC.B    '     ____--`~    `--~~__|.    |+++++__|----~    ~`---,              ___'
                 DC.B	$0D,$0A
                 DC.B    '-~--~                   ~---__|,--~`                  ~~----_____-~`   `~----~~', 0
                 
mainChoice   	DC.B	'What would you like to do?'
                DC.B	$0D,$0A
                DC.B	'1) Go to work and earn $75'
                DC.B	$0D,$0A
                DC.B	'2) Enter the Town'
                DC.B	$0D,$0A
                DC.B	'3) Sleep and end the day'
                DC.B	$0D,$0A
                DC.B	'Enter your choice) ',0

sleep_string    DC.B    'ZzZzZzZzZz',0
sleep_increment_co2_string_1 DC.B    'You sense that theres an extra ',0
sleep_increment_co2_string_2 DC.B    ' CO2 in the air',0

sleep_alarm_day              DC.B    'You woke up early because of your alarm!',0
sleep_coffee_day             DC.B    'You start your day consuming the coffee.',0

your    DC.B    'Your ',0
and     DC.B    ' and removed ',0 
from_air    DC.B    ' CO2 from the air',0

sleep_watermill_produce     DC.B    ' x Water Mills have given $',0
sleep_solarpanel_produce    DC.B    ' x Solar Panels have given $',0

cityChoice		DC.B	'What would you like to do in the town?'
                DC.B	$0D,$0A
                DC.B	'1) Visit the General Store'
                DC.B	$0D,$0A
                DC.B	'2) Explore the Town'
                DC.B	$0D,$0A
                DC.B	'3) Manage your items'
                DC.B	$0D,$0A
                DC.B	'4) Exit the Town'
                DC.B	$0D,$0A
                DC.B	'Enter your choice) ',0


shop_string_1           DC.B    'Hello ',0
shop_string_2           DC.B    ', you are free to have a look around my store.',0
shop_string_3           DC.B	$0D,$0A
                        DC.B	'1) Browse around the shop'
                        DC.B	$0D,$0A
                        DC.B	'2) Sell items to the shop'
                        DC.B	$0D,$0A
                        DC.B	'3) Exit the Shop'
                        DC.B	$0D,$0A
                        DC.B	'Enter your choice) ',0
                        
shop_browse_1           DC.B    'There is a selection of items that caught your interest:'
                        DC.B	$0D,$0A
                        DC.B    '1) Alarm Clock : $',0
shop_browse_2           DC.B	$0D,$0A
                        DC.B    '2) Water Mill : $',0
shop_browse_3           DC.B	$0D,$0A
                        DC.B    '3) Solar Panel : $',0
shop_browse_4           DC.B	$0D,$0A
                        DC.B    '4) Sword : $',0
shop_browse_5           DC.B	$0D,$0A
                        DC.B    '5) Coffee : $',0
shop_browse_6           DC.B	$0D,$0A
                        DC.B    '6) Exit Browse'
                        DC.B	$0D,$0A
                        DC.B	'Enter your choice) ',0


shop_unable_buy_string_1: DC.B    'You have ',0
shop_unable_buy_string_2: DC.B    ' cash. You need ',0
shop_unable_buy_string_3: DC.B    ' more cash to purchase this item.',0

shop_already_have_string:  DC.B    'You already have this item.',0

shop_intro_string_1           DC.B    'Welcome to my Store, my name is ',0
shop_intro_string_2           DC.B    '!' 
                              DC.B    $0D,$0A
                              DC.B    'I sell items that could be used to reduce your CO2 output.',0

shop_confirm_string DC.B    'Are you sure that you want to buy this item for $',0
YES_NO              DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'1) Yes'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'2) No'
                    DC.B	$0D,$0A
                    DC.B	'Enter your choice) ',0
shop_thank_string   DC.B    'Thank you for buying this item!',0
shop_unable_string   DC.B    'Sorry I am currently not buying goods from individuals!',0

exploreChoice	DC.B    'The road to town is currently blocked by a giant immovable boulder.', 0

explore_castle_out  DC.B    'You notice a castle in the distance',0
explore_option_out  DC.B    'Should I go visit the castle?'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'1) Yes'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'2) No'
                    DC.B	$0D,$0A
                    DC.B	'Enter your choice) ',0
explore_story_message_1 DC.B    'You walk into the empty castle with no guards around',0
explore_you_message_1   DC.B    'I wonder if this castle is empty',0
explore_story_message_2 DC.B    'You walk around the castle eventually reaching the throne room',0
explore_story_message_3 DC.B    'You spot the King of Oxeris sitting on the throne by himself crying',0
explore_king_message_1  DC.B    'Hello adventurer...',0
explore_king_message_2  DC.B    'Im the King of Oxeris and I have done a mistake',0
explore_you_message_2   DC.B    'What have you done to make a mistake?!',0
explore_king_message_3  DC.B    'I have ordered my workers to mine into a volcano releasing CO2',0
explore_you_message_3   DC.B    'Why would you do that!?',0
explore_king_message_4  DC.B    'I thought that the volcano would give the Kingdom all the energy it would every need',0
explore_you_message_4   DC.B    'Do you have any plan to solve this',0
explore_king_message_5  DC.B    'I have no idea how to solve this problem',0
explore_option_in   DC.B    'Should I go slay the king?'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'1) Yes'
                    DC.B	$0D,$0A
                    DC.B	$0D,$09
                    DC.B	'2) No'
                    DC.B	$0D,$0A
                    DC.B	'Enter your choice) ',0
explore_story_message_4 DC.B    'You have slayed the King of Oxeris',0
explore_story_message_5 DC.B    'However the guards have arrested you and put you into prison',0
explore_story_message_leave    DC.B    'You leave the castle.'

manage_browse      DC.B    'What should I manage?:'
                          DC.B    $0D,$0A
                          DC.B    '1) Exit Browse',0
manage_browse_alarm    DC.B    '2) Alarm Clock',0
manage_browse_water    DC.B    '3) Water Mill',0
manage_browse_solar    DC.B    '4) Solar Panel',0
manage_browse_sword    DC.B    '5) Sword',0
manage_browse_coffee    DC.B    '6) Coffee',0
manage_browse_choice    DC.B	'Enter your choice) ',0

manage_info_string_alarm    DC.B    'This alarm clock allows you to wake up earlier',0
manage_info_string_water    DC.B    'Water Mills are a cheap and reliable CO2 reducer.',0
manage_info_string_solar    DC.B    'Solar Panels are expensive but are efficient at removing CO2.',0
manage_info_string_sword    DC.B    'The sword is used to slay your enemies.',0
manage_info_string_coffee   DC.B    'Coffee allows you to stay awake longer.',0

manage_default_amount_string        DC.B    'You currently have ',0
manage_default_amount_waterMill     DC.B    'x Water Mills',0
manage_default_amount_solarPanel    DC.B    'x Solar Panels',0

work_string	   	DC.B	'Working', 0 
work_tired_string   DC.B    'You are too tired to work right now',0
PAUSE		  	DC.B	'Press enter to continue . . .', 0

temperature_warning_first   DC.B    'Feels quite warmer than before.'
                            DC.B    $0D,$0A
                            DC.B    'I should get some water mills or solar panels',0
temperature_warning_second  DC.B    'Maybe the tax on CO2 was a good idea',0
temperature_warning_third   DC.B    'Its REALLY getting hot in here.'
                            DC.B    $0D,$0A
                            DC.B    'I dont think I can stand much longer at 45C',0
end_game_lose_1   DC.W    'You have survived for ',0
end_game_lose_2   DC.W    ' days with $',0
end_game_lose_3   DC.W    'Water Mills: ',0
end_game_lose_4   DC.W    'Solar Panels: ',0

name	 		DS.W	30  *Max length of name can be 30
money 			DS.W	1	*PLAYER money in hundreds
day             DS.W    1   *DAYS PASSED

dayCounter     DS.W    1   *INCREASED FROM 3 TO 4 IF ALARM
CO2_daily      DS.W    1

temperature     DS.W    1   * Default = 15 C
CO2_level       DS.W    1   * Default = 4000 ppm or 0.00375 per CO2

* Amount
waterMillCount    DS.W    1
solarPanelCount   DS.W    1
* Booleans
visitedShop    DS.B    1   *Check if you visited shop before
hasAlarm       DS.B    1
hasSword       DS.B    1
hasCoffee      DS.B    1
temperatureFirstWarning DS.B    1
temperatureSecondWarning DS.B   1
visitedCastle  DS.B    1
*

*
*-------------------------------------------------------
*VALIDATION VALUES TO BE USED
*-------------------------------------------------------
SALARY	  EQU 75
STARTING_CASH	  EQU 100
SECOND  EQU 100

DAY_COUNTER_INCREMENT EQU 3

ALARM_DAY_COUNTER_BUFF EQU 2
COFFEE_DAY_COUNTER_BUFF EQU 1

* ITEMS
ALARM_COST          EQU 20
WATER_MILL_COST     EQU 200
SOLAR_PANEL_COST    EQU 1000
SWORD_COST          EQU 50
COFFEE_COST         EQU 12

* CO2 Reducers
WATER_MILL_REDUCTION    EQU 8
SOLAR_PANEL_REDUCTION   EQU 30

WATER_MILL_REDUCTION_OVERALL    EQU 2
SOLAR_PANEL_REDUCTION_OVERALL   EQU 25

* CO2 Money Givers
WATER_MILL_MONEY    EQU 10
SOLAR_PANEL_MONEY   EQU 40

* Temperature Thresholds
TEMP_THRESHOLD_FIRST   EQU 16
TEMP_THRESHOLD_SECOND  EQU 24
TEMP_THRESHOLD_THIRD   EQU 31
	END	START
































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
