unit ClaimTypesDataModel;

interface

uses
  UnitClaimTypes,
  DMClaimTypes_intf;

type
  TDMClaimTypes = class(TInterfacedObject, IDMClaimTypes)
  private
    procedure LoadClaimTypes(var aClaimTypeList: TClaimTypeList);
    procedure Initialize;
  public
    constructor Create;
  end;

implementation

uses
  Data.DB,
  ConnectionSettingsUnit;

{ TDMClaimTypes }

constructor TDMClaimTypes.Create;
begin
  inherited Create();

  Initialize;
end;

procedure TDMClaimTypes.Initialize;
begin
//only for tests
end;

procedure TDMClaimTypes.LoadClaimTypes(var aClaimTypeList: TClaimTypeList);
var
  lClaimType: IClaimType;
begin
  with ConnectionObject.Query do
  begin
    Close;
    SQL.Text :=
      'select ID, [Name] from claimTypes ';
    Open;

    while not eof do
    begin
      lClaimType := TClaimType.Create;

      lClaimType.ID := Fields.FieldByName('ID').AsInteger;
      lClaimType.Name := Fields.FieldByName('Name').AsString;

      aClaimTypeList.Add(lClaimType);

      Next;
    end;
  end;
end;

initialization
  DMClaimTypes := TDMClaimTypes.Create;

finalization
  DMClaimTypes := nil;

end.
