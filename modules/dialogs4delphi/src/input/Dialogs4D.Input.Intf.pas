unit Dialogs4D.Input.Intf;

interface

type
  IDialogInput = interface
    ['{213F3C9D-3CED-4407-82ED-4B0A143391DE}']
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

end.
