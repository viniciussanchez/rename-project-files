unit Providers.ProgressBar.Default;

interface

uses Providers.ProgressBar.Intf, Vcl.ComCtrls;

type
  TProgressBarDefault = class(TInterfacedObject, IProgressBar)
  private
    FProgressBar: TProgressBar;
    procedure SetMax(const Value: Integer);
    procedure Step; overload;
    procedure Step(const Value: Integer); overload;
    function Position: Integer;
    procedure SetPosition(const Position: Integer);
  public
    constructor Create(const ProgressBar: TProgressBar);
    destructor Destroy; override;
  end;

implementation

uses System.Classes;

constructor TProgressBarDefault.Create(const ProgressBar: TProgressBar);
begin
  FProgressBar := ProgressBar;
end;

destructor TProgressBarDefault.Destroy;
begin
  FProgressBar := nil;
  inherited;
end;

procedure TProgressBarDefault.SetMax(const Value: Integer);
begin
  FProgressBar.Max := Value;
end;

procedure TProgressBarDefault.SetPosition(const Position: Integer);
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      FProgressBar.Position := Position;
    end);
end;

function TProgressBarDefault.Position: Integer;
begin
  Result := Round(Int(FProgressBar.Position));
end;

procedure TProgressBarDefault.Step(const Value: Integer);
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      FProgressBar.Position := FProgressBar.Position + Value;
    end);
end;

procedure TProgressBarDefault.Step;
begin
  Self.Step(1);
end;

end.
