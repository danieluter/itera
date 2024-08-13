unit UnitClaims;

interface

uses
  Generics.Collections;

type
  IClaim = interface
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetName: String;
    procedure SetName(Value: String);
    function GetTypeID: Integer;
    procedure SetTypeID(Value: Integer);
    function GetTypeName: String;
    procedure SetTypeName(const Value: String);
    function GetYear: SmallInt;
    procedure SetYear(Value: SmallInt);
    function GetGrossClaim: Double;
    procedure SetGrossClaim(Value: Double);
    function GetDeductable: Double;
    procedure SetDeductable(Value: Double);
    function GetNetClaim: Double;

    property ID: Integer read GetID write SetID;
    property Name: String read GetName write SetName;
    property TypeID: Integer read GetTypeID write SetTypeID;
    property TypeName: String read GetTypeName write SetTypeName;
    property Year: SmallInt read GetYear write SetYear;
    property GrossClaim: Double read GetGrossClaim write SetGrossClaim;
    property Deductable: Double read GetDeductable write SetDeductable;
    property NetClaim: Double read GetNetClaim;
  end;

  TClaim = class(TInterfacedObject, IClaim)
  private
    fId: Integer;
    fName: String;
    fTypeID: Integer;
    fTypeName: String;
    fYear: SmallInt;
    fGrossClaim: Double;
    fDeductable: Double;

    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetName: String;
    procedure SetName(Value: String);
    function GetTypeID: Integer;
    procedure SetTypeID(Value: Integer);
    function GetTypeName: String;
    procedure SetTypeName(const Value: String);
    function GetYear: SmallInt;
    procedure SetYear(Value: SmallInt);
    function GetGrossClaim: Double;
    procedure SetGrossClaim(Value: Double);
    function GetDeductable: Double;
    procedure SetDeductable(Value: Double);
    function GetNetClaim: Double;
  public
    property ID: Integer read GetID write SetID;
    property Name: String read GetName write SetName;
    property TypeID: Integer read GetTypeID write SetTypeID;
    property TypeName: String read GetTypeName write SetTypeName;
    property Year: SmallInt read GetYear write SetYear;
    property GrossClaim: Double read GetGrossClaim write SetGrossClaim;
    property Deductable: Double read GetDeductable write SetDeductable;
    property NetClaim: Double read GetNetClaim;
  end;

  TClaimList = TList<IClaim>;

implementation

{ TClaim }

function TClaim.GetDeductable: Double;
begin
  Result := fDeductable;
end;

function TClaim.GetGrossClaim: Double;
begin
  Result := fGrossClaim;
end;

function TClaim.GetID: Integer;
begin
  Result := fID;
end;

function TClaim.GetName: String;
begin
  Result := fName;
end;

function TClaim.GetNetClaim: Double;
begin
  Result := fGrossClaim - fDeductable;
end;

function TClaim.GetTypeID: Integer;
begin
  Result := fTypeID;
end;

function TClaim.GetTypeName: String;
begin
  Result := fTypeName;
end;

function TClaim.GetYear: SmallInt;
begin
  Result := fYear;
end;

procedure TClaim.SetDeductable(Value: Double);
begin
  fDeductable := Value;
end;

procedure TClaim.SetGrossClaim(Value: Double);
begin
  fGrossClaim := Value;
end;

procedure TClaim.SetID(Value: Integer);
begin
  fId := Value;
end;

procedure TClaim.SetName(Value: String);
begin
  fName := Value;
end;

procedure TClaim.SetTypeID(Value: Integer);
begin
  fTypeID := Value;
end;

procedure TClaim.SetTypeName(const Value: String);
begin
  fTypeName := Value;
end;

procedure TClaim.SetYear(Value: SmallInt);
begin
  fYear := Value;
end;

end.
