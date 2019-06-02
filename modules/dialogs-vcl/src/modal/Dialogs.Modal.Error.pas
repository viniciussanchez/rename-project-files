unit Dialogs.Modal.Error;

interface

uses Dialogs.Modal.Intf;

type
  TDialogModalError = class(TInterfacedObject, IDialogModal)
  private
    function Show(const Content: string): Integer;
    constructor Create;
  public
    class function New(const Content: string): Integer;
  end;

implementation

uses Vcl.Forms, Winapi.Windows, Vcl.BlockUI.Intf, Vcl.BlockUI;

constructor TDialogModalError.Create;
begin
  inherited;
end;

class function TDialogModalError.New(const Content: string): Integer;
var
  Dialog: IDialogModal;
begin
  Dialog := TDialogModalError.Create();
  Result := Dialog.Show(Content);
end;

function TDialogModalError.Show(const Content: string): Integer;
var
  BlockUI: IBlockUI;
begin
  BlockUI := TBlockUI.Create();
  Result := Application.MessageBox(PWideChar(Content), PWideChar(Application.Title), MB_ICONHAND);
end;

end.
