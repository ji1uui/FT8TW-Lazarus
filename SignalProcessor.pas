unit SignalProcessor;

interface

uses
  Math, DataTypes;

type
  TSignalProcessor = class
  public
    class function CalculateRMS(const Samples: TFloatArray): Double;
    class function EstimateTonePower(const Samples: TFloatArray; FrequencyHz: Double; SampleRate: Integer): Double;
  end;

implementation

class function TSignalProcessor.CalculateRMS(const Samples: TFloatArray): Double;
var
  I: Integer;
  Acc: Double;
begin
  if Length(Samples) = 0 then
    Exit(0.0);
  Acc := 0.0;
  for I := 0 to High(Samples) do
    Acc := Acc + Samples[I] * Samples[I];
  Result := Sqrt(Acc / Length(Samples));
end;

class function TSignalProcessor.EstimateTonePower(const Samples: TFloatArray; FrequencyHz: Double; SampleRate: Integer): Double;
var
  I: Integer;
  CosAcc, SinAcc, W: Double;
begin
  CosAcc := 0.0;
  SinAcc := 0.0;
  for I := 0 to High(Samples) do
  begin
    W := 2 * Pi * FrequencyHz * I / SampleRate;
    CosAcc := CosAcc + Samples[I] * Cos(W);
    SinAcc := SinAcc + Samples[I] * Sin(W);
  end;
  Result := Sqrt(CosAcc * CosAcc + SinAcc * SinAcc) / Max(1, Length(Samples));
end;

end.
