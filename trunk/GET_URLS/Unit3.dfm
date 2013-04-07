object FormOsr: TFormOsr
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  ClientHeight = 193
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ScpText: TMemo
    Left = 0
    Top = 102
    Width = 380
    Height = 91
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Lines.Strings = (
      'player_obj.play('#39'saass'#39');'
      ''
      'this.SOP = function(url) {'
      
        #9#9'eval(function(p,a,c,k,e,d){e=function(c){return c};if(!'#39#39'.repl' +
        'ace(/^/,String)){while(c--){d[c]=k[c]||c}k=[function(e){return d' +
        '[e]}];e=function(){return'#39'\\w+'#39'};c=1};while(c--){if(k[c]){p=p.re' +
        'place(new RegExp('#39'\\b'#39'+e(c)+'#39'\\b'#39','#39'g'#39'),k[c])}}return p}('#39'0=2.1(0' +
        ');0=3.1(0);'#39',4,4,'#39'url|decode|crypt|B'#39'.split('#39'|'#39'),0,{}))'
      #9#9'if(url != '#39#39' && url != null)'
      #9#9#9'return url;'
      #9#9'else'
      #9#9#9'return '#39#39';'
      #9'}'
      'XM = '#39#39';'
      'LAST = '#39#39';'
      'for (var i = 0; i < types_obj.types_array.length; i++) {'
      '    if (XM.length > 0) {'
      '        XM = XM + '#39'</cat>'#39
      '    }'
      '  '
      
        '    XM = XM + '#39'\n <cat name="'#39' + types_obj.types_array[i].title ' +
        '+ '#39'"> '#39';'
      '    ar = channels_type_arr[i];'
      '    for (var k = 0; k < ar.length; k++) {'
      '        this.curChanel = ar[k];'
      '        channels_obj.set(this.curChanel);'
      '        if (SOP(channels_obj.url) != '#39#39') {'
      '            if (LAST != channels_obj.title) {'
      
        '                XM = XM + '#39'<br>\n'#39' + '#39'<button name="'#39' + channels' +
        '_obj.title + '#39'"  img="img\\'#39' + channels_obj.icon.substring(chann' +
        'els_obj.icon.lastIndexOf('#39'/'#39') + 1) + '#39'" pid="TORRENT '#39' + SOP(cha' +
        'nnels_obj.url) + '#39'"></button>'#39';'
      '                LAST = channels_obj.title;'
      '            }'
      '        }'
      '    }'
      '}'
      'if (XM.length > 0) {'
      '    XM = XM + '#39'</cat>'#39
      '}'
      'alert('#39'$EXPORT_LIST$'#39'+XM);')
    ParentFont = False
    TabOrder = 0
    Visible = False
    WordWrap = False
  end
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 372
    Height = 62
    Align = alCustom
    Caption = 'Starting...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
  end
  object OSR: TChromiumOSR
    OnLoadEnd = OSRLoadEnd
    OnLoadError = OSRLoadError
    OnJsAlert = OSRJsAlert
    Left = 16
    Top = 16
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 336
    Top = 56
  end
end
