with Grbl_Parser;
with Handlers;         use Handlers;
--  with Ada.Text_IO;      use Ada.Text_IO;

procedure Test_Msg is

begin
   --  Grbl_Parser.Init (State);
   --  Put_Info;
   --  Grbl_Parser.Parse_Line (State, "<Idle|MPos:5.000,10.000,0.000|WPos:1.000,2.000,3.000>");
   --  Grbl_Parser.Parse_Line (State, "Grbl 1.1h ['$' for help]");
   --  Grbl_Parser.Parse_Line (State, "[MSG:Check Limits]");
   --  Grbl_Parser.Parse_Line (State, "ALARM:3");
   --  Put_Info;
   Grbl_Parser.Handle_Msg := Handle_Message'Access;
   Grbl_Parser.Handle_Alarm := Handle_Alarm'Access;
   Grbl_Parser.Parse_Line ("[MSG:Check Limits]");
   Grbl_Parser.Parse_Line ("ALARM:3");

end Test_Msg;
