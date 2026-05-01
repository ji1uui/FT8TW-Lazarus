unit AudioDevice;

interface

uses
  Classes, SysUtils;

type
  TAudioDeviceInfo = record
    Index: Integer;
    Name: String;
    InputChannels: Integer;
    OutputChannels: Integer;
    SampleRate: Integer;
  end;

  TAudioDeviceList = array of TAudioDeviceInfo;

  TAudioDeviceManager = class
  public
    class function EnumerateInputDevices: TAudioDeviceList;
    class function GetDefaultInputDevice: TAudioDeviceInfo;
  end;

implementation

class function TAudioDeviceManager.EnumerateInputDevices: TAudioDeviceList;
begin
  SetLength(Result, 1);
  Result[0].Index := 0;
  Result[0].Name := 'Default Input Device';
  Result[0].InputChannels := 1;
  Result[0].OutputChannels := 0;
  Result[0].SampleRate := 12000;
end;

class function TAudioDeviceManager.GetDefaultInputDevice: TAudioDeviceInfo;
begin
  Result := EnumerateInputDevices[0];
end;

end.
