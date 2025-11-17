program learning;
function BackSlashProcessing(StrChar, NextPatChar: char): boolean;
begin
  case NextPatChar of
    '\', '*', '?', '+':
      BackSlashProcessing := StrChar = NextPatChar;
    'd':
      BackSlashProcessing := (StrChar >= '0') and (StrChar <= '9');
    'a':
      BackSlashProcessing := ((StrChar >= 'a') and (StrChar <= 'z')) or
        ((StrChar >= 'A') and (StrChar <= 'Z'));
    else
      BackSlashProcessing := false;
   end
end;

function Match(str, pat: string; StrCnt, PatCnt: integer): boolean;
var
  i: integer;
begin
  Match := false;
  if PatCnt > length(pat) then begin
    Match := StrCnt > length(str);
    exit
  end;

  case pat[PatCnt] of
    '?':;
    '\': begin
      inc(PatCnt);
      if not BackSlashProcessing(str[StrCnt], pat[PatCnt]) then
        exit
    end;
    '*': begin
      for i := 0 to (length(str) - StrCnt + 1) do begin
        if Match(str, pat, StrCnt + i, PatCnt + 1) then begin
          Match := true;
          exit
        end
      end;
      exit
    end;
    '+': begin
      for i := 1 to (length(str) - StrCnt + 1) do begin
        if Match(str, pat, StrCnt + i, PatCnt + 1) then begin
          Match := true;
          exit
        end
      end;
      exit
    end
    else
      if str[StrCnt] <> pat[PatCnt] then
        exit
  end;

  if StrCnt = length(str) then begin
    Match := PatCnt = length(pat);
    exit
  end;

  Match := Match(str, pat, StrCnt + 1, PatCnt + 1)
end;

function CallMatch(str, pat: string): boolean;
begin
  CallMatch := Match(str, pat, 1, 1);
end;

BEGIN
  if ParamCount <> 2 then begin
    WriteLn('Two parameters expected');
    halt(1)
  end;

  if CallMatch(ParamStr(1), ParamStr(2)) then
    WriteLn('Matched')
  else
    WriteLn('No matches')
END.

