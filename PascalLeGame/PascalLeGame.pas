program LeGame;

uses crt, character_unit, render_unit, controls_unit;

{$I './config/config.pas'}

type
  { type for info about each BLOCK on the scene }
  { and pointer for it                          }
  obj_ptr  = ^obj_info;
  obj_info = record
    Position: vertex;
    Symbol:   text_params;
    NextElem: obj_ptr;
  end;

{procedure CreateShitScreen(var map: obj_ptr; arr: sym_color);
var
  x, y: integer;
  tmp, cur:  obj_ptr;
begin
  randomize;
  map := nil;
  cur := map;
  for x := 1 to (ScreenWidth div 2) do begin
    for y := 1 to ScreenHeight do begin
      new(tmp);
      tmp^.X := x * 2;
      tmp^.Y := y;
      tmp^.Symbol := '  ';
      tmp^.BgColor := arr[random(7) + 1];
      tmp^.NextObj := nil;
      if map = nil then
        map := tmp
      else
        cur^.NextObj := tmp;
      cur := tmp;
    end
  end;
end;
}

{ draw level from objects list }
{procedure RenderScene(var map: obj_ptr; default: integer);
var
  cur: obj_ptr;
begin
  cur := map;
  while cur <> nil do begin
    GotoXY(cur^.X, cur^.Y);
    TextBackground(cur^.BgColor);
    write(cur^.Symbol);
    cur := cur^.NextObj
  end;
  textattr := default;
  HideCursor;
end;
}

var
  DefaultTerminalParams, KeyNum: integer;
  Character: character_ptr;
  BGColorArray: bg_color_arr;
  Map: obj_ptr;
BEGIN
  DefaultTerminalParams := textattr;

  InitCharList(Character);

  BgColorSetUp(BGColorArray);

  clrscr;
  {CreateShitScreen(Map, BGColorArray);}
  {RenderScene(Map, DefaultTerminalParams);}
  RenderCharacter(Character, 0, 0);

  repeat
    KeyNum := GetKey;
    {clrscr;}
    {RenderScene(Map, DefaultTerminalParams);}
    ControlsProcessing(KeyNum, Character);
    {writeLn(KeyNum)}
  until (char(KeyNum) = ' ');

  textattr := DefaultTerminalParams;
  clrscr;
END.
