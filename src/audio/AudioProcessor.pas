unit AudioProcessor;

interface

uses
  Classes, SysUtils;

type
  TAudioProcessor = class
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TAudioProcessor.Create;
begin
  inherited Create;
end;

destructor TAudioProcessor.Destroy;
begin
  inherited Destroy;
end;

end.
