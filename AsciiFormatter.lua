function string:split( inSplitPattern, outResults )
    if not outResults then
      outResults = { }
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
  end
  
  local ascii = [[                 :7P#&@@@@@@@@&#GY~.              
                .J&@@@&G5J!!!!!JPB&@@@&P!           
               !@@@5~.             .~5&@@@5.        
              ?@@B.                    ~&@@@?       
             ^@@&          .~?5GPG##BBGB&@@@@BY~.   
             &@@!        ~B&&&BBGPPPPP5YYY5PB#@@&Y  
            !@@#        5@&BY^::::::::        ^B&@#.
      .:!?Y5&@@?       ~@&BY7::^^^^^^^:....    ^#&@P
    7#@@@@@@@@@.       J@&PYY?~^::::::^^^^^^:::^B&&&
   ^@@B^...J@@#        ^&&GYY5YJ?7!~~^^^^^~~~!7J#&&#
   G@&     :@@5        .#@&GYYYYYYYYYYYYYYYYYY5B&@&~
  .@@Y     ^@@Y         :#@@&BGP555555555PGB#&&&&B: 
  ~@@7     7@@~           ~5B#&&&&&&&&&&&&&#BP&@&   
  5@@7     !@@^               .:::~!!!~:::.   P@@.  
  #@@7     7@@~                               7@@.  
  &@@!     ^@@~                               !@@:  
  @@@!     .@@J                               5@@:  ]]
  
  local s_ascii = ascii:split("\n")
  print("LOL              DC.B    '" .. s_ascii[1] .. "'")
  for i = 2, #s_ascii - 1 do
      print("                 DC.B	$0D,$0A")  -- 5 Tabs
      print("                 DC.B    '" .. s_ascii[i] .. "'")
  end
  print("                 DC.B	$0D,$0A")
  print("                 DC.B    '" .. s_ascii[#s_ascii] .. "', 0")