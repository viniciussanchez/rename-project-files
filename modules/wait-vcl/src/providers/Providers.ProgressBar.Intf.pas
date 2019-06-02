unit Providers.ProgressBar.Intf;

interface

type
  IProgressBar = interface
    ['{167DEF94-F49D-4FBA-A274-771A1F4A1656}']
    procedure SetMax(const Value: Integer);
    procedure Step; overload;
    procedure Step(const Value: Integer); overload;
    function Position: Integer;
    procedure SetPosition(const Position: Integer);
  end;

implementation

end.
