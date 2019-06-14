unit Dialogs4D.Modal.Warning;

interface

uses Dialogs4D.Modal.Intf;

type
  TDialogModalWarning = class(TInterfacedObject, IDialogModal)
  private
    /// <summary>
    ///   Displays a dialog box for the user with a warning message.
    /// </summary>
    /// <param name="Content">
    ///   Warning message to be displayed to the user.
    /// </param>
    procedure Show(const Content: string);
  end;

implementation

uses
{$IF (DEFINED(UNIGUI_VCL) or DEFINED(UNIGUI_ISAPI) or DEFINED(UNIGUI_SERVICE))}
  UniGuiDialogs, UniGuiTypes,
{$ELSEIF DEFINED(MSWINDOWS)}
  Vcl.Forms, Winapi.Windows, Vcl.BlockUI.Intf, Vcl.BlockUI,
{$ENDIF}
  System.SysUtils, Dialogs4D.Constants;

{$IF (DEFINED(UNIGUI_VCL) or DEFINED(UNIGUI_ISAPI) or DEFINED(UNIGUI_SERVICE))}
procedure TDialogModalWarning.Show(const Content: string);
begin
  MessageDlg(Content, mtWarning, [mbOK]);
end;
{$ELSEIF DEFINED(MSWINDOWS)}
procedure TDialogModalWarning.Show(const Content: string);
var
  BlockUI: IBlockUI;
begin
  BlockUI := TBlockUI.Create();
  Application.MessageBox(PWideChar(Content), PWideChar(Application.Title), MB_ICONWARNING);
end;
{$ELSE}
procedure TDialogModalWarning.Show(const Content: string);
begin
  raise Exception.Create(DIRECTIVE_NOT_DEFINED);
end;
{$ENDIF}

end.
