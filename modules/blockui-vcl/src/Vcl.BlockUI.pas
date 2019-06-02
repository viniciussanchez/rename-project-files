unit Vcl.BlockUI;

interface

uses VCL.BlockUI.Intf, Vcl.Controls, Vcl.Forms;

type
  TBlockUI = class(TInterfacedObject, IBlockUI)
  private
    FLockedForm: TForm;
    FLockedComponent: TWinControl;
    procedure Block;
    procedure Unlock;
  private
    procedure SetSizeLockedForm;	
  public
    constructor Create; overload;
    constructor Create(const Component: TWinControl); overload;
    destructor Destroy; override;
  end;

implementation

uses Vcl.Graphics, System.SysUtils;

procedure TBlockUI.Block;
begin
  if Assigned(FLockedForm) or (not Assigned(FLockedComponent)) then
    Exit;
  FLockedForm := TForm.Create(nil);
  FLockedForm.Position := poDesigned;
  FLockedForm.BorderStyle := bsNone;
  FLockedForm.AlphaBlendValue := 110;
  FLockedForm.AlphaBlend := True;
  FLockedForm.Color := clBlack;
  SetSizeLockedForm;
  FLockedForm.Show;
end;

constructor TBlockUI.Create(const Component: TWinControl);
begin
  if Assigned(Component) then
    FLockedComponent := Component
  else if Assigned(Application.MainForm) then
    FLockedComponent := Application.MainForm;
  Self.Block;
end;

constructor TBlockUI.Create;
begin
  Create(nil);
end;

procedure TBlockUI.Unlock;
begin
  if Assigned(FLockedForm) then
    FreeAndNil(FLockedForm);
end;

destructor TBlockUI.Destroy;
begin
  Self.Unlock;
  FLockedComponent := nil;
  inherited;
end;

procedure TBlockUI.SetSizeLockedForm;
begin
  if FLockedComponent = Application.MainForm then
  begin
    FLockedForm.Left := FLockedComponent.Left;
    FLockedForm.Top := FLockedComponent.Top;
    FLockedForm.Height := FLockedComponent.Height;
    FLockedForm.Width := FLockedComponent.Width;
  end
  else
  begin
    FLockedForm.Left := FLockedComponent.ClientOrigin.X;
    FLockedForm.Top := FLockedComponent.ClientOrigin.Y;
    FLockedForm.Height := FLockedComponent.ClientHeight;
    FLockedForm.Width := FLockedComponent.ClientWidth;
  end;
end;

end.
