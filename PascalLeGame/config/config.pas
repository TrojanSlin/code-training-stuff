{ Configuration params file }

const
  { --------- VISUAL CONFIG -------- }
  { Character's colors of body       }
  CHR_HEAD      = yellow;
  CHR_BODY      = lightred;
  CHR_LEG_FRONT = lightmagenta;
  CHR_LEG_BACK  = magenta;

  { ----------- KEYS VALUE --------- }
  { integer values for movement keys }
  KEY_W = 119;
  KEY_A = 97;
  KEY_S = 115;
  KEY_D = 100;

  { ---------- LEVEL SIZE ----------- }
  { typical size of each ingame level }
  LVL_WIDTH  = 100;
  LVL_HEIGHT = 40;
 
  { ----------- CRT COLORS ORDER ------------ }
  { crt colors order for array for easier use }
  CLR_BLACK     = 1;
  CLR_BLUE      = 2;
  CLR_GREEN     = 3;
  CLR_CYAN      = 4;
  CLR_RED       = 5;
  CLR_MAGENTA   = 6;
  CLR_BROWN     = 7;
  CLR_LIGHTGRAY = 8;

  { text only crt colors }
  CLRTXT_DARKGRAY     = 9;
  CLRTXT_LIGHTBLUE    = 10;
  CLRTXT_LIGHTGREEN   = 11;
  CLRTXT_LIGHTCYAN    = 13;
  CLRTXT_LIGHTRED     = 14;
  CLRTXT_LIGHTMAGENTA = 15;
  CLRTXT_YELLOW       = 15;
  CLRTXT_WHITE        = 16;

  { -------- ERROR MESSAGES --------- }
  ERR_LVL_TOO_SMALL  = 'Terminal window is too small. Pls resize it';
