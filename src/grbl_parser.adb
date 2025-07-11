with Strings_Edit;
with Strings_Edit.Integers;
with Strings_Edit.Floats;
with Ada.Text_IO;  use Ada.Text_IO;

package body Grbl_Parser is

   procedure Parse_Line (Line : String) is
      use Strings_Edit;

      Pos : Line_String_Range := Line'First;

      procedure Parse_Position (Into : out Position) is
         use Strings_Edit.Floats;
      begin
         for Axis in Into'Range loop
            Get (Line, Pos, Into (Axis));
            if Line (Pos) = ',' then  --  skip ','
               Pos := Pos + 1;
            else
               exit;
            end if;
         end loop;
      end Parse_Position;

   begin
      --  Status report
      if Line (Line'First) = '<' and then Line (Line'Last) = '>' then
         Pos := Pos + 1;
         loop
            Put_Line ("pos:" & Pos'Image);
            exit when Pos >= Line'Last - 1;

            if Line (Pos) = '|' then
               Pos := Pos + 1;
            end if;

            if Is_Prefix ("Idle", Line, Pos) then
               --  S.State := Idle;
               Pos := Pos + 4;
            elsif Is_Prefix ("Run", Line, Pos) then
               --  S.State := Run;
               Pos := Pos + 3;
            elsif Is_Prefix ("Hold", Line, Pos) then
               --  S.State := Hold;
               Pos := Pos + 4;
            elsif Is_Prefix ("Door", Line, Pos) then
               --  S.State := Door;
               Pos := Pos + 4;
            elsif Is_Prefix ("Alarm", Line, Pos) then
               --  S.State := Alarm;
               Pos := Pos + 5;
            elsif Is_Prefix ("Check", Line, Pos) then
               --  S.State := Check;
               Pos := Pos + 5;
            elsif Is_Prefix ("Homing", Line, Pos) then
               --  S.State := Homing;
               Pos := Pos + 4;
            elsif Is_Prefix ("Sleep", Line, Pos) then
               --  S.State := Sleep;
               Pos := Pos + 5;

            elsif Is_Prefix ("MPos:", Line, Pos) then
               declare
                  Machine_Position : Position (0 .. 5);
               begin
                  Pos := Pos + 5;
                  Parse_Position (Machine_Position);
                  if Handle_Machine_Position /= null then
                     Handle_Machine_Position (Machine_Position);
                  end if;
               end;

            elsif Is_Prefix ("WPos:", Line, Pos) then
               declare
                  Work_Position : Position (0 .. 5);
               begin
                  Pos := Pos + 5;
                  Parse_Position (Work_Position);
                  if Handle_Work_Position /= null then
                     Handle_Work_Position (Work_Position);
                  end if;
               end;

            end if;
         end loop;

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
            Sep : Line_String_Range := Msg_Index'Last;
         begin
            for I in Msg'Range loop
               if Msg(I) = ':' then
                  Sep := I;
                  exit;
               end if;
            end loop;
            if Handle_Msg /= null then
               Handle_Msg (Command => Msg(6 .. Sep-1), Arg => Msg(Sep+1 .. Msg'Last));
            end if;
         end;

      --  Alarm
      elsif Is_Prefix ("ALARM:", Line) then
         declare
            Alarm_Code : Integer;
         begin
            Pos := Pos + 6;
            Strings_Edit.Integers.Get (Line, Pos, Alarm_Code);
            if Handle_Alarm /= null then
               Handle_Alarm (Alarm_Code);
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
