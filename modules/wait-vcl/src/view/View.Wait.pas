unit View.Wait;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, dxGDIPlusClasses;

type
  TFrmWait = class(TForm)
    pbWait: TProgressBar;
    lblContent: TLabel;
    imgWait: TImage;
  end;

implementation

{$R *.dfm}

end.
