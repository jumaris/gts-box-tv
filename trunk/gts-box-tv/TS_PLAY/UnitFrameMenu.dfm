object FrameMenu: TFrameMenu
  Left = 0
  Top = 0
  Width = 239
  Height = 190
  Align = alCustom
  AutoScroll = True
  TabOrder = 0
  OnClick = FrameClick
  object sTmp: TsButton
    Left = 3
    Top = 3
    Width = 236
    Height = 50
    Caption = 'sTmp'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Visible = False
    SkinData.SkinSection = 'BUTTON'
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
