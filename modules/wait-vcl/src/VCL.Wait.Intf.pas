unit VCL.Wait.Intf;

interface

uses Providers.ProgressBar.Intf;

type
  IWait = interface
    ['{53685910-D261-41CF-84B9-1C6720BB246A}']
    function Content: string;
    procedure SetContent(const Content: string);
    procedure ShowProgressBar(const Value: Boolean);
    function ProgressBar: IProgressBar;
  end;

implementation

end.
