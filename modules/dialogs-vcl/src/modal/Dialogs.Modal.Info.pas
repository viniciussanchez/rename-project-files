unit Dialogs.Modal.Info;

interface

uses Dialogs.Modal.Intf;

type
  TDialogModalInfo = class(TInterfacedObject, IDialogModal)
  private
    function Show(const Content: string): Integer;
    constructor Create;
  public
    class function New(const Content: string): Integer;
  end;

implementation

uses Vcl.Forms, Winapi.Windows, Vcl.BlockUI.Intf, Vcl.BlockUI;

constructor TDialogModalInfo.Create;
begin
  inherited;
end;

class function TDialogModalInfo.New(const Content: string): Integer;
var
  Dialog: IDialogModal;
begin
  Dialog := TDialogModalInfo.Create();
  Result := Dialog.Show(Content);
end;

function TDialogModalInfo.Show(const Content: string): Integer;
var
  BlockUI: IBlockUI;
begin
  BlockUI := TBlockUI.Create();
  Result := Application.MessageBox(PWideChar(Content), PWideChar(Application.Title), MB_ICONINFORMATION);
end;

end.
