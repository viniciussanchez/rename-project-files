unit View.Wait;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, dxGDIPlusClasses, Vcl.WinXCtrls;

type
  TFrmWait = class(TForm)
    pbWait: TProgressBar;
    lblContent: TLabel;
    ActivityIndicator: TActivityIndicator;
  end;

implementation

{$R *.dfm}

end.
