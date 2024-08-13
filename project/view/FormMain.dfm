object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Constraints.MinHeight = 442
  Constraints.MinWidth = 628
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    628
    442)
  TextHeight = 15
  object btnAdd: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Action = actAdd
    TabOrder = 0
  end
  object MainGrid: TStringGrid
    Left = 8
    Top = 39
    Width = 619
    Height = 398
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 7
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goFixedRowClick, goFixedRowDefAlign]
    PopupMenu = PopupMenu
    TabOrder = 1
  end
  object ActionList: TActionList
    Left = 232
    Top = 64
    object actAdd: TAction
      Caption = 'Add'
      OnExecute = actAddExecute
    end
    object actEdit: TAction
      Caption = 'Edit'
      OnExecute = actEditExecute
    end
    object actDelete: TAction
      Caption = 'Delete'
      OnExecute = actDeleteExecute
    end
  end
  object ImageList: TImageList
    Left = 336
    Top = 128
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 280
    Top = 232
    object miEdit: TMenuItem
      Action = actEdit
    end
    object miDelete: TMenuItem
      Action = actDelete
    end
  end
end
