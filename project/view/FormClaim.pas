unit FormClaim;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.Samples.Spin,
  Vcl.NumberBox;

type
  TfrmClaim = class(TForm)
    btnSave: TButton;
    edName: TEdit;
    LabelClaimID: TLabel;
    LabelName: TLabel;
    LabelGrossClaim: TLabel;
    LabelDeductable: TLabel;
    Label2: TLabel;
    edYear: TNumberBox;
    edGrossClaim: TNumberBox;
    edDeductable: TNumberBox;
    edNetClaim: TNumberBox;
    LabelNetClaim: TLabel;
    LabelID: TLabel;
    edType: TComboBox;
    LabelType: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edGrossClaimChange(Sender: TObject);
  private
    fId: Integer;
    procedure SetID(const Value: Integer);
    { Private declarations }
  public
    { Public declarations }
    property Id: Integer read fId write SetID;
  end;

var
  frmClaim: TfrmClaim;

implementation

uses
  System.DateUtils,
  ClaimTypesController,
  ClaimsController;

{$R *.dfm}

{ TfrmClaim }

procedure TfrmClaim.btnSaveClick(Sender: TObject);
var
  lReturnValue: Boolean;
begin
  if fId = 0 then
    lReturnValue := ClaimController.AddCLaim(
      edName.Text,
      Integer(edType.Items.Objects[edType.ItemIndex]),
      edYear.ValueInt,
      edGrossClaim.ValueFloat,
      edDeductable.ValueFloat)
  else
    lReturnValue := ClaimController.EditCLaim(
      fID,
      edName.Text,
      Integer(edType.Items.Objects[edType.ItemIndex]),
      edYear.ValueInt,
      edGrossClaim.ValueFloat,
      edDeductable.ValueFloat);

  if lReturnValue then
    ModalResult := mrOK;
end;

procedure TfrmClaim.edGrossClaimChange(Sender: TObject);
begin
  edNetClaim.ValueFloat := edGrossClaim.ValueFloat - edDeductable.ValueFloat;
end;

procedure TfrmClaim.FormCreate(Sender: TObject);
begin
  ClaimTypeController.LoadClaimTypes(edType.Items);
  edType.ItemIndex := 0; //could do better here but assuming at least one type in the DB

  edYear.MinValue := YearOf(Now()) - 10;
  edYear.MaxValue := YearOf(Now());
  edYear.Value := edYear.MaxValue;
end;

procedure TfrmClaim.SetID(const Value: Integer);
var
  lName: String;
  lTypeID: Integer;
  lYear: SmallInt;
  lGrossClaim: Double;
  lDeductable: Double;

  lReturnValue: Boolean;
begin
  fId := Value;

  LabelClaimID.Caption := fId.ToString();

  lReturnValue := ClaimController.GetClaim(
    fId, lName, lTypeID, lYear, lGrossClaim, lDeductable);

  if not lReturnValue then
    Exit;

  edName.Text := lName;
  edType.ItemIndex := edType.Items.IndexOfObject(Pointer(lTypeID));
  edYear.ValueInt := lYear;
  edGrossClaim.ValueFloat := lGrossClaim;
  edDeductable.ValueFloat := lDeductable;
end;

end.
