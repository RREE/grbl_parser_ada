with Interfaces;

package Grbl_Parser is

   subtype Axis_Range is Integer range 0 .. 7;

   Axis_Name : constant array (Axis_Range) of Character :=
     ('X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E');

   type Position is array (Axis_Range range <>) of Float;

   Max_Line_Length    : constant := 128;
   subtype Line_String_Range is Positive range 1 .. Max_Line_Length;

   procedure Parse_Line (Line : String);

   --
   --  communication to FluidNC
   --
   subtype Byte is Interfaces.Unsigned_8;

   type Put_Profile is access procedure (Data : Byte);
   Put : Put_Profile;
   Send_Realtime_Command : Put_Profile renames Put;

   type Get_Profile is access function return Byte;
   Get : Get_Profile;

   --
   --  callbacks
   --

   type Empty_Profile is access procedure;
   Handle_OK : Empty_Profile;

   type Handle_Single_String_Profile is access procedure (Data : String);
   Handle_State : Handle_Single_String_Profile;


   --  [MSG:   ]
   type Handle_Msg_Profile is access procedure (Command : String; Arg : String);
   Handle_Msg : Handle_Msg_Profile;

   type Handle_Alarm_Profile is access procedure (Code : Integer);
   Handle_Alarm : Handle_Alarm_Profile;

   Handle_Others : Handle_Single_String_Profile;

   type Handle_Feed_Spindle_Profile is access procedure (Feed : Natural; Spindle : Natural);
   Handle_Feed_Spindle : Handle_Feed_Spindle_Profile;

   type Handle_Position_Profile is access procedure (Pos : Position);
   Handle_Machine_Pos  : Handle_Position_Profile;
   Handle_Work_Offset  : Handle_Position_Profile;
   --  Handle_Offset        : Handle_Position_Profile;
end Grbl_Parser;
