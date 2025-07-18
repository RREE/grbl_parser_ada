with Grbl_Parser;
package Handlers is

   procedure Handle_State (State : String);
   procedure Handle_Message (Command : String; Arg : String);
   procedure Handle_Alarm (Code : Integer);
   procedure Handle_OK;
   procedure Handle_Feed_Spindle (Feedrate : Natural; Spindlespeed : Natural);
   procedure Handle_Machine_Pos (Pos : Grbl_Parser.Position);
   procedure Handle_Work_Offset (Pos : Grbl_Parser.Position);

end Handlers;
