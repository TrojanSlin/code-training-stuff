unit controls_unit;
interface

  uses crt, character_unit;

  { return integer value of key pressed}
  function GetKey(): integer;

  { desicions for keys pressed }
  procedure ControlsProcessing(key: integer; var Character: character_ptr);

implementation

  { return integer value of key pressed}
  function GetKey(): integer;
  var
    key: integer;
  begin
    key := ord(ReadKey);
    if key = 0 then
      key := -ord(ReadKey);
    GetKey := key;
  end;

  { desicions for keys pressed }
  procedure ControlsProcessing(key: integer; var Character: character_ptr);
  begin
    case key of
      KEY_W: RenderCharacter(Character,  0, -1);
      KEY_A: RenderCharacter(Character, -1,  0);
      KEY_S: RenderCharacter(Character,  0,  1);
      KEY_D: RenderCharacter(Character,  1,  0);
    end;
  end;

end.
