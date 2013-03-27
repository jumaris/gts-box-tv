program ugTSboxTV;

uses
  Forms,
  gTSboxTV in 'gTSboxTV.pas' {FrmMain},
  uTLibVLC in 'uTLibVLC.pas',
  gtse_play in 'gtse_play.pas',
  gtsengine in 'gtsengine.pas',
  UnitFrameMenu in 'UnitFrameMenu.pas' {FrameMenu: TFrame},
  UBarForm in 'UBarForm.pas' {BarForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TBarForm, BarForm);
  Application.Run;
end.
