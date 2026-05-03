unit TimeSync;

interface

uses
  Classes, SysUtils;

type
  TTimeManager = class
  public
    function GetCurrentTimeUTC: TDateTime;
    function IsTimeSynced: Boolean;
  end;

implementation

function TTimeManager.GetCurrentTimeUTC: TDateTime;
begin
  Result := Now; // Simplified for stub
end;

function TTimeManager.IsTimeSynced: Boolean;
begin
  Result := True; // Simplified for stub
end;

end.
