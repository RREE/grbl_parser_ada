with Strings_Edit;
with Strings_Edit.Integers;
with Strings_Edit.Floats;
with Ada.Text_IO;  use Ada.Text_IO;

pragma Style_Checks ("-S"); --  permit code after "then"

package body Grbl_Parser is

   package SEI renames Strings_Edit.Integers;

   Work_Offset : Position (0 .. 5) := (others => 0.0);
   --  has to be remembered across multiple calls to Parse_Status

   procedure Parse_Line (Line : String) is
      use Strings_Edit;

      Pos : Line_String_Range := Line'First;

      procedure Parse_Position (Into : out Position; Dim : out Axis_Range) is
      begin
         for Axis in Into'Range loop
            Strings_Edit.Floats.Get (Line, Pos, Into (Axis));
            if Line (Pos) = ',' then  --  skip ','
               Pos := Pos + 1;
            else
               Dim := Axis;
               exit;
            end if;
         end loop;
      end Parse_Position;

      procedure Parse_Status is
         Last : constant Line_String_Range := Line'Last - 1;
      begin
         if Handle_Status_Start /= null then
            Handle_Status_Start.all;
         end if;

         Parse_Status_Line:
         loop
            exit Parse_Status_Line when Pos >= Line'Last - 1;

            if Line (Pos) = '|' then
               Pos := Pos + 1;
            end if;

            if Is_Prefix ("Idle", Line, Pos) then
               if Handle_State /= null then Handle_State ("Idle"); end if;
               Pos := Pos + 4;

            elsif Is_Prefix ("Run", Line, Pos) then
               if Handle_State /= null then Handle_State ("Run"); end if;
               Pos := Pos + 3;

            elsif Is_Prefix ("Hold", Line, Pos) then
               if Handle_State /= null then Handle_State ("Hold"); end if;
               Pos := Pos + 4;

            elsif Is_Prefix ("Door", Line, Pos) then
               if Handle_State /= null then Handle_State ("Door"); end if;
               Pos := Pos + 4;

            elsif Is_Prefix ("Alarm", Line, Pos) then
               if Handle_State /= null then Handle_State ("Alarm"); end if;
               Pos := Pos + 5;

            elsif Is_Prefix ("Check", Line, Pos) then
               if Handle_State /= null then Handle_State ("Check"); end if;
               Pos := Pos + 5;

            elsif Is_Prefix ("Homing", Line, Pos) then
               if Handle_State /= null then Handle_State ("Homing"); end if;
               Pos := Pos + 4;

            elsif Is_Prefix ("Sleep", Line, Pos) then
               if Handle_State /= null then Handle_State ("Sleep"); end if;
               Pos := Pos + 5;

            elsif Is_Prefix ("MPos:", Line, Pos) then
               declare
                  Machine_Position : Position (0 .. 5);
                  Dim : Axis_Range;
               begin
                  Pos := Pos + 5;
                  Parse_Position (Machine_Position, Dim);
                  if Handle_Machine_Pos /= null then
                     Handle_Machine_Pos (Machine_Position (0 .. Dim));
                  end if;
               end;

            elsif Is_Prefix ("WPos:", Line, Pos) then
               declare
                  Work_Position : Position (0 .. 5);
                  Dim : Axis_Range;
               begin
                  Pos := Pos + 5;
                  Parse_Position (Work_Position, Dim);
                  if Handle_Work_Pos /= null then
                     Handle_Work_Pos (Work_Position (0 .. Dim));
                  end if;
               end;

            elsif Is_Prefix ("WCO:", Line, Pos) then
               declare
                  Dim : Axis_Range;
               begin
                  Pos := Pos + 5;
                  Parse_Position (Work_Offset, Dim);
                  if Handle_Offset /= null then
                     Handle_Offset (Work_Offset (0 .. Dim));
                  end if;
               end;

            elsif Is_Prefix ("Ov:", Line, Pos) then
               declare
                  Feed_Ovr : Natural;
                  Rapid_Ovr : Natural;
                  Spindle_Ovr : Natural;
               begin
                  Pos := Pos + 3;
                  SEI.Get (Line, Pos, Feed_Ovr);
                  if Line (Pos) = ',' then Pos := Pos + 1; end if;
                  SEI.Get (Line, Pos, Rapid_Ovr);
                  if Line (Pos) = ',' then Pos := Pos + 1; end if;
                  SEI.Get (Line, Pos, Spindle_Ovr);

                  if Handle_Overrides /= null then
                     Handle_Overrides (Feed_Ovr, Rapid_Ovr, Spindle_Ovr);
                  end if;
               end;

            elsif Is_Prefix ("FS:", Line, Pos) then
               declare
                  Feedrate : Natural;
                  Spindlespeed : Natural;
               begin
                  Pos := Pos + 3;
                  SEI.Get (Line, Pos, Feedrate);
                  if Line (Pos) = ',' then Pos := Pos + 1; end if;
                  SEI.Get (Line, Pos, Spindlespeed);

                  if Handle_Feed_Spindle /= null then
                     Handle_Feed_Spindle (Feedrate, Spindlespeed);
                  end if;
               end;

            elsif Is_Prefix ("Bf:", Line, Pos) then
               declare
                  Available : Natural;
                  Rx_Available : Natural;
               begin
                  Pos := Pos + 3;
                  SEI.Get (Line, Pos, Available);
                  if Line (Pos) = ',' then Pos := Pos + 1; end if;
                  SEI.Get (Line, Pos, Rx_Available);

                  if Handle_Buffers /= null then
                     Handle_Buffers (Available, Rx_Available);
                  end if;
               end;

            elsif Is_Prefix ("Ln:", Line, Pos) then
               declare
                  Line_Number : Natural;
               begin
                  Pos := Pos + 3;
                  SEI.Get (Line, Pos, Line_Number);

                  if Handle_Linenum /= null then
                     Handle_Linenum (Line_Number);
                  end if;
               end;

            else
               declare
                  U : constant Line_String_Range := Pos;
               begin
                  loop
                     exit when Line (Pos) = '|';
                     exit when Pos > Last;
                     Pos := Pos + 1;
                  end loop;
                  Put_Line ("unknown:" & Line (U .. Pos));
               end;
            end if;
         end loop Parse_Status_Line;

         if Handle_Status_End /= null then
            Handle_Status_End.all;
         end if;
      end Parse_Status;

   begin
      --  ignore empty lines
      if Line'Length = 0 then
         null;

      --  "ok"
      elsif Is_Prefix ("ok", Line, Pos) then
         if Handle_OK /= null then
            Handle_OK.all;
         end if;

      --  Status report
      elsif Line (Line'First) = '<' and then Line (Line'Last) = '>' then
         Pos := Pos + 1;
         Parse_Status;

      --  Start-up
      elsif Is_Prefix ("Grbl ", Line) then
         null;

      --  Message
      elsif Is_Prefix ("[MSG:", Line) and then Line (Line'Last) = ']' then
         declare
            subtype Msg_Index is Positive range 6 .. Line'Last - 1;
            Msg : constant String := Line (Msg_Index);

            --  Msg may contain a command with arguments. Separator
            --  after the command is a colon ':'.
            Sep : Line_String_Range;
            Start : Line_String_Range := Msg_Index'First;
         begin
            Put_Line ("MESSAGE:'" & Msg & ''');
            Strings_Edit.Get (Line, Start, ' ');  --  skip blanks
            Sep := Start;
            Index (Line, Sep, ':');  --  search colon, if none found, Sep is Msg'Last+1
            Put_Line ("Start:" & Start'Image & ", Sep:" & Sep'Image & ", " & "Last:" & Msg'Last'Image);
            if Handle_Msg /= null then
               Handle_Msg (S1 => Msg(Start .. Sep-1), S2 => Msg(Sep+1 .. Msg'Last));
            end if;
         end;

      --  Alarm
      elsif Is_Prefix ("ALARM:", Line) then
         declare
            Alarm_Code : Integer;
         begin
            Pos := Pos + 6;
            SEI.Get (Line, Pos, Alarm_Code);
            if Handle_Alarm /= null then
               Handle_Alarm (Alarm_Code);
            end if;
         end;

      elsif Is_Prefix ("error:", Line) then
         declare
            Error_Code : Integer;
         begin
            Pos := Pos + 6;
            SEI.Get (Line, Pos, Error_Code);
            if Handle_Error /= null then
               Handle_Error (Error_Code);
            end if;
         end;

      --  everything else
      else
         if Handle_Others /= null then
            Handle_Others (Line);
         end if;
      end if;
   end Parse_Line;

end Grbl_Parser;
