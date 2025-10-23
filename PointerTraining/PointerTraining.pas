Program PointerTraining;
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
  for i := 1 to DATA_ARRAY_LENGTH do
  begin
    DataArray[i] := i;
    write(DataArray[i], ' ');
  end;
  writeLn;
  writeLn;
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

procedure Array2ListReverse(var DataList  :list_ptr;
                                DataArray :data_array);
var
  tmp :list_ptr;
  i :integer;
begin
  for i := DATA_ARRAY_LENGTH downto 1 do
  begin
    new(tmp);
    tmp^.Data := DataArray[i];
    if DataList = nil then
      tmp^.NextElement := nil
    else
      tmp^.NextElement := DataList;
    DataList := tmp;
  end;
end;

procedure ReverseArray2ListReverse(var DataList  :list_ptr;
                                DataArray :data_array);
var
  tmp :list_ptr;
  i :integer;
begin
  for i := 1 to DATA_ARRAY_LENGTH do
  begin
    new(tmp);
    tmp^.Data := DataArray[i];
    if DataList = nil then
      tmp^.NextElement := nil
    else
      tmp^.NextElement := DataList;
    DataList := tmp;
  end;
end;

procedure CountListLength(Datalist :list_ptr);
var
  cnt :integer;
begin
  cnt := 0;
  while DataList <> nil do
  begin
    cnt := cnt + 1;
    DataList := DataList^.NextElement;
  end;
  writeLn(cnt);
end;

procedure SumProductList(DataList :list_ptr);
var
  sum, product :integer;
begin
  sum := 0;
  product := 1;
  while DataList <> nil do
  begin
    sum := sum + DataList^.Data;
    product := product * DataList^.Data;
    DataList := DataList^.NextElement;
  end;
  writeLn('Sum is - ', sum);
  writeLn('Product is - ', product);
end;

procedure MinMax(DataList :list_ptr);
var
  min, max :integer;
begin
  if DataList <> nil then
  begin
    min := DataList^.Data;
    max := DataList^.Data;
    while DataList <> nil do
    begin
      if min > DataList^.Data then
        min := DataList^.Data;
      if max < DataList^.Data then
        max := DataList^.Data;
      DataList := DataList^.NextElement;
    end;
    writeLn('Least element is - ', min);
    writeLn('Greatest element is - ', max);
  end
  else
    writeLn('No elements found list is empty');
end;

procedure OddElementsOnly(var DataList :list_ptr);
var
  ToDeletion, PrevElement, cur :list_ptr;
begin
  cur := DataList;
  PrevElement := nil;
  ToDeletion := nil;
  while cur <> nil do
  begin
    if (cur^.Data mod 2) = 0 then
    begin
      ToDeletion := cur;
      if cur = DataList then
        DataList := DataList^.NextElement
      else
        PrevElement^.NextElement := cur^.NextElement;
      cur := cur^.NextElement;
      dispose(ToDeletion);
    end
    else
    begin
      PrevElement := cur;
      cur := cur^.NextElement;
    end;
  end;
end;

procedure Reverse(var DataList :list_ptr);
var
 exchange, tmp :list_ptr;
begin
  exchange := nil;
  while DataList <> nil do
  begin
    tmp := DataList;
    DataList := DataList^.NextElement;
    tmp^.NextElement := exchange;
    exchange := tmp;
  end;
  DataList := exchange;
end;

  { ================ WRAPPING PROCEDURES ============= }
procedure WriteDispose(var DataList :list_ptr);
begin
  WriteList(DataList);
  writeLn;
  DisposeListLoop(DataList);
end;

procedure FillListStraight(var DataList :list_ptr; DataArray :data_array);
begin
  Array2ListStraight(DataList, DataArray);
  WriteDispose(DataList);
end;

procedure FillListReverse(var DataList :list_ptr; DataArray :data_array);
begin
  Array2ListReverse(DataList, DataArray);
  WriteDispose(DataList);
end;

procedure ReverseFillListReverse(var DataList  :list_ptr;
                                     DataArray :data_array);
begin
  ReverseArray2ListReverse(DataList, DataArray);
  WriteDispose(DataList);
end;

procedure CountList(var DataList :list_ptr; DataArray :data_array);
begin
  Array2ListStraight(DataList, DataArray);
  CountListLength(DataList);
  DisposeListLoop(DataList);
  writeLn;
end;

procedure MathList(var DataList :list_ptr; DataArray :data_array);
begin
  Array2ListStraight(DataList, DataArray);
  SumProductList(DataList);
  DisposeListLoop(DataList);
  writeLn;
end;

procedure MinMaxList(var DataList :list_ptr; DataArray :data_array);
begin
  {Array2ListStraight(DataList, DataArray);}
  MinMax(DataList);
  DisposeListLoop(DataList);
  writeLn;
end;

procedure OddElementsOnlyList(var DataList  :list_ptr;
                                  DataArray :data_array);
begin
  Array2ListStraight(DataList, DataArray);
  OddElementsOnly(DataList);
  WriteDispose(DataList);
end;

procedure ReverseList(var DataList :list_ptr; DataArray :data_array);
begin
  Array2ListStraight(DataList, DataArray);
  Reverse(DataList);
  WriteDispose(DataList);
end;

var
  DataArray :data_array;
  DataList  :list_ptr;

begin
  { ================ PRINTING RESULT ===================}
  { Exercises on creating list }
  writeLn('Original Array: ');
  CreateArray(DataArray);

  writeLn('Array put in list by adding to the beginning');
  FillListStraight(DataList, DataArray);

  writeLn('Array put in list by adding to the ending');
  FillListReverse(DataList, DataArray);

  writeLn('Reversed array put in list by adding to the beginning');
  ReverseFillListReverse(DataList, DataArray);

  { Exercises on printing out list }
  writeLn('Printing list with a loop');
  FillListStraight(DataList, DataArray);

  writeLn('Counting length of the list with loop');
  CountList(DataList, DataArray);

  writeLn('Getting sum and product of all elements of the list');
  MathList(DataList, DataArray);

  writeLn('Getting least and greatest numbers from list');
  MinMaxList(DataList, DataArray);

  writeLn('Getting odd numbers from list');
  OddElementsOnlyList(DataList, DataArray);

  writeLn('Turn list around');
  ReverseList(DataList, DataArray);

  { Exercises on disposing list }
  writeLn('List disposed with a loop');
  DisposeListLoop(DataList);
  Write('What`s left of list: ');
  WriteList(DataList);
end.
