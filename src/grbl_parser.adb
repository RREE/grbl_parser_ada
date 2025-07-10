with Strings_Edit;
with Strings_Edit.Integers;
with Strings_Edit.Floats;
with Ada.Text_IO;  use Ada.Text_IO;


package body Grbl_Parser is

   procedure Init (S : out Parser_State) is
   begin
      S.Machine_Position := (others => 0.0);
      S.Work_Position := (others => 0.0);
      S.State := Unknown;
      S.Buf_Index := 1;
      S.Version_Length := 0;
      S.Message_Length := 0;
      S.Alarm_Code := 0;
   end Init;

   procedure Feed_Char (S : in out Parser_State; C : Character) is
   begin
      if C = ASCII.LF or else C = ASCII.CR then
         if S.Buf_Index > 1 then
            Parse_Line (S, S.Line_Buffer (1 .. S.Buf_Index - 1));
         end if;
         S.Buf_Index := 1;
      elsif S.Buf_Index <= S.Line_Buffer'Last then
         S.Line_Buffer (S.Buf_Index) := C;
         S.Buf_Index := S.Buf_Index + 1;
      end if;
   end Feed_Char;

   procedure Parse_Line (S : in out Parser_State; Line : String) is
      use Strings_Edit;

      Pos : Line_String_Range := Line'First;

      procedure Parse_Position (Into : out Position) is
         use Strings_Edit.Floats;
      begin
         Get (Line, Pos, Into.X);
         Pos := Pos + 1; --  skip ','
         Get (Line, Pos, Into.Y);
         Pos := Pos + 1; --  skip ','
         Get (Line, Pos, Into.Z);
      end Parse_Position;

   begin
      Put_Line (Line);
      Put_Line ("line length:" & Line'Length'Image);
      if Line (Line'First) = '<' and then Line (Line'Last) = '>' then
         Pos := Pos + 1;
         loop
            Put_Line ("pos:" & Pos'Image);
            exit when Pos >= Line'Last - 1;

            if Line (Pos) = '|' then
               Pos := Pos + 1;
            end if;

            if Is_Prefix ("Idle", Line, Pos) then
               S.State := Idle;
               Pos := Pos + 4;
            elsif Is_Prefix ("Run", Line, Pos) then
               S.State := Run;
               Pos := Pos + 3;
            elsif Is_Prefix ("Hold", Line, Pos) then
               S.State := Hold;
               Pos := Pos + 4;
            elsif Is_Prefix ("Alarm", Line, Pos) then
               S.State := Alarm;
               Pos := Pos + 5;
            elsif Is_Prefix ("Check", Line, Pos) then
               S.State := Check;
               Pos := Pos + 5;
            elsif Is_Prefix ("Home", Line, Pos) then
               S.State := Home;
               Pos := Pos + 4;
            elsif Is_Prefix ("Sleep", Line, Pos) then
               S.State := Sleep;
               Pos := Pos + 5;
            elsif Is_Prefix ("MPos:", Line, Pos) then
               Pos := Pos + 5;
               Parse_Position (S.Machine_Position);
            elsif Is_Prefix ("WPos:", Line, Pos) then
               Pos := Pos + 5;
               Parse_Position (S.Work_Position);
            end if;
         end loop;
      elsif Is_Prefix ("Grbl ", Line) then
         S.Version_Length := Line'Length;
         S.Version (1 .. S.Version_Length) := Line;
      elsif Is_Prefix ("[MSG:", Line) and then Line (Line'Last) = ']' then
         declare
            Msg : constant String := Line (6 .. Line'Last - 1);
         begin
            S.Message_Length := Msg'Length;
            S.Message (1 .. Msg'Length) := Msg;
         end;
      elsif Is_Prefix ("ALARM:", Line) then
         Pos := Pos + 6;
         Strings_Edit.Integers.Get (Line, Pos, S.Alarm_Code);
      end if;
   end Parse_Line;

end Grbl_Parser;
