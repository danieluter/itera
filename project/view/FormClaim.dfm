object frmClaim: TfrmClaim
  Left = 0
  Top = 0
  Caption = 'Insurance Claim'
  ClientHeight = 279
  ClientWidth = 483
  Color = clBtnFace
  Constraints.MinHeight = 279
  Constraints.MinWidth = 483
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object LabelClaimID: TLabel
    Left = 216
    Top = 19
    Width = 24
    Height = 15
    Caption = 'New'
  end
  object LabelName: TLabel
    Left = 120
    Top = 51
    Width = 32
    Height = 15
    Caption = 'Name'
  end
  object LabelGrossClaim: TLabel
    Left = 120
    Top = 80
    Width = 63
    Height = 15
    Caption = 'Gross Claim'
  end
  object LabelDeductable: TLabel
    Left = 120
    Top = 109
    Width = 60
    Height = 15
    Caption = 'Deductable'
  end
  object Label2: TLabel
    Left = 120
    Top = 171
    Width = 22
    Height = 15
    Caption = 'Year'
  end
  object LabelNetClaim: TLabel
    Left = 120
    Top = 138
    Width = 53
    Height = 15
    Caption = 'Net Claim'
  end
  object LabelID: TLabel
    Left = 120
    Top = 19
    Width = 11
    Height = 15
    Caption = 'ID'
  end
  object LabelType: TLabel
    Left = 120
    Top = 196
    Width = 24
    Height = 15
    Caption = 'Type'
  end
  object btnSave: TButton
    Left = 400
    Top = 246
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 6
    OnClick = btnSaveClick
  end
  object edName: TEdit
    Left = 216
    Top = 48
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object edYear: TNumberBox
    Left = 216
    Top = 164
    Width = 121
    Height = 23
    Decimal = 0
    DisplayFormat = '#'
    TabOrder = 4
  end
  object edGrossClaim: TNumberBox
    Left = 216
    Top = 77
    Width = 121
    Height = 23
    Mode = nbmFloat
    MaxValue = 100000.000000000000000000
    TabOrder = 1
    OnChange = edGrossClaimChange
  end
  object edDeductable: TNumberBox
    Left = 216
    Top = 106
    Width = 121
    Height = 23
    Mode = nbmFloat
    MaxValue = 100000.000000000000000000
    TabOrder = 2
    OnChange = edGrossClaimChange
  end
  object edNetClaim: TNumberBox
    Left = 216
    Top = 135
    Width = 121
    Height = 23
    Mode = nbmFloat
    MaxValue = 100000.000000000000000000
    ReadOnly = True
    TabOrder = 3
  end
  object edType: TComboBox
    Left = 216
    Top = 193
    Width = 121
    Height = 23
    Style = csDropDownList
    TabOrder = 5
  end
end
