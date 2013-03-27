
unit gTSboxTV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, uTLibVLC, ScktComp, Spin, Menus,  gtse_play,
  xmldom, XMLIntf, sScrollBox, sFrameBar, msxmldom, XMLDoc, sSkinManager,
  ImgList, acAlphaImageList, UnitFrameMenu,sButton, uBarForm,
   Jpeg, pngimage, GIFImg, sPanel, sEdit, sTrackBar, sGroupBox, ShellApi;

const
  ChrCRLF   = #13#10;
  HTTP_PORT = 222;
  RC_PORT   = 333;

type
  TOnIsPLaying       = procedure(p_event : Plibvlc_event_t; userdata : Pointer); cdecl;
  TMethodOnIsPlaying = procedure(p_event : Plibvlc_event_t; userdata : Pointer) of object; cdecl;

type
  TFrmMain = class(TForm)
    Panel1: TPanel;
    BtnInit: TButton;
    BtnPause: TButton;
    BtnStop: TButton;
    Label1: TLabel;
    MmoOptBase: TMemo;
    Label3: TLabel;
    MmoOptPlay: TMemo;
    BtnStartPlay: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    MemoPlay: TMemo;
    EdtURLBase: TEdit;
    EdtUrlPlay: TEdit;
    BtnTrack: TButton;
    Button2: TButton;
    Button1: TButton;
    Button5: TButton;
    SpinEdit1: TSpinEdit;
    Label5: TLabel;
    BtnOpen: TButton;
    DlgOpen: TOpenDialog;
    Label7: TLabel;
    EdtDelay: TSpinEdit;
    Button6: TButton;
    SpinEdit2: TSpinEdit;
    Label8: TLabel;
    Button8: TButton;
    BtnFullscreen: TButton;
    Button7: TButton;
    BtnSnapshot: TButton;
    BtnDeinterlace: TButton;
    Button3: TButton;
    Button4: TButton;
    MemoBase: TMemo;
    Timer1: TTimer;
    Timer2: TTimer;
    LblStat: TLabel;
    PanBar: TPanel;
    ImageList24: TsAlphaImageList;
    sSkinManager1: TsSkinManager;
    pan_Video: TPanel;
    sFrameBar1: TsFrameBar;
    Timer3: TTimer;
    XML_Menu: TXMLDocument;
    edtPID: TsEdit;
    sPanControl: TsGroupBox;
    btn_Stop: TsButton;
    btn_PLAY: TsButton;
    sButton4: TsButton;
    sTrackBarVolume: TsTrackBar;
    XMLDocument1: TXMLDocument;
    REFRESHPROGRAM: TsButton;
    Timer4: TTimer;
    REFRESH_MENU: TsButton;
    procedure Init;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure BtnStopClick(Sender: TObject);
    procedure BtnPauseClick(Sender: TObject);
    procedure BtnPlayClick(Sender: TObject);
    procedure BtnInitClick(Sender: TObject);
    procedure BtnStartPlayClick(Sender: TObject);
    procedure BtnFullscreenClick(Sender: TObject);
    procedure pan_VideoDblClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure BtnTrackClick(Sender: TObject);
    procedure BtnFScreenAutoClick(Sender: TObject);
    procedure BtnSnapshotClick(Sender: TObject);
    procedure BtnDeinterlaceClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure bPlayClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure LoadMenu;
    procedure Timer3Timer(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnExitClick(Sender: TObject);
    procedure sTrackBarVolumeChange(Sender: TObject);
    Procedure update_program;
    procedure REFRESHPROGRAMClick(Sender: TObject);
    procedure REFRESH_MENUClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure PrepareAndStart_Base;
    procedure PrepareAndStart_Play;
    procedure PrepareAndStart_Test;

    // Events
    procedure OnEventsBase (Sender : TObject;  MediaEvent : plibvlc_event_t );
    procedure OnEventsPlay (Sender : TObject;  MediaEvent : plibvlc_event_t );

    procedure OnLogVLCBase(const log_message: libvlc_log_message_t);
    procedure OnLogVLCPlay(const log_message: libvlc_log_message_t);

  public
    { Public-Deklarationen }
    VLC_Play : TLibVLC;
    VLC_Base : TLibVLC;
    gts : TgtsPlay;
    Bar : TBarForm;
    UpdateDir : string;
    procedure sMenuClick(Sender: TObject);
    procedure sFrameBar1ItemsGen(Sender: TObject;
  var Frame: TCustomFrame);
    procedure Delay(msDelay: DWORD);
    procedure LogStrBase(Text : String);
    procedure LogStrPlay(Text : String);
  end;


var
  FrmMain: TFrmMain;

implementation

{$R *.DFM}

function GetURL(v_str : string): string;
var st : string;
var i : integer;
begin

  st := trim(v_str);
  i := length(st);
  while ((i > 0) and (st[i]<>' ')) do
     dec(i);

  if st[i]=' ' then
    st := trim(copy(st,1,i));
  result := st;

end;

procedure vlcCallBackBase(p_event : Pointer; userdata : Pointer); cdecl;
begin
  if (NIL <> p_event) then
    (TFrmMain(userdata)).OnEventsBase( userdata, Plibvlc_event_t(p_event));
end;

procedure vlcCallBackPlay(p_event : Pointer; userdata : Pointer); cdecl;
begin
  if (NIL <> p_event) then
    (TFrmMain(userdata)).OnEventsPlay(userdata, Plibvlc_event_t(p_event));
end;


procedure TFrmMain.sMenuClick(Sender: TObject);
begin

  LogStrPlay('project: stop playback');
  VLC_Play.VLC_StopMedia;

  if not Assigned(VLC_Base) then
    exit;

  LogStrPlay('project: stop vlc_base');
  VLC_Base.VLC_StopMedia;

  gts.STOP;
  edtPid.Text := TFrameMenu( TSButton(Sender).Parent).idList.Strings[TSButton(Sender).Tag];
  sleep(500);
  gts.START(edtPid.Text);

end;

procedure DetectImage(const InputFileName: string; BM: TBitmap);
var
  FS: TFileStream;
  FirstBytes: AnsiString;
  Graphic: TGraphic;
begin
  Graphic := nil;
  FS := TFileStream.Create(InputFileName, fmOpenRead);
  try
    SetLength(FirstBytes, 8);
    FS.Read(FirstBytes[1], 8);
    if Copy(FirstBytes, 1, 2) = 'BM' then
    begin
      Graphic := TBitmap.Create;
    end else
    if FirstBytes = #137'PNG'#13#10#26#10 then
    begin
      Graphic := TPngImage.Create;
    end else
    if Copy(FirstBytes, 1, 3) =  'GIF' then
    begin
      Graphic := TGIFImage.Create;
    end else
    if Copy(FirstBytes, 1, 2) = #$FF#$D8 then
    begin
      Graphic := TJPEGImage.Create;
    end;
    if Assigned(Graphic) then
    begin
      try
        FS.Seek(0, soFromBeginning);
        Graphic.LoadFromStream(FS);
        BM.Assign(Graphic);
      except
      end;
      Graphic.Free;
    end;
  finally
    FS.Free;
  end;
end;

procedure TFrmMain.sFrameBar1ItemsGen(Sender: TObject;
  var Frame: TCustomFrame);
  var I : integer;
  MM : TsButton;
  but : IXMLNode;
 cat :IXMLNode;
 path : string;
 fileImg : string;
 BitMap : TBitmap;
begin
 cat:= XML_Menu.ChildNodes.Nodes[0].ChildNodes[tsTitleItem(Sender).tag];
  path := ExtractFileDir(application.ExeName) + '\';
  Frame:= TFrameMenu.Create(Self);
  Frame.Name := 'cat'+IntToStr(tsTitleItem(Sender).tag);
  TFrameMenu(Frame).idList := TStringList.Create;

      for i := 0 to cat.ChildNodes.Count -1 do
        begin
          but :=  cat.ChildNodes[i];
          MM := tsButton.Create(nil);
          MM.Width:=sFrameBar1.Width-20;
          MM.Height := TFrameMenu(Frame).sTmp.Height;
          MM.Font := TFrameMenu(Frame).sTmp.font;
          MM.Caption := but.GetAttributeNS('name','');
          MM.Top := i*MM.Height;
          MM.Visible := true;
          MM.Parent := Frame;
          MM.Tag := TFrameMenu(Frame).idList.Count;
          TFrameMenu(Frame).idList.Add(but.GetAttributeNS('pid',''));
          MM.OnClick :=sMenuClick;
          MM.Images := TFrameMenu(Frame).ImageList;

          fileImg := path + but.GetAttributeNS('img','');
          if fileexists(fileimg) then
            begin
                BitMap := TBitmap.Create;
                DetectImage(fileimg, BitMap);


               TFrameMenu(Frame).ImageList.Add(BitMap,nil);
               MM.ImageIndex :=TFrameMenu(Frame).ImageList.Items.Count-1;

            end;
           //ShowMessage(but.GetAttributeNS('name',''));
        end;

  {
  with Frame.Items.Add do
    begin
      FF.Caption:='adsasd';

    end;
    Frame:= TCustomFrame.CreateParented(TT.Handle);}
end;

procedure TFrmMain.update_program;
var app_name : string;
begin
  if FileExists(UpdateDir)then
    begin
      app_name := application.ExeName;
      RenameFile(app_name,app_name + '.old');
      copyfile(Pchar(UpdateDir),Pchar(app_name),true);
      bStopClick(nil);
      ShellExecute(0,'open',pchar(app_name),nil,nil,SW_SHOW);
      sleep(2000);
      close;

    end;
end;

procedure TFrmMain.LoadMenu;
var i,j : integer;
 F : IXMLNode;
 cat : IXMLNode;
 but : IXMLNode;
 tt : tsTitleItem;
 fl : string;

begin

  if FileExists('C:\temp\MENU\List.xml') then  fl :='C:\temp\MENU\List.xml'
  else  fl := ExtractFileDir(application.ExeName) + '\MENU\List.xml';


  XML_Menu.Active:= true;
  XML_Menu.LoadFromFile(fl);
  F :=XML_Menu.ChildNodes.Nodes[0];
  try
    UpdateDir := F.GetAttributeNS('updatedir','');
  except
  end;

  sFrameBar1.Items.Clear;

  for i := 0 to F.ChildNodes.Count-1 do
    begin
      cat := F.ChildNodes[i];
      //ShowMessage(cat.GetAttributeNS('name',''));
      tt := tsTitleItem.Create(sFrameBar1.Items);
      tt.Caption := cat.GetAttributeNS('name','');
      tt.Tag := i;
      tt.OnCreateFrame := sFrameBar1ItemsGen;

    end;


    sPanControl.Parent := Bar.sPanelBottom;
    Panel1.Parent := Bar;

    sFrameBar1.Parent := Bar;
    sFrameBar1.Left := 0;
    sFrameBar1.Top := 0;
    Bar.width := 0;
    Bar.Height := sFrameBar1.Height+sPanControl.Height;

    sPanControl.Top := 0;
    sPanControl.Left := 0;
    sPanControl.Align := alBottom;
end;
procedure TFrmMain.BtnStopClick(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  LogStrPlay('project: stop playback');
  VLC_Play.VLC_StopMedia;

  if not Assigned(VLC_Base) then
    exit;

  LogStrPlay('project: stop vlc_base');
  VLC_Base.VLC_StopMedia;
end;

procedure TFrmMain.BtnPauseClick(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_Pause;
end;

procedure TFrmMain.BtnPlayClick(Sender: TObject);
begin
  if not Assigned(VLC_Base) then
    exit;

  LogStrPlay('project: start base');
  VLC_Base.VLC_PlayMedia(EdtURLBase.Text, TStringList(MmoOptBase.Lines), nil);
  LogStrPlay('project: wait '+IntToStr(EdtDelay.Value)+'s...');
  Delay(EdtDelay.Value);

  if not Assigned(VLC_Play) then
    exit;

  LogStrPlay('project: start play');
  VLC_Play.VLC_PlayMedia(EdtURLPlay.Text, TStringList(MmoOptPlay.Lines), nil);
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned (VLC_Base) then
    VLC_Base.Free;
  if Assigned (VLC_Play) then
    VLC_Play.Free;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  gts := TgtsPlay.Create;
  Bar := TBarForm.Create(nil);
  Bar.Show;
  LoadMenu;
  Init;
end;

procedure TFrmMain.PrepareAndStart_Base;
var
  i : Integer;
  Params : array[0..25] of PAnsiChar;

//  Pevent_manager : Plibvlc_event_manager_t;
begin
  for i := 0 to 25 do begin
    Params[i] := '';
  end;

  // plugin path
  Params[0] := PAnsiChar('--plugin-path=./plugins/');

  // quiet
  Params[1] := PAnsiChar('--quiet');

  // keine Ausgabe
  Params[2] := PAnsiChar('--vout=dummy');
  Params[3] := PAnsiChar('--aout=dummy');

  if Assigned(VLC_Base) then begin
    VLC_Base.Free;
  end;

  if FileExists('libvlc.dll') then begin
    VLC_Base := TLibVLC.Create('vlc_base', 'libvlc.dll', Params, 4, nil, @VlcCallbackBase, nil);
  end
  else
    VLC_Base := TLibVLC.Create('vlc_base', VLC_Base.VLC_GetLibPath+ 'libvlc.dll', Params, 3, nil, @VlcCallbackBase, nil);

  VLC_Base.OnLog := OnLogVLCBase;

  LogStrPlay(VLC_Base.libvlc_get_version);
end;

procedure TFrmMain.PrepareAndStart_Play;
var
  i : Integer;
  Params : array[0..25] of PAnsiChar;
begin

  for i := 0 to 25 do begin
    Params[i] := '';
  end;

  // plugin path
  Params[0] := PAnsiChar('--plugin-path=./plugins/');

  // quiet
  Params[1] := PAnsiChar('--quiet');

  // Free
  if Assigned(VLC_Play) then begin
    VLC_Play.Free;
  end;

  if FileExists('libvlc.dll') then
    VLC_Play := TLibVLC.Create('vlc_play', 'libvlc.dll', Params, 3, pan_Video, @VlcCallbackPlay, nil)
  else
    VLC_Play := TLibVLC.Create('vlc_play', VLC_Play.VLC_GetLibPath+ 'libvlc.dll', Params, 3, pan_Video, @VlcCallbackPlay, nil);

   VLC_Play.OnLog := OnLogVLCPlay;

//  VLC_Play.VLC_CreatePlayer();


//  VLC.Lib.libvlc_media_player_set_hwnd(FPlayer_Play, Pointer(Form2.Handle));
//  Form2.Show;

//  VLC.Lib.libvlc_video_set_mouse_input(FPlayer_Play, 0);
(*
  //VLC.Lib.libvlc_video_set_mouse_input(FPlayer_Play, 0);
//  VLC.Lib.libvlc_video_set_key_input(FPlayer, 1);

// WICHTIG: nicht freigeben, sonst keine stats!
//  VLC.Lib.libvlc_media_release (FMedia_Play);
*)

(*
  //  ### media_list with media_player_list
  // media liste erzeugen
  FMedia_List_Play := VLC.Lib.libvlc_media_list_new(FLib_Play);
  // media in liste setzen
  VLC.Lib.libvlc_media_list_add_media(FMedia_List_Play, FMedia_Play);

  // media_list_player erzeugen
  FMedia_List_Player_Play := VLC.Lib.libvlc_media_list_player_new(FLib_Play);
  // media_list_player media_player und media_list zuweisen
  VLC.Lib.libvlc_media_list_player_set_media_player(FMedia_List_Player_Play, FPlayer_Play);
  VLC.Lib.libvlc_media_list_player_set_media_list(FMedia_List_Player_Play, FMedia_List_Play);

  // media_list_player abspielen
  VLC.Lib.libvlc_media_list_player_play(FMedia_List_Player_Play);
*)
//  VLC_Play.libvlc_media_player_play(FPlayer_Play);
end;

procedure TFrmMain.PrepareAndStart_Test;
var
//    FLibInt       : Plibvlc_instance_t;
    Params : array[0..25] of PAnsiChar;

    i : Integer;
begin

  for i := 0 to 25 do begin
    Params[i] := '';
  end;

  // set params for oldrc and oldhttp
//  Params[0] := PAnsiChar('http://192.168.0.6:31339/0,0x002C,0x00A3,0x0068,0x006A');
  //  Params[0] := PAnsiChar('--ignore-config');
//  Params[1] := PAnsiChar('--extraintf=oldrc');
//  Params[2] := PAnsiChar('--http-host=127.0.0.1:222');
//  Params[3] := PAnsiChar('--rc-host=127.0.0.1:333');

//  Params[4] := PAnsiChar('--drawable-hwnd=0');//+ IntToStr(pan_Video.Handle));

  // create libvlc instance
      (*
  if not Assigned(VLC_Play) then
    VLC_Play := TLibVLC.Create('vlc_play', 'libvlc.dll', Params, 3, pan_Video, VlcCallback);

  Delay(500);
  VLC_Play.VLC_PlayMedia(EdtURLPlay.Text, TStringList(MmoOptPlay.Lines), nil);
  

  // create media from url
  FMedia := VLC.Lib.libvlc_media_new_location(FLibInt, 'http://192.168.0.99:31339/0,0x0065,0x0066,0x0067,0x006B');

  // create media_player from media
  FMediaPlayer := VLC.Lib.libvlc_media_player_new_from_media(FMedia);

  // config video output
  VLC.Lib.libvlc_media_player_set_hwnd(FMediaPlayer, Pointer(pan_Video.Handle));

  // create media_list
  FMedia_List := VLC.Lib.libvlc_media_list_new(FLibInt);

  // add media to media_list
  VLC.Lib.libvlc_media_list_add_media(FMedia_List, FMedia);

  // create media_list_player
  FMedia_List_Player := VLC.Lib.libvlc_media_list_player_new(FLibInt);

  // set media_player and media_list to media_list_player
  VLC.Lib.libvlc_media_list_player_set_media_player(FMedia_List_Player, FMediaPlayer);
  VLC.Lib.libvlc_media_list_player_set_media_list(FMedia_List_Player, FMedia_List);

  // play media_list_player
  VLC.Lib.libvlc_media_list_player_play(FMedia_List_Player);
  *)
end;

procedure TFrmMain.REFRESHPROGRAMClick(Sender: TObject);
begin
 update_program;
end;

procedure TFrmMain.REFRESH_MENUClick(Sender: TObject);
begin
  LoadMenu;
end;

procedure TFrmMain.Init;
begin
   if Assigned(VLC_Play) then begin
    if VLC_Play.VLC_IsPlaying then
      exit;
  end;

  LogStrPlay('project: prepare base');
  PrepareAndStart_Base;
  LogStrPlay('project: prepare play');
  PrepareAndStart_Play;

end;

procedure TFrmMain.BtnInitClick(Sender: TObject);
begin
  if Assigned(VLC_Play) then begin
    if VLC_Play.VLC_IsPlaying then
      exit;
  end;

  LogStrPlay('project: prepare base');
  PrepareAndStart_Base;
  LogStrPlay('project: prepare play');
  PrepareAndStart_Play;


end;

procedure TFrmMain.BtnStartPlayClick(Sender: TObject);
begin
  PrepareAndStart_Test;
end;

procedure TFrmMain.Delay(msDelay: DWORD);
var
  Start : DWORD;
begin
  Start:=GetTickCount;
  //LogStrPlay(LOG_FUNCTION, 'GetTickCount: '+IntToStr(Start),0);
  repeat
    //  LogStrPlay(LOG_FUNCTION, 'GetTickCount: '+IntToStr(GetTickCount),0);
    sleep(2);

    Application.ProcessMessages;
  until GetTickCount-Start > msDelay;
end;

procedure TFrmMain.BtnFullscreenClick(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_ToggleFullscreen(pan_Video, nil);
  Delay(3000);
  VLC_Play.VLC_ToggleFullscreen(pan_Video, nil);
end;

procedure TFrmMain.pan_VideoDblClick(Sender: TObject);
begin
  VLC_Play.VLC_ToggleFullscreen(pan_Video, nil);
end;

procedure TFrmMain.FormDblClick(Sender: TObject);
begin
  VLC_Play.VLC_ToggleFullscreen(pan_Video, nil);
end;

procedure TFrmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

  if (mouse.CursorPos.X>(Self.Width/0.9)) and (mouse.CursorPos.X>sFramebar1.Left) then
     begin
       sFramebar1.Width := 380;
     end
  else  sFramebar1.Width :=0;

end;

procedure TFrmMain.OnEventsBase(Sender: TObject; MediaEvent: plibvlc_event_t);
begin
  LogStrBase('EVENT CALLBACK: '+FrmMain.VLC_Play.VLC_GetEventString(MediaEvent^));
end;

procedure TFrmMain.OnEventsPlay(Sender: TObject; MediaEvent: plibvlc_event_t);
begin
  LogStrPlay('EVENT CALLBACK: '+FrmMain.VLC_Play.VLC_GetEventString(MediaEvent^));
end;

procedure TFrmMain.BtnTrackClick(Sender: TObject);
begin
  MemoPlay.Lines.Append(VLC_Play.VLC_GetAudioTrackList());
end;

procedure TFrmMain.BtnFScreenAutoClick(Sender: TObject);
begin
  BtnInitClick(Sender);
  Delay(10000);

  BtnFullscreenClick(Sender);
  Delay(2000);
  BtnFullscreenClick(Sender);
  BtnStopClick(Sender);

  Screen.Cursor := crDefault;
end;

procedure TFrmMain.BtnSnapshotClick(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_TakeSnapshot('c:\test.png', 0, 0);
end;

procedure TFrmMain.bStopClick(Sender: TObject);
begin
  LogStrPlay('project: stop playback');
  VLC_Play.VLC_StopMedia;

  if not Assigned(VLC_Base) then
    exit;

  LogStrPlay('project: stop vlc_base');
  VLC_Base.VLC_StopMedia;

  gts.STOP;
end;

procedure TFrmMain.BtnDeinterlaceClick(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_SetDeinterlaceMode('discard');
end;

procedure TFrmMain.btnExitClick(Sender: TObject);
begin
Close;
end;

procedure TFrmMain.Button10Click(Sender: TObject);
begin
   edtpid.Text := GetURL(edtPid.Text);
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  if not Assigned(VLC_Base) then
    exit;

  if VLC_Base.VLC_IsPlaying then
    ShowMEssage('true')
  else
    ShowMEssage('false')
end;

procedure TFrmMain.Button2Click(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  if VLC_Play.VLC_IsPlaying then
    ShowMEssage('true')
  else
    ShowMEssage('false')
end;

procedure TFrmMain.Button3Click(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;
    
  VLC_Play.VLC_SetCropMode('4:3');
end;

procedure TFrmMain.Button4Click(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_SetARMode('16:9');
end;

procedure TFrmMain.Button5Click(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_SetMute(not VLC_Play.VLC_GetMute);
end;

procedure TFrmMain.SpinEdit2Change(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_SetAudioTrack(SpinEdit2.Value)
end;

procedure TFrmMain.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.Stop1Click(Sender: TObject);
begin
  LogStrPlay('project: stop playback');
  VLC_Play.VLC_Stop;
  LogStrPlay('project: stop vlc_base');
  if Assigned(VLC_Base) then
    VLC_Base.VLC_Stop;
end;

procedure TFrmMain.sTrackBarVolumeChange(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_SetVolume(tsTrackBar(Sender).Position)
end;

procedure TFrmMain.BtnOpenClick(Sender: TObject);
begin
  if Assigned(VLC_Play) then begin
    if VLC_Play.VLC_IsPlaying then
      exit;
  end;

  DlgOpen.Execute;

  EdtURLBase.Text := Trim(DlgOpen.Files.Text);

  if DlgOpen.Files.Text = '' then
    exit;

  LogStrPlay('project: prepare base');
  PrepareAndStart_Base;
  LogStrPlay('project: prepare play');
  PrepareAndStart_Play;

  LogStrPlay('project: start base');
  VLC_Base.VLC_PlayMedia(EdtURLBase.Text, TStringList(MmoOptBase.Lines), nil);
  LogStrPlay('project: wait 2s...');
  Delay(2000);

  LogStrPlay('project: start play');
  VLC_Play.VLC_PlayMedia(EdtURLPlay.Text, TStringList(MmoOptPlay.Lines), nil);
end;

procedure TFrmMain.Button6Click(Sender: TObject);
begin
  if Assigned(VLC_Play) then begin
    if VLC_Play.VLC_IsPlaying then
      exit;
  end;

  LogStrPlay('project: start play');
  PrepareAndStart_Play;
  VLC_Play.VLC_PlayMedia(EdtURLBase.Text, TStringList(MmoOptPlay.Lines), nil);
end;

procedure TFrmMain.LogStrBase(Text: String);
begin
 // FrmMain.MemoBase.Lines.Append(FormatDateTime('hh:nn:ss:zzz', now)+', '+Text);
end;

procedure TFrmMain.LogStrPlay(Text: String);
begin
  //FrmMain.MemoPlay.Lines.Append(FormatDateTime('hh:nn:ss:zzz', now)+', '+Text);
end;                         

procedure TFrmMain.Button7Click(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_SetLogo('c:\test.png');
end;

procedure TFrmMain.SpinEdit1Change(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  VLC_Play.VLC_SetVolume(SpinEdit1.Value)
end;

procedure TFrmMain.Button8Click(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;
                                  // FF0000
  vlc_play.VLC_SetMarquee('TEST', 16711680, 100, 6, 0, 50, 5000, 50, 50);
end;

procedure TFrmMain.bPlayClick(Sender: TObject);
begin

  gts.START(EdtPID.Text);
end;

procedure TFrmMain.OnLogVLCBase(const log_message: libvlc_log_message_t);
begin
  MemoBase.Lines.Append(FormatDateTime('hh:nn:ss:zzz', now)+' vlc_base '+log_message.psz_message+' ['+log_message.psz_type+','+log_message.psz_name+','+log_message.psz_header+']');
  SendMessage(MemoBase.Handle,WM_VSCROLL,SB_BOTTOM,0);
end;

procedure TFrmMain.OnLogVLCPlay(const log_message: libvlc_log_message_t);
begin
  MemoPlay.Lines.Append(FormatDateTime('hh:nn:ss:zzz', now)+' vlc_play '+log_message.psz_message+' ['+log_message.psz_type+','+log_message.psz_name+','+log_message.psz_header+']');
  SendMessage(MemoPlay.Handle,WM_VSCROLL,SB_BOTTOM,0);
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  if not Assigned(VLC_Play) then
    exit;

  if not VLC_Play.VLC_IsPlaying() then
    exit;

  try
    Label1.Caption := 'Bitrate: '+FloatToStr(Round(VLC_Play.VLC_GetStats().f_demux_bitrate*1000)) + ' kb/s';
  except
  end;
end;



procedure TFrmMain.Timer2Timer(Sender: TObject);
var i : integer;
    ss : string;
    l : TStringList;
    sPlay : string;
begin
try
 if FileExists(application.ExeName + '.old')then
    begin

      deletefile(application.ExeName + '.old');
    end;

except

end;
LblStat.Caption := gts.GetParam('STATE') + ' ' + gts.GetParam('START') + #13#10+
  gts.GetParam('STATUS') + #13#10+ GTS.LastMessage;

   sPlay := gts.GetParam('START');
   ss := gts.tsEngine.ReadTS;
   if (gts.GetParam('START')<>sPlay) {AND (gts.GetParam('STATE')='2')} then
   begin
     //edit4.Text := gts.GetParam('START');
     edtUrlPlay.Text := GetURL(gts.GetParam('START'));
     edtUrlBase.Text := gts.GetParam('START');

     {
     VLC_Base.VLC_PlayMedia(EdtURLBase.Text, TStringList(MmoOptBase.Lines), nil);
     sleep(500);}
     VLC_Play.VLC_PlayMedia(EdtURLPlay.Text, TStringList(MmoOptPlay.Lines), nil);

     //ShowMessage('PLAY:' + gts.GetParam('START'));
   end;

   if ss<> '' then
     begin
       try
         l := TStringList.Create;
         L.Text := ss;
         for i := 0 to l.Count-1 do
           begin
             //Memo1.Lines.Insert(0,l.Strings[i]);
           end;
       finally
         l.Clear;
         l.free;
       end;

     end;
     //Edit2.Text := TS.stPLAY;
     //label1.Caption := TS.stState;

end;

procedure TFrmMain.Timer3Timer(Sender: TObject);
var rs : TPoint;
    Handle : Thandle;
    pName : Pwidechar;
    wd : integer;
begin
wd := Bar.Width;
  if (mouse.CursorPos.X>(Self.Width*0.8)) or (mouse.CursorPos.X>Bar.Left) then
     begin
       if wd<380 then
         begin
           wd := wd+ 20;
         end;
     end
  else
  begin
     if wd>-19 then
       wd := wd- 20
     else   wd :=-20;
  end;
 Bar.Left := Self.Width - wd+20;
 Bar.Width := wd;
end;

end.
