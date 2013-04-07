program tsSniff;

uses
  Forms,
  Unit3 in '..\TS_SNIFF\Unit3.pas' {Form3},
  gtsengine in '..\tsengine\gtsengine.pas',
  gtse_play in '..\tsengine\gtse_play.pas',
  gParamStrings in '..\tsengine\gParamStrings.pas',
  gSniffLogTS in '..\TS_SNIFF\gSniffLogTS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
