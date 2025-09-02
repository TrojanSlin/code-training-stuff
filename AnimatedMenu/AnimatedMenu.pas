program AnimatedMenu;   { Just trying to make animated game's title screen }
uses crt;

const
  { keyboard codes }
  KEY_TOP = -72;
  KEY_DOWN = -80;
  KEY_ENTER = 13;

  { CONFIG ==========================================}
  { starting menu }
  MENU_OPT_AMOUNT = 4;      { amount of options (start, exit) etc }
  MENU_SHIFT_RIGHT = 4;     { shift of menu from right left corner }
  MENU_SHIFT_BOTTOM = 3;    { shift of menu from top half of screen }
  OPTIONS_PADDING = 2;      { distance between options }
  { animations }
  SELECTION_MOVE_DELAY = 200;   { delay of moving selected opt after key pressed }
  SELECTION_TEXT_MV_DELAY = 100;{ delay of text moving to right if it was slcted }
  { selected menu option castomization }
  SELECTED_OPT_BGC = DarkGray;  { background color }
  SELECTED_OPT_SHIFT = 2;       { shift to right from cursor }

type
  { properties of a single menu option }
  MenuOption = record
    name: string;
    selected: boolean;
    y: integer;
  end;
  { array to transfer menu options names to Menu type variable }
  MenuNames = array[1..MENU_OPT_AMOUNT] of string;
  { entire menu array }
  MenuType = array[1..MENU_OPT_AMOUNT] of MenuOption;
  OptionsParam = (number, y);

var
  NamesOfOptions: MenuNames = ('Start', 'Extras', 'Settings', 'Exit');
{ BASIC LOGIC ================================================================= }
{ get which button was pressed rn as a number }
function GetKey(): integer;
var
  key: integer;
begin
  key := ord(ReadKey);
  if key = 0 then
    key := -ord(ReadKey);
  GetKey := key;
end;

{ get where to place menu on screen }
procedure PositionMenu(var Menu: MenuType);
var
  StartY, i: integer;
begin
  StartY := ScreenHeight div 2 + MENU_SHIFT_BOTTOM;
  for i := 1 to MENU_OPT_AMOUNT do
    Menu[i].y := StartY + (i * OPTIONS_PADDING);
end;

{ setup parameters of menu }
procedure InitMenuParams(var Menu: MenuType; Options: MenuNames);
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    Menu[i].name := Options[i];
    Menu[i].selected := false;
  end;
  Menu[1].selected := true;

  PositionMenu(Menu);
end;

{ find y param of current selected option }
function FindSelectedY(Menu: MenuType):integer;
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    if Menu[i].selected then
      FindSelectedY := Menu[i].y;
  end;
end;

{ find number param of current selected option }
function FindSelectedNum(Menu: MenuType):integer;
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    if Menu[i].selected then
      FindSelectedNum := i;
  end;
end;

{ VISUALIZATION LOGIC ========================================================= }
{ clear text of option }
procedure ClearOpt(Menu: MenuType; OptionNum: integer);
var
  OptLength, StartPos, i: integer;
begin
  StartPos := WhereY;
  OptLength := length(Menu[OptionNum].name) + SELECTED_OPT_SHIFT + 1;
  GotoXY(MENU_SHIFT_RIGHT, Menu[OptionNum].y);
  for i := 1 to OptLength do
    write(' ');
  GotoXY(MENU_SHIFT_RIGHT, StartPos);
end;

{  }
procedure RewriteOptUp(Menu: MenuType);
var
  LocalShift, i: integer;
begin
  LocalShift := SELECTED_OPT_SHIFT div OPTIONS_PADDING;

  GotoXY(MENU_SHIFT_RIGHT, Menu[PrevOpt].y);
  for i := 1 to LocalShift * (OPTIONS_PADDING - RelativePos) do
    write(' ');
  write(Menu[PrevOpt].name);

  GotoXY(MENU_SHIFT_RIGHT, FindSelectedY(Menu));
  for i := 1 to LocalShift * RelativePos do
    write(' ');
  write(Menu[FindSelectedNum(Menu)].name);
end;

{  }
procedure RewriteOptDown(Menu: MenuType);
var
  LocalShift, i: integer;
begin
  LocalShift := SELECTED_OPT_SHIFT div OPTIONS_PADDING;

  GotoXY(MENU_SHIFT_RIGHT, Menu[PrevOpt].y);
  for i := 1 to LocalShift * (OPTIONS_PADDING - RelativePos) do
    write(' ');
  write(Menu[PrevOpt].name);

  GotoXY(MENU_SHIFT_RIGHT, FindSelectedY(Menu));
  for i := 1 to LocalShift * RelativePos do
    write(' ');
  write(Menu[FindSelectedNum(Menu)].name);
end;

{ write option over }
procedure UpdateOpt(Menu: MenuType; PrevOpt: integer);
var
  RelativePos: integer;
begin
  if PrevOpt < FindSelectedNum(Menu) then
  begin
    RelativePos := OPTIONS_PADDING - (FindSelectedY(Menu) - WhereY) + 1
    RewriteOptDown(Menu);
  end
  else
  begin
    RelativePos := OPTIONS_PADDING - (WhereY - FindSelectedY(Menu)) + 1;
    UpdateOpt(Menu, RelativePos);
  end;
end;

{ update option via cursor moving animaiton }
procedure UpdateText(Menu: MenuType; PrevOpt: integer);
begin
  ClearOpt(Menu, FindSelectedNum(Menu));
  ClearOpt(Menu, PrevOpt);
  UpdateOpt(Menu, PrevOpt);
end;

procedure UpdateSelectedBG();
begin

end;

procedure OneStepDown(Menu: MenuType; StepDelay: integer);
var
  NextCursorY, PrevOpt: integer;
begin
  PrevOpt := FindSelectedNum(Menu) - 1;
  NextCursorY := WhereY + 1;

  delay(StepDelay);
  UpdateText(Menu, PrevOpt);
  UpdateSelectedBG();
  GotoXY(MENU_SHIFT_RIGHT, NextCursorY);
end;

procedure OneStepUp(Menu: MenuType; StepDelay: integer);
var
  NextCursorY, PrevOpt: integer;
begin
  PrevOpt := FindSelectedNum(Menu) - 1;
  NextCursorY := WhereY - 1;

  delay(StepDelay);
  UpdateText(Menu, PrevOpt);
  UpdateSelectedBG();
  GotoXY(MENU_SHIFT_RIGHT, NextCursorY);
end;

{ conditions of moving up/down or moving to bottom/top if selected option on other
  side of list }
procedure StepsNormalization(Menu: MenuType; StepDelay:integer);
begin
  { condition if current option on top and selected one on bottom }
  if (WhereY = Menu[1].y) and
     (Menu[MENU_OPT_AMOUNT].y = FindSelectedY(Menu))
  then
    GotoXY(MENU_SHIFT_RIGHT, FindSelectedY(Menu))
  { condition if current option on bottom and selected one on top }
  else if (WhereY = Menu[MENU_OPT_AMOUNT].y) and
          (Menu[1].y = FindSelectedY(Menu))
  then
    GotoXY(MENU_SHIFT_RIGHT, FindSelectedY(Menu))
  else if WhereY < FindSelectedY(Menu)
  then
    OneStepDown(Menu, StepDelay)
  else if WhereY > FindSelectedY(Menu)
  then
    OneStepUp(Menu, StepDelay);
end;

procedure GotoSelected(Menu: MenuType);
var
  MovingSteps, StepDelay, i: integer;
begin
  MovingSteps := OPTIONS_PADDING;
  StepDelay := SELECTION_MOVE_DELAY div MovingSteps;

  for i := 1 to MovingSteps do
  begin
    StepsNormalization(Menu, StepDelay);
  end;
end;

{ write only first option with selection parameters on it }
procedure WriteFirstOpt(Menu: MenuType);
var
  i: integer;
begin
  GotoXY(MENU_SHIFT_RIGHT, Menu[1].y);
  for i := 1 to SELECTED_OPT_SHIFT do
    write(' ');
  write(Menu[1].name);
end;

{ write initialized menu }
procedure WriteMenu(Menu: MenuType);
var
  i: integer;
begin
  WriteFirstOpt(Menu);

  for i := 2 to MENU_OPT_AMOUNT do
  begin
    GotoXY(MENU_SHIFT_RIGHT, Menu[i].y);
    writeLn(Menu[i].name);
  end;
  GotoXY(MENU_SHIFT_RIGHT, Menu[1].y);
end;

procedure MoveOptionDown(var Menu: MenuType);
var
  CurrentSelected: integer;
begin
  CurrentSelected := FindSelectedNum(Menu);
  Menu[CurrentSelected].selected := false;
  if CurrentSelected >= MENU_OPT_AMOUNT then
    CurrentSelected := 0;
  Menu[CurrentSelected + 1].selected := true;
end;

procedure MoveOptionTop(var Menu: MenuType);
var
  CurrentSelected: integer;
begin
  CurrentSelected := FindSelectedNum(Menu);
  Menu[CurrentSelected].selected := false;
  if CurrentSelected <= 1 then
    CurrentSelected := MENU_OPT_AMOUNT + 1;
  Menu[CurrentSelected - 1].selected := true;
end;

procedure ChooseOption(Menu: MenuType);
begin

end;

procedure UpdateMenu(var Menu: Menutype; CurrentKey: integer);
begin
  case CurrentKey of
    KEY_TOP:   MoveOptionTop(Menu);
    KEY_DOWN:  MoveOptionDown(Menu);
    KEY_ENTER: ChooseOption(Menu);
  end;
  GotoSelected(Menu);
end;

var
  CurrentKey: integer;
  Menu: MenuType;
begin
  clrscr;
  InitMenuParams(Menu, NamesOfOptions);
  WriteMenu(Menu);
  repeat
     CurrentKey := GetKey();
     UpdateMenu(Menu, CurrentKey);
  until CurrentKey = ord(' ');
  clrscr;
end.

