with Interfaces;

package Grbl_Parser is

   subtype Axis_Range is Integer range 0 .. 7;

   Axis_Name : constant array (Axis_Range) of Character :=
     ('X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E');

   subtype Real is Float;
   --  use decimal fixed point types if the hardware doen not support floating point types
   --  type Real is delta 10**-3 digits 7;  --  -9999.999 .. 9999.999;

   type Position is array (Axis_Range range <>) of Real;

   type Coordinate_System is
     (Machine, -- absolute machine coordinates, typically known after homing
      Work);   -- coordinates realtive to the last manual zero setting

   type Offset_Mode is (G54, G55, G56, G57, G58, G59, G28, G30, G92);

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
   type Triple_Natural_Profile is access procedure (Data1 : Natural; Data2 : Natural; Data3 : Natural);
   type Single_String_Profile is access procedure (S1 : String);
   type Double_String_Profile is access procedure (S1, S2 : String);
   type Position_Profile is access procedure (Pos : Position);

   Handle_OK : Empty_Profile;
   Handle_State : Single_String_Profile;          --  state name
   Handle_Version_Report : Double_String_Profile; --  GRBL version, FluidNC version
   Handle_Msg : Double_String_Profile;            --  command, argument
   Handle_Alarm : Single_Natural_Profile;         --  alarm code
   Handle_Error : Single_Natural_Profile;         --  error code
   Handle_Linenum : Single_Natural_Profile;       --  line number
   Handle_Others : Single_String_Profile;         --  whatever
   Handle_Feed_Spindle : Double_Natural_Profile;  --  feed rate, spindle speed
   Handle_Buffers : Double_Natural_Profile;       --  Available, RX_Available
   Handle_Overrides : Triple_Natural_Profile;     --  Feed ovr, rapid ovr, spindle ovr
   Handle_Signon : Double_String_Profile;         --  GRBL startup message: version, extra
   Handle_Machine_Pos  : Position_Profile;
   Handle_Work_Pos     : Position_Profile;
   Handle_Offset       : Position_Profile;

   Handle_Status_Start : Empty_Profile;
   Handle_Status_End : Empty_Profile;

end Grbl_Parser;
