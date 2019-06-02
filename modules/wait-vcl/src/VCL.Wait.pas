unit VCL.Wait;

interface

uses BlockUI.Intf, VCL.Forms, VCL.Controls, VCL.BlockUI, VCL.ExtCtrls, System.Classes, VCL.Wait.Intf, Providers.ProgressBar.Intf,
  View.Wait;

type
  TWait = class(TInterfacedObject, IWait)
  private
    FWaitForm: TFrmWait;
    FProgressBar: IProgressBar;
    FBlockUI: IBlockUI;
    function Content: string;
    procedure SetContent(const Content: string);
    procedure ShowProgressBar(const Value: Boolean);
    function ProgressBar: IProgressBar;
  public
    constructor Create(const Content: string; const BlockUI: TWinControl = nil); overload;
    destructor Destroy; override;
  end;

implementation

uses Providers.ProgressBar.Default;

function TWait.ProgressBar: IProgressBar;
begin
  if not Assigned(FProgressBar) then
    FProgressBar := TProgressBarDefault.Create(FWaitForm.pbWait);
  Result := FProgressBar;
end;

constructor TWait.Create(const Content: string; const BlockUI: TWinControl);
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      if Assigned(BlockUI) then
        FBlockUI := TBlockUI.Create(BlockUI)
      else
        FBlockUI := TBlockUI.Create(Application.MainForm);
      FWaitForm := TFrmWait.Create(nil);
      FWaitForm.FormStyle := fsStayOnTop;
      FWaitForm.Position := poMainFormCenter;
      FWaitForm.Update;
      Self.ProgressBar.SetPosition(0);
      Self.SetContent(Content);
      FWaitForm.Show;
    end);
end;

destructor TWait.Destroy;
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      FWaitForm.free;
      FWaitForm := nil;
      if Assigned(FBlockUI) then
        FBlockUI.Unlock;
      FBlockUI := nil;
    end);
  inherited;
end;

procedure TWait.ShowProgressBar(const Value: Boolean);
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      FWaitForm.pbWait.Visible := Value;
      FWaitForm.pbWait.Update;
    end);
end;

function TWait.Content: string;
begin
  Result := FWaitForm.lblContent.Caption;
end;

procedure TWait.SetContent(const Content: string);
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      FWaitForm.lblContent.Caption := Content;
      FWaitForm.lblContent.Update;
    end);
end;

end.
