program module;

type
  QuestionType = (QHeight, QAmount);

{$DEFINE USE_CASE_OF}
{ or 'fpc -dUSE_CASE_OF learning.pas' }

function CheckUserInput(data_asked: integer;
                        question: questiontype): boolean;
begin
{$IFDEF USE_CASE_OF}
  case question of
    QHeight:
      CheckUserInput := (data_asked > 1) and (data_asked mod 2 = 1);
    QAmount:
      CheckUserInput := data_asked > 0;
    else
      WriteLn('Wrong type value');
      CheckUserInput := false
  end
{$ELSE}
  if question = QHeight then
    CheckUserInput := (data_asked > 1) and (data_asked mod 2 = 1)
  else if question = QAmount then
    CheckUserInput := data_asked > 0
  else
  begin
    WriteLn('Wrong type value');
    CheckUserInput := false
  end
{$ENDIF}
end;

procedure
AskValue(qsttext: string; var data_asked: integer; what: QuestionType);
begin
  while true do
  begin
    write(qsttext);
    readln(data_asked);
    if CheckUserInput(data_asked, what) then
      break;
    WriteLn('Incorrect value, write it again')
  end
end;

procedure PrintChars(amount: integer; symbol: char);
var
  i: integer;
begin
  for i := 1 to amount do
    write(symbol)
end;

procedure PrintDiamondLayer(dlayer, dheight, damount: integer);
var
  i: integer;
begin
  for i := 1 to damount do
  begin
    PrintChars(dheight - dlayer + 1, ' ');
    write('*');
    if dlayer > 1 then
    begin
      { We are inside the diamond }
      { 3 -- two stars and a space in the middle (?) }
      {                       V                      }
      PrintChars(2 * dlayer - 3, ' ');
      write('*')
    end;
    PrintChars(dheight - dlayer + 2, ' ')
  end;
  WriteLn
end;


procedure AskDiamondHeight(var dheight: integer);
const
  questiontext: string =
    'Enter height of your diamond (it has to be more then 1 and odd): ';
begin
  AskValue(questiontext, dheight, QHeight)
end;

procedure AskDiamondAmount(var damount: integer);
const
  questiontext: string = 'Enter amount of diamond you want to print: ';
begin
  AskValue(questiontext, damount, QAmount)
end;


procedure PrintDiamonds(damount, dheight: integer);
var
  halfheight, layer: integer;
begin
  halfheight := dheight div 2;
  for layer := 1 to halfheight + 1 do
  begin
    PrintDiamondLayer(layer, halfheight, damount)
  end;
  for layer := halfheight downto 1 do
  begin
    PrintDiamondLayer(layer, halfheight, damount)
  end
end;


var
  diamondheight, diamondamount: integer;
begin
  AskDiamondHeight(diamondheight);
  AskDiamondAmount(diamondamount);
  WriteLn;  { just for tests, e.g. 'printf "5\n5\n" | ./prog' }
  PrintDiamonds(diamondamount, diamondheight)
end.
