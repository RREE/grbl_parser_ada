with Model_Structure;

package Handlers is

   procedure Handle_State (State : Model_Structure.Machine_State);
   procedure Handle_Others (Unknown : String);
   procedure Handle_Message (Command : String; Arg : String);
   procedure Handle_Version_Report (Grbl_Version : String; FluidNC_Version : String);
   procedure Handle_Alarm (Code : Natural);
   procedure Handle_OK;
   procedure Handle_Feed_Spindle (Feedrate : Natural; Spindlespeed : Natural);
   procedure Handle_Machine_Pos (Pos : Model_Structure.Position);
   procedure Handle_Work_Pos (Pos : Model_Structure.Position);
   procedure Handle_Offset (Pos : Model_Structure.Position);
   procedure Handle_Spindle_Coolant (Spindle : Integer;
                                     Flood : Boolean; Mist : Boolean);

end Handlers;
