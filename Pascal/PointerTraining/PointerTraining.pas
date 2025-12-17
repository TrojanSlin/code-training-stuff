Program PointerTraining;
{$DEFINE RANDOM_NUMS}
{DEFINE DEBUG}

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

procedure WriteListRec(DataList: list_ptr);
begin
  if DataList <> nil then
    Write(DataList^.Data,' ')
  else
    exit;
  WriteListRec(DataList^.NextElement)
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

procedure DisposeListRec(var DataList :list_ptr);
begin
  if DataList = nil then begin
    exit
  end;
  DisposeListRec(DataList^.NextElement);
  dispose(DataList);
  DataList := nil;
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

function CountListLengthRec(DataList: list_ptr): integer;
begin
  if DataList^.NextElement <> nil then
    CountListLengthRec := CountListLengthRec(DataList^.NextElement) + 1
  else
    CountListLengthRec := 1
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
    {product := product * DataList^.Data;}
    DataList := DataList^.NextElement;
  end;
  writeLn('Sum is - ', sum);
  writeLn('Product is - ', product);
end;

function SumListRec(DataList: list_ptr): integer;
begin
  if DataList <> nil then
    SumListRec :=
      SumListRec(DataList^.NextElement) + DataList^.Data
  else
    SumListRec := 0
end;

function ProductListRec(DataList: list_ptr): integer;
begin
  if DataList <> nil then
    {ProductListRec :=
      ProductListRec(DataList^.NextElement) * DataList^.Data}
  else
    ProductListRec := 1
end;

procedure MinMax(DataList :list_ptr; var min, max :integer;
                 var ListExists :boolean);
begin
  ListExists := false;
  if not (DataList <> nil) then
    exit;

  min := DataList^.Data;
  max := DataList^.Data;
  ListExists := true;
  DataList := DataList^.NextElement;
  while DataList <> nil do
  begin
    if min > DataList^.Data then
      min := DataList^.Data;
    if max < DataList^.Data then
      max := DataList^.Data;
    DataList := DataList^.NextElement;
  end;
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

procedure OddElementsOnlyPtr(var DataList :list_ptr);
var
  ListPtr :^list_ptr;
  tmp :list_ptr;
begin
  ListPtr := @DataList;
  while ListPtr^ <> nil do
  begin
    if (ListPtr^^.Data mod 2 = 0) then
    begin
      tmp := ListPtr^;
      ListPtr^ := ListPtr^^.NextElement;
      dispose(tmp);
    end
    else
      ListPtr := @(ListPtr^^.NextElement);
  end;
end;

procedure OddElementsOnlyRec(var DataList :list_ptr);
var
  tmp: list_ptr;
begin
  if DataList = nil then
    exit;

  OddElementsOnlyRec(DataList^.NextElement);

  if (DataList^.Data mod 2 = 0) then begin
    new(tmp);
    tmp := DataList;
    DataList := DataList^.NextElement;
    dispose(tmp)
  end
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

procedure Unite2ListsPtr(var DataList, DataList2 :list_ptr);
var
  ListPtr :^list_ptr;
begin
  ListPtr := @DataList;
  while ListPtr^ <> nil do
    ListPtr := @ListPtr^^.NextElement;
  ListPtr^ := DataList2;
  DataList2 := nil;
end;

function Sorted(var DataList: list_ptr): boolean;
begin
  {$IFDEF DEBUG}
  CountListLength(Datalist);
  {$ENDIF}
  if (DataList = nil) or (DataList^.NextElement = nil) then begin
    Sorted := true;
    exit
  end;

  if (DataList^.NextElement^.Data <= DataList^.Data) then
    Sorted := Sorted(DataList^.NextElement)
  else
    Sorted := false;
end;

procedure SortList(var DataList: list_ptr);
var
  tmp: integer;
begin
  if DataList^.NextElement = nil then
    exit;

  if DataList^.NextElement^.Data > DataList^.Data then begin
    tmp := DataList^.NextElement^.Data;
    DataList^.NextElement^.Data := DataList^.Data;
    DataList^.Data := tmp;
    exit
  end;
  SortList(DataList^.NextElement)
end;

