unit VCL.Wait;

interface

uses VCL.BlockUI.Intf, VCL.Forms, VCL.Controls, VCL.BlockUI, VCL.ExtCtrls, System.Classes, Providers.ProgressBar.Intf,
  View.Wait, System.SysUtils;

type
  TWait = class
  private
    FBlockUI: IBlockUI;
    FProgressBar: IProgressBar;
    FWaitForm: TFrmWait;
  public
    /// <summary>
    ///   Creates the required resources.
    /// </summary>
    /// <param name="Content">
    ///   Message to be set.
    /// </param>
    constructor Create(const Content: string);
    /// <summary>
    ///   Get the message from the screen to wait.
    /// </summary>
    /// <returns>
    ///   Defined message.
    /// </returns>
    function Content: string;
    /// <summary>
    ///   Sets a new message to the screen to wait.
    /// </summary>
    /// <param name="Content">
    ///   New message to be set.
    /// </param>
    /// <returns>
    ///   Returns the instance itself.
    /// </returns>
    function SetContent(const Content: string): TWait;
    /// <summary>
    ///   Access the progress bar.
    /// </summary>
    /// <returns>
    ///   Returns an instance of the IProgressBar interface.
    /// </returns>
    function ProgressBar: IProgressBar;
    /// <summary>
    ///   Creates a wait screen.
    /// </summary>
    /// <param name="Process">
    ///   Procedure that should be performed with the wait screen.
    /// </param>
    /// <returns>
    ///   Returns the instance itself.
    /// </returns>
    function Start(const Process: TProc): TWait;
    /// <summary>
    ///   Destroys the resources created.
    /// </summary>
    destructor Destroy; override;
  end;

implementation

uses Providers.ProgressBar.Default;

function TWait.ProgressBar: IProgressBar;
begin
  Result := Self.FProgressBar;
end;

constructor TWait.Create(const Content: string);
begin
  Self.FBlockUI := TBlockUI.Create(Application.MainForm);
  Self.FWaitForm := TFrmWait.Create(Application);
  Self.FProgressBar := TProgressBarDefault.Create(Self.FWaitForm.pbWait);
  Self.SetContent(Content);
end;

destructor TWait.Destroy;
begin
  FBlockUI := nil;
  FProgressBar := nil;
  if (Assigned(FWaitForm)) then
  begin
    FWaitForm.Close;
    FWaitForm := nil;
  end;
  inherited;
end;

function TWait.Content: string;
begin
  Result := Self.FWaitForm.lblContent.Caption;
end;

function TWait.SetContent(const Content: string): TWait;
begin
  Result := Self;
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      Self.FWaitForm.lblContent.Caption := Content;
      Self.FWaitForm.lblContent.Update;
    end);
end;

function TWait.Start(const Process: TProc): TWait;
var
  FActivityThread: TThread;
begin
  Result := Self;
  FActivityThread := TThread.CreateAnonymousThread(
    procedure
    begin
      try
        try
          Process;
        except on E:Exception do
          Application.ShowException(E);
        end;
      finally
        TThread.Synchronize(nil,
        procedure
        begin
          Self.Destroy;
        end);
      end;
    end);
  FActivityThread.FreeOnTerminate := True;
  FActivityThread.Start;
  Self.FWaitForm.ShowModal;  
end;

end.
