with Strings_Edit;
-- with Ada.Text_IO;

package body Grbl_Parser is

   procedure Init (State : out Parser_State) is
   begin
      State.Machine_Position := (others => 0.0);
      State.Work_Position := (others => 0.0);
      State.State := Unknown;
      State.Buf_Index := 1;
      State.Version_Length := 0;
      State.Message_Length := 0;
      State.Alarm_Code := 0;
   end Init;

   procedure Feed_Char (State : in out Parser_State; C : Character) is
   begin
      if C = ASCII.LF or else C = ASCII.CR then
         if State.Buf_Index > 1 then
            Parse_Line (State, State.Line_Buffer (1 .. State.Buf_Index - 1));
         end if;
         State.Buf_Index := 1;
      elsif State.Buf_Index <= State.Line_Buffer'Last then
         State.Line_Buffer (State.Buf_Index) := C;
         State.Buf_Index := State.Buf_Index + 1;
      end if;
   end Feed_Char;

   function Parse_Float (S : String) return Float is
      F : Float;
   begin
      --  Float_Text_IO.Get (S, F, Last => others);
      return F;
   exception
      when others => return 0.0;
   end Parse_Float;

   procedure Parse_Line (State : in out Parser_State; Line : String) is
      function Is_Prefix (Prefix : String; Line : String) return Boolean is
      begin
         return Line'Length >= Prefix'Length
                and then
                Line (Line'First .. Line'First + Prefix'Length - 1) = Prefix;
      end Is_Prefix;

      function Slice_After (Prefix : String; Line : String) return String is
      begin
         return Line (Line'First + Prefix'Length .. Line'Last);
      end Slice_After;

      L : constant String := Line;
      Pos : Line_String_Range := L'First;

      function Next_Token return String is
         Start : constant Line_String_Range := Pos;
      begin
         while Pos <= L'Last and then L (Pos) /= '|' loop
            Pos := Pos + 1;
         end loop;
         declare
            Tok : String := L (Start .. Pos - 1);
         begin
            if Pos <= L'Last and then L (Pos) = '|' then
               Pos := Pos + 1;
            end if;
            return Tok;
         end;
      end Next_Token;

      procedure Parse_Position (Label : String; Into : out Position) is
         P : String := Label;
         Sep1, Sep2 : Natural;
      begin
         --  ???  Sep1 := Index (P, ',');
         --  ???  Sep2 := Index (P, ',', Sep1 + 1);
         if Sep1 > 0 and then Sep2 > 0 then
            Into.X := Parse_Float (P (1 .. Sep1 - 1));
            Into.Y := Parse_Float (P (Sep1 + 1 .. Sep2 - 1));
            Into.Z := Parse_Float (P (Sep2 + 1 .. P'Last));
         end if;
      end Parse_Position;

   begin
      if L (L'First) = '<' and then L (L'Last) = '>' then
         declare
            Inner : String := L (L'First + 1 .. L'Last - 1);
         begin
            Pos := Inner'First;
            loop
               exit when Pos > Inner'Last;
               declare
                  Tok : constant String := Next_Token;
                  Tok_F : constant Natural := Tok'First;
               begin
                  if Tok = "Idle" then
                     State.State := Idle;
                  elsif Tok = "Run" then
                     State.State := Run;
                  elsif Tok = "Hold" then
                     State.State := Hold;
                  elsif Tok = "Alarm" then
                     State.State := Alarm;
                  elsif Tok = "Check" then
                     State.State := Check;
                  elsif Tok = "Home" then
                     State.State := Home;
                  elsif Tok = "Sleep" then
                     State.State := Sleep;
                  elsif Tok'Length > 5 and then Tok (Tok_F .. Tok_F+4) = "MPos:" then
                     Parse_Position (Tok (Tok_F+5 .. Tok'Last), State.Machine_Position);
                  elsif Tok'Length > 5 and then Tok (Tok_F .. Tok_F+4) = "WPos:" then
                     Parse_Position (Tok (Tok_F+5 .. Tok'Last), State.Work_Position);
                  end if;
               end;
            end loop;
         end;
      elsif Is_Prefix ("Grbl ", L) then
         State.Version_Length := L'Length;
         State.Version (1 .. State.Version_Length) := L;
      elsif Is_Prefix ("[MSG:", L) and then L (L'Last) = ']' then
         declare
            Msg : constant String := L (6 .. L'Last - 1);
         begin
            State.Message_Length := Msg'Length;
            State.Message (1 .. Msg'Length) := Msg;
         end;
      elsif Is_Prefix ("ALARM:", L) then
         declare
            Code : constant String := Slice_After ("ALARM:", L);
         begin
            State.Alarm_Code := Integer'Value (Code);
         exception
            when others => State.Alarm_Code := -1;
         end;
      end if;
   end Parse_Line;

end Grbl_Parser;
