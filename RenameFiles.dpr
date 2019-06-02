program RenameFiles;

uses
  Vcl.Forms,
  Rename.Utils in 'src\Rename.Utils.pas',
  Rename in 'src\Rename.pas' {FrmMain};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
