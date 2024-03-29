library PCIPR_5_12;

uses
  Forms,
  Windows,
  SysUtils,
  Classes,
  IniFiles,
  PCIPR_5_12Form in 'PCIPR_5_12Form.pas' {Form1},
  HtmlHelper in 'HtmlHelper.pas',
  Language in 'Language.pas';

var
  local : array of string;


{$E plg}

{$R *.res}

procedure LoadParam(var NameParam:PCHAR); stdcall;
begin                                        
  NameParam:=HeapAlloc(GetProcessHeap,0,64);
  StrPCopy(NameParam,'10B5-9050-10191761-Base2-��������-5-0-PCIPR_5_12');
end;

procedure LoadPlug(var Namep:PCHAR); stdcall;
begin
  NameP:=HeapAlloc(GetProcessHeap,0,16);
  StrPCopy(Namep,'PCIPR_5_12');
end;

procedure PlugExec(MemIniFile:PCHAR;H:HWND;BaseAdr:array of integer; size:integer;typeplug:integer);stdcall;
var
  s:string;
  IniF:TIniFile;
  i:integer;
begin
  Application.Handle:=h;
  Form1:=TForm1.Create(Application);
  Form1.sz:=size;
  SetLength(Form1.BA,size);
  for i:=0 to size-1 do Form1.BA[i]:=BaseAdr[i];
  Form1.currstr:='0';
  Form1.IniFile:=MemIniFile;
  if FileExists(MemIniFile) then
  begin
    with Form1 do
    begin
      IniF:=TIniFile.Create(inifile);
      Edit1.Text:=IniF.ReadString('PCIPR_5_12','Bus','0');
      Edit2.Text:=IniF.ReadString('PCIPR_5_12','Slot','0');
      Edit3.Text:=IniF.ReadString('PCIPR_5_12','Base','0');
      IniF.Free;
    end;
    Deletefile(MemIniFile);
  end;
  Form1.ShowModal;
  Form1.Free;
end;

exports
  LoadPlug,
  LoadParam,
  PlugExec;

begin
  DecimalSeparator:='.';
end.
