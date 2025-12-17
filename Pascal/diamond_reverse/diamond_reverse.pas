program module;
var

  diamondheight, halfheight, layer: integer;

procedure print_sym(amount: integer; sym: char);
var
  i: integer;
begin
  for i := 1 to amount do begin
    write(sym);
  end;
end;

procedure print_diamond_layer(dlayer, dheight: integer);
begin
  print_sym(dheight - dlayer + 1, '*');
  write('*');
  if dlayer > 1 then begin
    print_sym(2 * dlayer - 3, ' ');
    write('*')
  end;
  print_sym(dheight - dlayer + 1, '*');
  writeln;
end;

begin

  repeat
    write('Enter height of your diamond (it has to be more then 1 and odd): ');
    readln(diamondheight)
  until (diamondheight > 1) and (diamondheight mod 2 = 1);

  writeln('Number entered');
  halfheight := diamondheight div 2;

  for layer := 1 to halfheight + 1 do begin
    print_diamond_layer(layer, halfheight)
  end;

  for layer := halfheight downto 1 do begin
    print_diamond_layer(layer, halfheight)
  end

end.
