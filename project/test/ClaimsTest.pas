unit ClaimsTest;

interface

uses
  DUnitX.TestFramework,

  ClaimsDataModel_Test;

type
  [TestFixture]
  TMyTestObject = class
  public
    [Setup]
    procedure Setup;

    [Test]
    procedure TestAddClaim;

    [Test]
    procedure TestAddClaimValidation;

    [Test]
    procedure TestEditClaim;

    [Test]
    procedure TestEditClaimValidation;

    [Test]
    procedure TestEditNonexistingClaim;

    [Test]
    procedure TestDeleteClaim;

    [Test]
    procedure TestDeleteNonexistingClaim;
  end;

implementation

uses
  SysUtils,
  DateUtils,
  ClaimsController,
  UnitClaims,
  DMClaims_intf;

{ TMyTestObject }

procedure TMyTestObject.Setup;
begin
  DMClaims.Initialize;
end;

procedure TMyTestObject.TestAddClaim;
var
  claimFound: Boolean;
  claim: IClaim;
  claims: TClaimList;
  lReturnValue: Boolean;
const
  CLAIM_NAME: string = 'Test';
begin
  claims := TClaimList.Create;
  try
    ClaimController.LoadClaims(claims);
    Assert.AreEqual(2, claims.Count, 'Initial test DB should only contain 2 records');

    claim := TClaim.Create;
    lReturnValue := ClaimController.AddClaim(CLAIM_NAME, 0, YearOf(Now()), 1, 0);

    Assert.AreEqual(True, lReturnValue, 'Should be able to add the claim');

    ClaimController.LoadClaims(claims);
    Assert.AreEqual(3, claims.Count, 'Test database should contain 3 records at this point');

    claimFound := False;
    for claim in claims do
      if claim.Name = CLAIM_NAME then
      begin
        claimFound := True;
        Break;
      end;

    Assert.IsTrue(claimFound, 'Should be able to find the claim');
  finally
    claims.Free;
  end;
end;

procedure TMyTestObject.TestAddClaimValidation;
var
  lReturnValue: Boolean;
