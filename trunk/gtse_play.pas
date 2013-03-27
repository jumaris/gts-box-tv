unit gtse_play;

interface

uses gtsengine, Windows, Classes, SysUtils,Dialogs;

type TgtsPlay=class
  tsEngine : TtsEngine;
  LastMessage : string;
public
  constructor Create;
  destructor Destroy;
  procedure Ready();
  procedure PAUSE();
  procedure PLAY();
  procedure STOP();
  procedure START(PID : string);
  procedure LOAD_INFO(PID : string);
  procedure ReConnect;
  procedure Msg(sMsg: string);
  procedure SendCmd(sCmd: string);
  function GetParam(sParam : string) : string;
  procedure SetParam(sParam : string; sValue : string);
  procedure DoActive;
  procedure RefreshFlag;
end;

implementation

function TgtsPlay.GetParam(sParam : string) : string;
begin
  Result := tsEngine.AllFlags.GetParam(sParam);
end;

procedure TgtsPlay.SetParam(sParam : string; sValue : string);
begin
  tsEngine.AllFlags.SetParam(sParam, sValue);
end;

procedure TgtsPlay.Msg(sMsg: string);
begin
  LastMessage := sMsg;
end;

procedure TgtsPlay.SendCmd(sCmd: string);
begin
  Msg('SEND '+ sCmd);
  tsEngine.SendTS_CMD(sCmd);
end;

procedure TgtsPlay.RefreshFlag;
begin
 tsEngine.ReadTS;
end;

procedure TgtsPlay.DoActive;
begin
 if not tsEngine.Connect then ReConnect;

end;

procedure TgtsPlay.ReConnect;
var Addr : string;
    ErrCon : integer;
begin
  Addr:= '127.0.0.1';
  tsEngine.RestartTS;
  ErrCon := 0;
  while (not tsEngine.ConnectTS) AND (ErrCon<3)  do
    begin
      inc(ErrCon);
      sleep(2000);
    end;
  if not tsEngine.Connect then MSG('ERROR:' + tsEngine.LastErr);
end;

constructor TgtsPlay.Create;
begin
  tsEngine := TtsEngine.Create;
end;

destructor TgtsPlay.Destroy;
begin
  tsEngine.Destroy;
end;

procedure TgtsPlay.Ready();
begin
  DoActive;
  SetParam('STATE','');
  SendCmd('READY');
end;

procedure TgtsPlay.PAUSE();
begin
  DoActive;
  SetParam('STATE','');
  SendCmd('PAUSE');
end;

procedure TgtsPlay.PLAY();
begin
  DoActive;
  SetParam('STATE','');
  SendCmd('PLAY');
end;

procedure TgtsPlay.START(PID : string);
begin
  DoActive;
  SetParam('STATE','');
  SetParam('PLAY','');
  SetParam('START','');
  SendCmd('START PID ' + PID + ' 0');
end;

procedure TgtsPlay.STOP();
begin
  DoActive;
  SendCmd('STOP');
end;

procedure TgtsPlay.LOAD_INFO(PID : string);
begin
  DoActive;
  SendCmd('LOADASYNC 126500 PID ' + PID);
end;

end.
