unit Providers.ProgressBar.Default;

interface

uses Providers.ProgressBar.Intf, Vcl.ComCtrls;

type
  TProgressBarDefault = class(TInterfacedObject, IProgressBar)
  private
    FProgressBar: TProgressBar;
    /// <summary>
    ///   Gets the max value set for the progress bar.
    /// </summary>
    /// <returns>
    ///   Max value.
    /// </returns>
    function Max: Integer;
    /// <summary>
    ///   Sets a maximum value for the progress bar.
    /// </summary>
    /// <param name="Value">
    ///   Value to be defined.
    /// </param>
    procedure SetMax(const Value: Integer);
    /// <summary>
    ///   Increase a position on the progress bar.
    /// </summary>
    /// <param name="Value">
    ///   Value to be increased (default is 1).
    /// </param>
    procedure Step(const Value: Integer = 1);
    /// <summary>
    ///   Gets the current position of the progress bar.
    /// </summary>
    /// <returns>
    ///   Current position.
    /// </returns>
    function Position: Integer;
    /// <summary>
    ///   Defines a position for the progress bar.
    /// </summary>
    /// <param name="Position">
    ///   Position to be set.
    /// </param>
    procedure SetPosition(const Position: Integer);
    /// <summary>
    ///   Show the progress bar.
    /// </summary>
    procedure Show;
    /// <summary>
    ///   Hide the progress bar.
    /// </summary>
    procedure Hide;
  public
    constructor Create(const ProgressBar: TProgressBar);
    destructor Destroy; override;
  end;

implementation

uses System.Classes;

constructor TProgressBarDefault.Create(const ProgressBar: TProgressBar);
begin
  Self.FProgressBar := ProgressBar;
  Self.FProgressBar.Position := 0;
end;

destructor TProgressBarDefault.Destroy;
begin
  Self.FProgressBar := nil;
  inherited;
end;

function TProgressBarDefault.Max: Integer;
begin
  Result := Self.FProgressBar.Max;
end;

procedure TProgressBarDefault.SetMax(const Value: Integer);
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      Self.FProgressBar.Max := Value;
      Self.FProgressBar.Update;
    end);
end;

procedure TProgressBarDefault.SetPosition(const Position: Integer);
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      Self.FProgressBar.Position := Position;
      Self.FProgressBar.Update;
    end);
end;

procedure TProgressBarDefault.Step(const Value: Integer);
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      if not Self.FProgressBar.Visible then
        Self.Show;	
      Self.FProgressBar.Position := Self.FProgressBar.Position + Value;
      Self.FProgressBar.Update;
    end);
end;

function TProgressBarDefault.Position: Integer;
begin
  Result := Self.FProgressBar.Position;
end;

procedure TProgressBarDefault.Show;
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      Self.FProgressBar.Visible := True;
      Self.FProgressBar.Update;
    end);
end;

procedure TProgressBarDefault.Hide;
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      Self.FProgressBar.Visible := False;
      Self.FProgressBar.Update;
    end);
end;

end.
