unit AudioProcessor;

interface

uses
  Math, DataTypes;

type
  TAudioProcessor = class
  public
    class function Normalize(const Samples: TFloatArray): TFloatArray;
    class function GenerateTone(FrequencyHz, DurationSec: Double; SampleRate: Integer): TFloatArray;
  end;

implementation

class function TAudioProcessor.Normalize(const Samples: TFloatArray): TFloatArray;
var
  I: Integer;
  Peak: Double;
begin
  SetLength(Result, Length(Samples));
  Peak := 0.0;
  for I := 0 to High(Samples) do
    Peak := Max(Peak, Abs(Samples[I]));

  if Peak = 0.0 then
  begin
    for I := 0 to High(Samples) do
      Result[I] := Samples[I];
    Exit;
  end;

  for I := 0 to High(Samples) do
    Result[I] := Samples[I] / Peak;
end;

class function TAudioProcessor.GenerateTone(FrequencyHz, DurationSec: Double; SampleRate: Integer): TFloatArray;
var
  I, N: Integer;
  T: Double;
begin
  N := Round(DurationSec * SampleRate);
  SetLength(Result, N);
  for I := 0 to N - 1 do
  begin
    T := I / SampleRate;
    Result[I] := Sin(2 * Pi * FrequencyHz * T);
  end;
end;

end.
