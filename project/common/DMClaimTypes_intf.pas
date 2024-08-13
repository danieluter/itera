unit DMClaimTypes_intf;

interface

uses
  UnitClaimTypes;

type
  IDMClaimTypes = interface(IInterface)
    procedure LoadClaimTypes(var aClaimTypeList: TClaimTypeList);
    procedure Initialize;
  end;

var
  DMClaimTypes: IDMClaimTypes;

implementation

end.
