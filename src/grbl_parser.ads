package Grbl_Parser is

   subtype Axis_Range is Integer range 0 .. 7;

   Axis_Name : constant array (Axis_Range) of Character :=
     ('X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E');

   type Position is array (Axis_Range range <>) of Float;

   type Machine_State is (Idle,
                          Alarm,
                          Check,
                          Homing,
                          Run,
                          Jog,
                          Hold,
                          Door,
                          Sleep,
                          Unknown);

   Max_Line_Length    : constant := 128;

   subtype Line_String_Range is Positive range 1 .. Max_Line_Length;

   procedure Parse_Line (Line : String);

   --
   --  callbacks
   --

   --  [MSG:   ]
   type Handle_Msg_Profile is access procedure (Command : String; Arg : String);
   Handle_Msg : Handle_Msg_Profile;

   type Handle_Alarm_Profile is access procedure (Code : Integer);
   Handle_Alarm : Handle_Alarm_Profile;

   type Handle_Others_Profile is access procedure (Other : String);
   Handle_Others : Handle_Others_Profile;

   type Handle_Position_Profile is access procedure (Pos : Position);
   Handle_Machine_Position : Handle_Position_Profile;
   Handle_Work_Position    : Handle_Position_Profile;
end Grbl_Parser;
