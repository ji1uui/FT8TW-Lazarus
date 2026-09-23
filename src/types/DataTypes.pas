unit DataTypes;

interface

type
  TAppConfig = record
    Callsign: String;
    Locator: String;
    TxPower: Integer;
    RxFrequency: Int64;
    TxFrequency: Int64;
    MonitorMode: Boolean;
    AutoReply: Boolean;
    AutoSequence: Boolean;
    Theme: String;
    LogFile: String;
    AudioDevice: Integer;
    Sensitivity: Integer;
    ContrastLevel: Integer;
  end;

implementation

end.
