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
    FIniFile: TIniFile;
    procedure LoadDefaultConfig;
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

constructor TConfigurationManager.Create(const AConfigFilePath: String);
begin
  inherited Create;
  FConfigFile := AConfigFilePath;
  LoadDefaultConfig;
  LoadConfig;
end;

destructor TConfigurationManager.Destroy;
begin
  if Assigned(FIniFile) then
    FIniFile.Free;
  inherited;
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
begin
  if FileExists(FConfigFile) then
  begin
    FIniFile := TIniFile.Create(FConfigFile);
    try
      with FConfig do
      begin
        { Station settings }
        Callsign := FIniFile.ReadString('Station', 'Callsign', DEFAULT_CALLSIGN);
        Locator := FIniFile.ReadString('Station', 'Locator', DEFAULT_LOCATOR);
        TxPower := FIniFile.ReadInteger('Station', 'TxPower', DEFAULT_TX_POWER);

        { Frequency settings }
        RxFrequency := FIniFile.ReadInt64('Frequency', 'RxFreq', BAND_80M_FREQ);
        TxFrequency := FIniFile.ReadInt64('Frequency', 'TxFreq', BAND_80M_FREQ);

        { Operation mode }
        MonitorMode := FIniFile.ReadBool('Operation', 'MonitorOnly', DEFAULT_MONITOR_ONLY);
        AutoReply := FIniFile.ReadBool('Operation', 'AutoReply', False);
        AutoSequence := FIniFile.ReadBool('Operation', 'AutoSequence', False);

        { Audio }
        AudioDevice := FIniFile.ReadInteger('Audio', 'Device', 0);
        Sensitivity := FIniFile.ReadInteger('Audio', 'Sensitivity', 50);

        { User Interface }
        Theme := FIniFile.ReadString('UI', 'Theme', DEFAULT_THEME);
        ContrastLevel := FIniFile.ReadInteger('UI', 'Contrast', 50);

        { Logging }
        LogFile := FIniFile.ReadString('Logging', 'LogFile',
          ExtractFilePath(FConfigFile) + 'ft8tw.log');
      end;
    finally
      FIniFile.Free;
    end;
  end
  else
  begin
    LoadDefaultConfig;
    SaveConfig;
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
      { Station settings }
      IniFile.WriteString('Station', 'Callsign', Callsign);
      IniFile.WriteString('Station', 'Locator', Locator);
      IniFile.WriteInteger('Station', 'TxPower', TxPower);

      { Frequency settings }
      IniFile.WriteInt64('Frequency', 'RxFreq', RxFrequency);
      IniFile.WriteInt64('Frequency', 'TxFreq', TxFrequency);

      { Operation mode }
      IniFile.WriteBool('Operation', 'MonitorOnly', MonitorMode);
      IniFile.WriteBool('Operation', 'AutoReply', AutoReply);
      IniFile.WriteBool('Operation', 'AutoSequence', AutoSequence);

      { Audio }
      IniFile.WriteInteger('Audio', 'Device', AudioDevice);
      IniFile.WriteInteger('Audio', 'Sensitivity', Sensitivity);

      { User Interface }
      IniFile.WriteString('UI', 'Theme', Theme);
      IniFile.WriteInteger('UI', 'Contrast', ContrastLevel);

      { Logging }
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