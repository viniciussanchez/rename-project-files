unit Dialogs.Modal.Confirm;

interface

uses Dialogs.Modal.Intf;

type
  TDialogModalConfirm = class(TInterfacedObject, IDialogModal)
  private
    function Show(const Content: string): Integer;
    constructor Create;
  public
    class function New(const Content: string): Integer;
  end;

implementation

uses Vcl.Forms, Winapi.Windows, Vcl.BlockUI.Intf, Vcl.BlockUI;

constructor TDialogModalConfirm.Create;
begin
  inherited;
end;

class function TDialogModalConfirm.New(const Content: string): Integer;
var
  Dialog: IDialogModal;
begin
  Dialog := TDialogModalConfirm.Create();
  Result := Dialog.Show(Content);
end;

function TDialogModalConfirm.Show(const Content: string): Integer;
var
  BlockUI: IBlockUI;
begin
  BlockUI := TBlockUI.Create();
  Result := Application.MessageBox(PWideChar(Content), PWideChar(Application.Title), MB_ICONQUESTION + MB_YESNO);
end;

end.
