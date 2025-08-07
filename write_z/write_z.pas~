program printZ;

type
  QuestionType = (typeHeight, typeAmount);
  DotPosition = (onTop, onBottom);

{ code wrote before, doesn`t need checking }
function CheckUserInput(data_asked: integer;
                        question: QuestionType): boolean;
begin
  if question = typeHeight then
    CheckUserInput := (data_asked >= 5) and (data_asked mod 2 = 1)
  else if question = typeAmount then
    CheckUserInput := data_asked > 0
  else
  begin
    writeLn('Wrong type value');
    CheckUserInput := false;
  end;
end;

procedure
AskValue(qst_text: string; var data_asked: integer; question: QuestionType);
begin
  while true do
  begin
    write(qst_text);
    readLn(data_asked);
    if CheckUserInput(data_asked, question) then
      break;
    writeLn('Incorrect value, write it again')
  end
end;

procedure AskHeight(var height: integer);
const
  question_text: string =
    'Enter height of your SVO ZZZ(it has to be more then 5 and odd): ';
begin
  AskValue(question_text, height, typeHeight);
end;

procedure AskAmount(var amount: integer);
const
  question_text: string = 'Enter amount of your SVO ZZZ: ';
begin
  AskValue(question_text, amount, typeAmount);
end;

procedure PrintChars(amount: integer; symbol: char);
var
  i: integer;
begin
  for i := 1 to amount do
    write(symbol);
end;
{ ^ code wrote before, doesn`t need checking }

procedure WriteSpaces(spaces: integer);
begin
  PrintChars(spaces, ' ');
end;

procedure Tabulation(line_length, position: integer);
var
  spaces: integer;
begin
  spaces := (position - 1) * line_length;
  if position > 1 then
    spaces := spaces + position - 1;

  WriteSpaces(spaces);
end;

procedure WriteLine(line_length, amount: integer);
var
  i: integer;
begin
  for i := 1 to amount do
  begin
    PrintChars(line_length, '*');
    write(' ');
  end;
end;

procedure WriteDot(line_length, dot_line: integer; position: DotPosition);
var
  top_spaces, bot_spaces: integer;
begin
  top_spaces := line_length - dot_line - 1;
  bot_spaces := (line_length div 2) - dot_line;

  if position = onTop then 
  begin
    WriteSpaces(top_spaces);
    write('*');
  end
  else
  begin
    WriteSpaces(bot_spaces);
    write('*');
    WriteSpaces((line_length div 2) + dot_line + 1);
  end;
end;

procedure WriteCrossLines(height, position, amount: integer);
var
  i: integer;
begin
  for i := 1 to ((height div 2) - 1) do
  begin
    Tabulation(height, position);
    if (position > 0) and (position <= amount) then
      WriteDot(height, i, onBottom);
    if (position < amount) then
      WriteDot(height, i, onTop);
    writeLn;
  end;
end;

procedure PrintZ(height: integer; amount: integer);
var
   position: integer;
begin
  WriteLine(height, 1);
  writeLn;
  for position := 0 to amount do
  begin
    WriteCrossLines(height, position, amount);
    Tabulation(height, position);
    WriteLine(height, 1);

    if (amount > 1) and (position < amount) then { condition to write second line }
      WriteLine(height, 1);
    if (position >= 1) and (position < amount - 1) then { condition to write third line }
      WriteLine(height, 1);
    writeLn;
  end;
end;

var
  height, amount: integer;
begin
  AskHeight(height);
  AskAmount(amount);
  WriteLn;  { just for tests, e.g. 'printf "5\n5\n" | ./prog' }
  PrintZ(height, amount);
end.
