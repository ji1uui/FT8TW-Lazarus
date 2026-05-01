unit DataTypes;

interface

type
  TFloatArray = array of Double;
  TIntArray = array of Integer;

  TComplex = record
    Re: Double;
    Im: Double;
  end;

  TComplexArray = array of TComplex;

  TAudioFrame = record
    SampleRate: Integer;
    Channels: Integer;
    Samples: TFloatArray;
  end;

  TDecodeResult = record
    Success: Boolean;
    MessageText: String;
    SNR: Integer;
    FrequencyHz: Integer;
    TimeOffsetSec: Double;
  end;

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
