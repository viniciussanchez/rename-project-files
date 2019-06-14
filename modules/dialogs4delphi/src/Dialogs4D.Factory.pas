unit Dialogs4D.Factory;

interface

type
  TDialogs = class
  public
    /// <summary>
    ///   Displays a dialog box for the user with a message.
    /// </summary>
    /// <param name="Content">
    ///   Message to be displayed to the user.
    /// </param>
    class procedure Info(const Content: string); static;
    /// <summary>
    ///   Displays a dialog box for the user with a error message.
    /// </summary>
    /// <param name="Content">
    ///   Error message to be displayed to the user.
    /// </param>
    class procedure Error(const Content: string); static;
    /// <summary>
    ///   Displays a dialog box for the user with a warning message.
    /// </summary>
    /// <param name="Content">
    ///   Warning message to be displayed to the user.
    /// </param>
    class procedure Warning(const Content: string); static;
    /// <summary>
    ///   Displays a dialog box for the user with a question.
    /// </summary>
    /// <param name="Content">
    ///   Question to be displayed to the user.
    /// </param>
    /// <returns>
    ///   Returns true if the user has confirmed the question.
    /// </returns>
    class function Confirm(const Content: string): Boolean; static;
    /// <summary>
    ///   Displays a dialog box for the user with an input box.
    /// </summary>
    /// <param name="Description">
    ///   Input box description.
    /// </param>
    /// <param name="Default">
    ///   Default value for the input box (default is empty).
    /// </param>
    /// <returns>
    ///   User defined value.
    /// </returns>
    class function Input(const Description: string; const Default: string = ''): string; static;
  end;

implementation

uses Dialogs4D.Modal.Confirm, Dialogs4D.Modal.Error, Dialogs4D.Modal.Info, Dialogs4D.Input, Dialogs4D.Modal.Warning,
  Dialogs4D.Modal.Intf, Dialogs4D.Input.Intf;

class function TDialogs.Input(const Description: string; const Default: string = ''): string;
var
  Dialog: IDialogInput;
begin
  Dialog := TDialogInput.Create;
  Result := Dialog.Show(Description, default);
end;

class function TDialogs.Confirm(const Content: string): Boolean;
var
  Dialog: IDialogModalConfirm;
begin
  Dialog := TDialogModalConfirm.Create;
  Result := Dialog.Show(Content);
end;

class procedure TDialogs.Error(const Content: string);
var
  Dialog: IDialogModal;
begin
  Dialog := TDialogModalError.Create;
  Dialog.Show(Content);
end;

class procedure TDialogs.Info(const Content: string);
var
  Dialog: IDialogModal;
begin
  Dialog := TDialogModalInfo.Create;
  Dialog.Show(Content);
end;

class procedure TDialogs.Warning(const Content: string);
var
  Dialog: IDialogModal;
begin
  Dialog := TDialogModalWarning.Create;
  Dialog.Show(Content);
end;

end.
