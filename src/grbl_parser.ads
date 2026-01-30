pragma Style_Checks ("M130");

with Interfaces;
with Model_Structure;

package Grbl_Parser is

   --  type Offset_Mode is (G54, G55, G56, G57, G58, G59, G28, G30, G92);

   Max_Line_Length    : constant := 250;
   subtype Line_String_Range is Positive range 1 .. Max_Line_Length;

   procedure Parse_Line (Line : String);

   --
   --  communication to FluidNC
   --
   subtype Byte is Interfaces.Unsigned_8;

   type Put_Procedure is access procedure (Data : Byte);
   Put : Put_Procedure;
   Send_Realtime_Command : Put_Procedure renames Put;

   type Get_Procedure is access function return Byte;
   Get : Get_Procedure;

   --
   --  callbacks
   --
   type Empty_Profile is access procedure;
   type State_Profile is access procedure (State : Model_Structure.Machine_State);
   type Single_Natural_Profile is access procedure (Data : Natural);
   type Double_Natural_Profile is access procedure (Data1 : Natural; Data2 : Natural);
   type Triple_Natural_Profile is access procedure (Data1 : Natural; Data2 : Natural; Data3 : Natural);
   type Single_String_Profile is access procedure (S1 : String);
   type Double_String_Profile is access procedure (S1, S2 : String);
   type Spindle_Coolant_Profile is access procedure (Spindle : Integer;
                                                     Flood : Boolean; Mist : Boolean);
   type Index_Position_Profile is access procedure (Index : Natural; Pos : Model_Structure.Position);
   type Position_Profile is access procedure (Pos : Model_Structure.Position);

   Handle_OK             : Empty_Profile;
   Handle_State          : State_Profile;           --  state name
   Handle_Version_Report : Double_String_Profile;   --  GRBL version, FluidNC version
   Handle_Msg            : Double_String_Profile;   --  command, argument
   Handle_Alarm          : Single_Natural_Profile;  --  alarm code
   Handle_Error          : Single_Natural_Profile;  --  error code
   Handle_Linenum        : Single_Natural_Profile;  --  line number
   Handle_Others         : Single_String_Profile;   --  whatever
   Handle_Feed_Spindle   : Double_Natural_Profile;  --  feed rate, spindle speed
   Handle_Buffers        : Double_Natural_Profile;  --  Available, RX_Available
   Handle_Overrides      : Triple_Natural_Profile;  --  Feed ovr, rapid ovr, spindle ovr
   Handle_Signon         : Double_String_Profile;   --  GRBL startup message: version, extra
   Handle_Spindle_Coolant : Spindle_Coolant_Profile;  --  Spindle, Flood, Mist
   Handle_Machine_Pos    : Position_Profile;
   Handle_Work_Pos       : Position_Profile;
   Handle_Offset         : Position_Profile;
   Handle_Indexed_Offset : Index_Position_Profile;  --  work offsets

   Handle_Status_Start : Empty_Profile;
   Handle_Status_End   : Empty_Profile;

end Grbl_Parser;
