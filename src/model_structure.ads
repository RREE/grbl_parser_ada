package Model_Structure is

   subtype Max_Axis_Range is Integer range 0 .. 7;
   subtype Axis_Range is Max_Axis_Range range 0 .. 3;

   Axis_Name : constant array (Max_Axis_Range) of Character :=
     ('X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E');

   subtype Real is Float range -9999.999 .. 9999.999;
   --  use decimal fixed point types if the hardware does not support floating point types
   --  type Real is delta 10**-3 digits 7;  --  results in the same range
   function Image (Value : Real) return String;

   type Position is array (Axis_Range) of Real;
   Null_Position : constant Position := (others => 0.0);
   function "+" (Left, Right : Position) return Position
     with Pre => Left'Length = Right'Length;
   function "-" (Left, Right : Position) return Position
     with Pre => Left'Length = Right'Length;

   type Coordinate_System is
     (Machine, -- absolute machine coordinates, typically known after homing
      Work);   -- coordinates realtive to the last manual zero setting

   subtype Offset_Slot_Index is Integer range 0 .. 9;
   type Offsets is array (Offset_Slot_Index) of Position;

   type Machine_State is (Idle, Run, Jog, Hold, Door, Alarm, Check, Homing, Sleep);

   type Spindle_Direction is (Off, CW, CCW);
   subtype Spindle_Speed_Range is Integer range -20000 .. 20000;

   type Device_State is (Off, On); --  mist, vacuum, light, etc.

end Model_Structure;
