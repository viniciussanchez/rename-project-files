object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Rename files'
  ClientHeight = 488
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 984
    Height = 488
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      984
      488)
    object Label1: TLabel
      Left = 9
      Top = 13
      Width = 49
      Height = 13
      Caption = 'Directory:'
    end
    object edtDirectory: TEdit
      Left = 64
      Top = 10
      Width = 844
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
    end
    object btnSearch: TButton
      Left = 914
      Top = 8
      Width = 59
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Search'
      TabOrder = 1
      OnClick = btnSearchClick
    end
    object DBGrid1: TDBGrid
      Left = 0
      Top = 41
      Width = 984
      Height = 410
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = dsFiles
      TabOrder = 2
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnDrawColumnCell = DBGrid1DrawColumnCell
      OnTitleClick = DBGrid1TitleClick
      Columns = <
        item
          Color = clBtnFace
          Expanded = False
          FieldName = 'OLD_FILE_NAME'
          ReadOnly = True
          Width = 300
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NEW_FILE_NAME'
          Width = 300
          Visible = True
        end
        item
          Color = clBtnFace
          Expanded = False
          FieldName = 'OLD_CLASS_NAME'
          ReadOnly = True
          Width = 180
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NEW_CLASS_NAME'
          Width = 180
          Visible = True
        end
        item
          Color = clBtnFace
          Expanded = False
          FieldName = 'DIRECTORY'
          ReadOnly = True
          Width = 300
          Visible = True
        end
        item
          Color = clBtnFace
          Expanded = False
          FieldName = 'EXTENSION'
          ReadOnly = True
          Visible = True
        end>
    end
    object Panel2: TPanel
      Left = 0
      Top = 451
      Width = 984
      Height = 37
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      DesignSize = (
        984
        37)
      object Button1: TButton
        Left = 876
        Top = 6
        Width = 97
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Rename files'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 9
        Top = 6
        Width = 97
        Height = 25
        Caption = 'Load data'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 112
        Top = 6
        Width = 97
        Height = 25
        Caption = 'Save data'
        TabOrder = 2
        OnClick = Button3Click
      end
    end
  end
  object dsFiles: TDataSource
    DataSet = mtFiles
    Left = 360
    Top = 216
  end
  object mtFiles: TFDMemTable
    AfterInsert = mtFilesAfterInsert
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 400
    Top = 216
    object mtFilesOLD_FILE_NAME: TStringField
      FieldName = 'OLD_FILE_NAME'
      Size = 200
    end
    object mtFilesNEW_FILE_NAME: TStringField
      FieldName = 'NEW_FILE_NAME'
      Size = 200
    end
    object mtFilesOLD_CLASS_NAME: TStringField
      FieldName = 'OLD_CLASS_NAME'
      Size = 100
    end
    object mtFilesNEW_CLASS_NAME: TStringField
      FieldName = 'NEW_CLASS_NAME'
      Size = 100
    end
    object mtFilesEXTENSION: TStringField
      FieldName = 'EXTENSION'
      Size = 10
    end
    object mtFilesDIRECTORY: TStringField
      FieldName = 'DIRECTORY'
      Size = 1000
    end
    object mtFilesRENAME: TStringField
      FieldName = 'RENAME'
      Size = 1
    end
  end
end
