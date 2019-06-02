unit Dialogs.Input.Intf;

interface

type
  IDialogInput = interface
    ['{213F3C9D-3CED-4407-82ED-4B0A143391DE}']
    function Show(const Description, Default: string): string;
  end;

implementation

end.
