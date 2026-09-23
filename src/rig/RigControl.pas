unit RigControl;

interface

uses
  Classes, SysUtils;

type
  TRigController = class
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetFrequency(AFreq: Int64);
    procedure SetPTT(AActive: Boolean);
  end;

implementation

constructor TRigController.Create;
begin
  inherited Create;
end;

destructor TRigController.Destroy;
begin
  inherited Destroy;
end;

procedure TRigController.SetFrequency(AFreq: Int64);
begin
  // Stub
end;

procedure TRigController.SetPTT(AActive: Boolean);
begin
  // Stub
end;

end.
