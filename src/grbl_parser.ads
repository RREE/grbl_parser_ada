package Grbl_Parser is

   type Position is record
      X : Float := 0.0;
      Y : Float := 0.0;
      Z : Float := 0.0;
   end record;

   type Machine_State is (Idle,
                          Run,
                          Hold,
                          Home,
                          Alarm,
                          Check,
                          Door,
                          Sleep,
                          Unknown);

   Max_Version_Length : constant := 32;
   Max_Message_Length : constant := 64;
   Max_Line_Length    : constant := 128;

   subtype Version_String_Range is Positive range 1 .. Max_Version_Length;
   subtype Message_String_Range is Positive range 1 .. Max_Message_Length;
   subtype Line_String_Range is Positive range 1 .. Max_Line_Length;

   type Parser_State is record
      Machine_Position : Position;
      Work_Position    : Position;
      State            : Machine_State;
      Version          : String (Version_String_Range);
      Version_Length   : Natural := 0;
      Alarm_Code       : Integer := 0;
      Message          : String (Message_String_Range);
      Message_Length   : Natural := 0;
      Line_Buffer      : String (Line_String_Range);
      Buf_Index        : Natural := 1;
   end record;

   procedure Init (State : out Parser_State);
   procedure Feed_Char (State : in out Parser_State; C : Character);
   procedure Parse_Line (State : in out Parser_State; Line : String);

end Grbl_Parser;
