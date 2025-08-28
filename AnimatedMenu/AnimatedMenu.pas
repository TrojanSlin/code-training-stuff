program AnimatedMenu;   { Just trying to make animated game's title screen }
uses crt;

const
  { keyboard codes }
  KEY_TOP = -72;
  KEY_DOWN = -80;
  KEY_ENTER = 13;

  { CONFIG }
  { starting menu }
  MENU_OPT_AMOUNT = 4;      { amount of options (start, exit) etc }
  MENU_SHIFT_RIGHT = 4;     { shift of menu from right left corner }
  MENU_SHIFT_BOTTOM = 3;    { shift of menu from top half of screen }
  OPTIONS_PADDING = 2;      { distance between options }
  { animations }
  SELECTION_MOVE_DELAY = 200;   { delay of moving selected opt after key pressed }
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

function FindSelected(Menu: MenuType; Param: OptionsParam):integer;
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    if Menu[i].selected then
      case Param of
        y:      FindSelected := Menu[i].y;
        number: FindSelected := i;
      end;
  end;
end;

procedure GotoSelected(Menu: MenuType);
begin
  GotoXY(MENU_SHIFT_RIGHT, FindSelected(Menu, y));
end;

procedure WriteMenu(Menu: MenuType);
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    GotoXY(MENU_SHIFT_RIGHT, Menu[i].y);
    writeLn(Menu[i].name);
  end;
  GotoSelected(Menu);
end;

procedure MoveOptionDown(var Menu: MenuType);
var
  CurrentSelected: integer;
begin
  CurrentSelected := FindSelected(Menu, number);
  if CurrentSelected < MENU_OPT_AMOUNT then
  begin
    Menu[CurrentSelected].selected := false;
    Menu[CurrentSelected + 1].selected := true;
  end
  else
  begin
    Menu[CurrentSelected].selected := false;
    Menu[1].selected := true;
  end;
  delay(SELECTION_MOVE_DELAY);
end;

procedure MoveOptionTop(var Menu: MenuType);
var
  CurrentSelected: integer;
begin
  CurrentSelected := FindSelected(Menu, number);
  if CurrentSelected > 1 then
  begin
    Menu[CurrentSelected].selected := false;
    Menu[CurrentSelected - 1].selected := true;
  end
  else
  begin
    Menu[CurrentSelected].selected := false;
    Menu[MENU_OPT_AMOUNT].selected := true;
  end;
  delay(SELECTION_MOVE_DELAY);
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

