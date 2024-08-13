unit ClaimsDataModel_test;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,

  UnitClaims, DMClaims_intf;

type
  TDMClaims = class(TInterfacedObject, IDMClaims)
  private
    LocalClaimList: TClaimList;

    procedure AddClaim(aClaim: ICLaim);
    procedure EditClaim(aClaim: ICLaim);
    procedure DeleteClaim(aClaim: ICLaim);
    procedure LoadClaims(var aClaimList: TClaimList);
    function GetClaim(const aClaimID: Integer): ICLaim;

    procedure Initialize;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TDMClaims }

constructor TDMClaims.Create;
begin
  inherited;

  LocalClaimList := TClaimList.Create();
end;

destructor TDMClaims.Destroy;
begin
  LocalClaimList.Free;

  inherited;
end;


procedure TDMClaims.LoadClaims(var aClaimList: TClaimList);
begin
  aClaimList.Clear;

  for var claim: IClaim in LocalClaimList do
    aClaimList.Add(claim);
end;

procedure TDMClaims.AddClaim(aClaim: ICLaim);
begin
  LocalClaimList.Add(aClaim);
end;

procedure TDMClaims.EditClaim(aClaim: ICLaim);
begin
  for var claim: ICLaim in LocalClaimList do
    if claim.ID = aClaim.ID then
    begin
      LocalClaimList[LocalClaimList.IndexOf(claim)] := aClaim;
      Break;
    end;
end;

procedure TDMClaims.DeleteClaim(aClaim: ICLaim);
begin
  LocalClaimList.Remove(aClaim);
end;

function TDMClaims.GetClaim(const aClaimID: Integer): ICLaim;
begin
  for var claim: IClaim in LocalClaimList do
    if claim.ID = aClaimID then
    begin
      result := claim;
      Break;
    end;
end;

procedure TDMClaims.Initialize;
var
  claim: IClaim;
begin
  //mock data

  LocalClaimList.Clear;

  claim := TCLaim.Create();
  claim.ID := 1;
  claim.Name := 'Monday';
  LocalClaimList.Add(claim);

  claim := TCLaim.Create();
  claim.ID := 2;
  claim.Name := 'Tuesday';
  LocalClaimList.Add(claim);
end;

initialization
  DMCLaims := TDMClaims.Create;

finalization
  DMClaims := nil;

end.
