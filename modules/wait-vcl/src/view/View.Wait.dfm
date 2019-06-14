object FrmWait: TFrmWait
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 150
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 110
  ClientWidth = 380
  Color = clBlack
  TransparentColorValue = clFuchsia
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    380
    110)
  PixelsPerInch = 96
  TextHeight = 17
  object lblContent: TLabel
    Left = 80
    Top = 29
    Width = 286
    Height = 52
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object pbWait: TProgressBar
    Left = 0
    Top = 99
    Width = 380
    Height = 11
    Align = alBottom
    DoubleBuffered = False
    ParentDoubleBuffered = False
    Position = 50
    TabOrder = 0
    Visible = False
  end
  object ActivityIndicator: TActivityIndicator
    Left = 17
    Top = 29
    Animate = True
    IndicatorColor = aicWhite
    IndicatorSize = aisLarge
  end
end
