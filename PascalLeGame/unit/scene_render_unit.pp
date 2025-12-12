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

implementation

  { for now fills list with manually selected colors and symbols }
  { for developmnet purposes                                     }
  procedure FillScreenList(var map: obj_ptr; arr: sym_color_arr);
  var
    x, y: integer;
    tmp, cur:  obj_ptr;
  begin
    randomize;  { }
    map := nil;
    cur := map;
    for x := 1 to ScreenWidth do begin
      for y := 1 to ScreenHeight do begin
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

  { draw level from objects list }
  procedure UpdateScene(var Map: obj_ptr; Character: character_ptr ;
                            default: integer);
  var
    CurChar: character_ptr;
  begin
    CurChar := Character;
    while CurChar <> nil do begin
      GotoXY(CurChar^.Position.X, CurChar^.Position.Y);
      TextBackground(cur^.Symbol.BgColor);
      TextColor(cur^.Symbol.TxtColor);
      write(cur^.Symbol.Letter);
      cur := cur^.NextElem
    end;
    textattr := default;
    HideCursor;
  end;

end.

