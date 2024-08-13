unit ClaimsController;

interface

uses
  Vcl.Grids,

  UnitClaims;

type
  TOnRefresh = procedure of object;
  TOnMessage = procedure(const aMessage: String) of object;

  TClaimController = class
  private
    fOnMessage: TOnMessage;
    fOnRefresh: TOnRefresh;

    function Validate(aClaim: IClaim; var aMessage: string): Boolean;
  public
    function AddClaim(const aName: String; const aTypeID: Integer; const aYear: SmallInt;
      const aGrossClaim: Double;  const aDeductable: Double): Boolean;
    function EditClaim(const aClaimID: Integer; const aName: String; const aTypeID: Integer;
      const aYear: SmallInt; const aGrossClaim: Double;
      const aDeductable: Double): Boolean;
    function DeleteClaim(const aClaimID: Integer): Boolean;

    function GetClaim(const aClaimID: Integer; var aName: String; var aTypeID: Integer; var aYear: SmallInt;
      var aGrossClaim: Double; var aDeductable: Double): Boolean;
    procedure LoadClaims(aClaimList: TClaimList); overload;
    procedure LoadClaims(var aGrid: TStringGrid); overload;

    property OnRefresh: TOnRefresh read fOnRefresh write fOnRefresh;
    property OnMessage: TOnMessage read fOnMessage write fOnMessage;
  end;

var
  ClaimController: TClaimController;

implementation

uses
  System.SysUtils, System.DateUtils, System.Classes, UnitConsts, DMClaims_intf;

{ TClaimController }

procedure TClaimController.LoadClaims(aClaimList: TClaimList);
begin
  DMClaims.LoadClaims(aClaimList);
end;

procedure TClaimController.LoadClaims(var aGrid: TStringGrid);
var
  i: Integer;
  lClaims: TClaimList;
begin
  lClaims := TClaimList.Create;
  try
    LoadClaims(lClaims);

    aGrid.RowCount := lClaims.Count + 1;

    for i := 0 to lClaims.Count - 1 do
    begin
      aGrid.Cells[ClaimID_col, i + 1] := lClaims[i].ID.ToString;
      aGrid.Cells[Name_col, i + 1] := lClaims[i].Name;
      aGrid.Cells[GrossClaim_col, i + 1] := lClaims[i].GrossClaim.ToString;
      aGrid.Cells[Deductible_col, i + 1] := lClaims[i].Deductable.ToString;
      aGrid.Cells[NetClaim_col, i + 1] := lClaims[i].NetClaim.ToString;
      aGrid.Cells[Year_col, i + 1] := lClaims[i].Year.ToString;
      aGrid.Cells[ClaimType_col, i + 1] := lClaims[i].TypeName;
    end;
  finally
    lClaims.Free;
  end;
end;

function TClaimController.Validate(aClaim: IClaim; var aMessage: string): Boolean;
var
  lList: TStringList;
begin
  lList := TStringList.Create;
  try
    //this was not mentioned in the task but i guess it's a good validation idea
    if aClaim.Name = '' then
      lList.Add('Claim name cannot be empty');

    if aClaim.Year > YearOf(Now()) then
      lList.Add('Claim year cannot be in the future');

    if aClaim.Year < YearOf(Now()) - 10 then
      lList.Add('Claim year cannot be more than 10 years into the past');

    //this was not mentioned in the task but i guess it's a good validation idea
    if aClaim.GrossClaim <= 0 then
      lList.Add('Claim gross value cannot be less than zero');

    if aClaim.GrossClaim > 100000 then
      lList.Add('Claim gross value cannot be greater than 100.000');

    //this was not mentioned in the task but i guess it's a good validation idea
    if aClaim.GrossClaim - aClaim.Deductable < 0 then
      lList.Add('Claim deductable value cannot be greater than claim gross value');

    aMessage := lList.Text;

    Result := lList.Count = 0;
  finally
    lList.Free;
  end;
end;

function TClaimController.AddClaim(const aName: String; const aTypeID: Integer;
  const aYear: SmallInt; const aGrossClaim: Double; const aDeductable: Double): Boolean;
var
  lClaim: IClaim;
  lValidationMessage: String;
begin
  Result := False;

  try
    lClaim := TCLaim.Create;
    lClaim.Name := aName;
    lClaim.TypeID := aTypeID;
    lClaim.Year := aYear;
    lClaim.GrossClaim := aGrossClaim;
    lClaim.Deductable := aDeductable;

    if not Validate(lClaim, lValidationMessage) then
    begin
      if Assigned(fOnMessage) then
        fOnMessage(lValidationMessage);

      Exit;
    end;

    DMClaims.AddClaim(lClaim);
    Result := True;

    if Assigned(fOnRefresh) then
      fOnRefresh();
  except on e: Exception do
    if Assigned(fOnMessage) then
      fOnMessage(e.Message);
  end;
end;

function TClaimController.EditClaim(const aClaimID: Integer; const aName: String;
  const aTypeID: Integer; const aYear: SmallInt; const aGrossClaim: Double;
  const aDeductable: Double): Boolean;
var
  lClaim: IClaim;
  lValidationMessage: String;
begin
  Result := False;

  try
    lClaim := DMClaims.GetClaim(aClaimID);

    if Assigned(lClaim) then
    begin
      lClaim.Name := aName;
      lClaim.TypeID := aTypeID;
      lClaim.Year := aYear;
      lClaim.GrossClaim := aGrossClaim;
      lClaim.Deductable := aDeductable;

      if not Validate(lClaim, lValidationMessage) then
      begin
        if Assigned(fOnMessage) then
          fOnMessage(lValidationMessage);

        Exit;
      end;

      DMClaims.EditClaim(lClaim);
      Result := True;
    end
    else if Assigned(fOnMessage) then
      fOnMessage(Format('Claim id = %d not found', [aClaimID]));

    if Assigned(fOnRefresh) then
      fOnRefresh();
  except on e: Exception do
    if Assigned(fOnMessage) then
      fOnMessage(e.Message);
  end;
end;

function TClaimController.GetClaim(const aClaimID: Integer; var aName: String;
  var aTypeID: Integer; var aYear: SmallInt; var aGrossClaim,
  aDeductable: Double): Boolean;
var
  lClaim: IClaim;
begin
  Result := False;

  try
    lClaim := DMClaims.GetClaim(aClaimID);

    if Assigned(lClaim) then
    begin
      aName := lClaim.Name;
      aTypeID := lClaim.TypeID;
      aYear := lClaim.Year;
      aGrossClaim := lClaim.GrossClaim;
      aDeductable := lClaim.Deductable;

      Result := True;
    end
    else if Assigned(fOnMessage) then
      fOnMessage(Format('Claim id = %d not found', [aClaimID]));

  except on e: Exception do
    if Assigned(fOnMessage) then
      fOnMessage(e.Message);
  end;
end;

function TClaimController.DeleteClaim(const aClaimID: Integer): Boolean;
var
  lClaim: IClaim;
begin
  Result := False;

  try
    lClaim := DMClaims.GetClaim(aClaimID);

    if Assigned(lClaim) then
    begin
      DMClaims.DeleteClaim(lClaim);
      Result := True;
    end
    else if Assigned(fOnMessage) then
      fOnMessage(Format('Claim id = %d not found', [aClaimID]));

    if Assigned(fOnRefresh) then
      fOnRefresh();
  except on e: Exception do
    if Assigned(fOnMessage) then
      fOnMessage(e.Message);
  end;
end;

initialization
  ClaimController := TClaimController.Create;

finalization
  ClaimController.Free;

end.
