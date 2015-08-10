object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'FattySid'
  ClientHeight = 70
  ClientWidth = 222
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbInetAddress: TLabel
    Left = 8
    Top = 16
    Width = 67
    Height = 13
    Caption = 'lbInetAddress'
  end
  object Label1: TLabel
    Left = 136
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Label1'
    Visible = False
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 44
    Width = 206
    Height = 17
    Caption = #1047#1072#1075#1088#1091#1078#1072#1090#1100#1089#1103' '#1089' Windows '
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 6666
    ServerType = stNonBlocking
    OnClientRead = ServerSocket1ClientRead
    Left = 176
    Top = 24
  end
end
