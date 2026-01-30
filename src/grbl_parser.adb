with Ada.Strings.Maps;
--  with Grbl_Parser.Commands;
with Strings_Edit;
with Strings_Edit.Integers;
with Strings_Edit.Floats;
with Model_Structure;              use Model_Structure;

pragma Style_Checks ("-S"); --  permit code after "then"
pragma Style_Checks ("M130");

package body Grbl_Parser is

   --  search for character Search in the string Source starting at
   --  Pointer.  Pointer is advanced to the first (leftmost) occurence
   --  of Search.  If no such character is found, Pointer is
   --  Source'Last+1.
   procedure Index (Source : String;
                    Pointer : in out Natural;
                    Search : Character := ' ')
     with Pre => Pointer in Source'First .. Source'Last + 1;

   procedure Index (Source  : String;
                    Pointer : in out Natural;
                    Search  : Ada.Strings.Maps.Character_Set)
     with Pre => Pointer in Source'First .. Source'Last + 1;

   procedure Index (Source  : String;
                    Pointer : in out Natural;
                    Search  : Character := ' ')
   is
   begin
      while Pointer < Source'Last loop
         exit when Source (Pointer) = Search;
         Pointer := Pointer + 1;
      end loop;
   end Index;

   procedure Index (Source  : String;
                    Pointer : in out Natural;
                    Search  : Ada.Strings.Maps.Character_Set)
   is
      use Ada.Strings.Maps;
   begin
      while Pointer <= Source'Last loop
         exit when Is_In (Source (Pointer), Search);
         Pointer := Pointer + 1;
      end loop;
      null;
   end Index;

   package SEI renames Strings_Edit.Integers;

   ----------------
   -- Parse_Line --
   ----------------

   procedure Parse_Line (Line : String) is
      use Strings_Edit;

      Pos : Line_String_Range := Line'First;

      -----------------
      -- Parse_Error --
      -----------------

      procedure Parse_Error
      is
      begin
         --  skip everything up to end of line
         Pos := Line'Last + 1;
      end Parse_Error;

      --------------------
      -- Parse_Position --
      --------------------

      procedure Parse_Position (Into : out Position; Dim : out Axis_Range) is
         --  Start_Pos, Stop_Pos : T.Time;
      begin
         --  Start_Pos := T.Clock;
         --  The type Position is an array of floats. We don't know how many
         --  values GRBL returns. That is why we have to return the last index
         --  in Dim.
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

      -------------------------
      -- Parse_Machine_State --
      -------------------------

      procedure Parse_Machine_State is
      begin
         if Is_Prefix ("Idle", Line, Pos) then
            Pos := Pos + 4;
            if Handle_State /= null then Handle_State (Idle); end if;

         elsif Is_Prefix ("Run", Line, Pos) then
            Pos := Pos + 3;
            if Handle_State /= null then Handle_State (Run); end if;

         elsif Is_Prefix ("Jog", Line, Pos) then
            Pos := Pos + 3;
            if Handle_State /= null then Handle_State (Jog); end if;

         elsif Is_Prefix ("Hold", Line, Pos) then
            Pos := Pos + 4;
            if Handle_State /= null then Handle_State (Hold); end if;

         elsif Is_Prefix ("Door", Line, Pos) then
            Pos := Pos + 4;
            if Line (Pos) = ':' then
               Pos := Pos + 1;
               --  read integer
            end if;
            if Handle_State /= null then Handle_State (Door); end if;

         elsif Is_Prefix ("Alarm", Line, Pos) then
            Pos := Pos + 5;
            if Handle_State /= null then Handle_State (Alarm); end if;

         elsif Is_Prefix ("Check", Line, Pos) then
            Pos := Pos + 5;
            if Handle_State /= null then Handle_State (Check); end if;

         elsif Is_Prefix ("Homing", Line, Pos) then
            Pos := Pos + 6;
            if Handle_State /= null then Handle_State (Homing); end if;

         elsif Is_Prefix ("Sleep", Line, Pos) then
            Pos := Pos + 5;
            if Handle_State /= null then Handle_State (Sleep); end if;

         else
            Parse_Error;
         end if;

         --  case Line (Pos) is
         --  when 'I' =>
         --     Pos := Pos + 1;
         --     if Is_Prefix ("dle", Line, Pos) then
         --        if Handle_State /= null then Handle_State (Idle); end if;
         --        Pos := Pos + 3;
         --     else
         --        Parse_Error;
         --     end if;

         --  when 'A' =>
         --     Pos := Pos + 1;
         --     if Is_Prefix ("larm", Line, Pos) then
         --        if Handle_State /= null then Handle_State (Alarm); end if;
         --        Pos := Pos + 4;
         --     else
         --        Parse_Error;
         --     end if;

         --  when 'C' =>
         --     Pos := Pos + 1;
         --     if Is_Prefix ("dle", Line, Pos) then
         --        if Handle_State /= null then Handle_State (Idle); end if;
         --        Pos := Pos + 3;
         --     else
         --        Parse_Error;
         --     end if;

         --  when 'H' =>
         --     Pos := Pos + 1;
         --     if Is_Prefix ("oming", Line, Pos) then
         --        if Handle_State /= null then Handle_State (Homing); end if;
         --        Pos := Pos + 5;
         --     else
         --        Parse_Error;
         --     end if;

         --  when 'S' =>
         --     Pos := Pos + 1;
         --     if Is_Prefix ("dle", Line, Pos) then
         --        if Handle_State /= null then Handle_State (Idle); end if;
         --        Pos := Pos + 3;
         --     else
         --        Parse_Error;
         --     end if;

         --  when 'D' =>
         --     Pos := Pos + 1;
         --     if Is_Prefix ("oor", Line, Pos) then
         --        if Handle_State /= null then Handle_State (Door); end if;
         --        Pos := Pos + 3;
         --     else
         --        Parse_Error;
         --     end if;

         --  when 'J' =>
         --     Pos := Pos + 1;
         --     if Is_Prefix ("og", Line, Pos) then
         --        if Handle_State /= null then Handle_State (Jog); end if;
         --        Pos := Pos + 2;
         --     else
         --        Parse_Error;
         --     end if;

         --  when 'R' =>
         --     Pos := Pos + 1;
         --     if Is_Prefix ("un", Line, Pos) then
         --        if Handle_State /= null then Handle_State (Run); end if;
         --        Pos := Pos + 2;
         --     else
         --        Parse_Error;
         --     end if;

         --  when others =>
         --     Parse_Error;
         --  end case;
      end Parse_Machine_State;

      ------------------------------------
      -- Parse_Machine_Or_Work_Position --
      ------------------------------------

      procedure Parse_Machine_Or_Work_Position
      is
         type Reference is (Machine, Work);
         Ref : Reference;
      begin
         if Line (Pos) = 'M' then
            Ref := Machine;
         elsif Line (Pos) = 'W' then
            Ref := Work;
         else
            Parse_Error;
         end if;
         Pos := Pos + 1;

         if Is_Prefix ("Pos:", Line, Pos) then
            Pos := Pos + 4;
            declare
               P   : Position;
               Dim : Axis_Range;
            begin
               Parse_Position (P, Dim);

               if Ref = Machine and then Handle_Machine_Pos /= null then
                  Handle_Machine_Pos (P);
               end if;
               if Ref = Work and then Handle_Work_Pos /= null then
                  Handle_Work_Pos (P);
               end if;
            end;
         else
            Parse_Error;
         end if;
      end Parse_Machine_Or_Work_Position;

      ------------------------
      -- Parse_Work_Offsets --
      ------------------------

      procedure Parse_Work_Offsets is
         Offset_Name : Natural;
         Offset      : Position;
         Dim         : Axis_Range;
      begin
         --  initial '[G' is already parsed
         SEI.Get (Line, Pos, Offset_Name);
         Pos := Pos + 1; --  skip the ':'
         Parse_Position (Offset, Dim);
         if Handle_Indexed_Offset /= null then
            Handle_Indexed_Offset (Offset_Name, Offset);
         end if;

      end Parse_Work_Offsets;

      ------------------
      -- Parse_Status --
      ------------------

      procedure Parse_Status is
         Last : constant Line_String_Range := Line'Last; -- ??? ignore final '>'
      begin
         if Handle_Status_Start /= null then
            Handle_Status_Start.all;
         end if;

         --  the first field is always the machine state
         Parse_Machine_State;

         if Line (Pos) = '|' then
            Pos := Pos + 1;
         else
            Parse_Error;
         end if;

         --  the second field is always either machine position or work position
         Parse_Machine_Or_Work_Position;

         if Line (Pos) = '|' then
            Pos := Pos + 1;
         else
            Parse_Error;
         end if;

         --  the remaining fields may apear in any order
         Parse_Status_Line :
         loop
            exit Parse_Status_Line when Pos >= Last or else Line (Pos) = '>';

            if Line (Pos) = '|' then
               Pos := Pos + 1;
            end if;

            if Is_Prefix ("WCO:", Line, Pos) then
               declare
                  Dim : Axis_Range;
                  Work_Offset : Position;
               begin
                  Pos := Pos + 4;
                  Parse_Position (Work_Offset, Dim);
                  if Handle_Offset /= null then
                     Handle_Offset (Work_Offset);
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

            elsif Is_Prefix ("A:", Line, Pos) then
               declare
                  Spindle : Integer := 0;
                  Flood   : Boolean := False;
                  Mist    : Boolean := False;
               begin
                  Pos := Pos + 2;
                  loop
                     case Line (Pos) is
                     when 'S' => Spindle := 1;
                     when 'C' => Spindle := -1;
                     when 'F' => Flood := True;
                     when 'M' => Mist := True;
                     when others => exit;
                     end case;
                     Pos := Pos + 1;
                  end loop;

                  if Handle_Spindle_Coolant /= null then
                     Handle_Spindle_Coolant (Spindle, Flood, Mist);
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
               loop
                  exit when Line (Pos) = '|';
                  exit when Pos > Last;
                  Pos := Pos + 1;
               end loop;
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
      elsif Line (Line'First) = '<' then --  and then Line (Line'Last) = '>' then
         Pos := Pos + 1;
         Parse_Status;

         --  Work Offset (G54 .. G59, G92)
      elsif Is_Prefix ("[G", Line) then
         Pos := Pos + 2;
         Parse_Work_Offsets;

      --  Start-up
      elsif Is_Prefix ("Grbl ", Line) then
         null;

      --  Version
      elsif Is_Prefix ("[VER:", Line) and then Line (Line'Last) = ']' then
         declare
            subtype Version_Index is Positive range 6 .. Line'Last - 1;
            Version_Line : constant String := Line (Version_Index);

            --  Version_Line may contain a second version for FluidNC. Separator
            --  a blank ' '.
            GRBL_Start : Line_String_Range := Version_Index'First;
            GRBL_End   : Line_String_Range := Version_Index'First;
            FNC_Start  : Line_String_Range := Version_Index'First;
            FNC_End    : Line_String_Range := Version_Index'First;
            use Ada.Strings.Maps;
            Sep_Set : constant Character_Set := To_Set (' ' & ASCII.LF & ASCII.HT & ASCII.CR);
            FNC_End_Set : constant Character_Set := To_Set (" :" & ASCII.LF & ASCII.HT & ASCII.CR);
         begin
            Strings_Edit.Get (Line, GRBL_Start, ' ');  --  skip blanks
            GRBL_End := GRBL_Start;
            Index (Version_Line, GRBL_End, Sep_Set);  --  search separator
            GRBL_End  := GRBL_End - 1;
            FNC_Start := GRBL_End + 1;
            if Is_Prefix ("FluidNC ", Version_Line, FNC_Start) then
               FNC_Start := FNC_Start + 8;
               FNC_End   := FNC_Start;
               Index (Version_Line, FNC_End, FNC_End_Set);
               FNC_End   := FNC_End - 1;
            end if;

            if Handle_Version_Report /= null then
               Handle_Version_Report (S1 => Version_Line (GRBL_Start .. GRBL_End),
                                      S2 => Version_Line (FNC_Start .. FNC_End));
            end if;
         end;

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
            Strings_Edit.Get (Line, Start, ' ');  --  skip blanks
            Sep := Start;
            Index (Line, Sep, ':');  --  search colon, if none found, Sep is Msg'Last+1

            if Handle_Msg /= null then
               Handle_Msg (S1 => Msg(Start..Sep-1), S2 => Msg(Sep+1..Msg'Last));
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
