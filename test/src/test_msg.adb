with Grbl_Parser;
with Handlers;         use Handlers;
--  with Ada.Text_IO;      use Ada.Text_IO;

procedure Test_Msg is

begin
   --  set up callback routines
   Grbl_Parser.Handle_Msg := Handle_Message'Access;
   Grbl_Parser.Handle_Alarm := Handle_Alarm'Access;

   --  look at their output when feeded with different lines
   Grbl_Parser.Parse_Line ("Grbl 1.1h ['$' for help]");
   Grbl_Parser.Parse_Line ("<Jog|MPos:110.000,88.550,0.000,0.000|FS:1000,0>");
   Grbl_Parser.Parse_Line ("<Jog|MPos:110.000,89.812,0.000,0.000|FS:1000,0>");
   Grbl_Parser.Parse_Line ("<Jog|MPos:110.000,91.088,0.000,0.000|FS:1000,0|WCO:0.000,0.000,0.000,0.000>");
   Grbl_Parser.Parse_Line ("<Jog|MPos:110.000,92.363,0.000,0.000|FS:1000,0|Ov:100,100,100>");

   Grbl_Parser.Parse_Line ("<Idle|MPos:10.000|FS:0,0>");
   Grbl_Parser.Parse_Line ("<Idle|MPos:10.000,0.000|FS:0,0>");
   Grbl_Parser.Parse_Line ("<Idle|MPos:10.000,0.000,0.000|FS:0,0>");
   Grbl_Parser.Parse_Line ("<Idle|MPos:10.000,0.000,0.000,0.000|FS:0,0>");
   Grbl_Parser.Parse_Line ("GC:G0 G54 G17 G21 G90 G94 M5 M9 T0 F0 S0]");
   Grbl_Parser.Parse_Line ("<Idle|MPos:0.000,0.000,0.000|Bf:15,128|FS:0,1000|Ov:100,100,100|A:SF>");
   Grbl_Parser.Parse_Line ("[MSG:Check Limits]");
   Grbl_Parser.Parse_Line ("ALARM:3");

end Test_Msg;
