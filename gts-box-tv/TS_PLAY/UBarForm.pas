unit UBarForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel;

type
  TBarForm = class(TForm)
    sPanelBottom: TsPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BarForm: TBarForm;

implementation

{$R *.dfm}

end.
