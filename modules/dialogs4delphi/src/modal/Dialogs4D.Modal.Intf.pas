unit Dialogs4D.Modal.Intf;

interface

type
  IDialogModal = interface
    ['{FDEBC19E-3E6F-4887-A1CB-3B0CB35C58A9}']
    /// <summary>
    ///   Displays a dialog box for the user with a message.
    /// </summary>
    /// <param name="Content">
    ///   Message to be displayed to the user.
    /// </param>
    procedure Show(const Content: string);
  end;

  IDialogModalConfirm = interface
    ['{E843C494-FD4C-46D5-8168-07D46541E19F}']
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

end.
