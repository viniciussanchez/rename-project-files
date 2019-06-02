unit Dialogs.Factory;

interface

type
  TDialogs = class
  public
    class procedure Info(const Content: string); static;
    class procedure Error(const Content: string); static;
    class procedure Warning(const Content: string); static;
    class function Confirm(const Content: string): Boolean; static;
    class function Input(const Description: string; const Default: string = ''): string; static;
  end;

implementation

uses Vcl.Controls, Dialogs.Modal.Info, Dialogs.Modal.Confirm, Dialogs.Modal.Error,
  Dialogs.Modal.Warning, Dialogs.Input;

class function TDialogs.Confirm(const Content: string): Boolean;
begin
  Result := TDialogModalConfirm.New(Content) = mrYes;
end;

class procedure TDialogs.Error(const Content: string);
begin
  TDialogModalError.New(Content);
end;

class procedure TDialogs.Info(const Content: string);
begin
  TDialogModalInfo.New(Content);
end;

class function TDialogs.Input(const Description: string; const Default: string = ''): string;
begin
  Result := TDialogInput.New(Description, default);
end;

class procedure TDialogs.Warning(const Content: string);
begin
  TDialogModalWarning.New(Content);
end;

end.
