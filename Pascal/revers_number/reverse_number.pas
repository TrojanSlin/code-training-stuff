program revers_number;

function pow(number, power: integer): longint;
var
  i, count: longint;
begin
  count := 1;
  if number < 0 then begin
    number := - number;
  end;
  for i := 1 to power do begin
    count := count * number
  end;
  pow := count
end;

procedure reverso(number: integer);
var
  i: integer = 0;
  n: integer;
begin
  n := number;
  while(n > 9) do begin
    i := i + 1;
    n := n div 10
  end;
  for n := 0 to i do begin
    write((number div pow(10, n)) mod 10)
  end;
  writeln;
end;

var
  usrnum: integer;
begin

  write('Enter number to reverse: ');
  readln(usrnum);

  {writeln(pow(10, usrnum))}

  reverso(usrnum)

end.
