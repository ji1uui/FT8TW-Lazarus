{ FT8TW - Configuration Management
  Application settings storage and loading
  Platform: Windows, macOS
}

unit Configuration;

interface

uses
  Classes, SysUtils, IniFiles, DataTypes;

type
  { Configuration manager class }
  TConfigurationManager = class
  private
    FConfigFile: String;
    FConfig: TAppConfig;
    function BuildDefaultLogFilePath: String;
    procedure ApplyDefaultConfig;
    procedure LoadFromIni(const AIniFile: TIniFile);
    procedure SaveToIni(const AIniFile: TIniFile);
  public
    constructor Create(const AConfigFilePath: String);
    destructor Destroy; override;

    { Configuration operations }
    procedure LoadConfig;
    procedure SaveConfig;
    procedure ResetToDefaults;

    { Individual setting access }
    procedure SetCallsign(const ACallsign: String);
    procedure SetLocator(const ALocator: String);
    procedure SetFrequency(ARxFreq, ATxFreq: Int64);
    procedure SetAudioDevice(ADeviceIndex: Integer);
    procedure SetTheme(const ATheme: String);

    { Properties }
    property Config: TAppConfig read FConfig write FConfig;
    property ConfigFile: String read FConfigFile;
  end;

implementation

{ BuildDefaultLogFilePath / デフォルトのログファイルパス生成
  EN: Build the log file path based on the configuration file directory.
  JP: 設定ファイルのディレクトリを基準にログファイルパスを生成します。
  Args/引数: none
  Returns/戻り値: String - default log file path / デフォルトログファイルパス }
function TConfigurationManager.BuildDefaultLogFilePath: String;
begin
  Result := ExtractFilePath(FConfigFile) + 'ft8tw.log';
end;

{ ApplyDefaultConfig / デフォルト設定の適用
  EN: Populate all configuration fields with safe defaults.
  JP: すべての設定項目を安全なデフォルト値で初期化します。
  Args/引数: none
  Returns/戻り値: none }
procedure TConfigurationManager.ApplyDefaultConfig;
begin
  FConfig.Callsign := DEFAULT_CALLSIGN;
  FConfig.Locator := DEFAULT_LOCATOR;
  FConfig.TxPower := DEFAULT_TX_POWER;
  FConfig.RxFrequency := BAND_80M_FREQ;
  FConfig.TxFrequency := BAND_80M_FREQ;
  FConfig.MonitorMode := DEFAULT_MONITOR_ONLY;
  FConfig.AutoReply := False;
  FConfig.AutoSequence := False;
  FConfig.Theme := DEFAULT_THEME;
  FConfig.LogFile := BuildDefaultLogFilePath;
  FConfig.AudioDevice := 0;
  FConfig.Sensitivity := 50;
  FConfig.ContrastLevel := 50;
end;

{ LoadFromIni / INIから設定を読み込み
  EN: Read configuration values from an opened INI instance.
  JP: 開いているINIインスタンスから設定値を読み込みます。
  Args/引数: AIniFile - source INI object / 読み込み元INIオブジェクト
  Returns/戻り値: none }
procedure TConfigurationManager.LoadFromIni(const AIniFile: TIniFile);
begin
  FConfig.Callsign := AIniFile.ReadString('Station', 'Callsign', DEFAULT_CALLSIGN);
  FConfig.Locator := AIniFile.ReadString('Station', 'Locator', DEFAULT_LOCATOR);
  FConfig.TxPower := AIniFile.ReadInteger('Station', 'TxPower', DEFAULT_TX_POWER);

  FConfig.RxFrequency := AIniFile.ReadInt64('Frequency', 'RxFreq', BAND_80M_FREQ);
  FConfig.TxFrequency := AIniFile.ReadInt64('Frequency', 'TxFreq', BAND_80M_FREQ);

  FConfig.MonitorMode := AIniFile.ReadBool('Operation', 'MonitorOnly', DEFAULT_MONITOR_ONLY);
  FConfig.AutoReply := AIniFile.ReadBool('Operation', 'AutoReply', False);
  FConfig.AutoSequence := AIniFile.ReadBool('Operation', 'AutoSequence', False);

  FConfig.AudioDevice := AIniFile.ReadInteger('Audio', 'Device', 0);
  FConfig.Sensitivity := AIniFile.ReadInteger('Audio', 'Sensitivity', 50);

  FConfig.Theme := AIniFile.ReadString('UI', 'Theme', DEFAULT_THEME);
  FConfig.ContrastLevel := AIniFile.ReadInteger('UI', 'Contrast', 50);
  FConfig.LogFile := AIniFile.ReadString('Logging', 'LogFile', BuildDefaultLogFilePath);
