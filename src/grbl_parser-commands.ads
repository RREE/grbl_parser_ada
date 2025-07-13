pragma Style_Checks ("M150");

with Interfaces;

package Grbl_Parser.Commands is

   subtype Byte is Interfaces.Unsigned_8;

   None                  : constant Byte := 16#00#;
   Reset                 : constant Byte := 16#18#;  --  Ctrl-X
   FeedHold              : constant Byte := 16#21#;  --  '!'
   StatusReport          : constant Byte := 16#3F#;  --  '?'
   CycleStart            : constant Byte := 16#7E#;  --  '~'
   SafetyDoor            : constant Byte := 16#84#;
   JogCancel             : constant Byte := 16#85#;
   DebugReport           : constant Byte := 16#86#;  --  Only when DEBUG_REPORT_REALTIME enabled, sends debug report in '{}' braces.
   Macro0                : constant Byte := 16#87#;
   Macro1                : constant Byte := 16#88#;
   Macro2                : constant Byte := 16#89#;
   Macro3                : constant Byte := 16#8a#;
   FeedOvrReset          : constant Byte := 16#90#;  --  Restores feed override value to 100%.
   FeedOvrCoarsePlus     : constant Byte := 16#91#;
   FeedOvrCoarseMinus    : constant Byte := 16#92#;
   FeedOvrFinePlus       : constant Byte := 16#93#;
   FeedOvrFineMinus      : constant Byte := 16#94#;
   RapidOvrReset         : constant Byte := 16#95#;  -- Restores rapid override value to 100%.
   RapidOvrMedium        : constant Byte := 16#96#;
   RapidOvrLow           : constant Byte := 16#97#;
   RapidOvrExtraLow      : constant Byte := 16#98#;  -- *NOT SUPPORTED*
   SpindleOvrReset       : constant Byte := 16#99#;  -- Restores spindle override value to 100%.
   SpindleOvrCoarsePlus  : constant Byte := 16#9A#;  -- 154
   SpindleOvrCoarseMinus : constant Byte := 16#9B#;
   SpindleOvrFinePlus    : constant Byte := 16#9C#;
   SpindleOvrFineMinus   : constant Byte := 16#9D#;
   SpindleOvrStop        : constant Byte := 16#9E#;
   CoolantFloodOvrToggle : constant Byte := 16#A0#;
   CoolantMistOvrToggle  : constant Byte := 16#A1#;

end Grbl_Parser.Commands;
