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
   Grbl_Parser.Handle_State := Handle_State'Access;
   Grbl_Parser.Handle_Feed_Spindle := Handle_Feed_Spindle'Access;
   Grbl_Parser.Handle_Machine_Pos  := Handle_Machine_Pos'Access;
   Grbl_Parser.Handle_Work_Offset  := Handle_Work_Offset'Access;

   if Argument (1) = "-l" then
      Grbl_Parser.Parse_Line (Argument (2));
   end if;

end Test_CL;
