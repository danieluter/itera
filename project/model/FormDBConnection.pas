unit FormDBConnection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls;

type
  TfrmDBConnection = class(TForm)
    edServerName: TEdit;
    edUserName: TEdit;
    edPassword: TEdit;
    edDatabaseName: TEdit;
    btnTestConnection: TButton;
    lblServerName: TLabel;
    lblUserName: TLabel;
    lblPassword: TLabel;
    lblDatabaseName: TLabel;
    procedure btnTestConnectionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fConnection: TADOConnection;
    { Private declarations }
    procedure LoadConnectionSettings;
    procedure SaveConnectionSettings;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AConnection: TAdoConnection); reintroduce;
  end;

var
  frmDBConnection: TfrmDBConnection;

implementation

uses
  System.IOUtils, System.IniFiles, ConnectionSettingsUnit, UnitConsts;

{$R *.dfm}

procedure TfrmDBConnection.btnTestConnectionClick(Sender: TObject);
begin
  fConnection.Connected := False;
  try
    fConnection.ConnectionString :=
      Format(ConnectionSettings.UnformattedConnectionString,
             [edServerName.Text,
              edUserName.Text,
              edPassword.Text,
              edDatabaseName.Text]);

    fConnection.Connected := True;

    SaveConnectionSettings;

    ModalResult := mrOK;

  except on E: Exception do
    ShowMessage('Connection failed. Please check your settings');
  end;
end;

constructor TfrmDBConnection.Create(AOwner: TComponent;
  AConnection: TAdoConnection);
begin
  inherited Create(AOwner);

  fConnection := AConnection;
end;

procedure TfrmDBConnection.FormCreate(Sender: TObject);
begin
  LoadConnectionSettings;
end;

procedure TfrmDBConnection.LoadConnectionSettings;
begin
  edServerName.Text := ConnectionSettings.ServerName;
  edUserName.Text := ConnectionSettings.UserName;
  edPassword.Text := ConnectionSettings.Password;
  edDatabaseName.Text := ConnectionSettings.DatabaseName;
end;

procedure TfrmDBConnection.SaveConnectionSettings;
begin
  ConnectionSettings.ServerName := edServerName.Text;
  ConnectionSettings.UserName := edUserName.Text;
  ConnectionSettings.Password := edPassword.Text;
  ConnectionSettings.DatabaseName := edDatabaseName.Text;
end;

end.
