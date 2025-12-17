Program prog1;

const
  DATA_ARRAY_LENGTH = 15;
type
  data_array = array [1..DATA_ARRAY_LENGTH] of integer;

  list_ptr = ^list;
  list = record
     Data :integer;
     NextElement :list_ptr;
  end;

  { =============== EXERCISES ITSELF ================= }
procedure CreateArray(var DataArray :data_array);
var
  i :integer;
begin
  writeLn('Original Array: ');
  for i := 1 to DATA_ARRAY_LENGTH do
  begin
    DataArray[i] :=
     {$IFDEF RANDOM_NUMS}
       -DATA_ARRAY_LENGTH + random(2*DATA_ARRAY_LENGTH + 1);
     {$ELSE}
       i;
     {$ENDIF}
    write(DataArray[i], ' ')
  end;
  writeLn;
  writeLn
end;

procedure WriteList(DataList :list_ptr);
begin
  while DataList <> nil do
  begin
    write(DataList^.Data, ' ');
    DataList := DataList^.NextElement;
  end;
  writeLn;
end;

procedure DisposeListLoop(var DataList :list_ptr);
var
  cur :list_ptr;
begin
  while DataList <> nil do
  begin
   cur := DataList;
   DataList := DataList^.NextElement;
   dispose(cur);
  end;
end;

procedure Array2ListStraight(var DataList  :list_ptr;
                                 DataArray :data_array);
var
  tmp, cur :list_ptr;
  i :integer;
begin
  cur := nil;
  for i := 1 to DATA_ARRAY_LENGTH do
  begin
    new(tmp);
    tmp^.Data := DataArray[i];
    tmp^.NextElement := nil;
    if DataList = nil then
    begin
      DataList := tmp;
    end
    else
      cur^.NextElement := tmp;
    cur := tmp;
  end;
end;

procedure ReverseList(var lst: list_ptr);
var
  tmp, res: list_ptr;
begin
  res := nil;
  while lst <> nil do begin
    tmp := lst;
    lst := lst^.NextElement;
    tmp^.NextElement := res;
    res := tmp
  end;
  lst := res
end;

procedure SortList(var lst: list_ptr);
var
  res, tmp, tmp2: list_ptr;
begin
  res := nil;
  while lst <> nil do begin
    TMP := lst;
    lst := lst^.NextElement;
    tmp2 := res;
    while (tmp2 <> nil) and (tmp2^.Data < tmp^.data) do
      tmp2 := tmp2^.NextElement;
    if tmp2 = res then begin
      tmp^.NextElement := res;
      res := tmp
    end else begin
      tmp^.NextElement := tmp2^.NextElement;
      tmp2^.NextElement := tmp
    end
  end;
  lst := res;
end;

var
  arr: data_array;
  lst: list_ptr;
begin
  CreateArray(arr);

  Array2ListStraight(lst, arr);
  WriteList(lst);
  writeLn;

  writeLn('Reversed List');
  ReverseList(lst);
  WriteList(lst);
  SortList(lst);
  WriteList(lst)
end.
