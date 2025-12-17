Program Learning_stuff;

const
  ARR_LENGTH = 15;

  LINELENGTH = 40;

  OPT_DEFAULT    = 0;
  OPT_PUSH_FRONT = 1;
  OPT_PUSH_BACK  = 2;
  OPT_POP_FRONT  = 3;
  OPT_POP_BACK   = 4;
  OPT_EXIT       = 5;

type
  long_item_ptr = ^long_item;
  long_item = record
    Data :longint;
    PrevElem, NextElem :long_item_ptr;
  end;

  long_deque = record
    FirstElem, LastElem: long_item_ptr;
  end;

  {controls = record
    PushEnd}

  long_array = array [1..15] of longint;

procedure ArrayInit(var arr: long_array);
var
  i :integer;
begin
  for i := 1 to ARR_LENGTH do
    arr[i] := i;
end;

function DequeIsEmpty(var deque :long_deque): boolean;
begin
  DequeIsEmpty := (deque.FirstElem = nil);
end;

procedure LongDequePushFront(var deque: long_deque; num :longint);
var
  tmp :long_item_ptr;
begin
  new(tmp);
  tmp^.Data := num;
  tmp^.PrevElem := nil;
  tmp^.NextElem := deque.FirstElem;
  if DequeIsEmpty(deque) then
    deque.LastElem := tmp
  else
    deque.FirstElem^.PrevElem := tmp;
  deque.FirstElem := tmp;
end;

procedure LongDequePushBack(var deque :long_deque; num :longint);
var
  tmp :long_item_ptr;
begin
  new(tmp);
  tmp^.Data := num;
  tmp^.NextElem := nil;
  tmp^.PrevElem := deque.LastElem;
  if DequeIsEmpty(deque) then
    deque.FirstElem := tmp
  else
    deque.LastElem^.NextElem := tmp;
  deque.LastElem := tmp;
end;

procedure LongDequePopFront(var deque :long_deque; var num :longint);
var
  tmp :long_item_ptr;
begin
  if DequeIsEmpty(deque) then
    exit;
  tmp := deque.FirstElem;
  num := deque.FirstElem^.Data;
  deque.FirstElem := deque.FirstElem^.NextElem;
  if deque.FirstElem = nil then
    deque.LastElem := nil
  else
    deque.FirstElem^.PrevElem := nil;
  dispose(tmp);
end;

procedure LongDequePopBack(var deque :long_deque; var num :longint);
var
  tmp :long_item_ptr;
begin
  if DequeIsEmpty(deque) then
    exit;
  tmp := deque.LastElem;
  num := deque.LastElem^.Data;
  deque.LastElem := deque.LastElem^.PrevElem;
  if deque.LastElem = nil then
    deque.FirstElem := nil
  else
    deque.LastElem^.NextElem := nil;
  dispose(tmp);
end;

procedure FillDeque(var deque :long_deque; arr :long_array);
var
  i :integer;
begin
  for i := 1 to ARR_LENGTH do
    LongDequePushBack(deque, arr[i]);
end;

procedure WriteDeque(var deque :long_deque);
var
  cur :long_item_ptr;
  i :integer;
begin
  cur := deque.FirstElem;
  i := 0;
  while cur <> nil do
  begin
    i := i + 1;
    writeLn(i, '. - ', cur^.Data);
    cur := cur^.NextElem;
  end;
  writeLn;
end;

procedure ReadLongint(var num:longint);
begin
  {$I-}
  while true do
  begin
    readLn(num);
    if IOResult = 0 then
      break;
    writeLn('Wrong data type');
  end;
  {$I+}
end;


procedure Controls(var deque :long_deque; UserInput :integer;
                   var num :longint);
begin
  case UserInput of
    OPT_PUSH_FRONT: begin
      writeLn('Enter new number to place in front of deque');
      ReadLongint(num);
      LongDequePushFront(deque, num);
    end;
    OPT_PUSH_BACK: begin
      writeLn('Enter new number to place in end of deque');
      ReadLongint(num);
      LongDequePushBack(deque, num);
    end;
    OPT_POP_FRONT: begin
      if DequeIsEmpty(deque) then
        writeLn('Cannot pop element from the deque')
      else
      begin
        LongDequePopFront(deque, num);
        writeLn('Popped form beginning number - ', num);
      end;
    end;
    OPT_POP_BACK: begin
      if DequeIsEmpty(deque) then
        writeLn('Cannot pop element from the deque')
      else
      begin
        LongDequePopBack(deque, num);
        writeLn('Popped form ending number - ', num);
      end;
    end;
  end;
end;

  { ============= WRAPPER PROCEDURES ============= }

procedure InitDeque(var deque :long_deque);
begin
  deque.FirstElem := nil;
  deque.LastElem  := nil;
end;

procedure WriteLine;
var
  i :integer;
begin
  for i := 1 to LINELENGTH do
    write('-');
end;

procedure WriteControls;
begin
  writeLn(OPT_PUSH_FRONT, '. Push number to beginnig');
  writeLn(OPT_PUSH_BACK, '. Push number to ending');
  writeLn(OPT_POP_FRONT, '. Pop number from beginning');
  writeLn(OPT_POP_BACK, '. Pop number from ending');
  writeLn(OPT_EXIT, '. Exit');
  writeLn;
end;

var
  arr       :long_array;
  deque     :long_deque;
  UserInput :integer;
  num       :longint;
begin
  {$I-}
  InitDeque(deque);
  ArrayInit(arr);
  FillDeque(deque, arr);

  UserInput := OPT_DEFAULT;
  while not (UserInput = OPT_EXIT) do
  begin
    WriteLine;
    writeLn;
    writeLn;
    if not DequeIsEmpty(deque) then
      WriteDeque(deque);
    WriteControls;
    readln(UserInput);
    if IOResult = 1 then
    begin
      writeLn('Wrong data type');
      UserInput := OPT_DEFAULT;
    end;
    writeLn;
    Controls(deque, UserInput, num);
  end;
end.

