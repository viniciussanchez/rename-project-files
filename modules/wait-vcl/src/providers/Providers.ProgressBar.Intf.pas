unit Providers.ProgressBar.Intf;

interface

type
  IProgressBar = interface
    ['{167DEF94-F49D-4FBA-A274-771A1F4A1656}']
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
  end;

implementation

end.
