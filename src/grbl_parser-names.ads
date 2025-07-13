pragma Style_Checks ("M120");
pragma Style_Checks ("-t"); -- don't check token spacing
pragma Style_Checks ("-u"); -- don't check unnecessary blank lines

package Grbl_Parser.Names is

   type String_Access is access constant String;

   --
   --  Alarm names
   --

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
     (0 => Al_00'Access,
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

   --
   --  Error descriptions
   --

   Err_0 : aliased constant String := "No error";
   Err_1 : aliased constant String := "Expected GCodecommand letter";
   Err_2 : aliased constant String := "Bad GCode number format";
   Err_3 : aliased constant String := "Invalid $ statement";
   Err_4 : aliased constant String := "Negative value";
   Err_5 : aliased constant String := "Setting disabled";
   Err_6 : aliased constant String := "Step pulse too short";
   Err_7 : aliased constant String := "Failed to read settings";
   Err_8 : aliased constant String := "Command requires idle state";
   Err_9 : aliased constant String := "GCode cannot be executed in lock or alarm state";
   Err_10 : aliased constant String := "Soft limit error";
   Err_11 : aliased constant String := "Line too long";
   Err_12 : aliased constant String := "Max step rate exceeded";
   Err_13 : aliased constant String := "Check door";
   Err_14 : aliased constant String := "Startup line too long";
   Err_15 : aliased constant String := "Max travel exceeded during jog";
   Err_16 : aliased constant String := "Invalid jog command";
   Err_17 : aliased constant String := "Laser mode requires PWM output";
   Err_18 : aliased constant String := "No Homing/Cycle defined in settings";
   Err_19 : aliased constant String := "Single axis homing not allowed";
   Err_20 : aliased constant String := "Unsupported GCode command";
   Err_21 : aliased constant String := "Gcode modal group violation";
   Err_22 : aliased constant String := "Gcode undefined feed rate";
   Err_23 : aliased constant String := "Gcode command value not integer";
   Err_24 : aliased constant String := "Gcode axis command conflict";
   Err_25 : aliased constant String := "Gcode word repeated";
   Err_26 : aliased constant String := "Gcode no axis words";
   Err_27 : aliased constant String := "Gcode invalid line number";
   Err_28 : aliased constant String := "Gcode value word missing";
   Err_29 : aliased constant String := "Gcode unsupported coordinate system";
   Err_30 : aliased constant String := "Gcode G53 invalid motion mode";
   Err_31 : aliased constant String := "Gcode extra axis words";
   Err_32 : aliased constant String := "Gcode no axis words in plane";
   Err_33 : aliased constant String := "Gcode invalid target";
   Err_34 : aliased constant String := "Gcode arc radius error";
   Err_35 : aliased constant String := "Gcode no offsets in plane";
   Err_36 : aliased constant String := "Gcode unused words";
   Err_37 : aliased constant String := "Gcode G43 dynamic axis error";
   Err_38 : aliased constant String := "Gcode max value exceeded";
   Err_39 : aliased constant String := "P param max exceeded";
   Err_40 : aliased constant String := "Check control pins";

   Error_Description : constant array (0 .. 40) of String_Access :=
     (0 => Err_0'Access,
      1 => Err_1'Access,
      2 => Err_2'Access,
      3 => Err_3'Access,
      4 => Err_4'Access,
      5 => Err_5'Access,
      6 => Err_6'Access,
      7 => Err_7'Access,
      8 => Err_8'Access,
      9 => Err_9'Access,
      10 => Err_10'Access,
      11 => Err_11'Access,
      12 => Err_12'Access,
      13 => Err_13'Access,
      14 => Err_14'Access,
      15 => Err_15'Access,
      16 => Err_16'Access,
      17 => Err_17'Access,
      18 => Err_18'Access,
      19 => Err_19'Access,
      20 => Err_20'Access,
      21 => Err_21'Access,
      22 => Err_22'Access,
      23 => Err_23'Access,
      24 => Err_24'Access,
      25 => Err_25'Access,
      26 => Err_26'Access,
      27 => Err_27'Access,
      28 => Err_28'Access,
      29 => Err_29'Access,
      30 => Err_30'Access,
      31 => Err_31'Access,
      32 => Err_32'Access,
      33 => Err_33'Access,
      34 => Err_34'Access,
      35 => Err_35'Access,
      36 => Err_36'Access,
      37 => Err_37'Access,
      38 => Err_38'Access,
      39 => Err_39'Access,
      40 => Err_40'Access);

end Grbl_Parser.Names;
