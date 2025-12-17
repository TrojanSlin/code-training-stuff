unit character_unit;
interface

  uses crt, render_unit;

  {$I '../config/config.pas'}
  { type for every element of CHARACTER }
  { and pointer for it                  }
  type
    character_ptr  = ^character_info;
    character_info = record
      Position: vertex;
      Symbol:   text_params;
      Visible:  boolean;
      NextElem: character_ptr
    end;

  { put character info into list }
  procedure InitCharList(var Character: character_ptr);

  { draw character in current position x+dx, y+dy}
  procedure RenderCharacter(var Character: character_ptr; dx, dy: integer);

  procedure RenderCharStill(var Character: character_ptr);

implementation

  type
    { array for text colors }
    char_arr = array [1..9] of char;

  { array for symbols of which character consists of }
  { 0    0
    U\  /U
   / \  / \ }
  procedure CharacterArrSetUp(var arr: char_arr);
  begin
    arr[1] := ' ';
    arr[2] := '0';
    arr[3] := ' ';
    arr[4] := '/';
    arr[5] := 'U';
    arr[6] := '\';
    arr[7] := '/';
    arr[8] := ' ';
    arr[9] := '\';
  end;

  { }
  function GetCharacterColor(x, y: integer): integer;
  begin
    case x of
      1: GetCharacterColor := CHR_HEAD;
      2: GetCharacterColor := CHR_BODY;
      3: begin
        if y = 1 then
          GetCharacterColor := CHR_LEG_FRONT
        else
          GetCharacterColor := CHR_LEG_BACK
      end
    end
  end;

  { create character list and put it into starting position }
  procedure CharacterListSetUp(var Character: character_ptr; arr: char_arr);
  var
    i, x, y: integer;
    cur, tmp: character_ptr;
  begin
    i := 1;
    Character := nil;
    cur := Character;
    for y := 1 to 3 do begin
      for x := 1 to 3 do begin
        new(tmp);
        tmp^.Position.X := (ScreenWidth div 2) + x;
        tmp^.Position.Y := (ScreenHeight div 2) + y;
        tmp^.Symbol.Letter := arr[i];
        tmp^.Symbol.TxtColor := GetCharacterColor(y, x);
        tmp^.Visible := true;
        tmp^.NextElem := nil;
        if Character = nil then
          Character := tmp
        else
          cur^.NextElem := tmp;
        cur := tmp;
        inc(i)
      end
    end
  end;

  { put character info into list }
  procedure InitCharList(var Character: character_ptr);
  var
    ChrArr: char_arr;
  begin
    CharacterArrSetUp(ChrArr);
    CharacterListSetUp(Character, ChrArr);
  end;

  { return color of characters symbol for render         }
  { currently it also changes color of legs like walking }
  procedure GetCharColor(var Character: character_ptr);
  begin
    case Character^.Symbol.TxtColor of
      CHR_LEG_FRONT: Character^.Symbol.TxtColor := CHR_LEG_BACK;
      CHR_LEG_BACK:  Character^.Symbol.TxtColor := CHR_LEG_FRONT
    end;
  end;

  { return symbol of }
  procedure GetCharSymbol(var Character: character_ptr; dx: integer);
  begin
    Character^.Visible := true;
    if (Character^.Symbol.TxtColor = CHR_BODY) and 
       (Character^.Symbol.Letter = '/') and
       (dx = -1) then
      Character^.Visible := false
    else if (Character^.Symbol.TxtColor = CHR_BODY) and 
            (Character^.Symbol.Letter = '\') and
            (dx = 1) then
      Character^.Visible := false
  end;

  { draw single element of character }
  procedure RenderCharElem(var Character: character_ptr; dx: integer);
  begin
    GotoXY(Character^.Position.X, Character^.Position.Y);
    GetCharColor(Character);
    TextColor(Character^.Symbol.TxtColor);
    GetCharSymbol(Character, dx);
    if Character^.Visible then
      write(Character^.Symbol.Letter)
    else
      write(' ')
  end;

  { draw character in current position x+dx, y+dy}
  procedure RenderCharacter(var Character: character_ptr; dx, dy: integer);
  var
    cur: character_ptr;
  begin
    cur := Character;
    while cur <> nil do begin
      cur^.Position.X := cur^.Position.X + dx;
      cur^.Position.Y := cur^.Position.Y + dY;
      RenderCharElem(cur, dx);
      cur := cur^.NextElem
    end;
    HideCursor
  end;

  procedure RenderCharStill(var Character: character_ptr);
  var
    cur: character_ptr;
  begin
    cur := Character;
    while cur <> nil do begin
      GotoXY(cur^.Position.X, cur^.Position.Y);
      TextColor(cur^.Symbol.TxtColor);
      if cur^.Visible then
        write(cur^.Symbol.Letter)
      else
        write(' ');
      cur := cur^.NextElem
    end;
    HideCursor
  end;


end.
