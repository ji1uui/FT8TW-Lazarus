program FT8TW;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, Configuration, DataTypes, Constants, RigControl, TimeSync;

var
  ConfigManager: TConfigurationManager;
  RigController: TRigController;
  TimeManager: TTimeManager;
  ConfigPath: String;

begin
  WriteLn('Starting FT8TW-Lazarus...');

  ConfigPath := ExtractFilePath(ParamStr(0)) + 'config.ini';
  ConfigManager := TConfigurationManager.Create(ConfigPath);
  RigController := TRigController.Create;
  TimeManager := TTimeManager.Create;
  try
    WriteLn('Application: ', APP_NAME, ' v', APP_VERSION);
    WriteLn('Author: ', APP_AUTHOR);
    WriteLn('Configuration loaded from: ', ConfigManager.ConfigFile);

    if TimeManager.IsTimeSynced then
      WriteLn('System time is synchronized.')
    else
      WriteLn('Warning: System time may not be synchronized. FT8 requires accurate time.');

    // Main application loop or initialization would go here
    WriteLn('Initialization complete. (Stub)');

  finally
    TimeManager.Free;
    RigController.Free;
    ConfigManager.Free;
  end;

  WriteLn('Exiting FT8TW-Lazarus.');
end.
