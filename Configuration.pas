unit Configuration;

interface

uses
  Classes, SysUtils, IniFiles, DataTypes, Constants;

type
  TConfigurationManager = class
  private
    FConfigFile: String;
    FConfig: TAppConfig;
    procedure LoadDefaultConfig;
  public
    constructor Create(const AConfigFilePath: String);
    procedure LoadConfig;
    procedure SaveConfig;
    procedure ResetToDefaults;

    procedure SetCallsign(const ACallsign: String);
    procedure SetLocator(const ALocator: String);
    procedure SetFrequency(ARxFreq, ATxFreq: Int64);
    procedure SetAudioDevice(ADeviceIndex: Integer);
    procedure SetTheme(const ATheme: String);

    property Config: TAppConfig read FConfig write FConfig;
    property ConfigFile: String read FConfigFile;
  end;

implementation

constructor TConfigurationManager.Create(const AConfigFilePath: String);
begin
  inherited Create;
  FConfigFile := AConfigFilePath;
  LoadDefaultConfig;
  LoadConfig;
end;

procedure TConfigurationManager.LoadDefaultConfig;
begin
  with FConfig do
  begin
    Callsign := DEFAULT_CALLSIGN;
    Locator := DEFAULT_LOCATOR;
    TxPower := DEFAULT_TX_POWER;
    RxFrequency := BAND_80M_FREQ;
    TxFrequency := BAND_80M_FREQ;
    MonitorMode := DEFAULT_MONITOR_ONLY;
    AutoReply := False;
    AutoSequence := False;
    Theme := DEFAULT_THEME;
    LogFile := ExtractFilePath(FConfigFile) + 'ft8tw.log';
    AudioDevice := 0;
    Sensitivity := 50;
    ContrastLevel := 50;
  end;
end;

procedure TConfigurationManager.LoadConfig;
var
  IniFile: TIniFile;
begin
  if not FileExists(FConfigFile) then
  begin
    SaveConfig;
    Exit;
  end;

  IniFile := TIniFile.Create(FConfigFile);
  try
    with FConfig do
    begin
      Callsign := IniFile.ReadString('Station', 'Callsign', DEFAULT_CALLSIGN);
      Locator := IniFile.ReadString('Station', 'Locator', DEFAULT_LOCATOR);
      TxPower := IniFile.ReadInteger('Station', 'TxPower', DEFAULT_TX_POWER);
      RxFrequency := IniFile.ReadInt64('Frequency', 'RxFreq', BAND_80M_FREQ);
      TxFrequency := IniFile.ReadInt64('Frequency', 'TxFreq', BAND_80M_FREQ);
      MonitorMode := IniFile.ReadBool('Operation', 'MonitorOnly', DEFAULT_MONITOR_ONLY);
      AutoReply := IniFile.ReadBool('Operation', 'AutoReply', False);
      AutoSequence := IniFile.ReadBool('Operation', 'AutoSequence', False);
      AudioDevice := IniFile.ReadInteger('Audio', 'Device', 0);
      Sensitivity := IniFile.ReadInteger('Audio', 'Sensitivity', 50);
      Theme := IniFile.ReadString('UI', 'Theme', DEFAULT_THEME);
      ContrastLevel := IniFile.ReadInteger('UI', 'Contrast', 50);
      LogFile := IniFile.ReadString('Logging', 'LogFile', ExtractFilePath(FConfigFile) + 'ft8tw.log');
    end;
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
    with FConfig do
    begin
      IniFile.WriteString('Station', 'Callsign', Callsign);
      IniFile.WriteString('Station', 'Locator', Locator);
      IniFile.WriteInteger('Station', 'TxPower', TxPower);
      IniFile.WriteInt64('Frequency', 'RxFreq', RxFrequency);
      IniFile.WriteInt64('Frequency', 'TxFreq', TxFrequency);
      IniFile.WriteBool('Operation', 'MonitorOnly', MonitorMode);
      IniFile.WriteBool('Operation', 'AutoReply', AutoReply);
      IniFile.WriteBool('Operation', 'AutoSequence', AutoSequence);
      IniFile.WriteInteger('Audio', 'Device', AudioDevice);
      IniFile.WriteInteger('Audio', 'Sensitivity', Sensitivity);
      IniFile.WriteString('UI', 'Theme', Theme);
      IniFile.WriteInteger('UI', 'Contrast', ContrastLevel);
      IniFile.WriteString('Logging', 'LogFile', LogFile);
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TConfigurationManager.ResetToDefaults;
begin
  LoadDefaultConfig;
  SaveConfig;
end;

procedure TConfigurationManager.SetCallsign(const ACallsign: String);
begin
  FConfig.Callsign := UpperCase(Trim(ACallsign));
end;

procedure TConfigurationManager.SetLocator(const ALocator: String);
begin
  FConfig.Locator := UpperCase(Trim(ALocator));
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
  if Trim(ATheme) <> '' then
    FConfig.Theme := ATheme;
end;

end.
