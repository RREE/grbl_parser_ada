with Grbl_Parser;
with Handlers;         use Handlers;
with Ada.Command_Line;

procedure Test_CL is
   use Ada.Command_Line;
begin
   if Argument_Count /= 2 then
      --  Show_Help;
      return;
   end if;

   --  set up callback routines
   Grbl_Parser.Handle_Msg   := Handle_Message'Access;
   Grbl_Parser.Handle_Alarm := Handle_Alarm'Access;
   Grbl_Parser.Handle_OK    := Handle_OK'Access;
   Grbl_Parser.Handle_State           := Handle_State'Access;
   Grbl_Parser.Handle_Feed_Spindle    := Handle_Feed_Spindle'Access;
   Grbl_Parser.Handle_Machine_Pos     := Handle_Machine_Pos'Access;
   Grbl_Parser.Handle_Work_Pos        := Handle_Work_Pos'Access;
   Grbl_Parser.Handle_Offset          := Handle_Offset'Access;
   Grbl_Parser.Handle_Version_Report  := Handle_Version_Report'Access;
   Grbl_Parser.Handle_Spindle_Coolant := Handle_Spindle_Coolant'Access;

   if Argument (1) = "-l" then
      Grbl_Parser.Parse_Line (Argument (2));
   end if;

end Test_CL;
