unit UnitFrameMenu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sFrameAdapter, ExtCtrls, sPanel, StdCtrls, sEdit, sButton, sCheckBox,
  sComboBox, ComCtrls, sListView, sScrollBox, sFrameBar, sListBox, ImgList,
  acAlphaImageList;

type
  TFrameMenu = class(TFrame)
    sFrameAdapter1: TsFrameAdapter;
    sTmp: TsButton;
    ImageList: TsAlphaImageList;

    procedure FrameClick(Sender: TObject);
  private
    { Private declarations }
  public
   idList : TStringList;
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TFrameMenu.FrameClick(Sender: TObject);
begin
  idList:=TStringList.Create;
end;

end.