end;

{ SaveToIni / 設定をINIへ保存
  EN: Persist current in-memory configuration to an opened INI instance.
  JP: メモリ上の現在設定を開いているINIインスタンスへ保存します。
  Args/引数: AIniFile - destination INI object / 保存先INIオブジェクト
  Returns/戻り値: none }
procedure TConfigurationManager.SaveToIni(const AIniFile: TIniFile);
begin
  AIniFile.WriteString('Station', 'Callsign', FConfig.Callsign);
  AIniFile.WriteString('Station', 'Locator', FConfig.Locator);
  AIniFile.WriteInteger('Station', 'TxPower', FConfig.TxPower);

  AIniFile.WriteInt64('Frequency', 'RxFreq', FConfig.RxFrequency);
  AIniFile.WriteInt64('Frequency', 'TxFreq', FConfig.TxFrequency);

  AIniFile.WriteBool('Operation', 'MonitorOnly', FConfig.MonitorMode);
  AIniFile.WriteBool('Operation', 'AutoReply', FConfig.AutoReply);
  AIniFile.WriteBool('Operation', 'AutoSequence', FConfig.AutoSequence);

  AIniFile.WriteInteger('Audio', 'Device', FConfig.AudioDevice);
  AIniFile.WriteInteger('Audio', 'Sensitivity', FConfig.Sensitivity);

  AIniFile.WriteString('UI', 'Theme', FConfig.Theme);
  AIniFile.WriteInteger('UI', 'Contrast', FConfig.ContrastLevel);
  AIniFile.WriteString('Logging', 'LogFile', FConfig.LogFile);
end;

constructor TConfigurationManager.Create(const AConfigFilePath: String);
begin
  inherited Create;
  FConfigFile := AConfigFilePath;
  ApplyDefaultConfig;
  LoadConfig;
end;

destructor TConfigurationManager.Destroy;
begin
  inherited;
end;

procedure TConfigurationManager.LoadConfig;
var
  IniFile: TIniFile;
begin
  if not FileExists(FConfigFile) then
  begin
    ApplyDefaultConfig;
    SaveConfig;
    Exit;
  end;

  IniFile := TIniFile.Create(FConfigFile);
  try
    LoadFromIni(IniFile);
  finally
    IniFile.Free;
  end;
end;

procedure TConfigurationManager.SaveConfig;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FConfigFile);
  try
    SaveToIni(IniFile);
  finally
    IniFile.Free;
  end;
end;

procedure TConfigurationManager.ResetToDefaults;
begin
  ApplyDefaultConfig;
  SaveConfig;
end;

procedure TConfigurationManager.SetCallsign(const ACallsign: String);
begin
  FConfig.Callsign := UpperCase(ACallsign);
end;

procedure TConfigurationManager.SetLocator(const ALocator: String);
begin
  FConfig.Locator := UpperCase(ALocator);
end;

procedure TConfigurationManager.SetFrequency(ARxFreq, ATxFreq: Int64);
begin
  FConfig.RxFrequency := ARxFreq;
  FConfig.TxFrequency := ATxFreq;
end;

procedure TConfigurationManager.SetAudioDevice(ADeviceIndex: Integer);
begin
  if ADeviceIndex >= 0 then
    FConfig.AudioDevice := ADeviceIndex;
end;

procedure TConfigurationManager.SetTheme(const ATheme: String);
begin
  FConfig.Theme := ATheme;
end;

end.
