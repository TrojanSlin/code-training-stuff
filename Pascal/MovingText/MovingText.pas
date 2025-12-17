program learning;   { program to train coding }
uses crt;

const
  KeyLeft  = -75;
  KeyRight = -77;
  KeyUp    = -72;
  KeyDown  = -80;
  TheMessage = 'Hello world!';
type
  OverflowError = (right_overflow, left_overflow,
                   top_overflow, bot_overflow, went_fine);
  TAxis         = (TX, TY);

procedure GetKey(var code: integer);
var
  c: char;
begin
  c := ReadKey;
  if c = #0 then
  begin
    c := ReadKey;
    code := -ord(c);
  end
  else
  begin
    code := ord(c);
  end
end;

procedure ClearText(x, y, len: integer);
var
  i: integer;
begin
  if (x <> -1) and (y <> -1) then
    GotoXY(x, y);
  for i := 0 to len do
    write(' ');
end;

procedure NoErrorMessage(x, y: integer; msg: string);
begin
  GotoXY(x ,y);
  write(msg);
end;

{ conditions of text goes out of screen by x }
function OverflowCheckByX(x: integer; msg: string): OverflowError;
begin
  if (x + length(msg)) > ScreenWidth then
    OverflowCheckByX := right_overflow
  else if (x < 1) then
    OverflowCheckByX := left_overflow
  else
    OverflowCheckByX := went_fine
end;

{ conditions of text goes out of screen by y }
function OverflowCheckByY(y: integer; msg: string): OverflowError;
begin
  if (y < 1) then
    OverflowCheckByY := top_overflow
  else if (y > ScreenHeight) then
    OverflowCheckByY := bot_overflow
  else
    OverflowCheckByY := went_fine
end;

procedure ResolveRightError(var x: integer; y: integer; msg: string;
                            ToClear: boolean);
var
  EndOfLine, LineLn, i: integer;
begin
  LineLn := length(msg);
  EndOfLine := LineLn - ((LineLn + x) - ScreenWidth);
  { if the entire word on the other side move cursor to it }
  if x = ScreenWidth then
  begin
    x := 1;
    NoErrorMessage(x, y, msg);
    exit
  end;

  if ToClear then
  begin
    for i := 1 to LineLn do
      msg[i] := ' '
  end;
  GotoXY(x, y);     { write string till it is contained in single line }
  write(msg[1..EndOfLine]);
  GotoXY(1, y);     { write string form previous char till its end }
  write(msg[(EndOfLine + 1)..LineLn])
end;

procedure ResolveLeftError(var x: integer; y: integer; msg: string);
begin
  x := ScreenWidth - 1;
  ResolveRightError(x, y, msg, false)
end;

procedure ResolveX(var x, y: integer; msg: string; ErrType: OverflowError);
begin
  case ErrType of
    right_overflow:
      ResolveRightError(x, y, msg, false);
    left_overflow:
      ResolveLeftError(x, y, msg)
  end
end;

procedure ResolveY(var y: integer; msg: string; ErrType: OverflowError);
begin
  case ErrType of
    top_overflow:
      y := ScreenHeight;
    bot_overflow:
      y := 1
  end
end;

procedure ShowMessage(var x, y: integer; msg: string);
const
  DebugMessageLen = 20;
begin
  case OverflowCheckByY(y, msg) of
    top_overflow:
      ResolveY(y, msg, top_overflow);
    bot_overflow:
      ResolveY(y, msg, bot_overflow)
  end;

  case OverflowCheckByX(x, msg) of
    right_overflow:
      ResolveX(x, y, msg, right_overflow);
    left_overflow:
      ResolveX(x, y, msg, left_overflow)
    else begin
      NoErrorMessage(x, y, msg);
    end
  end;
  { temporary debuging info }
  { ClearText(-1, -1, DebugMessageLen);
  write(x, ' of ', ScreenWidth, ' ', y, ' of ', ScreenHeight, ' ',
        OverflowCheckByX(x, msg)); }
end;

procedure HideMessage(x, y: integer; msg: string);
var
  len: integer;
begin
  len := length(msg);
  GotoXY(x, y);
  if OverflowCheckByX(x, msg) = right_overflow then
    ResolveRightError(x, y, msg, true)
  else
  begin
    ClearText(-1, -1, len)
  end
end;

procedure MoveMessage(var x, y: integer; msg: string; dx, dy: integer);
begin
  HideMessage(x, y, msg);
  x := x + dx;
  y := y + dy;
  ShowMessage(x, y, msg);
  GotoXY(1, 1);
end;

var
  CurX, CurY: integer;
  c: integer;
begin
  clrscr;
  CurX := (ScreenWidth - length(TheMessage)) div 2;
  CurY := ScreenHeight div 2;
  ShowMessage(CurX, CurY, TheMessage);
  while true do
  begin
    GetKey(c);
    if c > 0 then
      break;
    case c of
      KeyLeft:
        MoveMessage(CurX, CurY, TheMessage, -1, 0);
      KeyRight:
        MoveMessage(CurX, CurY, TheMessage, 1, 0);
      KeyUp:
        MoveMessage(CurX, CurY, TheMessage, 0, -1);
      KeyDown:
        MoveMessage(CurX, CurY, TheMessage, 0, 1)
    end
  end;
  clrscr
end.
