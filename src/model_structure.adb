with Strings_Edit;
with Strings_Edit.Integers;

package body Model_Structure is

   function Image (Value : Real) return String
   is
      package SEI renames Strings_Edit.Integers;
      use Strings_Edit;
      Neg : constant Boolean := Value < 0.0;
      V : constant Real := (if Neg then -Value else Value);
   begin
      declare
         Int  : constant Integer := Integer (Real'Floor (V));
         Frac : constant Integer := Integer ((V - Real(Int)) * 1000.0);
         Img  : String (1 .. 8) := (others => '@');
         P : Natural;
      begin
         if Neg then
            Img (1) := '-';
         else
            Img (1) := ' ';
         end if;

         P := 2;
         SEI.Put (Img, P, Int, Field => 3, Justify => Right, Fill => ' ');
         Img (P) := '.';
         P := P + 1;
         SEI.Put (Img, P, Frac, Field => 3, Justify => Right, Fill => '0');

         return Img;
      end;
   end Image;

   ------------
   --  Position
   ------------

   function "+" (Left, Right : Position) return Position
   is
      Result : Position;
   begin
      for I in Result'Range loop
         Result (I) := Left (I) + Right (I);
      end loop;
      return Result;
   end "+";

   function "-" (Left, Right : Position) return Position
   is
      Result : Position;
   begin
      for I in Result'Range loop
         Result (I) := Left (I) - Right (I);
      end loop;
      return Result;
   end "-";

end Model_Structure;
