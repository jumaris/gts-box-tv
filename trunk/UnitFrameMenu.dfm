object FrameMenu: TFrameMenu
  Left = 0
  Top = 0
  Width = 477
  Height = 124
  VertScrollBar.ButtonSize = 30
  VertScrollBar.Smooth = True
  VertScrollBar.Size = 30
  VertScrollBar.Style = ssFlat
  VertScrollBar.Tracking = True
  Align = alCustom
  AutoScroll = True
  TabOrder = 0
  OnClick = FrameClick
  object sBox: TsScrollBox
    Left = 0
    Top = 0
    Width = 468
    Height = 124
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PANEL_LOW'
    ExplicitWidth = 360
    object sTmp: TsButton
      Left = 3
      Top = 19
      Width = 405
      Height = 62
      Caption = 'sTmp'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Visible = False
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object sPanel1: TsPanel
    Left = 468
    Top = 0
    Width = 9
    Height = 124
    Align = alRight
    Caption = 'sPanel1'
    Color = clHotLight
    ParentBackground = False
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
  end
  object sFrameAdapter1: TsFrameAdapter
    SkinData.SkinSection = 'BAR'
    Left = 212
    Top = 11
  end
  object ImageList: TsAlphaImageList
    AllocBy = 0
    DrawingStyle = dsTransparent
    Height = 45
    Width = 45
    Items = <>
    Left = 305
    Top = 152
  end
end
