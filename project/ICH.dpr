program ICH;

uses
  Vcl.Forms,
  ClaimsDataModel in 'model\ClaimsDataModel.pas',
  ConnectionSettingsUnit in 'model\ConnectionSettingsUnit.pas',
  FormDBConnection in 'model\FormDBConnection.pas' {frmDBConnection},
  ClaimsController in 'controller\ClaimsController.pas',
  FormClaim in 'view\FormClaim.pas' {frmClaim},
  FormMain in 'view\FormMain.pas' {frmMain},
  UnitConsts in 'common\UnitConsts.pas',
  UnitClaims in 'controller\UnitClaims.pas',
  DMClaims_intf in 'common\DMClaims_intf.pas',
  ClaimTypesController in 'controller\ClaimTypesController.pas',
  UnitClaimTypes in 'controller\UnitClaimTypes.pas',
  DMClaimTypes_intf in 'common\DMClaimTypes_intf.pas',
  ClaimTypesDataModel in 'model\ClaimTypesDataModel.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Insurance Claim Handler';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