begin
  //test name
    //this was not mentioned in the task but i guess it's a good validation idea
  lReturnValue := ClaimController.AddClaim('', 0, YearOf(Now()), 1, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim name cannot be empty');



  //test year validation
  lReturnValue := ClaimController.AddClaim('test', 0, YearOf(Now()), 1, 0);
  Assert.AreEqual(True, lReturnValue, 'Should create current year claim');

  lReturnValue := ClaimController.AddClaim('test', 0, YearOf(Now()) + 1, 1, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim year cannot be in the future');

  lReturnValue := ClaimController.AddClaim('test', 0, YearOf(Now()) - 10, 1, 0);
  Assert.AreEqual(True, lReturnValue, 'Should create 10 year old claim');

  lReturnValue := ClaimController.AddClaim('test', 0, YearOf(Now()) - 11, 1, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim year cannot be more than 10 year into the past');



  //test gross validation
    //this was not mentioned in the task but i guess it's a good validation idea
  lReturnValue := ClaimController.AddClaim('test', 0, YearOf(Now()), 0, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim gross value cannot equal or less than zero');

    //this was not mentioned in the task but i guess it's a good validation idea
  lReturnValue := ClaimController.AddClaim('test', 0, YearOf(Now()), -1, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim gross value cannot equal or less than zero');

  lReturnValue := ClaimController.AddClaim('test', 0, YearOf(Now()), 100000, 0);
  Assert.AreEqual(True, lReturnValue, 'Should add claim not exceeding 100.000 gross value');

  lReturnValue := ClaimController.AddClaim('test', 0, YearOf(Now()), 100001, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim gross value cannot be greater than 100.000');



  //test deductable validation
    //this was not mentioned in the task but i guess it's a good validation idea
  lReturnValue := ClaimController.AddClaim('test', 0, YearOf(Now()), 10, 20);
  Assert.AreEqual(False, lReturnValue, 'Claim deductable value cannot be greater than claim gross value');
end;

procedure TMyTestObject.TestEditClaim;
var
  claimFound: Boolean;
  claim: IClaim;
  claims: TClaimList;
  lReturnValue: Boolean;
const
  CLAIM_ID: Integer = 1;
  CLAIM_NAME: string = 'Test';
begin
  claim := TClaim.Create;
  claims := TClaimList.Create;
  try
    ClaimController.LoadClaims(claims);
    Assert.AreEqual(2, claims.Count, 'Initial test DB should only contain 2 records');

    claim := claims[0];
    Assert.AreEqual(CLAIM_ID, claim.ID, 'Initial test claim id missmatch');
    Assert.AreEqual('Monday', claim.Name, 'Initial test claim name missmatch');

    lReturnValue := ClaimController.EditClaim(CLAIM_ID, CLAIM_NAME, 0, YearOf(Now()), 1, 0);

    Assert.AreEqual(True, lReturnValue, 'Should be able to edit the claim');

    ClaimController.LoadClaims(claims);
    Assert.AreEqual(2, claims.Count, 'Test database should contain 2 records at this point');

    claimFound := False;
    for claim in claims do
      if (claim.ID = CLAIM_ID) and (claim.Name = CLAIM_NAME) then
      begin
        claimFound := True;
        Break;
      end;

    Assert.IsTrue(claimFound, 'Should be able to find the claim');
  finally
    claims.Free;
  end;
end;

procedure TMyTestObject.TestEditClaimValidation;
var
  lReturnValue: Boolean;
begin
  //test name
    //this was not mentioned in the task but i guess it's a good validation idea
  lReturnValue := ClaimController.EditClaim(1, '', 0, YearOf(Now()), 1, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim name cannot be empty');



  //test year validation
  lReturnValue := ClaimController.EditClaim(1, 'test', 0, YearOf(Now()), 1, 0);
  Assert.AreEqual(True, lReturnValue, 'Should edit current year claim');

  lReturnValue := ClaimController.EditClaim(1, 'test', 0, YearOf(Now()) + 1, 1, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim year cannot be in the future');

  lReturnValue := ClaimController.EditClaim(1, 'test', 0, YearOf(Now()) - 10, 1, 0);
  Assert.AreEqual(True, lReturnValue, 'Should edit 10 year old claim');

  lReturnValue := ClaimController.EditClaim(1, 'test', 0, YearOf(Now()) - 11, 1, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim year cannot be more than 10 year into the past');



  //test gross validation
    //this was not mentioned in the task but i guess it's a good validation idea
  lReturnValue := ClaimController.EditClaim(1, 'test', 0, YearOf(Now()), 0, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim gross value cannot be equal or less than zero');

    //this was not mentioned in the task but i guess it's a good validation idea
  lReturnValue := ClaimController.EditClaim(1, 'test', 0, YearOf(Now()), -1, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim gross value cannot be equal or less than zero');

  lReturnValue := ClaimController.EditClaim(1, 'test', 0, YearOf(Now()), 100000, 0);
  Assert.AreEqual(True, lReturnValue, 'Should edit claim not exceeding 100.000 gross value');

  lReturnValue := ClaimController.EditClaim(1, 'test', 0, YearOf(Now()), 100001, 0);
  Assert.AreEqual(False, lReturnValue, 'Claim gross value cannot be greater than 100.000');



  //test deductable validation
    //this was not mentioned in the task but i guess it's a good validation idea
  lReturnValue := ClaimController.EditClaim(1, 'test', 0, YearOf(Now()), 10, 20);
  Assert.AreEqual(False, lReturnValue, 'Claim deductable value cannot be greater than claim gross value');
end;

procedure TMyTestObject.TestEditNonexistingClaim;
var
  claimFound: Boolean;
  claim: IClaim;
  claims: TClaimList;
  lReturnValue: Boolean;
const
  CLAIM_ID: Integer = 100;
  CLAIM_NAME: string = 'Test';
begin
  claim := TClaim.Create;
  claims := TClaimList.Create;
  try
    lReturnValue := ClaimController.EditClaim(CLAIM_ID, CLAIM_NAME, 0, 0, 0, 0);

    Assert.AreEqual(False, lReturnValue, 'Should not be able to edit a nonexisting claim');

    ClaimController.LoadClaims(claims);
    Assert.AreEqual(2, claims.Count, 'Test database should contain 2 records at this point');

    claimFound := False;
    for claim in claims do
      if (claim.ID = CLAIM_ID) or (claim.Name = CLAIM_NAME) then
      begin
        claimFound := True;
        Break;
      end;

    Assert.IsFalse(claimFound, 'Should not be able to find the claim');
  finally
    claims.Free;
  end;
end;

procedure TMyTestObject.TestDeleteClaim;
var
  claimFound: Boolean;
  claim: IClaim;
  claims: TClaimList;
  lReturnValue: Boolean;
const
  CLAIM_ID: Integer = 1;
begin
  claims := TClaimList.Create;
  try
    ClaimController.LoadClaims(claims);
    Assert.AreEqual(2, claims.Count, 'Initial test DB should only contain 2 records');

    lReturnValue := ClaimController.DeleteClaim(CLAIM_ID);

    Assert.AreEqual(True, lReturnValue, 'Should be able to delete a claim');

    ClaimController.LoadClaims(claims);
    Assert.AreEqual(1, claims.Count, 'Test database should contain 1 record at this point');

    claimFound := False;
    for claim in claims do
      if claim.ID = CLAIM_ID then
      begin
        claimFound := True;
        Break;
      end;

    Assert.IsFalse(claimFound, 'Should not be able to find the claim');
  finally
    claims.Free;
  end;
end;

procedure TMyTestObject.TestDeleteNonexistingClaim;
var
  claims: TClaimList;
  lReturnValue: Boolean;
const
  CLAIM_ID: Integer = 100;
begin
  claims := TClaimList.Create;
  try
    ClaimController.LoadClaims(claims);
    Assert.AreEqual(2, claims.Count, 'Initial test DB should only contain 2 records');

    lReturnValue := ClaimController.DeleteClaim(CLAIM_ID);

    Assert.AreEqual(False, lReturnValue, 'Should not be able to delete a claim');

    ClaimController.LoadClaims(claims);
    Assert.AreEqual(2, claims.Count, 'Test database should contain 2 records at this point');
  finally
    claims.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
