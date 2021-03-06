//Соловьев К. А.
//#66
//Создание калькулятора с решением в столбик
unit Calculator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TCalculatorForSC }

  TCalculatorForSC = class(TForm)
    Calculate: TButton;
    ComboBox: TComboBox;
    Number1: TEdit;
    Number2: TEdit;
    Image1: TImage;
    procedure CalculateClick(Sender: TObject);//Кнопка "="
    procedure ColumnForDivision(q: string; Edit1Low: boolean; //Столбик для деления
                                Ed1: string;
                                Ed2: string; MLow: string);
    procedure ColumnFormultiplication(Ed1:string; Ed2: string); //столбик для умножения
    procedure ColumnForAddition(Ed1:string; Ed2: string); //столбик для сложения
    procedure ComboBoxChange(Sender: TObject); //Выблор действия
    procedure division(div1: integer; div2: integer; //деление
                       k1: integer; Ed1: string;
                       Ed2: string; OstFromDelStr: string);
    procedure Number1KeyPress(Sender: TObject; var Key: char);//Ограничение вводимых символов
    procedure Number2KeyPress(Sender: TObject; var Key: char);//Ограничение вводимых символов
    procedure multiplication(Ed1: string; Ed2:String);//Умножение
    procedure FormCreate(Sender: TObject);
    procedure ColumnForSubtraction(Ed1:string; Ed2: string);//Столбик для вычитания
    procedure MoreElemForDiv(var yVic1: integer;            //Рисует одну из частей
                             var xVic1: integer; s1: string;//столбца для деления
                             var yOst1: integer; var xOst1: integer; r1: string);
    procedure FracInPut(var buffEd1: String; // Вывод дробных чисел для
                        var buffEd2: String; PartEd1: String; PartEd2: string;
                        x: integer; y: integer; x1: integer;  y1: integer;
                        var fz: integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  CalculatorForSC: TCalculatorForSC;
  boo1: boolean;
  piz: integer;
  SelectAct: integer;
implementation

{$R *.lfm}

{ TCalculatorForSC }

function pow(var Mfor: integer):integer; //Добавляет к числу нужное кол-во нулей
var
   i1: integer;
begin
 if Mfor = 0 then
 begin
   pow:= 1;
 end
 else
 begin
   pow:=1;
   for i1:= 1 to Mfor do
   begin
     pow:= pow * 10;
   end;
 end;
end;

procedure IfFrac(var Edit1Text: string; var Edit2Text: string; // Если встречено дробное число
                 var ZerosPlus: integer; var Ed1Zeros: integer);
var
   Factor, factor2: integer;
   k, kk, plus0: integer;
   ch, ch2: char;
   brya, chB0, Not0: boolean;
begin
  Not0:= false;
  chB0:= true;
  factor:=0;
  factor2:=0;
  k:= Length(Edit1Text);
  kk:= Length(Edit2Text);
  brya:= false;
  repeat
    ch:= Edit1Text[k];
    if ((pos(',', Edit1Text) = 0)) then begin
      Not0:= true;
    end
    else
    begin
      if ((ch = '0') and (chB0)) and ((pos(',', Edit1Text) > 0)) then begin
        delete(Edit1Text, k, 1);
        k:=k-1;
      end
      else
      begin
        chB0:= false;
        k:=k-1;
        if (ch <> ',') then
          inc(factor);
      end;
    end;
  until (ch = ',') or (k = 0) or (Not0);
  chB0:= true;
  not0:= false;
  repeat
    ch2:= Edit2Text[kk];
    if ((pos(',', Edit2Text) = 0)) then begin
      Not0:= true;
    end
    else
    begin
      if (ch2 = '0') and (chB0) and ((pos(',', Edit2Text) > 0)) then begin
        delete(Edit2Text, kk, 1);
        kk:=kk-1;
      end
      else
      begin
        chB0:= false;
        kk:=kk-1;
        if (ch2 <> ',') then
          inc(factor2);
      end;
    end;
  until (ch2 = ',') or (kk = 0) or (Not0);
  if (Pos(',', Edit1Text) <> 0) or (Pos(',', Edit2Text) <> 0) then begin
    if pos(',', Edit2Text) > 0 then begin
      Plus0:= factor2 - factor;
      factor:= factor2;
      brya:= true;
    end;
    Delete(Edit1Text, pos(',', Edit1Text), 1);
    repeat
      if Edit1Text[1] = '0' then begin
        delete(Edit1Text, 1, 1);
        ch:= Edit1Text[1];
      end;
    until ch <> '0';
    if brya then begin
      Delete(Edit2Text, pos(',', Edit2Text), 1);
      repeat
        if Edit2Text[1] = '0' then begin
          delete(Edit2Text, 1, 1);
          ch:= Edit2Text[1];
        end;
      until ch <> '0';
      if plus0 < 0 then begin
        plus0:= abs(plus0);
        ZerosPlus:= Plus0;
        while Plus0 <> 0 do begin
          Edit2Text:= Edit2Text + '0';
          Plus0:= Plus0 - 1;
        end;
      end
      else
      begin
        Ed1Zeros:= Plus0;
        while Plus0 <> 0 do begin
          Edit1Text:= Edit1Text + '0';
          Plus0:= Plus0 - 1;
        end;
      end;
    end
    else
    begin
      Edit2Text:= IntToStr(StrToInt(Edit2Text)*(pow(factor)));
      ZerosPlus:= factor;
    end;
  end;
end;

procedure TCalculatorForSC.MoreElemForDiv(var yVic1: integer; var xVic1: integer; s1: string;
                           var yOst1: integer; var xOst1: integer; r1: string);
var
   xLine: integer;
begin
  if boo1 then begin
  yVic1:= yVic1+(20)+Image1.Canvas.TextHeight(s1);
  end
  else
  yVic1:= yVic1+(Image1.Canvas.TextHeight(s1));
  yOst1:= yVic1+(Image1.Canvas.TextHeight(r1));
  boo1:=false;
  Image1.Canvas.TextOut(xVic1,yVic1,s1);
  Image1.Canvas.TextOut(xVic1-20,yVic1-20,'-');
  Image1.Canvas.TextOut(xOst1,yOst1,r1);
  xLine:= Image1.Canvas.TextWidth(s1);
  Image1.Canvas.Line(xVic1,yOst1,xLine+xVic1,yOst1);
  xVic1:=xOst1;
  yVic1:=yOst1;
end;

procedure TCalculatorForSC.ColumnForDivision
(q: string; Edit1Low: boolean; Ed1: string; Ed2: string; MLow: string);
var
    PenW: integer;
    x, x1, y: integer;
begin
  PenW:= 3;
  if Edit1Low then
  begin
    Image1.Canvas.TextOut(20,20,Ed1); //Делимое
    Image1.Canvas.Pen.Width:= PenW;
    x:= Image1.Canvas.TextWidth(MLow);
    y:= Image1.Canvas.TextHeight(MLow);
    Image1.Canvas.Line(x+20+PenW,20,x+20+PenW,60+y);
    Image1.Canvas.TextOut(x+20+PenW*2,20,Ed2);  //Делитель
    x1:= Image1.Canvas.TextWidth(q);
    Image1.Canvas.Line(x+20+PenW*2,y+20,x1+x+20+PenW*2,y+20);
    Image1.Canvas.TextOut(x+20+PenW*2,y+20+PenW,q); //Вывод частного
    //PenW:= 0;
  end
  else
  begin
  Image1.Canvas.TextOut(20,20,Ed1);  //Делимое
  Image1.Canvas.Pen.Width:= PenW;
  x:= Image1.Canvas.TextWidth(Ed1);
  y:= Image1.Canvas.TextHeight(Ed1);
  Image1.Canvas.Line(x+20+PenW,20,x+20+PenW,60+y);
  Image1.Canvas.TextOut(x+20+PenW*2,20,Ed2);  //Делитель
  x1:= Image1.Canvas.TextWidth(q);
  Image1.Canvas.Line(x+20+PenW*2,y+20,x1+x+20+PenW*2,y+20);
  Image1.Canvas.TextOut(x+20+PenW*2,y+20+PenW,q); //Вывод частного
  //PenW:= 0;
  end;
end;

procedure TCalculatorForSC.ColumnForMultiplication
(Ed1:string; Ed2: string);
var
   x, y, PenW: integer;
begin
  PenW:= 3;
  if Length(Ed1) > Length(Ed2) then begin
    Image1.Canvas.TextOut(580,20,Ed1);
    Image1.Canvas.Pen.Width:= PenW;
    x:= Image1.Canvas.TextWidth(Ed1);
    y:= Image1.Canvas.TextHeight(Ed1);
    Image1.Canvas.TextOut(560,20+y,'*');
    if (pos(',', Ed2) > 0) and (pos(',', Ed1) > 0) then begin
      Image1.Canvas.TextOut(580+(Image1.Canvas.TextWidth(',')+(((Length(Ed1)-Length(Ed2)))*15)),y+20,Ed2);
    end
    else
    if (pos(',', Ed2) > 0) then begin
      Image1.Canvas.TextOut(580+(Image1.Canvas.TextWidth(',')+(((Length(Ed1)-Length(Ed2)))*15)),y+20,Ed2);
    end
    else
    if (pos(',', Ed1) > 0) then begin
      Image1.Canvas.TextOut(580+(Image1.Canvas.TextWidth(',')+(((Length(Ed1)-Length(Ed2))-1)*15)),y+20,Ed2);
    end
    else
    Image1.Canvas.TextOut(580+((Length(Ed1)-Length(Ed2))*15),y+20,Ed2);
    Image1.Canvas.Line(580, y+y+20+PenW, 580+x, y+y+20+PenW);
  end
  else
  begin
    Image1.Canvas.TextOut(580,20,Ed1);
    Image1.Canvas.Pen.Width:= PenW;
    x:= Image1.Canvas.TextWidth(Ed1);
    y:= Image1.Canvas.TextHeight(Ed1);
    if ((pos(',', Ed2) = 0) and (pos(',', Ed1) = 0)) or ((pos(',', Ed2) > 0) and (pos(',', Ed1) > 0)) then begin
      Image1.Canvas.TextOut(580-((Length(Ed2)-Length(Ed1))*15),y+20,Ed2);
      Image1.Canvas.TextOut(560-((Length(Ed2)-Length(Ed1))*15),20+y,'*');
      Image1.Canvas.Line(580-((Length(Ed2)-Length(Ed1))*15), y+y+20+PenW, 580+x, y+y+20+PenW);
    end
    else
      begin
      if (pos(',', Ed2) > 0) then begin
        Image1.Canvas.TextOut(580-(((Length(Ed2)-1)-Length(Ed1))*15),y+20,Ed2);
        Image1.Canvas.TextOut(560-(((Length(Ed2)-1)-Length(Ed1))*15),20+y,'*');
        Image1.Canvas.Line(580-(((Length(Ed2)-1)-Length(Ed1))*15), y+y+20+PenW, 580+x, y+y+20+PenW);
      end;
      if (pos(',', Ed1) > 0) then begin
        Image1.Canvas.TextOut(580-((Length(Ed2)-(Length(Ed1)-1))*15),y+20,Ed2);
        Image1.Canvas.TextOut(560-((Length(Ed2)-(Length(Ed1)-1))*15),20+y,'*');
        Image1.Canvas.Line(580-((Length(Ed2)-(Length(Ed1)-1))*15), y+y+20+PenW, 580+x, y+y+20+PenW);
      end;
    end;
  end;
end;

procedure TCalculatorForSC.FracInPut(var buffEd1: String; var buffEd2: String; PartEd1: String;
                                     PartEd2: string; x: integer; y: integer; x1: integer; y1: integer; var fz: integer);
var
   zeros, i: integer;
begin
  if length(buffEd1) > length(buffEd2) then begin
        Zeros:=length(buffEd1)-length(buffEd2);
        for i:= 1 to Zeros do
          buffEd2:= buffEd2 + '0';
          Image1.Canvas.TextOut(x+Image1.Canvas.TextWidth(PartEd1),y,buffEd1);
          Image1.Canvas.TextOut(x1+Image1.Canvas.TextWidth(PartEd2),y1,buffEd2);
      end;
      if length(buffEd1) < length(buffEd2) then begin
        Zeros:=length(buffEd2)-length(buffEd1);
        for i:= 1 to Zeros do
          buffEd1:= buffEd1 + '0';
          Image1.Canvas.TextOut(x+Image1.Canvas.TextWidth(PartEd1),y,buffEd1);
          Image1.Canvas.TextOut(x1+Image1.Canvas.TextWidth(PartEd2),y1,buffEd2);
          fz:= fz + 1;
      end
      else
      begin
        Image1.Canvas.TextOut(x+Image1.Canvas.TextWidth(PartEd1),y,buffEd1);
        Image1.Canvas.TextOut(x1+Image1.Canvas.TextWidth(PartEd2),y1,buffEd2);
      end;
end;

procedure TCalculatorForSC.ColumnForAddition
(Ed1:string; Ed2: string);
var
   x, y, PenW, leng, FPow, x1, y1: integer;
   buffEd1, buffEd11, buffEd2, IntEd, PartEd1, PartEd2: string;   //, buffEd22
   Nine, fzBool: boolean;
   ch: char;
   fz, xFz: integer;
begin
  xFz:= Image1.Canvas.TextWidth(',');
  fzBool:= true;
  Image1.Canvas.Pen.Width:= 3;
  PenW:= 3;
  leng:= 1;
  Nine:= false;
  FPow:=1;
  if (pos(',', Ed1) > 0) or (pos(',', Ed2) > 0) then begin //дробные
    if (pos(',', Ed1) > 0) then begin
      IntEd:= Ed1;
      delete(IntEd ,pos(',', IntEd), 1);
      repeat
        buffEd1:= IntToStr(StrToInt(IntEd) mod 10)+buffEd1;
        IntEd:= IntToStr(StrToInt(IntEd) div 10);
        Ch:= Ed1[length(Ed1)-FPow];
        inc(Fpow);
      until ch = ',';
      fz:= fpow - 1;
      PartEd1:= IntEd;
    end
    else
    begin
      PartEd1:= Ed1;
      buffEd1:= '0';
    end;
    if (pos(',', Ed2) > 0) then begin
      FPow:=1;
      IntEd:= Ed2;
      delete(IntEd ,pos(',', IntEd), 1);
      repeat
        buffEd2:= IntToStr(StrToInt(IntEd) mod 10)+buffEd2;
        IntEd:= IntToStr(StrToInt(IntEd) div 10);
        Ch:= Ed2[length(Ed2)-FPow];
        inc(Fpow);
      until ch = ',';
      PartEd2:= IntEd;
    end
    else
    begin
      PartEd2:= Ed2;
      buffEd2:= '0';
    end;
    if Length(PartEd1) > Length(PartEd2) then begin
      PartEd1:= PartEd1 + ',';
      PartEd2:= PartEd2 + ',';
      x:= 580;
      y:= 30;
      x1:= 580+(abs(Length(PartEd1)-Length(PartEd2))*15);
      y1:= 30+Image1.Canvas.TextHeight(PartEd1);
      Image1.Canvas.TextOut(x, y,PartEd1);
      Image1.Canvas.TextOut(560,15+Image1.Canvas.TextHeight(Ed1),'+');
      Image1.Canvas.TextOut(x1, y1,PartEd2);
      FracInPut(buffEd1, buffEd2, PartEd1, PartEd2, x, y, x1, y1, fz);
      buffEd1:= PartEd1+buffEd1;
      buffEd2:= PartEd2+buffEd2;
      Image1.Canvas.Line(x,y+Image1.Canvas.TextHeight(Ed1)*2,x+length(buffEd1)*15,y+Image1.Canvas.TextHeight(Ed1)*2);
      if length(buffEd1) < length(FloatToStr(StrToFloat(Number1.Text)+StrToFloat(Number2.Text))) then
        Image1.Canvas.TextOut(x-15,y+Image1.Canvas.TextHeight(Ed1)*2+3,
                              FloatToStr(StrToFloat(Number1.Text)+StrToFloat(Number2.Text)))
      else
        Image1.Canvas.TextOut(x,y+Image1.Canvas.TextHeight(Ed1)*2+3,
                            FloatToStr(StrToFloat(Number1.Text)+StrToFloat(Number2.Text)));
      buffEd11:= buffEd1;
      //buffEd22:= buffEd2;
      delete(buffEd1 ,pos(',', buffEd1), 1);
      delete(buffEd2 ,pos(',', buffEd2), 1);
      repeat    //////////////
      if ((StrToInt(buffEd1) mod 10) + (StrToInt(buffEd2) mod 10) = 9) and (Nine) then begin
        if (fz <> 1) or (fzBool = false) then begin
          inc(leng);
          Image1.Canvas.TextOut(x+((Length(buffEd11)-leng)*15)-xFz,1,'.');
        end;
        if (fz = 1) and (fzBool) then begin
          inc(leng);
          xFz:=2*Image1.Canvas.TextWidth(',');
          Image1.Canvas.TextOut(x+((Length(buffEd11)-leng)*15)-xFz,1,'.');
          fzBool:= false;
        end;
      end
      else
      if (StrToInt(buffEd1) mod 10) + (StrToInt(buffEd2) mod 10) >= 10 then begin
        if (fz <> 1) or (fzBool = false) then begin
          inc(leng);
          Image1.Canvas.TextOut(x+((Length(buffEd11)-leng)*15)-xFz,1,'.');
          Nine:= true;
        end;
        if (fz = 1) and (fzBool) then begin
          inc(leng);
          xFz:=2*Image1.Canvas.TextWidth(',');
          Image1.Canvas.TextOut(x+((Length(buffEd11)-leng)*15)-xFz,1,'.');
          fzBool:= false;
        end;
      end
      else
      begin
        if (fz = 1) and (fzBool) then begin
          xFz:=2*Image1.Canvas.TextWidth(',');
          fzBool:= false;
        end;
        inc(leng);
        Nine:= false;
      end;
        fz:= fz - 1;
        buffEd1:= IntToStr(StrToInt(buffEd1) div 10);
        buffEd2:= IntToStr(StrToInt(buffEd2) div 10);
      until (buffEd2 = '0') and (buffEd1 = '0');  /////////
    end
    else
    begin
      PartEd1:= PartEd1 + ',';
      PartEd2:= PartEd2 + ',';
      x:= 580+(abs(Length(PartEd1)-Length(PartEd2))*15);
      y:= 30;
      x1:= 580;
      y1:= 30+Image1.Canvas.TextHeight(PartEd1);
      Image1.Canvas.TextOut(x,y,PartEd1);
      Image1.Canvas.TextOut(560,15+Image1.Canvas.TextHeight(Ed1),'+');
      Image1.Canvas.TextOut(x1,y1,PartEd2);
      FracInPut(buffEd1, buffEd2, PartEd1, PartEd2, x, y, x1, y1, fz);
      buffEd1:= PartEd1+buffEd1;
      buffEd2:= PartEd2+buffEd2;
      Image1.Canvas.Line(x1,y+Image1.Canvas.TextHeight(Ed1)*2,x1+length(buffEd2)*15,y+Image1.Canvas.TextHeight(Ed1)*2);
      if length(buffEd2) < length(FloatToStr(StrToFloat(Number1.Text)+StrToFloat(Number2.Text))) then
        Image1.Canvas.TextOut(x1-15,y+Image1.Canvas.TextHeight(Ed1)*2+3,
                              FloatToStr(StrToFloat(Number1.Text)+StrToFloat(Number2.Text)))
      else
        Image1.Canvas.TextOut(x1,y+Image1.Canvas.TextHeight(Ed1)*2+3,
                              FloatToStr(StrToFloat(Number1.Text)+StrToFloat(Number2.Text)));
      buffEd11:= buffEd1;
      //buffEd22:= buffEd2;
      delete(buffEd1 ,pos(',', buffEd1), 1);
      delete(buffEd2 ,pos(',', buffEd2), 1);
   repeat    //////////////
      if ((StrToInt(buffEd1) mod 10) + (StrToInt(buffEd2) mod 10) = 9) and (Nine) then begin
        if (fz <> 1) or (fzBool = false) then begin
          inc(leng);
          Image1.Canvas.TextOut(x+((Length(buffEd11)-leng)*15)-xFz,1,'.');
        end;
        if (fz = 1) and (fzBool) then begin
          inc(leng);
          xFz:=2*Image1.Canvas.TextWidth(',');
          Image1.Canvas.TextOut(x+((Length(buffEd11)-leng)*15)-xFz,1,'.');
          fzBool:= false;
        end;
      end
      else
      if (StrToInt(buffEd1) mod 10) + (StrToInt(buffEd2) mod 10) >= 10 then begin
        if (fz <> 1) or (fzBool = false) then begin
          inc(leng);
          Image1.Canvas.TextOut(x+((Length(buffEd11)-leng)*15)-xFz,1,'.');
          Nine:= true;
        end;
        if (fz = 1) and (fzBool) then begin
          inc(leng);
          xFz:=2*Image1.Canvas.TextWidth(',');
          Image1.Canvas.TextOut(x+((Length(buffEd11)-leng)*15)-xFz,1,'.');
          fzBool:= false;
        end;
      end
      else
      begin
        if (fz = 1) and (fzBool) then begin
          xFz:=2*Image1.Canvas.TextWidth(',');
          fzBool:= false;
        end;
        inc(leng);
        Nine:= false;
      end;
        fz:= fz - 1;
        buffEd1:= IntToStr(StrToInt(buffEd1) div 10);
        buffEd2:= IntToStr(StrToInt(buffEd2) div 10);
    until (buffEd2 = '0') and (buffEd1 = '0');  /////////
    end;
  end
  else
  begin  //целые числа
    buffEd1:= Ed1;
    buffEd2:= Ed2;
    if Length(Ed1) > Length(Ed2) then begin
    Image1.Canvas.TextOut(580,30,Ed1);
    repeat
      if ((StrToInt(buffEd1) mod 10) + (StrToInt(buffEd2) mod 10) = 9) and (Nine) then begin
        inc(leng);
        Image1.Canvas.TextOut(580+((Length(Ed1)-leng)*15),1,'.');
      end
      else
      if (StrToInt(buffEd1) mod 10) + (StrToInt(buffEd2) mod 10) >= 10 then begin
        inc(leng);
        Image1.Canvas.TextOut(580+((Length(Ed1)-leng)*15),1,'.');
        Nine:= true;
      end
      else
      begin
        inc(leng);
        Nine:= false;
      end;
      buffEd1:= IntToStr(StrToInt(buffEd1) div 10);
      buffEd2:= IntToStr(StrToInt(buffEd2) div 10);
    until buffEd1 = '0';

    Image1.Canvas.Pen.Width:= PenW;
    x:= Image1.Canvas.TextWidth(Ed1);
    y:= Image1.Canvas.TextHeight(Ed1);
    Image1.Canvas.TextOut(560,15+y,'+');
    Image1.Canvas.TextOut(580+((Length(Ed1)-Length(Ed2))*15),y+30,Ed2);
    Image1.Canvas.Line(580, y+y+30+PenW, 580+x, y+y+30+PenW);
    if Length(Ed1) < Length(IntToStr(StrToInt(Ed1)+StrToInt(Ed2))) then
      Image1.Canvas.TextOut(580-15,y+y+30+PenW+5,
                            IntToStr(StrToInt(Ed1)+StrToInt(Ed2)))
    else
    Image1.Canvas.TextOut(580,y+y+30+PenW+5,
                          IntToStr(StrToInt(Ed1)+StrToInt(Ed2)));
  end
    else
    begin
    Image1.Canvas.TextOut(580,30,Ed1);
    repeat
      if ((StrToInt(buffEd1) mod 10) + (StrToInt(buffEd2) mod 10) = 9) and (Nine) then begin
        inc(leng);
        Image1.Canvas.TextOut(580+((Length(Ed1)-leng)*15),1,'.');
      end
      else
      if (StrToInt(buffEd1) mod 10) + (StrToInt(buffEd2) mod 10) >= 10 then begin
        inc(leng);
        Image1.Canvas.TextOut(580+((Length(Ed1)-leng)*15),1,'.');
        Nine:= true;
      end
      else
      begin
        inc(leng);
        Nine:= false;
      end;
      buffEd1:= IntToStr(StrToInt(buffEd1) div 10);
      buffEd2:= IntToStr(StrToInt(buffEd2) div 10);
    until (buffEd2 = '0') and (buffEd1 = '0');
    Image1.Canvas.Pen.Width:= PenW;
    x:= Image1.Canvas.TextWidth(Ed1);
    y:= Image1.Canvas.TextHeight(Ed1);
    Image1.Canvas.TextOut(580-((Length(Ed2)-Length(Ed1))*15),y+30,Ed2);
    Image1.Canvas.TextOut(560-((Length(Ed2)-Length(Ed1))*15),15+y,'+');
    Image1.Canvas.Line(580-((Length(Ed2)-Length(Ed1))*15), y+y+30+PenW, 580+x, y+y+30+PenW);
    if Length(Ed2) < Length(IntToStr(StrToInt(Ed1)+StrToInt(Ed2))) then
    Image1.Canvas.TextOut(580-((Length(Ed2)-Length(Ed1))*15)-15,y+y+30+PenW+5,
                          IntToStr(StrToInt(Ed1)+StrToInt(Ed2)))
    else
    Image1.Canvas.TextOut(580-((Length(Ed2)-Length(Ed1))*15),y+y+30+PenW+5,
                          IntToStr(StrToInt(Ed1)+StrToInt(Ed2)));
  end;
  end;
end;

procedure TCalculatorForSC.ColumnForSubtraction
(Ed1:string; Ed2: string);
  var
   x, y, PenW, FPow, x1, y1: integer;
   buffEd1, buffEd2, IntEd, PartEd1, PartEd2: string;
   Nine, fzBool: boolean;
   ch: char;
   fz: integer;
begin
  //xFz:= Image1.Canvas.TextWidth(',');
  fzBool:= true;
  Image1.Canvas.Pen.Width:= 3;
  PenW:= 3;
  //leng:= 1;
  Nine:= false;
  FPow:=1;
  if (pos(',', Ed1) > 0) or (pos(',', Ed2) > 0) then begin //дробные
    if (pos(',', Ed1) > 0) then begin
      IntEd:= Ed1;
      delete(IntEd ,pos(',', IntEd), 1);
      repeat
        buffEd1:= IntToStr(StrToInt(IntEd) mod 10)+buffEd1;
        IntEd:= IntToStr(StrToInt(IntEd) div 10);
        Ch:= Ed1[length(Ed1)-FPow];
        inc(Fpow);
      until ch = ',';
      fz:= fpow - 1;
      PartEd1:= IntEd;
    end
    else
    begin
      PartEd1:= Ed1;
      buffEd1:= '0';
    end;
    if (pos(',', Ed2) > 0) then begin
      FPow:=1;
      IntEd:= Ed2;
      delete(IntEd ,pos(',', IntEd), 1);
      repeat
        buffEd2:= IntToStr(StrToInt(IntEd) mod 10)+buffEd2;
        IntEd:= IntToStr(StrToInt(IntEd) div 10);
        Ch:= Ed2[length(Ed2)-FPow];
        inc(Fpow);
      until ch = ',';
      PartEd2:= IntEd;
    end
    else
    begin
      PartEd2:= Ed2;
      buffEd2:= '0';
    end;
    if Length(PartEd1) > Length(PartEd2) then begin
      PartEd1:= PartEd1 + ',';
      PartEd2:= PartEd2 + ',';
      x:= 580;
      y:= 30;
      x1:= 580+(abs(Length(PartEd1)-Length(PartEd2))*15);
      y1:= 30+Image1.Canvas.TextHeight(PartEd1);
      Image1.Canvas.TextOut(x, y,PartEd1);
      Image1.Canvas.TextOut(560,15+Image1.Canvas.TextHeight(Ed1),'-');
      Image1.Canvas.TextOut(x1, y1,PartEd2);
      FracInPut(buffEd1, buffEd2, PartEd1, PartEd2, x, y, x1, y1, fz);
      buffEd1:= buffEd1 + PartEd1;
      buffEd2:= buffEd2 + PartEd2;
      Image1.Canvas.Line(x,y+Image1.Canvas.TextHeight(Ed1)*2,x+Image1.Canvas.TextWidth(buffEd1),y+Image1.Canvas.TextHeight(Ed1)*2);
      Image1.Canvas.TextOut(x+(Image1.Canvas.TextWidth(FloatToStr(StrToFloat(buffEd1)
                            -StrToFloat(buffEd2)))-Image1.Canvas.TextWidth(buffEd1)),
                            y+Image1.Canvas.TextHeight(Ed1)*2+3,
                            FloatToStr(StrToFloat(Number1.Text)-StrToFloat(Number2.Text)));
    end
    else
    begin
      PartEd1:= PartEd1 + ',';
      PartEd2:= PartEd2 + ',';
      x:= 580+(abs(Length(PartEd1)-Length(PartEd2))*15);
      y:= 30;
      x1:= 580;
      y1:= 30+Image1.Canvas.TextHeight(PartEd1);
      Image1.Canvas.TextOut(x,y,PartEd1);
      Image1.Canvas.TextOut(560,15+Image1.Canvas.TextHeight(Ed1),'-');
      Image1.Canvas.TextOut(x1,y1,PartEd2);
      FracInPut(buffEd1, buffEd2, PartEd1, PartEd2, x, y, x1, y1, fz);
      Image1.Canvas.Line(x1,y+Image1.Canvas.TextHeight(Ed1)*2,x1+Image1.Canvas.TextWidth(buffEd2),y+Image1.Canvas.TextHeight(Ed1)*2);
      if length(Number2.Text) < length(FloatToStr(StrToFloat(Number1.Text)+StrToFloat(Number2.Text))) then
        Image1.Canvas.TextOut(x1-15,y+Image1.Canvas.TextHeight(Ed1)*2+3,
                              FloatToStr(StrToFloat(Number1.Text)-StrToFloat(Number2.Text)))
      else
        Image1.Canvas.TextOut(x1,y+Image1.Canvas.TextHeight(Ed1)*2+3,
                              FloatToStr(StrToFloat(Number1.Text)-StrToFloat(Number2.Text)));
    end;
  end
  else
  begin  //целые числа
    buffEd1:= Ed1;
    buffEd2:= Ed2;
    if Length(Ed1) > Length(Ed2) then begin
    Image1.Canvas.TextOut(580,30,Ed1);
    Image1.Canvas.Pen.Width:= PenW;
    x:= Image1.Canvas.TextWidth(Ed1);
    y:= Image1.Canvas.TextHeight(Ed1);
    Image1.Canvas.TextOut(560,15+y,'-');
    Image1.Canvas.TextOut(580+((Length(Ed1)-Length(Ed2))*15),y+30,Ed2);
    Image1.Canvas.Line(580, y+y+30+PenW, 580+x, y+y+30+PenW);
    Image1.Canvas.TextOut(580+((Length(Ed1)-Length(IntToStr(StrToInt(Ed1)-StrToInt(Ed2))))*15),y+y+30+PenW+5,
                          IntToStr(StrToInt(Ed1)-StrToInt(Ed2)));
  end
    else
    begin
    Image1.Canvas.TextOut(580,30,Ed1);
    Image1.Canvas.Pen.Width:= PenW;
    x:= Image1.Canvas.TextWidth(Ed1);
    y:= Image1.Canvas.TextHeight(Ed1);
    Image1.Canvas.TextOut(580-((Length(Ed2)-Length(Ed1))*15),y+30,Ed2);
    Image1.Canvas.TextOut(560-((Length(Ed2)-Length(Ed1))*15),15+y,'-');
    Image1.Canvas.Line(580-((Length(Ed2)-Length(Ed1))*15), y+y+30+PenW, 580+x, y+y+30+PenW);
    Image1.Canvas.TextOut(580-((Length(Ed2)-Length(Ed1))*15)-Image1.Canvas.TextWidth('-'),y+y+30+PenW+5,
                          IntToStr(StrToInt(Ed1)-StrToInt(Ed2)));
  end;
  end;
end;

procedure TCalculatorForSC.ComboBoxChange(Sender: TObject);
var
  act: integer;
begin
 act:= ComboBox.ItemIndex;
 case act of
   0:
     SelectAct:=0;
   1:
     SelectAct:=1;
   2:
     SelectAct:=2;
   3:
     SelectAct:=3;
 end;

end;

procedure TCalculatorForSC.division(div1: integer; div2: integer; k1: integer;
                          Ed1: string; Ed2: String; OstFromDelStr: string);
var
    MLow, buff2: string;
    Myinc, xOst, xVic, iter, n, zeros: integer;
    str, strDiv2: string;
    ggg, yOst, yVic: integer;
    buff: integer;
    bool, boo, boolINT, Edit1Low1, EdLow, o, LowB, div0: boolean;
    QuotientText, RemainderText, SubtrahendText: string;
    remainder, subtrahend, quotient: integer;  //остаток, вычитаемое, частное
begin
  zeros:= 0;
  div0:= false;
  n:= 1;
  LowB:= true;
  yOst:= 0;
  yVic:= 0;
  xOst:= 0;
  xVic:= 0;
  MyInc:= 1;
  strDiv2:= 'NOTNULL';
  bool:= false;
  boo:= true;
  o:= false;
  Edit1Low1:= false;
  boolINT:=false;
  QuotientText:= '';
  EdLow:= false;

  for GGG:=1 to 10 do begin
    boolINT:=false; ////////////////////////////////////////////////////
    if (k1 = 0) and (div2 = 0) then
     begin
       strDiv2:= '';
       if (k1 = 0) and (div1 < StrToInt(Ed2)) then
       begin
         buff2:= QuotientText;
         repeat
         if o then begin
           QuotientText:= QuotientText+'0';
         end;
         div1:= div1 * 10;
         Edit1Low1:=true;
         if not(o) then begin
         QuotientText:= '0,';
         end;
         EdLow:= true;
         o:= true;
         until (div1 >= StrToInt(Ed2)) or (div1 = 0); ///////////////
         if div1 = 0 then //////////////////
           QuotientText:= buff2;///////////////////
       end;
     end;
     remainder:= trunc(div1 mod StrToInt(Ed2)); //остаток
     quotient:= trunc(div1 div StrToInt(Ed2));  //частное
     subtrahend:= trunc(quotient * StrToInt(Ed2)); //вычитаемое
     QuotientText:= QuotientText + IntToStr(quotient);
     if div0 then begin
        xVic:= xVic+((Length(RemainderText)-Length(intToStr(subtrahend)))*15);
        div0:= false;
     end;
     if boo then begin
     xVic:= xVic+(20+((Length(IntToStr(div1))-Length(intToStr(subtrahend)))*15));
     end
     else
     xVic:= xVic+((Length(IntToStr(div1))-Length(intToStr(subtrahend)))*15);
     boo:=false;
     if (remainder = 0) and (k1 = 0) then
       xOst:= xVic+((Length(IntToStr(subtrahend))-Length(intToStr(remainder)))*15)
     else
     if remainder = 0 then
       xOst:= xVic+((Length(IntToStr(subtrahend))-Length(intToStr(remainder)))*15+15)
     else
     xOst:= xVic+((Length(IntToStr(subtrahend))-Length(intToStr(remainder)))*15);
     /////////////////////////////////////////////////////////////
     if (OstFromDelStr <> '') and (OstFromDelStr[1] = '0') and (remainder = 0) then begin
       zeros:= 0;
       repeat
         QuotientText:= QuotientText + '0';
         delete(OstFromDelStr, n, 1);
         k1:= k1-1;
         inc(zeros);
       until (OstFromDelStr = '')  or (OstFromDelStr[1] <> '0');
       if OstFromDelStr = '' then
         OstFromDelStr:= '0'
       else
       div0:= true;
       div2:= StrToInt(OstFromDelStr);

     end;
     ////////////////////////////////////////////////////////////
     if (remainder = 0) and (k1=0) then begin
      SubtrahendText:= IntToStr(subtrahend);
      RemainderText:= IntToStr(remainder);
      if LowB then
        MLow:= SubtrahendText;
      ColumnForDivision(QuotientText, Edit1Low1, Ed1, Ed2, MLow);
      MoreElemForDiv(yVic,xVic,SubtrahendText,yOst,xOst,RemainderText);
      Break;
     end
     else
     begin
     div1:= remainder;
     repeat
       if Length(strDiv2) = 0 then //условие после запятой
       begin
         div1:= div1*10;
         RemainderText:= IntToStr(div1);
         if (MyInc = 1) and (EdLow = false) then begin
            QuotientText:= QuotientText + ',';
         end;
      MyInc:= 2;
      if bool then
      begin
        QuotientText:= QuotientText + '0';
      end;
    end
    else
    begin //условие для целых чисел до запятой
      if boolINT then
      begin
        QuotientText:= QuotientText + '0';
        if k1 = 0 then
        begin
          QuotientText:= QuotientText + ',';
        end;
      end;
      k1:=k1-1;
      buff:= div2 div pow(k1);
      div2:= div2 mod pow(k1);
      str:= IntToStr(div1) + IntToStr(buff);
      div1:= StrToInt(str);
      delete(OstFromDelStr, 1, 1);
      RemainderText:= IntToStr(div1);
      if div0 then begin
        for iter:= 1 to zeros do
          RemainderText:= '0' + RemainderText;
      end;
      boolINT:=true;
    end;
    bool:= true;
  until (div1 >= StrToInt(Ed2)) or (div1 = 0);   //////////////////
  bool:= false;
  SubtrahendText:= IntToStr(subtrahend);
  if LowB then
    MLow:= SubtrahendText;
  LowB:= false;
  ColumnForDivision(QuotientText, Edit1Low1, Ed1, Ed2, MLow);
  MoreElemForDiv(yVic,xVic,SubtrahendText,yOst,xOst,RemainderText);
  if div1 = 0 then ////
   if k1 = 0 then ////////////////////////////////////
     Break;          ///////////////
  end;
  end;
end;

procedure TCalculatorForSC.Number1KeyPress(Sender: TObject; var Key: char);
begin
  case key of
    '0'..'9':;
    ',':;
    #8:;
  else
    begin
      key:=chr(0);
      ShowMessage('Вы ввели недопустимый символ!');
    end;
  end;
end;

procedure TCalculatorForSC.Number2KeyPress(Sender: TObject; var Key: char);
begin
  case key of
    '0'..'9':;
    ',':;
    #8:;
  else
    begin
      key:=chr(0);
      ShowMessage('Вы ввели недопустимый символ!');
    end;
  end;
end;

procedure TCalculatorForSC.multiplication(Ed1: string; Ed2: String);
var
    x, y, y1, ZerosPlus, Ed1Zeros: integer;
    compos: string;
    buff, buff2: string;
    Frac: boolean;
begin
  Frac:= false;
  y1:= 2;
  x:= 0;
  Ed1Zeros:= 0;
  y:= Image1.Canvas.TextHeight(Ed1);
  buff:= Ed2;
  if (pos(',', Ed2) <> 0) or (pos(',', Ed1) <> 0) then begin
    buff2:= Ed1;
    IfFrac(Ed1, Ed2, ZerosPlus, Ed1Zeros);
    Frac:= true;
  end;
  If Ed1Zeros <> 0 then begin
    Ed1:= IntToStr(StrToInt(Ed1) div pow(Ed1Zeros));
  end;
  repeat
    compos:=IntToStr((StrToInt(Ed2) mod 10) * StrToInt(Ed1));
    Ed2:= IntToStr(StrToInt(Ed2) div 10);
      If ZerosPlus <= 0 then begin
        if length(compos) > length(Ed1) then begin
          x:= x+15;
          Image1.Canvas.TextOut(580-x, (y*y1)+20+5, compos);
        end
        else
        Image1.Canvas.TextOut(580-x, (y*y1)+20+5, compos);
        x:= x+15;
        inc(y1);
      end;
      ZerosPlus:= ZerosPlus-1;
  until Ed2 = '0';
  if Frac then begin
    Image1.Canvas.TextOut(580-x+15, (y*y1)+20+5, FloatToStr(StrToFloat(buff)*StrToFloat(buff2)));
    Image1.Canvas.Line(580-x+15, (y*y1)+20+5, 580-x+15+
                      ((Length(FloatToStr(StrToFloat(buff)*
                        StrToFloat(buff2))))*15),(y*y1)+20+5);
  end
  else
  begin
    Image1.Canvas.TextOut(580-x+15, (y*y1)+20+5, IntToStr(StrToInt(buff)*
                          StrToInt(Ed1)));
    Image1.Canvas.Line(580-x+15, (y*y1)+20+5, 580-x+15+
                      ((Length(IntToStr(StrToInt(buff)*
                        StrToInt(Ed1))))*15),(y*y1)+20+5);
  end;
end;

procedure TCalculatorForSC.FormCreate(Sender: TObject);
begin
  Image1.Canvas.Pen.Color:= clWhite;
  Image1.Canvas.Rectangle(0,0,1000,1000);  //фон
  Image1.Canvas.Pen.Color := clBlack;
  boo1:=true;
end;

procedure TCalculatorForSC.CalculateClick(Sender: TObject);
var
    i, OstFromDel, Edit1TextInt: integer;
    delimoe, k: integer;
    divi: integer;
    Edit1Text, Edit2Text: string;
    OstFromDelStr: string;
    mNullInt, mNullInt2: integer;
begin
  Image1.Canvas.Rectangle(0,0,1000,1000);
  if (Number1.Text = '') or (Number2.Text = '') then
    ShowMessage('Вы забыли ввести числа!')
  else
  case SelectAct of
   0:begin
       Edit1Text:= Number1.Text;
       Edit2Text:= Number2.Text;
       ColumnForAddition(Edit1Text, Edit2Text);
     end;
   1:begin
       Edit1Text:= Number1.Text;
       Edit2Text:= Number2.Text;
       ColumnForSubtraction(Edit1Text, Edit2Text);
     end;
   2: begin
        Edit1Text:= Number1.Text;
        Edit2Text:= Number2.Text;
        ColumnForMultiplication(Edit1Text, Edit2Text);
        multiplication(Edit1Text, Edit2Text);
      end;
   3: begin
  if Number2.Text = '0' then begin
   Number1.Text:= '';
   Number2.Text:= '';
   ShowMessage('Деление на ноль запрещено!')
  end
  else
  begin
  Edit1Text:= Number1.Text;
  Edit2Text:= Number2.Text;
  if (pos(',', Edit2Text) <> 0) or (pos(',', Edit1Text) <> 0) then begin
    IfFrac(Edit1Text, Edit2Text, mNullInt, mNullInt2);
  end;
  k:= 0;
  divi:= 1;
  OstFromDelStr:='';
  Edit1TextInt:= StrToInt(Edit1Text);
  k:= Length(Edit1Text)-Length(Edit2Text);
  if k<0 then
  k:=0;
  if (k = 0) then
  begin
    delimoe:=StrToInt(Edit1Text);
    OstFromDel:=0;
    division(delimoe, OstFromDel, k, Edit1Text, Edit2Text, 'not');
  end
  else
  begin
  for i:=1 to k do begin
    divi:= divi*10;
    delimoe:= StrToInt(Edit1Text) div divi;
    OstFromDel:= StrToInt(Edit1Text) mod divi;
    OstFromDelStr:= IntToStr(Edit1TextInt mod 10) + OstFromDelStr;
    Edit1TextInt:= Edit1TextInt div 10;
  end;
  If (delimoe >= StrToInt(Edit2Text)) then begin
    division(delimoe, OstFromDel, k, Edit1Text, Edit2Text, OstFromDelStr);
  end
  else
  begin
    divi:= 1;
    repeat
      k:= k-1;
      for i:=1 to k do begin
        divi:= divi*10;
        delimoe:= StrToInt(Edit1Text) div divi;
        OstFromDel:= StrToInt(Edit1Text) mod divi;
        OstFromDelStr:= IntToStr(Edit1TextInt mod 10) + OstFromDelStr;
        Edit1TextInt:= Edit1TextInt div 10;
      end;
    until (delimoe >= StrToInt(Edit2Text)) or (k<=0); // для частного не имеющего целую часть
    if delimoe < StrToInt(Edit2Text) then
      division(StrToInt(Edit1Text), 0, k, Edit1Text, Edit2Text, 'not')
    else
    division(delimoe, OstFromDel, k, Edit1Text, Edit2Text, OstFromDelStr);
  end;
  end;
  end;
    end;
  end;
end;

end.