procedure SortListWrap(var DataList: list_ptr);
begin
  while not Sorted(DataList) do begin
    SortList(DataList);
    {$IFDEF DEBUG}
    if Sorted(DataList) then writeLn('sorted')
    else writeLn('not sorted');
    WriteList(DataList)
    {$ENDIF}
  end;
end;

procedure DivideByKey(var DataList, ResLess, ResMore: list_ptr; key: integer);
var
  CurLess, CurMore: ^list_ptr;
  tmp: list_ptr;
begin
  ResLess := nil;
  ResMore := nil;
  CurLess := @ResLess;
  CurMore := @ResMore;
  while DataList <> nil do begin
    tmp := DataList;
    DataList := DataList^.NextElement;
    if tmp^.Data >= key then begin
      CurMore^ := tmp;
      CurMore^^.NextElement := nil;
      CurMore := @CurMore^^.NextElement;
    end
    else begin
      CurLess^ := tmp;
      CurLess^^.NextElement := nil;
      CurLess := @CurLess^^.NextElement;
    end
  end
end;

procedure OtherSort(var DataList, cur: list_ptr);
var
  tmp: integer;
begin
  if cur^.NextElement = nil then
    exit;

  if cur^.Data > cur^.NextElement^.Data then begin
    tmp := cur^.Data;
    cur^.Data := cur^.NextElement^.Data;
    cur^.NextElement^.Data := tmp;
    OtherSort(DataList, DataList)
  end
  else
    OtherSort(DataList, cur^.NextElement)
end;

procedure OtherOtherSort(var DataList: list_ptr);
var
  ResLess, ResMore, tmp: list_ptr;
begin
  if (DataList = nil) or (DataList^.NextElement = nil) then
    exit;
  tmp := DataList;
  DataList := DataList^.NextElement;
  tmp^.NextElement := nil;

  {$IFDEF DEBUG}
  write('Datalist - ');
  WriteList(DataList);
  {$ENDIF}

  DivideByKey(DataList, ResLess, ResMore, tmp^.Data);

  {$IFDEF DEBUG}
  write('tmp list - ');
  WriteList(tmp);
  write('ResMore list - ');
  WriteList(ResMore);
  write('ResLess list - ');
  WriteList(ResLess);
  writeLn;
  {$ENDIF}

  OtherOtherSort(ResLess);
  OtherOtherSort(ResMore);
  tmp^.NextElement := ResMore;
  ResMore := tmp;
  Unite2ListsPtr(ResLess, ResMore);
  DataList := ResLess
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
  writeLn('Printing list with loop');
  Array2ListStraight(DataList, DataArray);
  WriteList(DataList);
  writeLn('Printing list with recursion');
  WriteListRec(DataList);
  writeLn;
  DisposeListLoop(DataList);
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
  writeLn('Counting length of the list with loop and with recursion');
  Array2ListStraight(DataList, DataArray);
  CountListLength(DataList);
  writeLn(CountListLengthRec(DataList));
  DisposeListLoop(DataList);
  writeLn;
end;

procedure MathList(var DataList :list_ptr; DataArray :data_array);
begin
  writeLn('Sum and product of all elements of the list with loop and recursion');
  Array2ListStraight(DataList, DataArray);
  SumProductList(DataList);
  writeLn;
  writeLn('Sum is - ', SumListRec(DataList));
  writeLn('Product is - ', ProductListRec(DataList));
  DisposeListLoop(DataList);
  writeLn;
end;

procedure MinMaxList(var DataList :list_ptr; DataArray :data_array);
var
  min, max :integer;
  ListExists :boolean;
begin
  writeLn('Getting least and greatest numbers from list');
  ListExists := false;
  Array2ListStraight(DataList, DataArray);
  MinMax(DataList, min, max, ListExists);
  if ListExists then
  begin
    writeLn('Least element is - ', min);
    writeLn('Greatest element is - ', max);
  end
  else
    writeLn('List doesn`t exists');
  DisposeListLoop(DataList);
  writeLn;
end;

procedure OddElementsOnlyList(var DataList  :list_ptr;
                                  DataArray :data_array);
