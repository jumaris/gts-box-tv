unit gtsengine;

interface
uses Windows,Classes, SysUtils,IdTCPClient,Dialogs,ShellApi;

type
   TString = class(TObject)
   private
     fStr: String;
   public
     constructor Create(const AStr: String) ;
     property Str: String read FStr write FStr;
   end;

 Type
   TLastParam=class
   ParamList : TstringList;
 public
   constructor Create;
   destructor Destroy;
   procedure SetParam(Param:string; Value : string);
   function GetParam(Param: string) : string;
 end;

type TtsEngine=class
  PathtsEngine : string;
  AcePortFile : string;
  AcePort : integer;
  ApiVersion : string;
private
  ReadBuf : string;
public
 TCP: TIdTCPClient;
 BufList: TStringList;
 stSTATE : string;
 stPLAY  : string;
 stLOADASYNC : string;
 Connect : boolean;
 LastErr : string;
 AllFlags : TLastParam;
 constructor Create;
 destructor Destroy;
 function GetLibPath: String;
 function GetLibPort: integer;
 function ConnectTS: boolean;
 procedure SendTS_CMD(sCMD: string);
 function ReadTS():string;
 procedure GetFlagState(BufInp : string);
 procedure ClearFalg;
 procedure RestartTS();

end;


implementation

constructor TString.Create(const AStr: String) ;
begin
   inherited Create;
   FStr := AStr;
end;

constructor TLastParam.Create;
begin
  ParamList := TStringList.Create;
end;

procedure TLastParam.SetParam(Param:string; Value : string);
var i  : integer;
    par : string;
    newVal : TString;
begin
  Par := upperCase(Param);
  i:=ParamList.IndexOf(Par);
  if i>-1 then //Создаём
    begin
       TString(ParamList.Objects[i]).Str := Value;
    end
  else
    begin
      newVal := TString.Create(Value);
      ParamList.AddObject(Par,newVal);
    end;
end;

function TLastParam.GetParam(Param: string) : string;
var i  : integer;
    par : string;
    newVal : TString;
begin
  Par := upperCase(Param);
  i:=ParamList.IndexOf(Par);
  if i>-1 then //Создаём
    begin
       Result := TString(ParamList.Objects[i]).Str;
    end
  else Result := '';
end;

destructor TLastParam.Destroy;
var I : integer;
begin
  for i := 0 to ParamList.Count-1 do
    begin
      TString(ParamList.Objects[i]).Free;
      ParamList.Objects[i]:= nil;
    end;
    ParamList.Clear;
end;

procedure TtsEngine.RestartTS();
begin

ShellExecute(0,'open',pchar('taskkill /IM tsengine.exe'),nil,nil,SW_SHOW);
sleep(200);
ShellExecute(0,'open',pchar(PathtsEngine+'tsengine.exe'),nil,nil,SW_SHOW);
sleep(1000);
end;

procedure TtsEngine.ClearFalg;
begin
  stSTATE := '';
  stPLAY  := '';
  stLOADASYNC :='';
end;

procedure TtsEngine.GetFlagState(BufInp : string);
   var l : TStringList;
       i,j : integer;
       sCmd : string;
       lStr : string;
 begin
   if BufInp<>'' then
     begin
       l := TStringList.Create;
       l.Text := BufInp;
       try
         for i :=  0 to l.Count-1 do
           begin
             lStr := l.Strings[i];
             j := POS(' ', lStr);
             if j >1 then
               begin
                 sCmd := trim(Copy(lStr ,0,j));
                 lStr := Copy(lStr,j+1, Length(lStr)-j);
                 if sCmd='PLAY' then
                   stPlay := lStr
                 else if sCmd='STATE' then
                   stState := lStr
                 else if sCmd='LOADASYNC' then
                   stLOADASYNC := lStr;
                  AllFlags.SetParam(sCMD, lStr);
               end;


           end;
       finally
         l.Clear;
         l.Free;
       end;
     end;


 end;

