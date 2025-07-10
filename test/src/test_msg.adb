with Grbl_Parser;
with Ada.Text_IO;

procedure Test_Msg is
   State : Grbl_Parser.Parser_State;

   procedure Put_Info is
      use Ada.Text_IO;
   begin
      Put_Line ("State: " & Grbl_Parser.Machine_State'Image (State.State));
      Put_Line ("MPos: X=" & Float'Image (State.Machine_Position.X));
      Put_Line ("MPos: Y=" & Float'Image (State.Machine_Position.Y));
      Put_Line ("MPos: Z=" & Float'Image (State.Machine_Position.Z));
      Put_Line ("WPos: X=" & Float'Image (State.Work_Position.X));
      Put_Line ("WPos: Y=" & Float'Image (State.Work_Position.Y));
      Put_Line ("WPos: Z=" & Float'Image (State.Work_Position.Z));
      Put_Line ("Version: " & State.Version (1 .. State.Version_Length));
      Put_Line ("Message: " & State.Message (1 .. State.Message_Length));
      Put_Line ("Alarm: " & Integer'Image (State.Alarm_Code));
   end Put_Info;

begin
   Grbl_Parser.Init (State);
   Put_Info;
   Grbl_Parser.Parse_Line (State, "<Idle|MPos:5.000,10.000,0.000|WPos:1.000,2.000,3.000>");
   Grbl_Parser.Parse_Line (State, "Grbl 1.1h ['$' for help]");
   Grbl_Parser.Parse_Line (State, "[MSG:Check Limits]");
   Grbl_Parser.Parse_Line (State, "ALARM:3");
   Put_Info;
end Test_Msg;
