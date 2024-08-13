unit ConnectionSettingsUnit;

interface

uses
  Data.Win.ADODB;

type
  TConnectionSettings = record
  private
    procedure Initialize;
    procedure Finalize;

    function SimpleEncrypt(const Input: string): string;
    function SimpleDecrypt(const Input: string): string;
  public
    ServerName: String;
    UserName: String;
    Password: String;
    DatabaseName: String;

    function ConnectionString: string;
    function UnformattedConnectionString: String;
  end;

  TConnectionObject = record
  private
    fInitialized: Boolean;
    fConnection: TAdoConnection;
    fQuery: TAdoQuery;

    procedure Initialize;
    procedure Finalize;
  public
    property Query: TADOQuery read fQuery write fQuery;
  end;

var
  ConnectionSettings: TConnectionSettings;
  ConnectionObject: TConnectionObject;

implementation

uses
  System.SysUtils, System.IOUtils, System.IniFiles, Vcl.Forms, UnitConsts, Vcl.Dialogs,
  FormDBConnection, Vcl.Controls;

{ TDatabaseConnectionSettings }

function TConnectionSettings.UnformattedConnectionString: String;
begin
  Result :=
    'Provider=MSOLEDBSQL.1;'+
    'Persist Security Info=False;'+
    'Data Source=%s;'+
    'User ID=%s;'+
    'Password=%s;'+
    'Initial Catalog=%s;'+
    'Initial File Name="";'+
    'Server SPN="";'+
    'Authentication="";'+
    'Access Token="";'
end;

function TConnectionSettings.ConnectionString: string;
begin
  Result :=
    Format(UnformattedConnectionString,
          [ConnectionSettings.ServerName,
           ConnectionSettings.UserName,
           ConnectionSettings.Password,
           ConnectionSettings.DatabaseName]);
end;

procedure TConnectionSettings.Initialize;
var
  lIni: TIniFile;
  lConfigPath: String;
begin
  lConfigPath := TPath.Combine(ExtractFilePath(Application.ExeName), CONFIG_INI);

  lIni := TIniFile.Create(lConfigPath);
  try
    ConnectionSettings.ServerName := SimpleDecrypt(lIni.ReadString('Database', 'ServerName', ''));
    ConnectionSettings.UserName := SimpleDecrypt(lIni.ReadString('Database', 'UserName', ''));
    ConnectionSettings.Password := SimpleDecrypt(lIni.ReadString('Database', 'Password', ''));
    ConnectionSettings.DatabaseName := SimpleDecrypt(lIni.ReadString('Database', 'DatabaseName', ''));
  finally
    lIni.Free;
  end;
end;

function TConnectionSettings.SimpleDecrypt(const Input: string): string;
var
  i: Integer;
  DecryptedChar: Char;
begin
  Result := '';
  for i := 1 to Length(Input) do
  begin
    DecryptedChar := Chr(Ord(Input[i]) - 3);
    Result := Result + DecryptedChar;
  end;
end;

function TConnectionSettings.SimpleEncrypt(const Input: string): string;
var
  i: Integer;
  EncryptedChar: Char;
begin
  Result := '';
  for i := 1 to Length(Input) do
  begin
    EncryptedChar := Chr(Ord(Input[i]) + 3);
    Result := Result + EncryptedChar;
  end;
end;

procedure TConnectionSettings.Finalize;
var
  lIni: TIniFile;
  lConfigPath: String;
begin
  lConfigPath := TPath.Combine(ExtractFilePath(Application.ExeName), CONFIG_INI);

  lIni := TIniFile.Create(lConfigPath);
  try
    lIni.WriteString('Database', 'ServerName', SimpleEncrypt(ConnectionSettings.ServerName));
    lIni.WriteString('Database', 'UserName', SimpleEncrypt(ConnectionSettings.UserName));
    lIni.WriteString('Database', 'Password', SimpleEncrypt(ConnectionSettings.Password));
    lIni.WriteString('Database', 'DatabaseName', SimpleEncrypt(ConnectionSettings.DatabaseName));
  finally
    lIni.Free;
  end;
end;

{ TConnectionObject }

procedure TConnectionObject.Finalize;
begin
  if Assigned(fQuery) then
    fQuery.Free;

  if Assigned(fConnection) then
    fConnection.Free;
end;

procedure TConnectionObject.Initialize;
var
  frmDBConnection: TfrmDBConnection;
begin
  if fInitialized then
    Exit;

  fInitialized := True;

  fConnection := TADOConnection.Create(nil);

  fQuery := TAdoQuery.Create(nil);
  fQuery.Connection := fConnection;

  fConnection.ConnectionString := ConnectionSettings.ConnectionString;

  try
    fConnection.Connected	:= True;
  except
    on E: Exception do
    begin
      ShowMessage('Connection failed. Please check your settings');

      frmDBConnection := TfrmDBConnection.Create(nil, fConnection);
      try
        if frmDBConnection.ShowModal <> mrOK then
          Application.Terminate;
      finally
        frmDBConnection.Free;
      end;
    end;
  end;
end;

initialization
  ConnectionSettings.Initialize;
  ConnectionObject.Initialize;

finalization
  ConnectionSettings.Finalize;
  ConnectionObject.Finalize;

end.
