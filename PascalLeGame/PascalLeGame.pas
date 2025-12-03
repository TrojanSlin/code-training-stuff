program LeGame;

uses crt;

{$I 'config/config.pas'}

type
  { array for background colors }
  bg_color_arr = array [1..8] of integer;
  { array for text colors       }
  sym_color_arr = array [1..16] of integer;

  { array for text colors       }
  char_arr = array [1..9] of char;

  { XY position saving type }
  vertex = record
    X: integer;
    Y: integer;
  end;

  { saving parameters of one symbol                     }
  { letter itself, color of text and color of background}
  text_params = record
    Letter:   char;
    TxtColor: integer;
    BgColor:  integer;
  end;

  { type for every element of CHARACTER }
  { and pointer for it                  }
  character_ptr  = ^character_info;
  character_info = record
    Position: vertex;
    Symbol:   text_params;
    NextElem: character_ptr;
  end;

  { type for info about each BLOCK on the scene }
  { and pointer for it                          }
  obj_ptr  = ^obj_info;
  obj_info = record
    Position: vertex;
    Symbol:   text_params;
    NextElem: obj_ptr;
  end;

{ ----------- PARAMS FILLED BY HAND ------------ }
{ setting up background colors in a single array }
procedure BGColorSetUp(var arr: bg_color_arr);
begin
  arr[CLR_BLACK]        := Black;
  arr[CLR_BLUE]         := Blue;
  arr[CLR_GREEN]        := Green;
  arr[CLR_CYAN]         := Cyan;
  arr[CLR_RED]          := Red;
  arr[CLR_MAGENTA]      := Magenta;
  arr[CLR_BROWN]        := Brown;
  arr[CLR_LIGHTGRAY]    := LightGray;
end;

{ setting up text colors in a single array }
procedure TxtColorSetUp(var arr: sym_color_arr);
begin
  arr[CLR_BLACK]           := Black;
  arr[CLR_BLUE]            := Blue;
  arr[CLR_GREEN]           := Green;
  arr[CLR_CYAN]            := Cyan;
  arr[CLR_RED]             := Red;
  arr[CLR_MAGENTA]         := Magenta;
  arr[CLR_BROWN]           := Brown;
  arr[CLR_LIGHTGRAY]       := LightGray;
  arr[CLRTXT_DARKGRAY]     := DarkGray;
  arr[CLRTXT_LIGHTBLUE]    := LightBlue;
  arr[CLRTXT_LIGHTGREEN]   := LightGreen;
  arr[CLRTXT_LIGHTCYAN]    := LightCyan;
  arr[CLRTXT_LIGHTRED]     := LightRed;
  arr[CLRTXT_LIGHTMAGENTA] := LightMagenta;
  arr[CLRTXT_YELLOW]       := Yellow;
  arr[CLRTXT_WHITE]        := White;
end;

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
procedure CharacterListSetUp(var CharList: character_ptr; arr: char_arr);
var
  i, x, y: integer;
  cur, tmp: character_ptr;
begin
  i := 1;
  CharList := nil;
  cur := CharList;
  for y := 1 to 3 do begin
    for x := 1 to 3 do begin
      new(tmp);
      tmp^.Position.X := (ScreenWidth div 2) + x;
      tmp^.Position.Y := (ScreenHeight div 2) + y;
      tmp^.Symbol.Letter := arr[i];
      tmp^.Symbol.TxtColor := GetCharacterColor(y, x);
      tmp^.NextElem := nil;
      if CharList = nil then
        CharList := tmp
      else
        cur^.NextElem := tmp;
      cur := tmp;
      inc(i)
    end
  end
end;

{ get integer value of the key pressed }
function GetKey(): integer;
var
  key: integer;
begin
  key := ord(ReadKey);
  if key = 0 then
    key := -ord(ReadKey);
  GetKey := key;
end;

{ move coursor away to 1, 1 }
procedure HideCursor();
begin
  GotoXY(1, 1);
end;

function GetCharColor(var Character: character_ptr): integer;
begin
  if Character^.Symbol.TxtColor = CHR_LEG_FRONT then
    Character^.Symbol.TxtColor := CHR_LEG_BACK
  else if Character^.Symbol.TxtColor = CHR_LEG_BACK then
    Character^.Symbol.TxtColor := CHR_LEG_FRONT;

  GetCharColor := Character^.Symbol.TxtColor;
end;

function GetCharSymbol(var Character: character_ptr; dx: integer): char;
begin
  GetCharSymbol := Character^.Symbol.Letter;
  if (Character^.Symbol.TxtColor = CHR_BODY) and 
     (Character^.Symbol.Letter = '/') and
     (dx = -1) then
    GetCharSymbol := ' '
  else if (Character^.Symbol.TxtColor = CHR_BODY) and 
     (Character^.Symbol.Letter = '\') and
     (dx = 1) then
    GetCharSymbol := ' '
end;

procedure RenderCharElem(var Character: character_ptr; dx: integer);
begin
  GotoXY(Character^.Position.X, Character^.Position.Y);
  TextColor(GetCharColor(Character));
  write(GetCharSymbol(Character, dx))
end;

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

{ desicions for keys pressed }
procedure MoveOption(key: integer; var Character: character_ptr);
begin
  case key of
    KEY_W: RenderCharacter(Character,  0, -1);
    KEY_A: RenderCharacter(Character, -1,  0);
    KEY_S: RenderCharacter(Character,  0,  1);
    KEY_D: RenderCharacter(Character,  1,  0);
  end;
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
  CharArr: char_arr;
  Character: character_ptr;
  BGColorArray: bg_color_arr;
  Map: obj_ptr;
BEGIN
  DefaultTerminalParams := textattr;

  CharacterArrSetUp(CharArr);
  CharacterListSetUp(Character, CharArr);

  BgColorSetUp(BGColorArray);

  clrscr;
  {CreateShitScreen(Map, BGColorArray);}
  {RenderScene(Map, DefaultTerminalParams);}
  RenderCharacter(Character, 0, 0);

  repeat
    KeyNum := GetKey;
    {clrscr;}
    {RenderScene(Map, DefaultTerminalParams);}
    MoveOption(KeyNum, Character);
    {writeLn(KeyNum)}
  until (char(KeyNum) = ' ');

  textattr := DefaultTerminalParams;
  clrscr;
END.
