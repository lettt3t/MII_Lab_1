object Form1: TForm1
  Left = 844
  Top = 442
  ActiveControl = Edit1
  BorderIcons = [biMinimize]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' PCIPR_021_512'
  ClientHeight = 198
  ClientWidth = 181
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 96
    Top = 164
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 11
    Top = 164
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 21
    Top = 54
    Width = 132
    Height = 46
    Caption = #1053#1086#1084#1077#1088' '#1096#1080#1085#1099
    TabOrder = 2
    object Edit1: TEdit
      Tag = 3
      Left = 8
      Top = 16
      Width = 116
      Height = 21
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 23
    Top = 107
    Width = 132
    Height = 46
    Caption = #1053#1086#1084#1077#1088' '#1089#1083#1086#1090#1072
    TabOrder = 3
    object Edit2: TEdit
      Left = 8
      Top = 16
      Width = 116
      Height = 21
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
  end
  object GroupBox3: TGroupBox
    Left = 21
    Top = 2
    Width = 132
    Height = 46
    Caption = #1053#1086#1084#1077#1088' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072
    TabOrder = 4
    object Edit3: TEdit
      Tag = 3
      Left = 8
      Top = 16
      Width = 116
      Height = 21
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 136
    Top = 33
  end
end
