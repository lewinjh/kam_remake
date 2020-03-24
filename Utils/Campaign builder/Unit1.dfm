object Form1: TForm1
  Left = 72
  Top = 90
  Caption = 'Campaign Builder'
  ClientHeight = 808
  ClientWidth = 1253
  Color = clBtnFace
  Constraints.MinHeight = 492
  Constraints.MinWidth = 689
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    1253
    808)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 152
    Top = 160
    Width = 56
    Height = 16
    AutoSize = False
    Caption = 'Maps count'
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 514
    Width = 60
    Height = 16
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Nodes count'
    Layout = tlCenter
    ExplicitTop = 426
  end
  object Bevel1: TBevel
    Left = 8
    Top = 214
    Width = 200
    Height = 2
  end
  object Label6: TLabel
    Left = 8
    Top = 160
    Width = 56
    Height = 16
    AutoSize = False
    Caption = 'Short name'
    Layout = tlCenter
  end
  object Bevel2: TBevel
    Left = 8
    Top = 662
    Width = 200
    Height = 2
    Anchors = [akLeft, akBottom]
    ExplicitTop = 574
  end
  object Bevel3: TBevel
    Left = 8
    Top = 698
    Width = 200
    Height = 2
    Anchors = [akLeft, akBottom]
    ExplicitTop = 610
  end
  object Label3: TLabel
    Left = 8
    Top = 104
    Width = 200
    Height = 16
    AutoSize = False
    Caption = 'Campaign name'
    Layout = tlCenter
  end
  object tvList: TTreeView
    Left = 8
    Top = 224
    Width = 200
    Height = 282
    Anchors = [akLeft, akTop, akBottom]
    AutoExpand = True
    HideSelection = False
    Indent = 19
    TabOrder = 0
    OnChange = tvListChange
  end
  object btnSaveCMP: TButton
    Left = 112
    Top = 8
    Width = 96
    Height = 24
    Caption = 'Save CMP'
    TabOrder = 1
    OnClick = btnSaveCMPClick
  end
  object btnLoadCMP: TButton
    Left = 8
    Top = 8
    Width = 96
    Height = 24
    Caption = 'Load CMP'
    TabOrder = 2
    OnClick = btnLoadCMPClick
  end
  object btnLoadPicture: TButton
    Left = 8
    Top = 40
    Width = 200
    Height = 24
    Caption = 'Load picture'
    TabOrder = 3
    OnClick = btnLoadPictureClick
  end
  object seMapCount: TSpinEdit
    Left = 152
    Top = 184
    Width = 56
    Height = 22
    AutoSize = False
    MaxValue = 32
    MinValue = 1
    TabOrder = 4
    Value = 1
    OnChange = seMapCountChange
  end
  object seNodeCount: TSpinEdit
    Left = 8
    Top = 538
    Width = 41
    Height = 22
    Anchors = [akLeft, akBottom]
    MaxValue = 32
    MinValue = 0
    TabOrder = 5
    Value = 0
    OnChange = seNodeCountChange
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 788
    Width = 1253
    Height = 20
    Panels = <
      item
        Width = 200
      end
      item
        Width = 100
      end
      item
        Width = 200
      end
      item
        Width = 100
      end>
  end
  object ScrollBox1: TScrollBox
    Left = 216
    Top = 8
    Width = 1029
    Height = 772
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 7
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 1024
      Height = 768
      Stretch = True
      OnDragDrop = Image1DragDrop
      OnDragOver = Image1DragOver
      OnMouseMove = Image1MouseMove
    end
    object imgBlackFlag: TImage
      Left = 0
      Top = 0
      Width = 27
      Height = 29
      AutoSize = True
      Picture.Data = {
        07544269746D6170BA090000424DBA0900000000000036000000280000001B00
        00001D0000000100180000000000840900000000000000000000000000000000
        00002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35566D
        372B2C35566D2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2B
        FF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B37393D355757372B2C15234535566D
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2B
        FF2B2BFF2B37393D344C3B0012090C0E1E0C0E1E35566D2BFF2B2BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF
        2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35566D0C0E1E3557570C
        0E1E0C0E1E0C0E1E0C0E1E0C0E1E15234535566D2BFF2B2BFF2B2BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B1523450C0E1E372B2C3864570012090C0E1E0C0E1E0C0E1E0C
        0E1E0C0E1E0C0E1E0C0E1E35566D2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B
        2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B3557570012090012
        090012090012090012090012090C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E15
        234535566D2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        2BFF2B2BFF2B355757001209372B2C4337374337374337374337374337374337
        37433737372B2C0012090C0E1E0C0E1E0C0E1E0C0E1E0C0E1E35566D2BFF2B2B
        FF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B355757372B2C433737
        4337374337374337374C403E4C403E4C403E4337374C403E4C403E433737372B
        2C0C0E1E0C0E1E0C0E1E0C0E1E15234535566D2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B2BFF2B0012094337374C403E4337374C403E574B4B7F6F77
        93838F6B5B634C403E4337374C403E4C403E4337370012090C0E1E0C0E1E0C0E
        1E0C0E1E15234535566D2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B00
        1209433737574B4B4337374C403EA797A3DFD7E3CBBFCF93838F6B5B634C403E
        4337374C403E4337370012090C0E1E0C0E1E0C0E1E0C0E1E0C0E1E1523453556
        6D2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B0012094C403E574B4B4337374C
        403E000A02000A02000A02000A02000A024C403E433737433737372B2C001209
        0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E35566D2BFF2B2BFF2B0000002BFF
        2B2BFF2B2BFF2B001209574B4B4C403E4C403E574B4B93838FA797A3A797A37F
        6F776B5B634C403E4337374337374C403E0012090C0E1E0C0E1E0C0E1E0C0E1E
        0C0E1E0C0E1E15234515234535566D0000002BFF2B2BFF2B35575737393D574B
        4B4337374C403E93838FBBABBB93838F000A0293838F7F6F77574B4B4C403E43
        37374C403E00120935566D35566D35566D35566D35566D35566D35566D35566D
        35566D0000002BFF2B2BFF2B372B2C574B4B4337374C403E6B5B637F6F77BBAB
        BBA797A3574B4B7F6F77A797A36B5B63574B4B4C403E4C403E37393D3557572B
        FF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        372B2C574B4B4337374C403EA797A3574B4B000A026B5B63A797A36B5B63000A
        027F6F776B5B634C403E4337374337370012092BFF2B2BFF2B2BFF2B2BFF2B2B
        FF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B372B2C574B4B4C403E4C403E
        A797A3000A02000A02574B4B93838F574B4B000A02000A026B5B634C403E4337
        374C403E0012092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B372B2C574B4B574B4B4C403E7F6F7793838FDFD7E3BBABBB
        A797A3A797A37F6F776B5B63574B4B4C403E4337374C403E0012092BFF2B2BFF
        2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B0012096B
        5B63574B4B4337374C403EA797A3DFD7E3BBABBB93838F7F6F776B5B636B5B63
        4C403E574B4B4337374337370012092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B0012096B5B63574B4B4337374337374C
        403E7F6F77BBABBBA797A37F6F77574B4B574B4B574B4B4C403E574B4B433737
        0012092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF
        2B2BFF2B0012096B5B63574B4B4337374337372F27274C403E4C403E4C403E4C
        403E4C403E574B4B6B5B636B5B63433737433737372B2C2BFF2B2BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B001209574B4B574B
        4B4337372F27272F2727433737433737574B4B6B5B63574B4B433737574B4B6B
        5B63574B4B433737372B2C2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B
        2BFF2B0000002BFF2B2BFF2B0012096B5B63574B4B2F27272F27272F27270D2F
        430D2F430D2F430D2F434337376B5B63574B4B6B5B637F6F77574B4B372B2C2B
        FF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        372B2C6B5B634337372F27270D2F430D2F432BFF2B37393D37393D0012092BFF
        2B0D2F430D2F434337376B5B636B5B63372B2C2BFF2B2BFF2B2BFF2B2BFF2B2B
        FF2B2BFF2B2BFF2B2BFF2B0000003557570012090012094337370D2F431C5654
        0012092BFF2B2BFF2B37393D37393D0012092BFF2B2BFF2B1C56540012090D2F
        43574B4B0012090012093557572BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        0000001209344C3B001209001209001209001209001209001209001209001209
        001209001209001209001209001209001209001209001209001209344C3B0012
        092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000000012093557571F616D1F
        616D3274781F616D1F616D3274783274781F616D3557573A4E603274781F616D
        3A4E603274781F616D3A4E603557573557570012092BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B00000035575700120900120900120900120900120900120900
        1209001209001209001209001209001209001209001209001209001209001209
        0012090012093557572BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF
        2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0012091F616D37393D00
        12092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B2BFF2B3557570012090012093557572BFF2B2BFF2B2BFF2B2B
        FF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B
        2BFF2B000000}
      Transparent = True
      Visible = False
    end
    object imgRedFlag: TImage
      Left = 0
      Top = 0
      Width = 23
      Height = 29
      AutoSize = True
      Picture.Data = {
        07544269746D61705E080000424D5E0800000000000036000000280000001700
        00001D0000000100180000000000280800000000000000000000000000000000
        00002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35566D
        372B2C35566D2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2B
        FF2B2BFF2B37393D355757372B2C15234535566D2BFF2B2BFF2B2BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B2BFF2B2BFF2B37393D344C3B0012090C0E1E0C0E1E35566D2B
        FF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35566D0C0E1E3557570C0E1E0C0E
        1E0C0E1E0C0E1E0C0E1E15234535566D2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B1523450C0E1E372B2C
        3864570012090C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E35566D2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35
        566D0C0E1E37393D3557570012090C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E
        0C0E1E15234535566D2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B2BFF2B152345372B2C1F616D0012090C0E1E0C0E1E0C0E1E0C
        0E1E0C0E1E0C0E1E0C0E1E15234515234535566D2BFF2B0000002BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35566D372B2C1F616D0012090C0E
        1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E15234515234535566D00
        00002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B372B2C
        344C3B00120935566D35566D35566D35566D35566D35566D35566D35566D3556
        6D35566D35566D0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2B
        FF2B2BFF2B0012090012090012092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B355757001209001209001209001209001209372B2C3557572BFF2B2B
        FF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        2BFF2B2BFF2B355757001209372B2C002B7B002B7B002B7B002B7B002B7B002B
        7B372B2C0012090012093557572BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B2BFF2B355757372B2C002B7B002B7B002B7B002B7B002B7B
        002B7B002B7B002B7B002B7B002B7B002B7B372B2C3557572BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B001209002B7B00338B002B7B00
        276B002B7B00338B002B7B002B7B00276B002B7B002B7B002B7B002B7B001209
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B0012090033
        8B00338B00276B002B7B00338B00338B002B7B00276B00276B00338B002B7B00
        2B7B002B7B0012092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        35575737393D00338B00338B00276B00338B00338B002B7B00276B00276B002B
        7B002B7B00338B002B7B002B7B0012092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B372B2C002B7B002B7B00338B002B7B00338B002B7B002B7B
        002B7B002B7B002B7B002B7B00338B00338B002B7B37393D3557572BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B00120900379B002B7B002B7B002B7B00
        338B00276B002B7B00338B00379B00338B00338B002B7B00338B002B7B002B7B
        0012092BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B00120900379B0033
        8B002B7B002B7B002B7B00276B002B7B002B7B00338B003FAF003FAF00338B00
        2B7B00338B002B7B0012092BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        00120900379B00338B002B7B002B7B00276B00276B002B7B002B7B002B7B0033
        8B00379B003FAF00379B002B7B002B7B372B2C2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B00120900338B00338B002B7B00276B00276B002B7B002B7B
        00338B00379B00338B002B7B00379B003FAF00338B002B7B372B2C2BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B00120900379B00338B00276B00276B00
        276B0D2F430D2F430D2F430D2F43002B7B00379B00338B00379B003FAF00338B
        372B2C2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B372B2C00379B002B
        7B00276B0D2F430D2F432BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0D2F430D2F4300
        2B7B00379B00379B372B2C2BFF2B2BFF2B2BFF2B2BFF2B000000355757001209
        001209002B7B0D2F431C56540012092BFF2B2BFF2B37393D37393D0012092BFF
        2B2BFF2B1C56540012090D2F4300338B0012090012093557572BFF2B2BFF2B00
        0000001209344C3B001209001209001209001209001209001209001209001209
        001209001209001209001209001209001209001209001209001209344C3B0012
        092BFF2B2BFF2B0000000012093557571F616D1F616D3274781F616D1F616D32
        74783274781F616D3557573A4E603274781F616D3A4E603274781F616D3A4E60
        3557573557570012092BFF2B2BFF2B0000003557570012090012090012090012
        0900120900120900120900120900120900120900120900120900120900120900
        12090012090012090012090012093557572BFF2B2BFF2B0000002BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0012091F616D37393D0012092BFF
        2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B355757001209
        0012093557572BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B000000}
      Transparent = True
      Visible = False
    end
    object imgNode: TImage
      Left = 0
      Top = 0
      Width = 11
      Height = 11
      AutoSize = True
      Picture.Data = {
        07544269746D6170C2010000424DC20100000000000036000000280000000B00
        00000B00000001001800000000008C0100000000000000000000000000000000
        00002BFF2B2BFF2B2BFF2B042042042042042042042042191E352BFF2B2BFF2B
        2BFF2B0000002BFF2B2BFF2B191E35003FAF003FAF003FAF003FAF002B7B191E
        352BFF2B2BFF2B0000002BFF2B191E35002B7B00379B00379B00338B00379B00
        3FAF002B7B191E352BFF2B000000191E35002B7B003FAF00338B00338B00338B
        00338B00379B003FAF002B7B191E35000000042042003FAF00379B002B7B0027
        6B002B7B002B7B00338B00379B003FAF042042000000042042003FAF00338B00
        2B7B002B7B00276B002B7B00338B00338B003FAF042042000000042042003FAF
        00379B002B7B002B7B002B7B00276B00338B00379B003FAF0420420000000420
        42003FAF003FAF00379B002B7B002B7B00338B00379B00379B003FAF04204200
        00002BFF2B191E35002B7B003FAF00379B00338B00379B003FAF002B7B191E35
        2BFF2B0000002BFF2B2BFF2B191E35003FAF003FAF003FAF003FAF002B7B191E
        352BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B04204204204204204204204219
        1E352BFF2B2BFF2B2BFF2B000000}
      Transparent = True
      Visible = False
    end
    object shpBriefing: TShape
      Left = 0
      Top = 151
      Width = 360
      Height = 430
      Brush.Style = bsDiagCross
      Pen.Color = clWhite
    end
  end
  object rgBriefingPos: TRadioGroup
    Left = 8
    Top = 592
    Width = 200
    Height = 60
    Anchors = [akLeft, akBottom]
    Caption = ' Briefing position '
    Items.Strings = (
      'Bottom-right'
      'Bottom-left')
    TabOrder = 8
    OnClick = rgBriefingPosClick
  end
  object edtShortName: TMaskEdit
    Left = 8
    Top = 184
    Width = 56
    Height = 22
    AutoSize = False
    EditMask = '>LLL'
    MaxLength = 3
    TabOrder = 9
    Text = '   '
    OnChange = edtShortNameChange
    OnKeyPress = edtShortNameKeyPress
  end
  object cbShowNodeNumbers: TCheckBox
    Left = 8
    Top = 672
    Width = 113
    Height = 18
    Anchors = [akLeft, akBottom]
    Caption = 'Show node numbers'
    Checked = True
    State = cbChecked
    TabOrder = 10
    OnClick = cbShowNodeNumbersClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 708
    Width = 200
    Height = 72
    Hint = 'Double click to quick-add'#13#10'Drag&Drop to add to mouse position.'
    Anchors = [akLeft, akBottom]
    Caption = 'New chart objects'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    object imgNewFlag: TImage
      Left = 18
      Top = 26
      Width = 23
      Height = 29
      Hint = 'New Flag'
      AutoSize = True
      ParentShowHint = False
      Picture.Data = {
        07544269746D61705E080000424D5E0800000000000036000000280000001700
        00001D0000000100180000000000280800000000000000000000000000000000
        00002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35566D
        372B2C35566D2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2B
        FF2B2BFF2B37393D355757372B2C15234535566D2BFF2B2BFF2B2BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B2BFF2B2BFF2B37393D344C3B0012090C0E1E0C0E1E35566D2B
        FF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35566D0C0E1E3557570C0E1E0C0E
        1E0C0E1E0C0E1E0C0E1E15234535566D2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B1523450C0E1E372B2C
        3864570012090C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E35566D2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35
        566D0C0E1E37393D3557570012090C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E
        0C0E1E15234535566D2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B2BFF2B152345372B2C1F616D0012090C0E1E0C0E1E0C0E1E0C
        0E1E0C0E1E0C0E1E0C0E1E15234515234535566D2BFF2B0000002BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B35566D372B2C1F616D0012090C0E
        1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E0C0E1E15234515234535566D00
        00002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B372B2C
        344C3B00120935566D35566D35566D35566D35566D35566D35566D35566D3556
        6D35566D35566D0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2B
        FF2B2BFF2B0012090012090012092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B355757001209001209001209001209001209372B2C3557572BFF2B2B
        FF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        2BFF2B2BFF2B355757001209372B2C002B7B002B7B002B7B002B7B002B7B002B
        7B372B2C0012090012093557572BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B2BFF2B355757372B2C002B7B002B7B002B7B002B7B002B7B
        002B7B002B7B002B7B002B7B002B7B002B7B372B2C3557572BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B001209002B7B00338B002B7B00
        276B002B7B00338B002B7B002B7B00276B002B7B002B7B002B7B002B7B001209
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B0012090033
        8B00338B00276B002B7B00338B00338B002B7B00276B00276B00338B002B7B00
        2B7B002B7B0012092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        35575737393D00338B00338B00276B00338B00338B002B7B00276B00276B002B
        7B002B7B00338B002B7B002B7B0012092BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B372B2C002B7B002B7B00338B002B7B00338B002B7B002B7B
        002B7B002B7B002B7B002B7B00338B00338B002B7B37393D3557572BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B00120900379B002B7B002B7B002B7B00
        338B00276B002B7B00338B00379B00338B00338B002B7B00338B002B7B002B7B
        0012092BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B00120900379B0033
        8B002B7B002B7B002B7B00276B002B7B002B7B00338B003FAF003FAF00338B00
        2B7B00338B002B7B0012092BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B
        00120900379B00338B002B7B002B7B00276B00276B002B7B002B7B002B7B0033
        8B00379B003FAF00379B002B7B002B7B372B2C2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B00120900338B00338B002B7B00276B00276B002B7B002B7B
        00338B00379B00338B002B7B00379B003FAF00338B002B7B372B2C2BFF2B2BFF
        2B2BFF2B2BFF2B0000002BFF2B2BFF2B00120900379B00338B00276B00276B00
        276B0D2F430D2F430D2F430D2F43002B7B00379B00338B00379B003FAF00338B
        372B2C2BFF2B2BFF2B2BFF2B2BFF2B0000002BFF2B2BFF2B372B2C00379B002B
        7B00276B0D2F430D2F432BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0D2F430D2F4300
        2B7B00379B00379B372B2C2BFF2B2BFF2B2BFF2B2BFF2B000000355757001209
        001209002B7B0D2F431C56540012092BFF2B2BFF2B37393D37393D0012092BFF
        2B2BFF2B1C56540012090D2F4300338B0012090012093557572BFF2B2BFF2B00
        0000001209344C3B001209001209001209001209001209001209001209001209
        001209001209001209001209001209001209001209001209001209344C3B0012
        092BFF2B2BFF2B0000000012093557571F616D1F616D3274781F616D1F616D32
        74783274781F616D3557573A4E603274781F616D3A4E603274781F616D3A4E60
        3557573557570012092BFF2B2BFF2B0000003557570012090012090012090012
        0900120900120900120900120900120900120900120900120900120900120900
        12090012090012090012090012093557572BFF2B2BFF2B0000002BFF2B2BFF2B
        2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B0012091F616D37393D0012092BFF
        2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B00
        00002BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B355757001209
        0012093557572BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF2B2BFF
        2B2BFF2B2BFF2B000000}
      ShowHint = True
      Transparent = True
      OnDblClick = NewObjectImgDblClick
      OnMouseDown = NewObjectImgMouseDown
    end
    object imgNewNode: TImage
      Left = 59
      Top = 37
      Width = 11
      Height = 11
      Hint = 'New Node'
      AutoSize = True
      ParentShowHint = False
      Picture.Data = {
        07544269746D6170C2010000424DC20100000000000036000000280000000B00
        00000B00000001001800000000008C0100000000000000000000000000000000
        00002BFF2B2BFF2B2BFF2B042042042042042042042042191E352BFF2B2BFF2B
        2BFF2B0000002BFF2B2BFF2B191E35003FAF003FAF003FAF003FAF002B7B191E
        352BFF2B2BFF2B0000002BFF2B191E35002B7B00379B00379B00338B00379B00
        3FAF002B7B191E352BFF2B000000191E35002B7B003FAF00338B00338B00338B
        00338B00379B003FAF002B7B191E35000000042042003FAF00379B002B7B0027
        6B002B7B002B7B00338B00379B003FAF042042000000042042003FAF00338B00
        2B7B002B7B00276B002B7B00338B00338B003FAF042042000000042042003FAF
        00379B002B7B002B7B002B7B00276B00338B00379B003FAF0420420000000420
        42003FAF003FAF00379B002B7B002B7B00338B00379B00379B003FAF04204200
        00002BFF2B191E35002B7B003FAF00379B00338B00379B003FAF002B7B191E35
        2BFF2B0000002BFF2B2BFF2B191E35003FAF003FAF003FAF003FAF002B7B191E
        352BFF2B2BFF2B0000002BFF2B2BFF2B2BFF2B04204204204204204204204219
        1E352BFF2B2BFF2B2BFF2B000000}
      ShowHint = True
      Transparent = True
      OnDblClick = NewObjectImgDblClick
      OnMouseDown = NewObjectImgMouseDown
    end
  end
  object cbShowBriefingPosition: TCheckBox
    Left = 8
    Top = 568
    Width = 121
    Height = 18
    Anchors = [akLeft, akBottom]
    Caption = 'Show briefing position'
    Checked = True
    State = cbChecked
    TabOrder = 12
    OnClick = cbShowBriefingPositionClick
  end
  object edtName: TEdit
    Left = 8
    Top = 128
    Width = 200
    Height = 24
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    Text = 'Campaign name'
  end
  object btnUnloadCMP: TButton
    Left = 8
    Top = 72
    Width = 200
    Height = 24
    Hint = 'Clear campaign data'
    Caption = 'Unload CMP'
    TabOrder = 14
    OnClick = btnUnloadCMPClick
  end
  object btnEditMission: TButton
    Left = 114
    Top = 512
    Width = 96
    Height = 24
    Caption = 'Edit mission'
    Enabled = False
    TabOrder = 15
    OnClick = btnEditMissionClick
  end
  object dlgOpenPicture: TOpenDialog
    Filter = 'Supported images (*.png)|*.png'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoNetworkButton, ofEnableSizing]
    Left = 320
    Top = 16
  end
  object dlgOpenCampaign: TOpenDialog
    Filter = 'KaM Remake campaigns (*.cmp)|*.cmp'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoNetworkButton, ofEnableSizing]
    Left = 320
    Top = 64
  end
  object dlgSaveCampaign: TSaveDialog
    DefaultExt = 'cmp'
    Filter = 'KaM Remake campaigns (*.cmp)|*.cmp'
    Left = 320
    Top = 112
  end
end
