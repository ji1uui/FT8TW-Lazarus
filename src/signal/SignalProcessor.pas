unit SignalProcessor;

interface

uses
  Classes, SysUtils;

type
  TSignalProcessor = class
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TSignalProcessor.Create;
begin
  inherited Create;
end;

destructor TSignalProcessor.Destroy;
begin
  inherited Destroy;
end;

end.