begin
  writeLn('Getting odd numbers from list');
  Array2ListStraight(DataList, DataArray);
  OddElementsOnly(DataList);
  WriteDispose(DataList);
  writeLn('Getting odd numbers from list with pointer on pointer');
  Array2ListStraight(DataList, DataArray);
  OddElementsOnlyPtr(DataList);
  WriteDispose(DataList);
  writeLn('Getting odd numbers from list with recursion');
  Array2ListStraight(DataList, DataArray);
  OddElementsOnlyRec(DataList);
  WriteDispose(DataList);
end;

procedure ReverseList(var DataList :list_ptr; DataArray :data_array);
begin
  writeLn('Turn list around');
  Array2ListStraight(DataList, DataArray);
  Reverse(DataList);
  WriteDispose(DataList);
end;

procedure Unite2ListsPtrList(var DataList, DataList2 :list_ptr;
                                DataArray :data_array);
begin
  writeLn('Unite two lists in 1 with pointer on pointer');
  Array2ListStraight(DataList, DataArray);
  Array2ListStraight(DataList2, DataArray);
  Unite2ListsPtr(DataList, DataList2);
  WriteDispose(DataList);
end;

procedure SortingThingsOut(var DataList :list_ptr; DataArray :data_array);
begin
  ReverseArray2ListReverse(DataList, DataArray);
  WriteLn('Sorting reverse list');
  WriteList(DataList);
  writeLn('After sorting');
  SortListWrap(DataList);
  WriteDispose(DataList);

  Array2ListReverse(DataList, DataArray);
  WriteLn('Sorting straight list');
  WriteList(DataList);
  writeLn('After sorting');
  SortListWrap(DataList);
  WriteDispose(DataList);
end;

procedure DividingList(var Datalist: list_ptr; DataArray: data_array);
var
  ResMore, ResLess: list_ptr;
  key: integer;
begin
  key := 0;
  Array2ListReverse(DataList, DataArray);
  WriteLn('Dividing list by ', key, ' key');
  WriteList(DataList);
  DivideByKey(DataList, ResLess, ResMore, key);

  writeLn('After dividing');
  writeLn('More then key');
  WriteDispose(ResMore);

  writeLn('Less then key');
  WriteDispose(ResLess);

  writeLn('Original list');
  WriteDispose(DataList);
end;

procedure OtherSortingOut(var DataList :list_ptr; DataArray :data_array);
begin
  Array2ListReverse(DataList, DataArray);
  WriteLn('Sorting straight list');
  OtherSort(DataList, DataList);
  WriteDispose(DataList);
end;

procedure OtherOtherSorting(var DataList: list_ptr; DataArray: data_array);
begin
  Array2ListReverse(DataList, DataArray);
  {$IFDEF DEBUG}
  writeLn('Orig list');
  WriteList(DataList);
  {$ENDIF}
  WriteLn('Fast sorting list');
  OtherOtherSort(DataList);
  WriteDispose(DataList);
end;

var
  DataArray :data_array;
  DataList, DataList2 :list_ptr;

begin
  randomize;
  { ================ PRINTING RESULT ===================}
  { Exercises on creating list }
  CreateArray(DataArray);

  writeLn('Array put in list by adding to the beginning');
  FillListStraight(DataList, DataArray);

  writeLn('Array put in list by adding to the ending');
  FillListReverse(DataList, DataArray);

  writeLn('Reversed array put in list by adding to the beginning');
  ReverseFillListReverse(DataList, DataArray);

  { Exercises on printing out list }
  FillListStraight(DataList, DataArray);

  CountList(DataList, DataArray);

  MathList(DataList, DataArray);

  MinMaxList(DataList, DataArray);

  OddElementsOnlyList(DataList, DataArray);

  ReverseList(DataList, DataArray);

  Unite2ListsPtrList(DataList, DataList2, DataArray);

  { Exercises on disposing list }
  Array2ListStraight(DataList, DataArray);
  writeLn('List disposed with a loop');
  DisposeListLoop(DataList);
  Write('What`s left of list: ');
  WriteList(DataList);

  Array2ListStraight(DataList, DataArray);
  writeLn('List disposed with a recursion');
  DisposeListRec(DataList);
  Write('What`s left of list: ');
  WriteList(DataList);

  SortingThingsOut(DataList, DataArray);

  DividingList(DataList, DataArray);

  OtherSortingOut(DataList, DataArray);

  OtherOtherSorting(DataList, DataArray);
end.
