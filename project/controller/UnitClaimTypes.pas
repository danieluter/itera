unit UnitClaimTypes;

interface

uses
  Generics.Collections;

type
  IClaimType = interface
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetName: String;
    procedure SetName(Value: String);

    property ID: Integer read GetID write SetID;
    property Name: String read GetName write SetName;
  end;

  TClaimType = class(TInterfacedObject, IClaimType)
  private
    fId: Integer;
    fName: String;

    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetName: String;
    procedure SetName(Value: String);
  public
    property ID: Integer read GetID write SetID;
    property Name: String read GetName write SetName;
  end;

  TClaimTypeList = TList<IClaimType>;

implementation

{ TClaimType }

function TClaimType.GetID: Integer;
begin
  Result := fId;
end;

function TClaimType.GetName: String;
begin
  Result := fName;
end;

procedure TClaimType.SetID(Value: Integer);
begin
  fId := Value;
end;

procedure TClaimType.SetName(Value: String);
begin
  fName := Value;
end;

end.
