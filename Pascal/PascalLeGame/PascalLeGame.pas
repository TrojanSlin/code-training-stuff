program LeGame;

uses crt, character_unit, render_unit, controls_unit, scene_render_unit;

{$I './config/config.pas'}

var
  DefaultTerminalParams, KeyNum: integer;
  Character: character_ptr;
  BGColorArray: bg_color_arr;
  TxtColorArray: sym_color_arr;
  Map: obj_ptr;
BEGIN

  if not ValidScreenSize then begin
    writeLn(ERR_LVL_TOO_SMALL);
    writeLn('Current size is Height is ', ScreenHeight, ' out of ',
            LVL_HEIGHT, ' needed');
    writeLn('Current width is ', ScreenWidth, ' out of ',
            LVL_WIDTH, ' needed');
    halt(1)
  end;

  DefaultTerminalParams := textattr;
  InitCharList(Character);
  BgColorSetUp(BGColorArray);
  TxtColorSetUp(TxtColorArray);
  FillScreenList(Map, TxtColorArray);

  clrscr;
  RenderScene(Map, DefaultTerminalParams);
  RenderCharacter(Character, 0, 0);

  repeat
    KeyNum := GetKey;
    {RenderScene(Map, DefaultTerminalParams);}
    UpdateScene(Map, Character, DefaultTerminalParams);
    ControlsProcessing(KeyNum, Character);
  until (char(KeyNum) = ' ');

  textattr := DefaultTerminalParams;
  clrscr;
END.
