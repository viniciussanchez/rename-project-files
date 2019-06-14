unit Dialogs4D.Input;

interface

uses Dialogs4D.Input.Intf;

type
  TDialogInput = class(TInterfacedObject, IDialogInput)
  private
    /// <summary>
    ///   Displays a dialog box for the user with an input box.
    /// </summary>
    /// <param name="Description">
    ///   Input box description.
    /// </param>
    /// <param name="Default">
    ///   Default value for the input box.
    /// </param>
    /// <returns>
    ///   User defined value.
    /// </returns>
    function Show(const Description, Default: string): string;
  end;

implementation

uses
{$IF (DEFINED(UNIGUI_VCL) or DEFINED(UNIGUI_ISAPI) or DEFINED(UNIGUI_SERVICE))}
  UniGuiDialogs, UniGuiTypes,
{$ELSEIF DEFINED(MSWINDOWS)}
  Vcl.Dialogs, Vcl.Forms, Vcl.BlockUI.Intf, Vcl.BlockUI,
{$ENDIF}
  System.SysUtils, Dialogs4D.Constants;

{$IF (DEFINED(UNIGUI_VCL) or DEFINED(UNIGUI_ISAPI) or DEFINED(UNIGUI_SERVICE))}
function TDialogInput.Show(const Description, Default: string): string;
var
  UserValue: string;
begin
  UserValue := Default;
  Prompt(Description, Default, mtInformation, [mbOk], UserValue, False);
  Result := UserValue;
end;
{$ELSEIF DEFINED(MSWINDOWS)}
function TDialogInput.Show(const Description, Default: string): string;
var
  BlockUI: IBlockUI;
begin
  BlockUI := TBlockUI.Create();
  Result := InputBox(PWideChar(Application.Title), PWideChar(Description), Default);
end;
{$ELSE}
function TDialogInput.Show(const Description, Default: string): string;
begin
  raise Exception.Create(DIRECTIVE_NOT_DEFINED);
end;
{$ENDIF}

end.
