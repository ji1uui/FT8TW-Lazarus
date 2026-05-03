unit FT8Protocol;

interface

uses
  Classes, SysUtils;

type
  TFT8Protocol = class
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TFT8Protocol.Create;
begin
  inherited Create;
end;

destructor TFT8Protocol.Destroy;
begin
  inherited Destroy;
end;

end.
