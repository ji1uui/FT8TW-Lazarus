unit AudioDevice;

interface

uses
  Classes, SysUtils;

type
  TAudioDeviceManager = class
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TAudioDeviceManager.Create;
begin
  inherited Create;
end;

destructor TAudioDeviceManager.Destroy;
begin
  inherited Destroy;
end;

end.
