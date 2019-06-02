unit Dialogs.Input;

interface

uses Dialogs.Input.Intf;

type
  TDialogInput = class(TInterfacedObject, IDialogInput)
  private
    function Show(const Description, Default: string): string;
    constructor Create;
  public
    class function New(const Description, Default: string): string;
  end;

implementation

uses Vcl.Dialogs, Vcl.Forms, Vcl.BlockUI.Intf, Vcl.BlockUI;

constructor TDialogInput.Create;
begin
  inherited;
end;

class function TDialogInput.New(const Description, Default: string): string;
var
  Dialog: IDialogInput;
begin
  Dialog := TDialogInput.Create();
  Result := Dialog.Show(Description, Default);
end;

function TDialogInput.Show(const Description, Default: string): string;
var
  BlockUI: IBlockUI;
begin
  BlockUI := TBlockUI.Create();
  Result := InputBox(PWideChar(Application.Title), PWideChar(Description), Default);
end;

end.
