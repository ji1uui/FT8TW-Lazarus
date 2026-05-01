unit FT8Protocol;

interface

uses
  SysUtils;

type
  TFT8Message = record
    CallsignFrom: String;
    CallsignTo: String;
    Payload: String;
  end;

  TFT8Protocol = class
  public
    class function EncodeMessage(const Msg: TFT8Message): String;
    class function DecodeMessage(const Raw: String; out Msg: TFT8Message): Boolean;
  end;

implementation

class function TFT8Protocol.EncodeMessage(const Msg: TFT8Message): String;
begin
  Result := Trim(Msg.CallsignFrom) + '>' + Trim(Msg.CallsignTo) + ':' + Trim(Msg.Payload);
end;

class function TFT8Protocol.DecodeMessage(const Raw: String; out Msg: TFT8Message): Boolean;
var
  ArrowPos, ColonPos: SizeInt;
begin
  Result := False;
  ArrowPos := Pos('>', Raw);
  ColonPos := Pos(':', Raw);
  if (ArrowPos < 2) or (ColonPos <= ArrowPos + 1) then
    Exit;
  Msg.CallsignFrom := Trim(Copy(Raw, 1, ArrowPos - 1));
  Msg.CallsignTo := Trim(Copy(Raw, ArrowPos + 1, ColonPos - ArrowPos - 1));
  Msg.Payload := Trim(Copy(Raw, ColonPos + 1, MaxInt));
  Result := (Msg.CallsignFrom <> '') and (Msg.CallsignTo <> '');
end;

end.
