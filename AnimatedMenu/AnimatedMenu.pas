program AnimatedMenu;   { Just trying to make animated game's title screen }
uses crt;

const
  { keyboard codes }
  KEY_TOP   = -72;
  KEY_DOWN  = -80;
  KEY_ENTER = 13;

  { ========================== CONFIG ========================== }
  { STARTNG MENU }
  MENU_OPT_AMOUNT   = 4;      { amount of options (start, exit) etc   }
  MENU_SHIFT_RIGHT  = 4;      { shift of menu from right left corner  }
  MENU_SHIFT_BOTTOM = 3;      { shift of menu from top half of screen }
  OPTIONS_PADDING   = 1;      { distance between options              }
  { ANIMAITONS }
  { delay of moving selected opt after key pressed }
  SELECTION_MOVE_DELAY    = 200;
  { delay of text moving to right if it was slcted }
  SELECTION_TEXT_MV_DELAY = 100;      { selected menu option castomization }
  { selected option background color }
  SELECTED_TEXT_BGC       = Magenta;
  SELECTED_TEXT_CLR       = LightGray;{ ackground color                    }
  SELECTED_OPT_SHIFT      = 2;        { shift to right from cursor         }
  { DEFAULT TEXT PARAMS }
  TEXT_COLOR       = LightCyan;
  BACKGROUND_COLOR = Black;
type
  { properties of a single menu option }
  MenuOption = record
    Name     :string;
    Selected :boolean;
    PosY     :integer;
    NameLen  :integer;
  end;
  { array to transfer menu options names to Menu type variable }
  MenuNames = array[1..MENU_OPT_AMOUNT] of string;
  { entire menu array }
  MenuType = array[1..MENU_OPT_AMOUNT] of MenuOption;
  OptionsParam = (number, y);

var
  NamesOfOptions: MenuNames = ('Start', 'Extras', 'Settings', 'Exit');
  { ========================== BASIC LOGIC ========================== }
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
  StartY := (ScreenHeight div 2) + MENU_SHIFT_BOTTOM;
  for i := 1 to MENU_OPT_AMOUNT do
    Menu[i].PosY := StartY + ((OPTIONS_PADDING + 1) * i);
end;

  { setup parameters of menu }
procedure InitMenuParams(var Menu: MenuType; Options: MenuNames);
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    Menu[i].Name := Options[i];
    Menu[i].NameLen := length(Menu[i].Name);
    Menu[i].Selected := false;
  end;
  Menu[1].Selected := true;

  PositionMenu(Menu);
end;

  { find y param of current selected option }
function FindSelectedY(Menu: MenuType):integer;
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    if Menu[i].Selected then
      FindSelectedY := Menu[i].PosY;
  end;
end;

  { find number param of current selected option }
function FindSelectedNum(Menu: MenuType):integer;
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    if Menu[i].Selected then
      FindSelectedNum := i;
  end;
end;

  { find biggest length param of menu }
function FindBiggestLen(Menu: MenuType):integer;
var
  i, max: integer;
begin
  max := 0;
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    if Menu[i].NameLen > max then
      max := Menu[i].NameLen;
  end;
  FindBiggestLen := max;
end;

  { ========================== VISUAL LOGIC ========================== }
{$IF 0}
  { ========================== OLD CODE ============================== }
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

  { conditions of moving up/down or moving to bottom/top if selected option on }
  { other side of list                                                         }
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
  { ======================= END ========================= }

{$ENDIF}

{procedure UpdateMenu(Menu: MenuType);
begin
  case CurrentKey of
    KEY_TOP:   MoveOptionTop(Menu);
    KEY_DOWN:  MoveOptionDown(Menu);
    KEY_ENTER: ChooseOption(Menu);
  end;
end;
}
procedure TextParamsToSelected;
begin
  TextColor(SELECTED_TEXT_CLR);
  TextBackground(SELECTED_TEXT_BGC);
end;

procedure TextParamsToDefault;
begin
  TextColor(TEXT_COLOR);
  TextBackground(BACKGROUND_COLOR);
end;

procedure FillPadding(Menu: MenuType; StartY, LinesAmount: integer);
var
  CurY, i, y, SpacesAmount: integer;
begin
  SpacesAmount := MENU_SHIFT_RIGHT + FindBiggestLen(Menu);
  CurY := StartY;
  for i := 1 to LinesAmount do
  begin
    GotoXY(MENU_SHIFT_RIGHT, CurY);
    CurY := CurY + 1;
    for y := 1 to SpacesAmount do
      write(' ');
  end;
end;

procedure WriteSelectedOpt(Menu: MenuType);
var
  i, StartY: integer;
begin
  StartY := FindSelectedY(Menu) - 1;

  write(' ');
  TextParamsToSelected;
  FillPadding(Menu, StartY, OPTIONS_PADDING);
  for i := 1 to SELECTED_OPT_SHIFT do
    write(' ');
  write(Menu[FindSelectedNum(Menu)].name);
  for i := 1 to SELECTED_OPT_SHIFT + 1 do
    write(' ');
  TextParamsToDefault;
end;

procedure WriteMenu(Menu: MenuType);
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    GotoXY(MENU_SHIFT_RIGHT, Menu[i].PosY);
    if Menu[i].Selected then
      WriteSelectedOpt(Menu)
    else
      writeLn(Menu[i].Name);
  end;
  GotoXY(MENU_SHIFT_RIGHT, Menu[1].PosY);
end;

var
  CurrentKey, DefaultTextParams: integer;
  Menu: MenuType;
begin
  clrscr;
  DefaultTextParams := TextAttr;
  InitMenuParams(Menu, NamesOfOptions);
  WriteMenu(Menu);
  repeat
     CurrentKey := GetKey();
     {UpdateMenu(Menu, CurrentKey);}
  until CurrentKey = ord(' ');
  TextAttr := DefaultTextParams;
  clrscr;
end.

