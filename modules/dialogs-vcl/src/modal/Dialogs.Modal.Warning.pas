unit Dialogs.Modal.Warning;

interface

uses Dialogs.Modal.Intf;

type
  TDialogModalWarning = class(TInterfacedObject, IDialogModal)
  private
    function Show(const Content: string): Integer;
    constructor Create;
  public
    class function New(const Content: string): Integer;
  end;

implementation

uses Vcl.Forms, Winapi.Windows, Vcl.BlockUI.Intf, Vcl.BlockUI;

constructor TDialogModalWarning.Create;
begin
  inherited;
end;

class function TDialogModalWarning.New(const Content: string): Integer;
var
  Dialog: IDialogModal;
begin
  Dialog := TDialogModalWarning.Create();
  Result := Dialog.Show(Content);
end;

function TDialogModalWarning.Show(const Content: string): Integer;
var
  BlockUI: IBlockUI;
begin
  BlockUI := TBlockUI.Create();
  Result := Application.MessageBox(PWideChar(Content), PWideChar(Application.Title), MB_ICONWARNING);
end;

end.
