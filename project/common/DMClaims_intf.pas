unit DMClaims_intf;

interface

uses
  UnitClaims;

type
  IDMClaims = interface(IInterface)
    procedure AddClaim(aClaim: ICLaim);
    procedure EditClaim(aClaim: ICLaim);
    procedure DeleteClaim(aClaim: ICLaim);
    procedure LoadClaims(var aClaimList: TClaimList);
    function GetClaim(const aClaimID: Integer): ICLaim;
    procedure Initialize;
  end;

var
  DMClaims: IDMClaims;

implementation

end.
