unit Rename;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Dialogs.Factory;

type
  TFrmMain = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtDirectory: TEdit;
    btnSearch: TButton;
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
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    function GetDataFileName: string;
  end;

var
  FrmMain: TFrmMain;

implementation

uses Vcl.FileCtrl, Rename.Utils, DataSet.Serialize.Helper, System.JSON;

{$R *.dfm}

procedure TFrmMain.btnSearchClick(Sender: TObject);
var
  Directory: string;
  DirectoryList: TStrings;
begin
  if SelectDirectory(Directory, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    edtDirectory.Text := Directory;
    DirectoryList := TStringList.Create;
    try
      DirectoryList.Add(Directory);
      TDirectoryUtils.GetSubDirectorys(Directory, DirectoryList);
      TDirectoryUtils.ListAllFiles(DirectoryList, mtFiles);
    finally
      DirectoryList.Free;
    end;
  end;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  if mtFiles.IsEmpty then
    Exit;
  if TDialogs.Confirm('Do you want to rename the files?') then
    TDirectoryUtils.RenameFiles(mtFiles);
end;

procedure TFrmMain.Button2Click(Sender: TObject);
var
  DataArray: TJSONArray;
  Data: TStrings;
begin
  if not FileExists(GetDataFileName) then
  begin
    TDialogs.Warning('Data file not found!');
    Exit;
  end;
  Data := TStringList.Create;
  try
    Data.LoadFromFile(GetDataFileName);
    DataArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Data.Text),0) as TJSONArray;
    try
      mtFiles.EmptyDataSet;
      mtFiles.LoadFromJSONArray(DataArray);
    finally
      DataArray.Free;
    end;
  finally
    Data.Free;
  end;
end;

procedure TFrmMain.Button3Click(Sender: TObject);
var
  Data: TJSONArray;
  SaveFile: TStrings;
begin
  Data := mtFiles.ToJSONArray;
  try
    SaveFile := TStringList.Create;
    try
      SaveFile.Text := Data.ToString;
      SaveFile.SaveToFile(GetDataFileName);
    finally
      SaveFile.Free;
    end;
    TDialogs.Info('Exported: ' + GetDataFileName);
  finally
    Data.Free;
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

end.
