program GetMenu;

uses
  Forms,
  Unit3 in 'Unit3.pas' {FormOsr};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormOsr, FormOsr);
  Application.Run;
end.
