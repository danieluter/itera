unit FormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.StdCtrls, Data.DB, Data.Win.ADODB,
  Vcl.Grids;

type
  TColType = (ctString, ctDouble, ctInt);

  TfrmMain = class(TForm)
    ActionList: TActionList;
    actAdd: TAction;
    actEdit: TAction;
    actDelete: TAction;
    ImageList: TImageList;
    btnAdd: TButton;
    PopupMenu: TPopupMenu;
    miEdit: TMenuItem;
    miDelete: TMenuItem;
    MainGrid: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
  private
    { Private declarations }
    function CalumnValue(const aColID: Integer; const aColType: TColType): Variant;

    procedure ListRefresh;
    function SelectedClaimId: Integer;

    procedure OnControllerRefresh;
    procedure OnControllerMessage(const aMessage: String);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.UITypes, ClaimsController, FormClaim, UnitConsts;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;

  MainGrid.RowCount := 1;
  MainGrid.ColCount := 7;

  MainGrid.Cells[ClaimID_col, 0] := 'Claim ID';
  MainGrid.Cells[Name_col, 0] := 'Name';
  MainGrid.Cells[GrossClaim_col, 0] := 'Gross Claim';
  MainGrid.Cells[Deductible_col, 0] := 'Deductible';
  MainGrid.Cells[NetClaim_col, 0] := 'Net Claim';
  MainGrid.Cells[Year_col, 0] := 'Year';
  MainGrid.Cells[ClaimType_col, 0] := 'Type';

  ClaimController.OnRefresh	:= OnControllerRefresh;
  CLaimController.OnMessage := OnControllerMessage;

  ListRefresh();
end;

procedure TfrmMain.actAddExecute(Sender: TObject);
var
  frmClaim: TfrmClaim;
begin
  frmClaim := TfrmClaim.Create(Self);
  try
    frmClaim.ShowModal;
  finally
    frmClaim.Free;
  end;
end;

procedure TfrmMain.actEditExecute(Sender: TObject);
var
  frmClaim: TfrmClaim;
begin
  frmClaim := TfrmClaim.Create(Self);
  try
    frmClaim.Id := SelectedClaimId;

    frmClaim.ShowModal
  finally
    frmClaim.Free;
  end;
end;

procedure TfrmMain.actDeleteExecute(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete selected claim?', TMsgDlgType.mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  ClaimController.DeleteClaim(SelectedClaimId);
end;

procedure TfrmMain.ListRefresh;
begin
  ClaimController.LoadClaims(MainGrid);
end;

procedure TfrmMain.OnControllerRefresh();
begin
  ListRefresh();
end;

procedure TfrmMain.PopupMenuPopup(Sender: TObject);
begin
  actEdit.Enabled := MainGrid.RowCount > 1;
  actDelete.Enabled := MainGrid.RowCount > 1;
end;

procedure TfrmMain.OnControllerMessage(const aMessage: String);
begin
  ShowMessage(aMessage);
end;

function TfrmMain.CalumnValue(const aColID: Integer;
  const aColType: TColType): Variant;
var
  lSelectedRow: Integer;
begin
  Result := -1;
  lSelectedRow := MainGrid.Row;
  if lSelectedRow <= 0 then
    Exit;

  case aColType of
    ctDouble: Result := StrToFloatDef(MainGrid.Cells[aColID, lSelectedRow], 0);
    ctInt:  Result := StrToIntDef(MainGrid.Cells[aColID, lSelectedRow], 0);
  else
    //ctString
    Result := MainGrid.Cells[aColID, lSelectedRow];
  end;
end;

function TfrmMain.SelectedClaimId: Integer;
begin
  Result := CalumnValue(ClaimID_col, ctInt);
end;

end.
