with Grbl_Parser.Names;
with Ada.Text_IO;     use Ada.Text_IO;

package body Handlers is

   procedure Handle_OK
   is begin
      Put_Line ("ok");
   end Handle_OK;

   procedure Handle_State (State : String)
   is begin
      Put_Line ("System is in state '" & State & ''');
   end Handle_State;

   procedure Handle_Others (Unknown : String)
   is begin
      Put_Line ("Unknown field '" & Unknown & ''');
   end Handle_Others;

   procedure Handle_Message (Command : String; Arg : String)
   is begin
      Put_Line ("Message received, Command: '" & Command & "', Arg: '" & Arg & ''');
   end Handle_Message;

   procedure Handle_Version_Report (Grbl_Version : String; FluidNC_Version : String)
   is begin
      Put_Line ("Grbl version: '" & Grbl_Version & "', FluidNC version: '" & FluidNC_Version & ''');
   end Handle_Version_Report;

   procedure Handle_Alarm (Code : Natural)
   is
      use Grbl_Parser.Names;
   begin
      Put ("Alarm received, ");
      if Code in 0 .. 15 then
         Put_Line (Alarm_Name (Code).all);
      else
         Put_Line (Alarm_Name (0).all);
      end if;
   end Handle_Alarm;

   procedure Handle_Feed_Spindle (Feedrate : Natural; Spindlespeed : Natural)
   is
   begin
      Put_Line ("Feedrate:" & Feedrate'Image);
      Put_Line ("Spindlespeed:" & Spindlespeed'Image);
   end Handle_Feed_Spindle;

   procedure Handle_Machine_Pos (Pos : Grbl_Parser.Position)
   is
      use Grbl_Parser;
   begin
      for P in Pos'Range loop
         Put_Line ("Pos " & Axis_Name (P) & ": " & Pos (P)'Image);
      end loop;
   end Handle_Machine_Pos;

   procedure Handle_Work_Pos (Pos : Grbl_Parser.Position)
   is
      use Grbl_Parser;
   begin
      for P in Pos'Range loop
         Put_Line ("Work position " & Axis_Name (P) & ": " & Pos (P)'Image);
      end loop;
   end Handle_Work_Pos;

   procedure Handle_Offset (Pos : Grbl_Parser.Position)
   is
      use Grbl_Parser;
   begin
      for P in Pos'Range loop
         Put_Line ("Offset " & Axis_Name (P) & ": " & Pos (P)'Image);
      end loop;
   end Handle_Offset;

   procedure Handle_Spindle_Coolant (Spindle : Grbl_Parser.Spindle_Direction;
                                     Flood : Boolean; Mist : Boolean)
   is
   begin
      Put_Line ("Spindle: " & Spindle'Image &
                ", Flood: " & (if Flood then "On" else "Off") &
                ", Mist: " & (if Mist then "On" else "Off"));
   end Handle_Spindle_Coolant;

end Handlers;
