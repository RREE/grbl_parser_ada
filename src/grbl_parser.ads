with Interfaces;

package Grbl_Parser is

   subtype Axis_Range is Integer range 0 .. 7;

   Axis_Name : constant array (Axis_Range) of Character :=
     ('X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E');

   subtype Real is Float;
   --  use decimal fixed point types if the hardware doen not support floating point types
   --  type Real is delta 10**-3 digits 7;  --  -9999.999 .. 9999.999;

   type Position is array (Axis_Range range <>) of Real;

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
   type Single_Natural_Profile is access procedure (Data : Natural);
   type Double_Natural_Profile is access procedure (Data1 : Natural; Data2 : Natural);
   type Single_String_Profile is access procedure (S1 : String);
   type Double_String_Profile is access procedure (S1, S2 : String);
   Handle_OK : Empty_Profile;

   Handle_State : Single_String_Profile;

   --  type Handle_Msg_Profile is access procedure (Command : String; Arg : String);
   Handle_Msg : Double_String_Profile;

   --  type Handle_Alarm_Profile is access procedure (Code : Natural);
   Handle_Alarm : Single_Natural_Profile;

   --  type Handle_Linenum_Profile is access procedure (Line : Natural);
   Handle_Linenum : Single_Natural_Profile;

   Handle_Others : Single_String_Profile;

   --  type Handle_Feed_Spindle_Profile is access procedure (Feed : Natural; Spindle : Natural);
   Handle_Feed_Spindle : Double_Natural_Profile;

   type Position_Profile is access procedure (Pos : Position);
   Handle_Machine_Pos  : Position_Profile;
   Handle_Work_Pos     : Position_Profile;
   Handle_Offset       : Position_Profile;

end Grbl_Parser;
