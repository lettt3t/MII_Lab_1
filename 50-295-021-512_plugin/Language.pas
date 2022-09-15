unit Language;

interface

uses Forms, Windows, Controls, SysUtils, inifiles;

var
  LanguagePath : string = 'fregat.lng';
  Msg1:string='Введенный номер занят другим устройством';
  Msg3:string='Неверное значение номера устройства';
  Mes1:string='Не все поля заполнены';
  Fregat:string='Фрегат';

procedure LanguageSetup(Form: TForm);


implementation

const
  text_length = 1024;
  STR_END = '^';


{procedure EnumMenuCallbak(menu: hmenu; inf: tinifile);
var
  strbuf : array[0..text_length-1] of char;
  i: integer;
  minfo : TMenuItemInfo;
begin
  for i:=0 to GetmenuItemCount(menu)-1 do
    begin
      minfo.cbSize     := sizeof(TMenuItemInfo);
      minfo.fMask      := MIIM_STRING or MIIM_SUBMENU;
      minfo.dwTypeData := @strbuf[0];
      minfo.cch        := text_length;
      GetMenuItemInfo(menu,i,true,minfo);
      if minfo.cch <>0 then inf.WriteString('MAIN',strbuf,STR_END);
      GetMenuItemInfo(menu,i,true,minfo);
      if minfo.hSubMenu<>0 then EnumMenuCallbak(minfo.hSubMenu,inf);
    end;
end; 

procedure EnumControls(Form: TWinControl; inf : tinifile);
var
  strbuf : array[0..text_length-1] of char;
  i: integer;
begin
  for i:=0 to Form.ControlCount-1 do
    begin
      if Form.Controls[i].GetTextLen<>0 then
        begin
          Form.Controls[i].GetTextBuf(strbuf,Form.Controls[i].GetTextLen+1);
          inf.WriteString('MAIN',strbuf,STR_END);
        end;
      if (Form.Controls[i] is TWinControl) then
        if TWinControl(Form.Controls[i]).ControlCount<>0 then EnumControls(TWinControl(Form.Controls[i]),inf);
    end;
end;

procedure LanguageSetup(Form: TForm; Path: string);
var
  inf: tinifile;
begin
  inf := tinifile.Create(Path);
  inf.WriteString('MAIN',Form.Caption,STR_END);
  EnumControls(Form,inf);
  EnumMenuCallbak(GetMenu(Form.Handle), inf);
  inf.Free;
end;   }

     {put stuff}
procedure EnumMenuCallbak(menu: hmenu; inf: tinifile);
var
  strbuf : array[0..text_length-1] of char;
  i: integer;
  minfo : TMenuItemInfo;
begin
  for i:=0 to GetmenuItemCount(menu)-1 do
    begin
      minfo.cbSize     := sizeof(TMenuItemInfo);
      minfo.fMask      := MIIM_STRING or MIIM_SUBMENU;
      minfo.dwTypeData := @strbuf[0];
      minfo.cch        := text_length;
      GetMenuItemInfo(menu,i,true,minfo);
      if minfo.cch <>0 then inf.WriteString('MAIN',strbuf,STR_END);
      GetMenuItemInfo(menu,i,true,minfo);
      if minfo.hSubMenu<>0 then EnumMenuCallbak(minfo.hSubMenu,inf);
    end;
end;

procedure EnumControls(Form: TWinControl; inf : tinifile);
var
  strbuf, newstrbuf : array[0..text_length-1] of char;
  i: integer;
begin
  for i:=0 to Form.ControlCount-1 do
    begin
      if Form.Controls[i].GetTextLen<>0 then
        begin
          Form.Controls[i].GetTextBuf(strbuf,Form.Controls[i].GetTextLen+1);
          StrPCopy(newstrbuf,inf.ReadString('MAIN',strbuf,STR_END));
          if StrComp(newstrbuf,STR_END)<>0 then Form.Controls[i].SetTextBuf(newstrbuf);
        end;
      if (Form.Controls[i] is TWinControl) then
        if TWinControl(Form.Controls[i]).ControlCount<>0 then EnumControls(TWinControl(Form.Controls[i]),inf);
    end;
end;

procedure LanguageSetup(Form: TForm);
var
  inf: tinifile;
  newstrbuf: array[0..text_length-1] of char;
  dir:pchar;
  Path:string;
  i:integer;
begin
  GetMem(Dir,MAX_PATH);
  GetModuleFileName(0,Dir,MAX_PATH);
  Path:=ExtractFilePath(Dir);
  Freemem(Dir);
  inf := tinifile.Create(Path+LanguagePath);
  StrPCopy(newstrbuf,inf.ReadString('MAIN',Form.Caption,STR_END));
  if StrComp(newstrbuf,STR_END)<>0 then Form.Caption:=newstrbuf;
  EnumControls(Form,inf);
  EnumMenuCallbak(GetMenu(Form.Handle), inf);
  Fregat:=inf.ReadString('MAIN','Fregat',Fregat);
  Msg1:=inf.ReadString('MAIN','Msg1_1',Msg1);
  Msg3:=inf.ReadString('MAIN','Msg3_1',Msg3);
  Mes1:=inf.ReadString('MAIN','Mes1',Mes1);
  inf.Free;
end;

end.
