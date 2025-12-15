unit scene_render_unit;
interface

  uses crt, render_unit, character_unit;

  type
    { type for info about each BLOCK on the scene }
    { and pointer for it                          }
    obj_ptr  = ^obj_info;
    obj_info = record
      Position: vertex;
      Symbol:   text_params;
      NextElem: obj_ptr;
    end;

  { for now fills list with manually selected colors and symbols }
  { for developmnet purposes                                     }
  procedure FillScreenList(var map: obj_ptr; arr: sym_color_arr);

  { draw level from objects list }
  procedure RenderScene(var map: obj_ptr; default: integer);

  { draw level from objects list }
  procedure UpdateScene(var map: obj_ptr; var character: character_ptr ;
                            default: integer);

  function ValidScreenSize(): boolean;

implementation

  { for now fills list with manually selected colors and symbols }
  { for developmnet purposes                                     }
  procedure FillScreenList(var map: obj_ptr; arr: sym_color_arr);
  var
    x, y, LvlStartX, LvlStartY : integer;
    tmp, cur:  obj_ptr;
  begin
    randomize;  { }
    map := nil;
    cur := map;
    LvlStartX := (ScreenWidth - LVL_WIDTH) div 2;
    LvlStartY := (ScreenHeight - LVL_HEIGHT) div 2;
    for x := LvlStartX to LvlStartX + LVL_WIDTH do begin
      for y := LVLStartY to LVLStartY + LVL_HEIGHT do begin
        new(tmp);
        tmp^.Position.X := x;
        tmp^.Position.Y := y;
        tmp^.Symbol.Letter := '_';
        tmp^.Symbol.TxtColor := Red;
        tmp^.Symbol.BgColor := Yellow;
        tmp^.NextElem := nil;
        if map = nil then
          map := tmp
        else
          cur^.NextElem := tmp;
        cur := tmp;
      end
    end;
  end;

  procedure RenderElement(var cur: obj_ptr);
  begin
    GotoXY(cur^.Position.X, cur^.Position.Y);
    TextBackground(cur^.Symbol.BgColor);
    TextColor(cur^.Symbol.TxtColor);
    write(cur^.Symbol.Letter);
    cur := cur^.NextElem
  end;

  { draw level from objects list }
  procedure RenderScene(var map: obj_ptr; default: integer);
  var
    cur: obj_ptr;
  begin
    cur := map;
    while cur <> nil do begin
      RenderElement(cur);
    end;
    textattr := default;
    HideCursor;
  end;

  function FindBgElem(var map: obj_ptr; x, y: integer): obj_ptr;
  var
    cur: obj_ptr;
  begin
    cur := map;
    while (cur^.Position.X <> x) and (cur^.Position.Y <> y) do
      cur := cur^.NextElem;
    FindBgElem := cur;
  end;

  { draw level from objects list }
  procedure UpdateScene(var map: obj_ptr; var character: character_ptr ;
                            default: integer);
  var
    CurChar: character_ptr;
    CurMap:  obj_ptr;
    x, y:    integer;
  begin
    CurChar := character;
    CurMap  := nil;

    while CurChar <> nil do begin
      x := CurChar^.Position.X;
      y := CurChar^.Position.Y;
      CurMap := FindBgElem(map, x, y);
      GotoXY(x, y);
      TextBackground(CurMap^.Symbol.BgColor);
      TextColor(CurMap^.Symbol.TxtColor);
      write(CurMap^.Symbol.Letter);
      CurChar := CurChar^.NextElem
    end;

    textattr := default;
    HideCursor;
  end;

  function ValidScreenSize(): boolean;
  begin
    if (ScreenWidth < LVL_WIDTH) or (ScreenHeight < LVL_HEIGHT) then
      ValidScreenSize := false
    else
      ValidScreenSize := true;
      {GotoXY(((ScreenWidth + length(ERR_LVL_TOO_SMALL)) div 2),
             ((ScreenWidth + 1) div 2));
      write(ERR_LVL_TOO_SMALL);}
  end;

end.

