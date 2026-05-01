program FT8TW_GUI;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, MainForm;

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
