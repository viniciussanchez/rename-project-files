unit Rename;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.ExprFuncs, Vcl.ComCtrls;

type
  TFrmMain = class(TForm)
    Panel1: TPanel;
    dsFiles: TDataSource;
    mtFiles: TFDMemTable;
    DBGrid1: TDBGrid;
    mtFilesOLD_FILE_NAME: TStringField;
    mtFilesNEW_FILE_NAME: TStringField;
    mtFilesOLD_CLASS_NAME: TStringField;
    mtFilesNEW_CLASS_NAME: TStringField;
    mtFilesEXTENSION: TStringField;
    Panel2: TPanel;
    Button1: TButton;
    mtFilesDIRECTORY: TStringField;
    Button2: TButton;
    Button3: TButton;
    mtFilesRENAME: TStringField;
    Panel3: TPanel;
    Label1: TLabel;
    edtDirectory: TEdit;
    btnSearch: TButton;
    Button4: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel4: TPanel;
    Label2: TLabel;
    edtFilterFileName: TEdit;
    btnFilter: TButton;
    Panel5: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    edtTextFind: TEdit;
    btnReplace: TButton;
    edtReplace: TEdit;
    TabSheet2: TTabSheet;
    Panel6: TPanel;
    Label3: TLabel;
    edtFilterClassName: TEdit;
    Button5: TButton;
    Panel7: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    edtTextFindClassName: TEdit;
    Button6: TButton;
    edtReplaceClassName: TEdit;
    Button7: TButton;
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure mtFilesAfterInsert(DataSet: TDataSet);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnFilterClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure edtFilterFileNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    function GetDataFileName: string;
  end;

var
  FrmMain: TFrmMain;

implementation

uses Vcl.FileCtrl, Rename.Utils, DataSet.Serialize.Helper, System.JSON, VCL.Wait, Dialogs4D.Factory;

{$R *.dfm}

procedure TFrmMain.btnFilterClick(Sender: TObject);
begin
  if not mtFiles.Active then
    Exit;
  if Trim(edtFilterFileName.Text).IsEmpty then
    mtFiles.Filter := 'EXTENSION = ''.pas'''
  else
    mtFiles.Filter :=
      'EXTENSION = ''.pas'' and (Lower(OLD_FILE_NAME) like ' + QuotedStr('%' + Trim(edtFilterFileName.Text).ToLower + '%') +
      ' or Lower(NEW_FILE_NAME) like ' + QuotedStr('%' + Trim(edtFilterFileName.Text).ToLower + '%') + ')';
  mtFiles.Filtered := True;
end;

procedure TFrmMain.btnReplaceClick(Sender: TObject);
begin
  if Trim(edtTextFind.Text).IsEmpty or mtFiles.IsEmpty then
    Exit;
  TDirectoryUtils.ReplaceFileName(edtTextFind.Text, edtReplace.Text, mtFiles);
end;

procedure TFrmMain.btnSearchClick(Sender: TObject);
var
  LDirectory: string;
  LDirectoryList: TStrings;
begin
  if SelectDirectory(LDirectory, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    edtDirectory.Text := LDirectory;
    LDirectoryList := TStringList.Create;
    try
      LDirectoryList.Add(LDirectory);
      TDirectoryUtils.GetSubDirectorys(LDirectory, LDirectoryList);
      TDirectoryUtils.ListAllFiles(LDirectoryList, mtFiles);
      TDirectoryUtils.SetOldClassName(mtFiles);
    finally
      LDirectoryList.Free;
    end;
  end;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  if mtFiles.IsEmpty then
    Exit;
  if TDialogs.Confirm('Do you want to rename the files?') then
  begin
    if TDirectoryUtils.ValidateFileName(mtFiles) then
    begin
      if TDirectoryUtils.RenameFiles(mtFiles) then
        TDirectoryUtils.UpdateFiles(mtFiles);
    end
    else
      TDialogs.Warning('Invalid filename');
  end;
end;

procedure TFrmMain.Button2Click(Sender: TObject);
var
  LDataArray: TJSONArray;
  LData: TStrings;
begin
  if not FileExists(GetDataFileName) then
  begin
    TDialogs.Warning('Data file not found!');
    Exit;
  end;
  LData := TStringList.Create;
  try
    LData.LoadFromFile(GetDataFileName);
    LDataArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LData.Text),0) as TJSONArray;
    mtFiles.DisableControls;
    try
      mtFiles.EmptyDataSet;
      TWait.Create('Loading...').Start(
        procedure
        begin
          mtFiles.LoadFromJSONArray(LDataArray);
        end);
    finally
      mtFiles.EnableControls;
      LDataArray.Free;
    end;
  finally
    LData.Free;
  end;
end;

procedure TFrmMain.Button3Click(Sender: TObject);
var
  LData: TJSONArray;
  LSaveFile: TStrings;
begin
  mtFiles.DisableControls;
  try
    LData := mtFiles.ToJSONArray;
    try
      LSaveFile := TStringList.Create;
      try
        LSaveFile.Text := LData.ToString;
        LSaveFile.SaveToFile(GetDataFileName);
      finally
        LSaveFile.Free;
      end;
      TDialogs.Info('Exported: ' + GetDataFileName);
    finally
      LData.Free;
    end;
  finally
    mtFiles.EnableControls;
  end;
end;

procedure TFrmMain.Button4Click(Sender: TObject);
begin
  TDirectoryUtils.LoadNewFileName(mtFiles);
end;

procedure TFrmMain.Button5Click(Sender: TObject);
begin
  if not mtFiles.Active then
    Exit;
  if Trim(edtFilterClassName.Text).IsEmpty then
    mtFiles.Filter := 'EXTENSION = ''.pas'''
  else
    mtFiles.Filter :=
      'EXTENSION = ''.pas'' and (Lower(OLD_CLASS_NAME) like ' + QuotedStr('%' + Trim(edtFilterClassName.Text).ToLower + '%') +
      ' or Lower(NEW_CLASS_NAME) like ' + QuotedStr('%' + Trim(edtFilterClassName.Text).ToLower + '%') + ')';
  mtFiles.Filtered := True;
end;

procedure TFrmMain.Button6Click(Sender: TObject);
begin
  if Trim(edtTextFindClassName.Text).IsEmpty or mtFiles.IsEmpty then
    Exit;
  TDirectoryUtils.ReplaceClassName(edtTextFindClassName.Text, edtReplaceClassName.Text, mtFiles);
end;

procedure TFrmMain.Button7Click(Sender: TObject);
begin
  TDirectoryUtils.LoadNewClassName(mtFiles);
end;

procedure TFrmMain.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if mtFilesRENAME.AsString = 'S' then
    DBGrid1.Canvas.Brush.Color := clRed;
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFrmMain.DBGrid1TitleClick(Column: TColumn);
begin
  mtFiles.IndexFieldNames := Column.FieldName;
end;

procedure TFrmMain.edtFilterFileNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnFilter.Click;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  mtFiles.Active := True;
  mtFiles.Filter := 'EXTENSION = ''.pas''';
  mtFiles.Filtered := True;
end;

function TFrmMain.GetDataFileName: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'Rename.json';
end;

procedure TFrmMain.mtFilesAfterInsert(DataSet: TDataSet);
begin
  mtFilesRENAME.AsString := 'N';
end;

end.
