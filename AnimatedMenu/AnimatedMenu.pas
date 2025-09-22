program AnimatedMenu;   { Just trying to make animated game's title screen }
uses crt;

const
  { keyboard codes }
  KEY_TOP   = -72;
  KEY_DOWN  = -80;
  KEY_ENTER =  13;

  { ========================== PARAMETERS  =========================== }
  { STARTNG MENU }
  MENU_OPT_AMOUNT    = 4;      { amount of options (start, exit) etc   }
  MENU_OFFSET_RIGHT  = 4;      { shift of menu from right left corner  }
  MENU_OFFSET_BOTTOM = 3;      { shift of menu from top half of screen }
  MENU_PADDING       = 1;      { distance between options              }
  { ANIMAITONS }
  { delay of moving animation after key pressed }
  SELECTION_MOVE_DELAY    = 200;
  { delay of text moving to right if it was selected }
  SELECTION_TEXT_MV_DELAY = 100;      { selected menu option castomization }
  { selected option background color }
  SELECTED_TEXT_BGC       = Magenta;
  SELECTED_TEXT_CLR       = LightGray;{ ackground color                    }
  SELECTED_OFFSET         = 2;        { shift to right from cursor         }
  { DEFAULT TEXT PARAMS }
  TEXT_COLOR       = Black;
  BACKGROUND_COLOR = LightGray;
  { x position of cursor used for animations and visible for user }
  CURSOR_POSX   = MENU_OFFSET_RIGHT - 1;
  { amount of Y layers of menu }
  BG_BOT_BORDER = MENU_OPT_AMOUNT * (1 + MENU_PADDING);

type
  { properties of a single menu option }
  MenuOption = record
    Name     : string;  { name of option that will be used on screen }
    Selected : boolean; { true if this option is selected            }
    PosY     : integer; { y position of option's top line            }
    NameLen  : integer; { length of option's name                    }
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
  StartY := (ScreenHeight div 2) + MENU_OFFSET_BOTTOM;
  for i := 1 to MENU_OPT_AMOUNT do
    Menu[i].PosY := StartY + ((MENU_PADDING + 1) * i);
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
function FindGreatestLen(Menu: MenuType):integer;
var
  i, max: integer;
begin
  max := 0;
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    if Menu[i].NameLen > max then
      max := Menu[i].NameLen;
  end;
  FindGreatestLen := max;
end;

  { change selected option and normalize it depending on key pressed
    +1 to go to next option and -1 for previous                      }
procedure GetNextSelected(var Menu: MenuType; ChangePos: integer);
var
  PrevSelected, NewSelected: integer;
begin
  PrevSelected := FindSelectedNum(Menu);
  NewSelected := PrevSelected + ChangePos;

  if NewSelected > MENU_OPT_AMOUNT then
    NewSelected := 1
  else if NewSelected < 1 then NewSelected := MENU_OPT_AMOUNT;
  Menu[PrevSelected].Selected := false;
  Menu[NewSelected].Selected := true;
end;

  { ========================== VISUAL LOGIC ========================== }
  { write Amount of spaces. Usualy used to fill colored background of menu }
procedure WriteSpaces(Amount: integer);
var
  i: integer;
begin
  for i := 1 to Amount do
    write(' ');
end;
  { set text params to selected menu option }
procedure TextParamsToSelected;
begin
  TextColor(SELECTED_TEXT_CLR);
  TextBackground(SELECTED_TEXT_BGC);
end;

  { set text params to not selected menu option }
procedure TextParamsToDefault;
begin
  TextColor(TEXT_COLOR);
  TextBackground(BACKGROUND_COLOR);
end;

  { set text params to default terminal ones }
procedure TextParamsToClear;
begin
  TextColor(TEXT_COLOR);
  TextBackground(Black);
end;

  { draw box of unselected type color for entire menu to fit in }
procedure FillBG(Menu: MenuType);
var
  CurY, SpacesAmount, TopBorder, BotBorder: integer;
begin
  SpacesAmount := MENU_OFFSET_RIGHT + FindGreatestLen(Menu);
  TopBorder := (ScreenHeight div 2) + MENU_OFFSET_BOTTOM + 1;
  BotBorder := TopBorder + BG_BOT_BORDER - 1;

  for CurY := TopBorder to BotBorder do
  begin
    GotoXY(MENU_OFFSET_RIGHT, CurY);
    WriteSpaces(SpacesAmount);
  end;
end;

  { write text for DrawSelectedLine bc it's overwrites previous text }
procedure WriteIfOnText(Menu: MenuType);
var
  i: integer;
begin
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    if WhereY = Menu[i].PosY then
    begin
      WriteSpaces(SELECTED_OFFSET);
      write(Menu[i].Name);
    end;
  end;
end;

  { draw a single line of selected option box }
procedure DrawSelectedLine(Menu: MenuType; PosY: integer);
var
  SpacesAmount, TopBorder, BotBorder, ResY: integer;
begin
  SpacesAmount := MENU_OFFSET_RIGHT + FindGreatestLen(Menu);
  TopBorder := (ScreenHeight div 2) + MENU_OFFSET_BOTTOM;
  BotBorder := TopBorder + BG_BOT_BORDER;

  if (PosY > TopBorder) and (PosY <= BotBorder) then
    ResY := PosY
  else if PosY = TopBorder then
    ResY := BotBorder;

  GotoXY(MENU_OFFSET_RIGHT, ResY);
  WriteSpaces(SpacesAmount);
  GotoXY(MENU_OFFSET_RIGHT, ResY);
  WriteIfOnText(Menu);
end;

  { draw a selected option box next to cursor }
procedure DrawCursor(Menu: MenuType);
var
  CurY, i: integer;
begin
  CurY := WhereY;

  TextParamsToSelected;
  for i := MENU_PADDING downto 1 do
  begin
      DrawSelectedLine(Menu, CurY - i);
  end;
  { Last string wrote outside of loop for fixing bug
    if MENU_OFFSET_RIGHT is odd                      }
  DrawSelectedLine(Menu, CurY);

  GotoXY(CURSOR_POSX, CurY);
  TextParamsToClear;
end;

  { rewrite entire menu basically draw a frame of animation }
procedure WriteMenu(Menu: MenuType);
var
  i, CurPos: integer;
begin
  CurPos := WhereY;
  clrscr;
  TextParamsToDefault;
  FillBG(Menu);
  for i := 1 to MENU_OPT_AMOUNT do
  begin
    GotoXY(MENU_OFFSET_RIGHT, Menu[i].PosY);
    write(Menu[i].Name);
  end;
  GotoXY(CURSOR_POSX, CurPos);
  DrawCursor(Menu);
  TextParamsToClear;
end;

  { movement of selected option across menu + normalization if it selected
    option goes to previous of 1st one and after last one
    redraws menu                                                           }
procedure MoveOption(var Menu: MenuType; ChangePos: integer);
var
  MovingSteps, TopBorder, BotBorder, i: integer;
begin
  MovingSteps := MENU_PADDING + 1;
  GetNextSelected(Menu, ChangePos);
  TopBorder := Menu[1].PosY;
  BotBorder := Menu[MENU_OPT_AMOUNT].PosY;

  for i := 1 to MovingSteps do
  begin
    delay(SELECTION_MOVE_DELAY div MovingSteps);
    if (WhereY < TopBorder) and (ChangePos = -1) then
      GotoXY(CURSOR_POSX, BotBorder)
    else if (WhereY > BotBorder - MENU_PADDING) and (ChangePos = 1) then
      GotoXY(CURSOR_POSX, TopBorder - MENU_PADDING)
    else
      GotoXY(CURSOR_POSX, WhereY + ChangePos);
    WriteMenu(Menu);
  end;
end;

  { what to do if selected option is activated }
procedure ChooseOption(Menu: MenuType);
begin
  TextParamsToSelected;
  write(FindSelectedNum(Menu));
  TextParamsToClear;
end;

  { what to do if any those buttons are pressed }
procedure UpdateMenu(var Menu: MenuType; CurrentKey: integer);
begin
  case CurrentKey of
    KEY_TOP   : MoveOption(Menu, -1);
    KEY_DOWN  : MoveOption(Menu, 1);
    KEY_ENTER : ChooseOption(Menu);
  end;
end;

var
  CurrentKey, DefaultTextParams: integer;
  Menu: MenuType;
begin
  clrscr;
  DefaultTextParams := TextAttr;
  InitMenuParams(Menu, NamesOfOptions);
  GotoXY(CURSOR_POSX, FindSelectedY(Menu));
  WriteMenu(Menu);
  repeat
     CurrentKey := GetKey();
     UpdateMenu(Menu, CurrentKey);
  until CurrentKey = ord(' ');
  TextAttr := DefaultTextParams;
  clrscr;
end.

