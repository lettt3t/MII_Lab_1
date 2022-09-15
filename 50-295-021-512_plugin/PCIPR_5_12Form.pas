unit PCIPR_5_12Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, HtmlHelper, StdCtrls, Buttons, IniFiles, Menus;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    PopupMenu1: TPopupMenu;
    GroupBox3: TGroupBox;
    Edit3: TEdit;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    Level,IniFile,currstr:string;
    ch:boolean;
    BA:array of integer;
    sz:integer;
  protected
    inited: boolean;    
  end;

const
  KEY_DEC = 3;

var
  Form1: TForm1;

implementation

uses Language;

{$R *.dfm}

procedure CheckKey(Edit: TWinControl; var Key: char);
var
  text, null_text: pChar;
begin
  Key := UpperCase(Key)[1];
  null_text := AllocMem(Edit.GetTextLen+3);
  Edit.GetTextBuf(@null_text[1],Edit.GetTextLen+1);
  text := @null_text[1];
  null_text[0] := #0;

  case Edit.Tag of
    KEY_DEC:
      if ((Key >= '0') and  (Key <= '9'))  or (Key = #8) then else Key :=#0;
  end;
  FreeMem(null_text);
  //SendMessage(Edit.Handle, EM_SETSEL,Edit.GetTextLen+1,Edit.GetTextLen+1);
end;


procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  //TEdit(Sender).SelText:='';// TEdit(Sender).Text then TEdit(Sender).Text:='';
  CheckKey(TWinControl(Sender),Key);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if inited = false then
    begin
      LanguageSetup(Form1);
      inited:=true;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if FileExists(inifile) then DeleteFile(inifile);
  ModalResult:=mrCancel;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i,int,code:integer;
  IniF:TIniFile;
begin
  if (Edit1.Text='') then
   begin
     MessageBox(Handle,Pchar(Mes1),Pchar(Fregat),MB_ICONWARNING);
     Edit1.SetFocus;
     Exit;
   end;
  Val(Edit3.Text, int, Code);
  if (int<=0)or(int>32)or(Code<>0) then
   begin
     MessageBox(Handle,PCHAR(msg3),PCHAR(Fregat),MB_ICONWARNING);
     Edit1.SetFocus;
     Exit;
   end;
  for i:=1 to sz do
  begin
    if BA[i-1]=int then
     begin
       MessageBox(Handle,PCHAR(msg1),PCHAR(Fregat),MB_ICONWARNING);
       Edit1.SetFocus;
       exit;
     end;
  end;
  if FileExists(inifile) then DeleteFile(inifile);
  IniF:=TIniFile.Create(inifile);
  IniF.WriteString('PCIPR_5_12','Bus',Edit1.Text);
  IniF.WriteString('PCIPR_5_12','Slot',Edit2.Text);
  IniF.WriteString('PCIPR_5_12','Base',Edit3.Text);
  IniF.Free;
  ModalResult:=MrOk;
end;

end.
