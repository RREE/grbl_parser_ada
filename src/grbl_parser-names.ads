pragma Style_Checks ("M120");
pragma Style_Checks ("T"); -- don't check token spacing
pragma Style_Checks ("U"); -- don't check unnecessary blan lines

package Grbl_Parser.Names is

   type String_Access is access constant String;

   Al_00 : aliased constant String := "Unknown";
   Al_01 : aliased constant String := "Hard Limit";
   Al_02 : aliased constant String := "Soft Limit";
   Al_03 : aliased constant String := "Abort Cycle";
   Al_04 : aliased constant String := "Probe Fail Initial";
   Al_05 : aliased constant String := "Probe Fail Contact";
   Al_06 : aliased constant String := "Homing Fail Reset";
   Al_07 : aliased constant String := "Homing Fail Door";
   Al_08 : aliased constant String := "Homing Fail Pulloff";
   Al_09 : aliased constant String := "Homing Fail Approach";
   Al_10 : aliased constant String := "Spindle Control";
   Al_11 : aliased constant String := "Control Pin Initially On";
   Al_12 : aliased constant String := "Ambiguous Switch";
   Al_13 : aliased constant String := "Hard Stop";
   Al_14 : aliased constant String := "Unhomed";
   Al_15 : aliased constant String := "Init";

   Alarm_Name : constant array (0 .. 15) of String_Access :=
     ( 0 => Al_00'Access,
       1 => Al_01'Access,
       2 => Al_02'Access,
       3 => Al_03'Access,
       4 => Al_04'Access,
       5 => Al_05'Access,
       6 => Al_06'Access,
       7 => Al_07'Access,
       8 => Al_08'Access,
       9 => Al_09'Access,
      10 => Al_10'Access,
      11 => Al_11'Access,
      12 => Al_12'Access,
      13 => Al_13'Access,
      14 => Al_14'Access,
      15 => Al_15'Access);

end Grbl_Parser.Names;
