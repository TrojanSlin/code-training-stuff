unit render_unit;
interface

  uses crt;

  type
    { array for background colors of symbol }
    bg_color_arr  = array [1..8]  of integer;
    { array for text colors of symbol       }
    sym_color_arr = array [1..16] of integer;

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

  { move cursor to 1,1 }
  procedure HideCursor;

  { setup array of background colors }
  procedure BGcolorSetUp(var arr: bg_color_arr);

  { setup array of text colors       }
  procedure TxtColorSetUp(var arr: sym_color_arr);

implementation

  {$I './config/config.pas'}

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

  { move cursor to 1,1 }
  procedure HideCursor();
  begin
    GotoXY(1, 1);
  end;

end.
