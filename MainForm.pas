unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DataTypes, Constants, Configuration, AudioProcessor, SignalProcessor, FT8Protocol;

type
  { TFrmMain }
  TFrmMain = class(TForm)
  private
    BtnGenerate: TButton;
    BtnSaveConfig: TButton;
    EdCallsign: TEdit;
    EdLocator: TEdit;
    EdRxFreq: TEdit;
    EdTxFreq: TEdit;
    MemoLog: TMemo;
    LblCallsign: TLabel;
    LblLocator: TLabel;
    LblRxFreq: TLabel;
    LblTxFreq: TLabel;
    LblStatus: TLabel;
    ConfigMgr: TConfigurationManager;
    procedure BuildUI;
    procedure LoadConfigToUI;
    procedure SaveUIToConfig;
    procedure HandleGenerateClick(Sender: TObject);
    procedure HandleSaveClick(Sender: TObject);
    procedure Log(const Msg: String);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FrmMain: TFrmMain;

implementation

constructor TFrmMain.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Caption := APP_NAME + ' GUI';
  Width := 760;
  Height := 520;
  Position := poScreenCenter;

  ConfigMgr := TConfigurationManager.Create(ExtractFilePath(ParamStr(0)) + 'ft8tw.ini');
  BuildUI;
  LoadConfigToUI;
  Log('GUI initialized.');
end;

destructor TFrmMain.Destroy;
begin
  ConfigMgr.Free;
  inherited Destroy;
end;

procedure TFrmMain.BuildUI;
begin
  LblCallsign := TLabel.Create(Self);
  LblCallsign.Parent := Self;
  LblCallsign.Caption := 'Callsign';
  LblCallsign.Left := 16;
  LblCallsign.Top := 20;

  EdCallsign := TEdit.Create(Self);
  EdCallsign.Parent := Self;
  EdCallsign.Left := 96;
  EdCallsign.Top := 16;
  EdCallsign.Width := 120;

  LblLocator := TLabel.Create(Self);
  LblLocator.Parent := Self;
  LblLocator.Caption := 'Locator';
  LblLocator.Left := 240;
  LblLocator.Top := 20;

  EdLocator := TEdit.Create(Self);
  EdLocator.Parent := Self;
  EdLocator.Left := 300;
  EdLocator.Top := 16;
  EdLocator.Width := 90;

  LblRxFreq := TLabel.Create(Self);
  LblRxFreq.Parent := Self;
  LblRxFreq.Caption := 'RX Freq (Hz)';
  LblRxFreq.Left := 16;
  LblRxFreq.Top := 56;

  EdRxFreq := TEdit.Create(Self);
  EdRxFreq.Parent := Self;
  EdRxFreq.Left := 96;
  EdRxFreq.Top := 52;
  EdRxFreq.Width := 140;

  LblTxFreq := TLabel.Create(Self);
  LblTxFreq.Parent := Self;
  LblTxFreq.Caption := 'TX Freq (Hz)';
  LblTxFreq.Left := 260;
  LblTxFreq.Top := 56;

  EdTxFreq := TEdit.Create(Self);
  EdTxFreq.Parent := Self;
  EdTxFreq.Left := 340;
  EdTxFreq.Top := 52;
  EdTxFreq.Width := 140;

  BtnGenerate := TButton.Create(Self);
  BtnGenerate.Parent := Self;
  BtnGenerate.Left := 16;
  BtnGenerate.Top := 92;
  BtnGenerate.Width := 180;
  BtnGenerate.Caption := 'Generate/Test Signal';
  BtnGenerate.OnClick := @HandleGenerateClick;

  BtnSaveConfig := TButton.Create(Self);
  BtnSaveConfig.Parent := Self;
  BtnSaveConfig.Left := 210;
  BtnSaveConfig.Top := 92;
  BtnSaveConfig.Width := 130;
  BtnSaveConfig.Caption := 'Save Config';
  BtnSaveConfig.OnClick := @HandleSaveClick;

  LblStatus := TLabel.Create(Self);
  LblStatus.Parent := Self;
  LblStatus.Left := 16;
  LblStatus.Top := 132;
  LblStatus.Width := 700;
  LblStatus.Caption := 'Status: Ready';

  MemoLog := TMemo.Create(Self);
  MemoLog.Parent := Self;
  MemoLog.Left := 16;
  MemoLog.Top := 160;
  MemoLog.Width := 720;
  MemoLog.Height := 300;
  MemoLog.ScrollBars := ssAutoVertical;
end;

procedure TFrmMain.LoadConfigToUI;
begin
  EdCallsign.Text := ConfigMgr.Config.Callsign;
  EdLocator.Text := ConfigMgr.Config.Locator;
  EdRxFreq.Text := IntToStr(ConfigMgr.Config.RxFrequency);
  EdTxFreq.Text := IntToStr(ConfigMgr.Config.TxFrequency);
end;

procedure TFrmMain.SaveUIToConfig;
var
  RxFreq, TxFreq: Int64;
begin
  ConfigMgr.SetCallsign(EdCallsign.Text);
  ConfigMgr.SetLocator(EdLocator.Text);

  RxFreq := StrToInt64Def(EdRxFreq.Text, BAND_80M_FREQ);
  TxFreq := StrToInt64Def(EdTxFreq.Text, BAND_80M_FREQ);
  ConfigMgr.SetFrequency(RxFreq, TxFreq);
end;

procedure TFrmMain.HandleGenerateClick(Sender: TObject);
var
  Samples: TFloatArray;
  RMS, Pwr: Double;
  Raw: String;
  MsgIn, MsgOut: TFT8Message;
begin
  SaveUIToConfig;

  Samples := TAudioProcessor.GenerateTone(1000, 0.2, FT8_SAMPLE_RATE);
  RMS := TSignalProcessor.CalculateRMS(Samples);
  Pwr := TSignalProcessor.EstimateTonePower(Samples, 1000, FT8_SAMPLE_RATE);

  MsgIn.CallsignFrom := ConfigMgr.Config.Callsign;
  MsgIn.CallsignTo := 'CQ';
  MsgIn.Payload := ConfigMgr.Config.Locator;
  Raw := TFT8Protocol.EncodeMessage(MsgIn);
  TFT8Protocol.DecodeMessage(Raw, MsgOut);

  LblStatus.Caption := Format('Status: RMS=%.4f TonePower=%.4f', [RMS, Pwr]);
  Log('Generated 1000Hz tone for 0.2s at 12kHz.');
  Log('Encoded: ' + Raw);
  Log('Decoded: ' + MsgOut.CallsignFrom + ' -> ' + MsgOut.CallsignTo + ' / ' + MsgOut.Payload);
end;

procedure TFrmMain.HandleSaveClick(Sender: TObject);
begin
  SaveUIToConfig;
  ConfigMgr.SaveConfig;
  LblStatus.Caption := 'Status: Configuration saved.';
  Log('Configuration written to: ' + ConfigMgr.ConfigFile);
end;

procedure TFrmMain.Log(const Msg: String);
begin
  MemoLog.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + Msg);
end;

end.
