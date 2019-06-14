unit Dialogs4D.Modal.Confirm;

interface

uses Dialogs4D.Modal.Intf;

type
  TDialogModalConfirm = class(TInterfacedObject, IDialogModalConfirm)
  private
    /// <summary>
    ///   Displays a dialog box for the user with a question.
    /// </summary>
    /// <param name="Content">
    ///   Question to be displayed to the user.
    /// </param>
    /// <returns>
    ///   Returns true if the user has confirmed the question.
    /// </returns>
    function Show(const Content: string): Boolean;
  end;

implementation

uses
{$IF (DEFINED(UNIGUI_VCL) or DEFINED(UNIGUI_ISAPI) or DEFINED(UNIGUI_SERVICE))}
  UniGuiDialogs, UniGuiTypes,
{$ELSEIF DEFINED(MSWINDOWS)}
  Vcl.Forms, Winapi.Windows, Vcl.BlockUI.Intf, Vcl.BlockUI,
{$ENDIF}
  Vcl.Controls, System.SysUtils, Dialogs4D.Constants;

{$IF (DEFINED(UNIGUI_VCL) or DEFINED(UNIGUI_ISAPI) or DEFINED(UNIGUI_SERVICE))}
function TDialogModalConfirm.Show(const Content: string): Boolean;
begin
  Result := MessageDlg(Content, mtConfirmation, [mbYes, mbNo]) = mrYes;
end;
{$ELSEIF DEFINED(MSWINDOWS)}
function TDialogModalConfirm.Show(const Content: string): Boolean;
var
  BlockUI: IBlockUI;
begin
  BlockUI := TBlockUI.Create();
  Result := Application.MessageBox(PWideChar(Content), PWideChar(Application.Title), MB_ICONQUESTION + MB_YESNO) = mrYes;
end;
{$ELSE}
function TDialogModalConfirm.Show(const Content: string): Boolean;
begin
  raise Exception.Create(DIRECTIVE_NOT_DEFINED);
end;
{$ENDIF}

end.
