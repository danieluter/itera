unit ClaimsDataModel;

interface

uses
  UnitClaims,
  DMClaims_intf;

type
  TDMClaims = class(TInterfacedObject, IDMClaims)
  private
    procedure AddClaim(aClaim: ICLaim);
    procedure EditClaim(aClaim: ICLaim);
    procedure DeleteClaim(aClaim: ICLaim);
    procedure LoadClaims(var aClaimList: TClaimList);
    function GetClaim(const aClaimID: Integer): ICLaim;
    procedure Initialize;
  public
    constructor Create;
  end;

var
  dm: TDMClaims;

implementation

uses
  Data.DB,
  ConnectionSettingsUnit;

{ TDMClaims }

constructor TDMClaims.Create;
begin
  inherited Create();

  Initialize;
end;

procedure TDMClaims.AddClaim(aClaim: ICLaim);
begin
  with ConnectionObject.Query do
  begin
    Close;
    SQL.Text :=
      'insert into claims ([Name], TypeID, GrossClaim, Deductable, [Year]) '+
      'values (:Name, :TypeID, :GrossClaim, :Deductable, :Year)';
    Parameters.ParamByName('Name').Value := aClaim.Name;
    Parameters.ParamByName('TypeID').Value := aClaim.TypeID;
    Parameters.ParamByName('GrossClaim').Value := aClaim.GrossClaim;
    Parameters.ParamByName('Deductable').Value := aClaim.Deductable;
    Parameters.ParamByName('Year').Value := aClaim.Year;
    ExecSQL;
  end;
end;

procedure TDMClaims.EditClaim(aClaim: ICLaim);
begin
  with ConnectionObject.Query do
  begin
    Close;
    SQL.Text :=
      'update claims set '+
      '[Name] = :Name, '+
      'TypeID = :TypeID, '+
      'GrossClaim = :GrossClaim, '+
      'Deductable = :Deductable, '+
      '[Year] = :Year '+
      'where ID = :ID';
    Parameters.ParamByName('Name').Value := aClaim.Name;
    Parameters.ParamByName('TypeID').Value := aClaim.TypeID;
    Parameters.ParamByName('GrossClaim').Value := aClaim.GrossClaim;
    Parameters.ParamByName('Deductable').Value := aClaim.Deductable;
    Parameters.ParamByName('Year').Value := aClaim.Year;
    Parameters.ParamByName('ID').Value := aClaim.ID;
    ExecSQL;
  end;
end;

procedure TDMClaims.DeleteClaim(aClaim: ICLaim);
begin
  with ConnectionObject.Query do
  begin
    Close;
    SQL.Text :=
      'delete from claims where id = :id';
    Parameters.ParamByName('id').Value := aClaim.ID;
    ExecSQL;
  end;
end;

procedure TDMClaims.LoadClaims(var aClaimList: TClaimList);
var
  lClaim: IClaim;
begin
  with ConnectionObject.Query do
  begin
    Close;
    SQL.Text :=
      'select c.ID, c.[Name], c.TypeID, c.GrossClaim, c.Deductable, c.[Year], ct.[Name] as TypeName '+
      'from Claims as c '+
      '     left join ClaimTypes as ct '+
      '       on c.TypeID = ct.ID ';
    Open;

    while not eof do
    begin
      lClaim := TClaim.Create;

      lClaim.ID := Fields.FieldByName('ID').AsInteger;
      lClaim.Name := Fields.FieldByName('Name').AsString;
      lClaim.TypeID := Fields.FieldByName('TypeID').AsInteger;
      lClaim.TypeName := Fields.FieldByName('TypeName').AsString;
      lClaim.GrossClaim := Fields.FieldByName('GrossClaim').AsFloat;
      lClaim.Deductable := Fields.FieldByName('Deductable').AsFloat;
      lClaim.Year := Fields.FieldByName('Year').AsInteger;

      aClaimList.Add(lClaim);

      Next;
    end;
  end;
end;

function TDMClaims.GetClaim(const aClaimID: Integer): ICLaim;
var
  lClaim: ICLaim;
begin
  Result := nil;

  with ConnectionObject.Query do
  begin
    Close;
    SQL.Text :=
      'select c.ID, c.[Name], c.TypeID, c.GrossClaim, c.Deductable, c.[Year], ct.[Name] as TypeName '+
      'from Claims as c '+
      '     left join ClaimTypes as ct '+
      '       on c.TypeID = ct.ID '+
      'where c.id = :id ';
    Parameters.ParamByName('id').Value := aClaimID;
    Open;

    if not IsEmpty then
    begin
      lClaim := TClaim.Create;

      lClaim.ID := Fields.FieldByName('id').AsInteger;
      lClaim.Name := Fields.FieldByName('Name').AsString;
      lClaim.TypeID := Fields.FieldByName('TypeID').AsInteger;
      lClaim.TypeName := Fields.FieldByName('TypeName').AsString;
      lClaim.GrossClaim := Fields.FieldByName('GrossClaim').AsFloat;
      lClaim.Deductable := Fields.FieldByName('Deductable').AsFloat;
      lClaim.Year := Fields.FieldByName('Year').AsInteger;

      Result := lClaim;
    end;
  end;
end;

procedure TDMClaims.Initialize;
begin
//only for tests
end;

initialization
  DMCLaims := TDMClaims.Create;

finalization
  DMClaims := nil;

end.
