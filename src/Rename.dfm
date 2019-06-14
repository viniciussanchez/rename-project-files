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
    object DBGrid1: TDBGrid
      Left = 0
      Top = 41
      Width = 984
      Height = 344
      Align = alClient
      DataSource = dsFiles
      TabOrder = 0
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
      TabOrder = 1
      ExplicitTop = 453
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
      object Button4: TButton
        Left = 215
        Top = 6
        Width = 218
        Height = 25
        Caption = 'Copy the old name to the new name'
        TabOrder = 3
        OnClick = Button4Click
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 984
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        984
        41)
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
    end
    object Panel4: TPanel
      Left = 0
      Top = 418
      Width = 984
      Height = 33
      Align = alBottom
      BevelOuter = bvSpace
      Color = cl3DLight
      ParentBackground = False
      TabOrder = 3
      DesignSize = (
        984
        33)
      object Label2: TLabel
        Left = 9
        Top = 10
        Width = 90
        Height = 13
        Caption = 'File name to find:'
      end
      object edtFilterFileName: TEdit
        Left = 105
        Top = 6
        Width = 765
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        TextHint = 'Type file name...'
        OnKeyDown = edtFilterFileNameKeyDown
      end
      object btnFilter: TButton
        Left = 876
        Top = 4
        Width = 97
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Filter'
        TabOrder = 1
        OnClick = btnFilterClick
      end
    end
    object Panel5: TPanel
      Left = 0
      Top = 385
      Width = 984
      Height = 33
      Align = alBottom
      BevelOuter = bvSpace
      Color = cl3DLight
      ParentBackground = False
      TabOrder = 4
      ExplicitTop = 418
      DesignSize = (
        984
        33)
      object Label4: TLabel
        Left = 39
        Top = 10
        Width = 60
        Height = 13
        Caption = 'Text to find:'
      end
      object Label5: TLabel
        Left = 526
        Top = 10
        Width = 69
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Replace with:'
      end
      object edtTextFind: TEdit
        Left = 105
        Top = 6
        Width = 415
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        TextHint = 'Type text...'
      end
      object btnReplace: TButton
        Left = 876
        Top = 4
        Width = 97
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Replace'
        TabOrder = 1
        OnClick = btnReplaceClick
      end
      object edtReplace: TEdit
        Left = 601
        Top = 6
        Width = 269
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 2
        TextHint = 'Type new value...'
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
