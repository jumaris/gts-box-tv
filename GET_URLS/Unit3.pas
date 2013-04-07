unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cefgui, cefvcl,ceflib, ExtCtrls, sPanel;

const FileMenu='Menu\Menu.lst';

type
  TFormOsr = class(TForm)
    OSR: TChromiumOSR;
    ScpText: TMemo;
    sPanel1: TsPanel;
    Timer1: TTimer;
    procedure OSRLoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure OSRLoadError(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; errorCode: Integer; const failedUrl: ustring;
      var errorText: ustring; out Result: Boolean);
    procedure OSRJsAlert(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const message: ustring; out Result: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
   GlobStatus : integer;
    { Public declarations }
  end;

var
  FormOsr: TFormOsr;

implementation

{$R *.dfm}

procedure TFormOsr.FormCreate(Sender: TObject);
begin
 GlobStatus:=0;
 Width:= sPanel1.Width;
 Height:=spanel1.Height;
 OSR.Browser.MainFrame.LoadUrl('http://raketa-tv.com/watch');

end;

procedure TFormOsr.OSRJsAlert(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring; out Result: Boolean);
var LstSourse: TstringList;
begin
  Result:=true;
  LstSourse := TStringList.Create;
  if POs('$EXPORT_LIST$', message)>-1 then
    begin
      osr.Browser.StopLoad;

      LstSourse.Text := StringReplace(message,'$EXPORT_LIST$','',[rfReplaceAll]);
      LstSourse.SaveToFile(FileMenu);
      //ShowMessage(message);
      GlobStatus:=2;
      Close;
    end;
end;

procedure TFormOsr.OSRLoadEnd(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean);
begin
 if (browser <> nil) and ((frame = nil) or (frame.IsMain)) then
  begin
    GlobStatus := 1;
      osr.Browser.MainFrame.ExecuteJavaScript(ScpText.Text

, '', 0);
  end;
end;

procedure TFormOsr.OSRLoadError(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; errorCode: Integer; const failedUrl: ustring;
  var errorText: ustring; out Result: Boolean);
begin
 GlobStatus := -1;
end;

procedure TFormOsr.Timer1Timer(Sender: TObject);
begin
  if GlobStatus=0 then
    sPanel1.Caption := 'Loading...'
  else if  GlobStatus=1 then
    sPanel1.Caption := 'Execute JS/'
  else if GlobStatus = 2 then
   sPanel1.Caption := 'Execute_Ok'
  else if GlobStatus = -1 then
    begin
      if TTimer(Sender).Tag<3 then
        begin
          TTimer(Sender).Tag:= TTimer(Sender).Tag + 1;
          sPanel1.Caption := 'Reloading...'+ IntToStr(TTimer(Sender).Tag);
          GlobStatus:=0;
          OSR.Browser.MainFrame.LoadUrl('http://raketa-tv.com/watch');
        end
      else
        begin
          ShowMessage('Error');
        end;
    end;


end;

end.
