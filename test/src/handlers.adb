with Grbl_Parser.Names;
with Ada.Text_IO;     use Ada.Text_IO;

package body Handlers is

   procedure Handle_Message (Command : String; Arg : String)
   is begin
      Put_Line ("Message received, Command: " & Command & ", Arg: " & Arg);
   end Handle_Message;

   procedure Handle_Alarm (Code : Integer)
   is
      use Grbl_Parser.Names;
   begin
      Put ("Alarm received, ");
      if Code in 0 .. 15 then
         Put_Line (Alarm_Name (Code).all);
      else
         Put_Line (Alarm_Name (0).all);
      end if;
   end Handle_Alarm;

end Handlers;