function TtsEngine.ReadTS():string;
var CH : string;
function GetReadLn(var Buf : string): string;
  var st : string;
      ipr : integer;
      Res : string;
begin
  ipr := Length(Buf)-1;
  while ipr > 0 do
    begin
      if (Buf[ipr]=#13) and (Buf[ipr+1]=#10) then
        begin
          Res := Copy(Buf,0,ipr+1);
          Buf:=Copy(Buf,ipr+2,Length(Buf)-ipr+1);

          ipr := -1;
        end;
       dec(ipr);
    end;
  GetFlagState(Res);
  Result := Res;
end;


 var Res : string;
begin
  Res := '';
  if TCP.Connected then
    begin
       try
         if TCP.Socket.InputBuffer.Size>0 then
           begin
             CH := TCP.Socket.Readstring(TCP.Socket.InputBuffer.Size);
             ReadBuf := ReadBuf + CH;
             Res := GetReadLn(ReadBuf);
           end;
       except
         try
           TCP.Disconnect;
         except
         end;
       end;
    end;
  Result := Res;
end;

procedure TtsEngine.SendTS_CMD(sCMD: string);
begin
  if tcp.Connected then

  tcp.Socket.Writeln(sCmd);
end;

function TtsEngine.ConnectTS: boolean;
begin
  Connect := false;
  try
    TCP.Disconnect;
  except
  end;
  BufList.Clear;
  ReadBuf := '';
  AcePort := GetLibPort;
  TCP.Port := AcePort;
  try
    TCP.Connect;
    Connect := true;
    RESULT := true;
  except
    ON E:EXCEPTION DO
      begin
        Connect := false;
        LastErr := E.Message;
        Result := false;
      end;
  end;
end;


function TtsEngine.GetLibPort: integer;
var Fil: TStringList;
    tsPort: integer;
    i: integer;
begin
  tsPort := -1;
 AcePortFile := PathtsEngine + 'acestream.port';
 if not FileExists(AcePortFile) then
   raise Exception.Create('Not File Find:'+ AcePortFile);
 try
   Fil := TStringList.Create();
   Fil.LoadFromFile(AcePortFile);

   for i := 0 to Fil.Count-1 do
     tryStrToInt(Fil.Strings[i], tsPort);

 finally
   Fil.Clear;
   Fil.Free;
 end;
   if  tsPort=-1 then
     raise Exception.Create('Not Port IN File:'+ AcePortFile);
 Result := tsPort;
end;

function TtsEngine.GetLibPath: String;
// get vlc library path
var
  Handle:HKEY;
  RegType:integer;
  DataSize:integer;
begin

  Result := '';

  if (RegOpenKeyEx(HKEY_CURRENT_USER,'Software\TorrentStream',0,KEY_ALL_ACCESS,Handle)=ERROR_SUCCESS) then begin

    if RegQueryValueEx(Handle,'EnginePath',nil,@RegType,nil,@DataSize)=ERROR_SUCCESS then begin
      SetLength(Result,Datasize);
      RegQueryValueEx(Handle,'EnginePath',nil,@RegType,PByte(@Result[1]),@DataSize);
      Result[DataSize]:='\';
    end;

    RegCloseKey(Handle);
  end;

end;

function ExtractPath(const S: string): string;
var
  I: Integer;
  g : integer;
begin
  I :=0;
  G:=1;
  while (I < Length(s))  do
  begin
    if S[i]='\' then g:= i;
    inc(i);
  end;

  Result := Copy(S, 1, g );
end;

constructor TtsEngine.Create;
begin
  ApiVersion :='1';
  PathtsEngine :=  GetLibPath;
  PathtsEngine := ExtractPath( PathtsEngine );
  AcePort := GetLibPort;
  BufList:= TStringList.Create;
  TCP:= TIdTCPClient.Create(nil);
  TCP.Host := '127.0.0.1';
  TCP.ReadTimeout := 3000;
  TCP.Port := AcePort;
  Connect := false;
  AllFlags := TLastParam.Create;
end;

destructor TtsEngine.Destroy;
begin
 AllFlags.Destroy;

end;

end.
