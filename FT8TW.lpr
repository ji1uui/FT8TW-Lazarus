program FT8TW;

{$mode objfpc}{$H+}

uses
  SysUtils, Constants, DataTypes, Configuration, AudioProcessor, SignalProcessor, FT8Protocol;

var
  ConfigMgr: TConfigurationManager;
  Samples: TFloatArray;
  MsgIn, MsgOut: TFT8Message;
  Raw: String;
begin
  WriteLn(APP_NAME, ' v', APP_VERSION);

  ConfigMgr := TConfigurationManager.Create('ft8tw.ini');
  try
    Samples := TAudioProcessor.GenerateTone(1000, 0.1, FT8_SAMPLE_RATE);
    WriteLn('RMS: ', FormatFloat('0.0000', TSignalProcessor.CalculateRMS(Samples)));

    MsgIn.CallsignFrom := 'K1ABC';
    MsgIn.CallsignTo := 'JA1XYZ';
    MsgIn.Payload := 'CQ FN31';
    Raw := TFT8Protocol.EncodeMessage(MsgIn);
    if TFT8Protocol.DecodeMessage(Raw, MsgOut) then
      WriteLn('Decoded: ', MsgOut.CallsignFrom, ' -> ', MsgOut.CallsignTo, ' / ', MsgOut.Payload);

    ConfigMgr.SaveConfig;
  finally
    ConfigMgr.Free;
  end;
end.
