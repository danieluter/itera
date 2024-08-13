object frmDBConnection: TfrmDBConnection
  Left = 0
  Top = 0
  Caption = 'Database Configuration'
  ClientHeight = 175
  ClientWidth = 435
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblServerName: TLabel
    Left = 56
    Top = 19
    Width = 67
    Height = 15
    Caption = 'Server Name'
  end
  object lblUserName: TLabel
    Left = 56
    Top = 48
    Width = 58
    Height = 15
    Caption = 'User Name'
  end
  object lblPassword: TLabel
    Left = 56
    Top = 77
    Width = 50
    Height = 15
    Caption = 'Password'
  end
  object lblDatabaseName: TLabel
    Left = 56
    Top = 106
    Width = 83
    Height = 15
    Caption = 'Database Name'
  end
  object edServerName: TEdit
    Left = 145
    Top = 16
    Width = 161
    Height = 23
    TabOrder = 0
  end
  object edUserName: TEdit
    Left = 145
    Top = 45
    Width = 161
    Height = 23
    TabOrder = 1
  end
  object edPassword: TEdit
    Left = 145
    Top = 74
    Width = 161
    Height = 23
    PasswordChar = '*'
    TabOrder = 2
  end
  object edDatabaseName: TEdit
    Left = 145
    Top = 103
    Width = 161
    Height = 23
    TabOrder = 3
  end
  object btnTestConnection: TButton
    Left = 145
    Top = 132
    Width = 161
    Height = 25
    Caption = 'Test connection...'
    TabOrder = 4
    OnClick = btnTestConnectionClick
  end
end
