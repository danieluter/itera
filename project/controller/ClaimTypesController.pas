unit ClaimTypesController;

interface

uses
  System.Classes;

type
  TClaimTypesController = class
  public
    procedure LoadClaimTypes(aClaimTypeList: TStrings);
  end;

var
  ClaimTypeController: TClaimTypesController;

implementation

uses
  UnitClaimTypes, DMClaimTypes_intf;

{ TClaimTypesController }

procedure TClaimTypesController.LoadClaimTypes(aClaimTypeList: TStrings);
var
  lClaimType: IClaimTYpe;
  lClaimTypes: TClaimTypeList;
begin
  lClaimTypes := TClaimTypeList.Create;
  try
    DMClaimTypes.LoadClaimTypes(lClaimTypes);

    for lClaimType in lClaimTypes do
      aClaimTypeList.AddObject(lClaimType.Name, Pointer(lClaimType.Id));

  finally
    lClaimTypes.Free;
  end;
end;

initialization
  ClaimTypeController := TClaimTypesController.Create;

finalization
  ClaimTypeController.Free;

end.
